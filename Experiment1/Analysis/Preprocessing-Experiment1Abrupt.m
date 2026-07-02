%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                     exotimes_abrupt                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear 
close all
clc

% restoredefaultpath
% addpath 'U:\FPI\Programas_Toolbox\Análisis de datos\FieldTrip_20110213'
% addpath 'U:\FPI\Experimentos\colaboraciones\Análisis\exotimes'
% ft_defaults

matlab%% Parameters to modify

% Path
ruta='U:\UAM\Experimentos\exotimes\análisis\datos\S26'; 
ruta_scripts = 'U:\UAM\Experimentos\exotimes\análisis\scripts'; 
cd(ruta)
sujeto=ruta(end-1:end);  

% Filters
f1=0.3;
f2=30;

% Baseline correction
lbinicio=-0.2;
lbfin=0; 

% Delay
delay=[9];

% Conditions
cond_code=[1 2 3 4 5 6 7 8 9]; % emotion x duration: pos_125ms, neg_125ms, neu_125ms, pos_250ms, neg_250ms, neu_250ms, pos_500ms, neg_500ms, neu_500ms
ncond=length(cond_code);

%% Subject condition matrix and behavioral data
eval((sprintf('load Output_s%s',sujeto)));
clear c d p times

condic=r.Performance(6,:); 

RT=r.Performance(1,:);
corr_resp=r.Performance(2,:);

%% Behavioral correction; mean RT and accuracy
% Outliers (remove responses < and > mean+3SD and <200ms)
mn_RT=nanmean(RT);
std_RT=nanstd(RT);
for i=1:length(RT)
    if RT(i)<mn_RT-3*std_RT || RT(i)>mn_RT+3*std_RT || RT(i)<0.2
        RT(i)=NaN;
        corr_resp(i)=NaN;
    end
end

% Replace RTs for incorrect responses with NaN => corr_TR
corr_RT=RT;         
for i=1:length(RT)
    if corr_resp(i)==0
       corr_RT(i)=NaN;
    end
end

% Calculate means per condition
for cond=1:ncond
    corr_RT_condic{cond}=corr_RT(condic==cond_code(cond)); % RT (correct trials) for each trial
    corr_RT_condic_mean(cond)=nanmean(corr_RT_condic{cond}); % Mean RT (correct trials) per conditi
    RT_condic{cond}=RT(condic==cond_code(cond));  % RT for each trial
    RT_condic_mean(cond)=nanmean(RT_condic{cond}); % Mean RT per condition
    corr_resp_condic{cond}=corr_resp(condic==cond_code(cond));   % correct responses (1) or errors (0) for each trial
    corr_resp_condic_mean(cond)=nansum(corr_resp_condic{cond});    % number of correct responses per condition
    corr_resp_condic_por(cond)=nansum(corr_resp_condic{cond})./(length(corr_resp_condic{cond})-sum(isnan(corr_resp_condic{cond})));   % proportion of correct responses per condition
end

exotimes.conducta.RT=RT;
exotimes.conducta.RT_condic=RT_condic;
exotimes.conducta.RT_condic_mean=RT_condic_mean;

exotimes.conducta.corr_RT=corr_RT;
exotimes.conducta.corr_RT_condic=corr_RT_condic;
exotimes.conducta.corr_RT_condic_mean=corr_RT_condic_mean;

exotimes.conducta.corr_resp=corr_resp;
exotimes.conducta.corr_resp_condic=corr_resp_condic;
exotimes.conducta.corr_resp_condic_mean=corr_resp_condic_mean;
exotimes.conducta.corr_resp_condic_por=corr_resp_condic_por;
exotimes.condiciones.condiciones=condic;
cd(ruta)
save exotimes exotimes


%% Reed EEG data

eegfile=ls(sprintf('ET%s.bdf',sujeto));

cfg=[];
cfg.dataset=eegfile;
cfg.channel={'all' '-EXG6' '-EXG7' '-EXG8' '-Status'}; 
cfg.reref = 'yes';
cfg.refchannel = 'EXG5';
cfg.bpfilter='yes';
cfg.bpfreq=[f1 f2];
data=ft_preprocessing(cfg);

% EXG1=vEOG1 (above)
% EXG2=vEOG2 (below)
% EXG3=hEOG1 (right)
% EXG4=hEOG2 (left)
% EXG5=nosetip (offline reference)

data.label{65}='vEOG1';
data.label{66}='vEOG2';
data.label{67}='hEOG1';
data.label{68}='hEOG2';
data.label{69}='nose_ref';

% Read triggers
event=ft_read_event(eegfile);
event = event(find(strcmp({event.type},'STATUS')));
if size (event,2)>360
        event=event(2:end); matlab% remove the first spurious trigger
end
data.cfg.event=event; 

% Check whether triggers are correct
cd(ruta_scripts)
load equimat
cd(ruta)
trig=[];% Assign theoretical trigger to each trial
for i=1:length(condic)
    for j=1:length(equimat(:,1))
        if condic(i)==equimat(j,1)
           trig(i)=equimat(j,2);
        end
    end
end
trig2=NaN(1,length(event));
trig2(1,1:length(trig))=trig;

figure % Plot theoretical triggers (trig) alongside real triggers (event.value)
plot([event.sample],[event.value],'.b')
hold on
if length(event) ~= length(trig)
    plot([event.sample],trig2+1,'.g')
    title('¡Error en la detección de triggers! Comprobar puntos')
    legend({'EEG','Conducta'})
else
    plot([event.sample],trig2+1,'.g')
    title('Triggers correctos :)')
    legend({'EEG','Conducta'})
    %set(gca,'YLim',[0 150])
end

% Save
exotimes.ERP.datos.brutos=data;
cd(ruta)
save exotimes exotimes  

%% ICA

% To ACCEPT a component: press the spacebar
% To REJECT a component: press the mouse button

% Remove all non-EEG channels before ICA
cfg=[];
cfg.channel={'all' '-vEOG1' '-vEOG2' '-hEOG1' '-hEOG2' '-nose_ref'};
data_64=ft_preprocessing(cfg,data);

cfg=[];
cfg.method='runica';   %Infomax
comp = ft_componentanalysis(cfg,data_64);

exotimes.ERP.ica.comp=comp;
cd(ruta)
save exotimes exotimes


%% Visualize ICs: plot data and topography of each component
% Click the mouse button to reject the IC (or press spacebar to move to the next one)
cd(ruta_scripts)
load davg_biosemi64
cd(ruta)

figure
count=1;
badica=[];
vEOG=data.trial{1}(65,:)-data.trial{1}(66,:);
hEOG=data.trial{1}(67,:)-data.trial{1}(68,:);
for ic=1:size(comp.trial{1},1)
    
    C=comp.trial{1}(ic,:);
    Rv=corrcoef(vEOG,C);
    Rh=corrcoef(hEOG,C);
    
    % Topography
    subplot(6,2,[2 4 6])
    topo_ica=comp.topo(:,ic);
    davg2=davg;
    davg2.avg=repmat(topo_ica,[1 size(davg.avg,2)]);
    cfg=[];
    cfg.layout = 'biosemi64.lay';
    cfg.interactive='yes';
    %cfg.zlim=[-10 10];
    cfg.figure='gcf';
    cfg.style='straight';
    ft_topoplotER(cfg,davg2)      % IC topography
    title(['IC #  ' num2str(ic)],'FontWeight','bold','FontSize',16)
    
    % Signal+EOG: to compare the IC signal with the EOG signal
    subplot(6,2,[9 10])
    plot(resample(comp.time{1},1,10),resample(comp.trial{1}(ic,:),1,10))
    % Resample for plotting at lower resolution to speed up rendering
    title(['Señal EEG Componente #  ' num2str(ic)])
    set(gca,'YLim',[-50 50])
    
    subplot(6,2,[7 8])
    plot(resample(comp.time{1},1,10),resample(data.trial{1}(65,:)-data.trial{1}(66,:),1,10),'r')
    title(['r(comp-EOGv) = ' num2str((round(Rv(1,2)*1000))/1000)])
    set(gca,'YLim',[-1000 1000])
    
    subplot(6,2,[11 12])
    plot(resample(comp.time{1},1,10),resample(data.trial{1}(67,:)-data.trial{1}(68,:),1,10),'r')
    title(['r(comp-EOGh) = ' num2str((round(Rh(1,2)*1000))/1000)])
    set(gca,'YLim',[-1000 1000])
    
    keydown = waitforbuttonpress;
    if (keydown == 0)
        badica(count)=ic;  
        count=count+1;
    end
end
close(clf)

%% Subtract rejected components from EEG data
cfg=[];
cfg.component=badica;
data_ica_prov = ft_rejectcomponent(cfg,comp,data_64);

% Filtering
cfg=[];
cfg.bpfilter='yes';
cfg.bpfreq=[f1 f2];
data_ica=ft_preprocessing(cfg,data_ica_prov);

data2=data;
for i=1:length(data_64.label)
    data2.trial{1}(i,:)=data_ica.trial{1}(i,:);  
end

exotimes.ERP.ica.badica=badica;
exotimes.ERP.ica.comp=comp;
exotimes.ERP.datos.prepro_ica=data2;
cd(ruta)
save exotimes exotimes

%% Create epochs

% cond_code=[trigger codes for the 9 conditions]; % Emotion x Duration
cond_code= [527 557 587 617 647 677 707 737 767];  
cd(ruta_scripts)
for cond=1:length(cond_code)
    cfg=[];
    cfg.trialfun = 'lab8_trialfun';
    cfg.prestim = 0.5;
    cfg.poststim = 1.2;
    cfg.event = event;
    cfg.fsample = data2.fsample;
    cfg.code = cond_code(cond);
    cfg.resp = corr_resp;
    cfg2 = ft_definetrial(cfg);
 
    cfg3=[];
    cfg3.trl=cfg2.trl;
    data3=ft_redefinetrial(cfg3,data2);
    
    % Baseline correction
    cfg=[];
    cfg.demean='yes';   %subtracts the mean of the specified baseline window
    cfg.baselinewindow = [lbinicio lbfin];
%     cfg.detrend ='yes';
    datos{cond}=ft_preprocessing(cfg,data3);
end

ntrials=[];
for cond=1:ncond
    ntrials(cond)=length(datos{cond}.trial);
end

exotimes.ERP.datos.prepro_ica_epocas=datos;
exotimes.ERP.ntrials=ntrials;
cd(ruta)
save exotimes exotimes

%% Plot trials and channels to detect channels to interpolate
% % new data1 with trial defined
% cfg=[];
% cfg.trialfun = 'lab8_trialfun_visualizar'; % now we will delete wrong answers
% cfg.prestim = 0.6;                 % epoch segmentation
% cfg.poststim = 0.8;                % epoch segmentation
% cfg.event = event;
% cfg.fsample = data2.fsample;
% cfg.resp = corr_resp;              % right answers
% cfg2 = ft_definetrial(cfg);        % define trial
% cfg3 = [];
% cfg3.trl=cfg2.trl;
% data1 = ft_redefinetrial(cfg3,data);
% 
% % plot each channel per trial
% % just to see what channels need to be interpolated
% cfg            = [];
% cfg.method     ='summary';    
% cfg.channel    = {'all' '-vEOG1' '-vEOG2' '-hEOG1' '-hEOG2' '-nose_ref'};
% ft_rejectvisual (cfg, data1);
% 
% clear data1


%% Plot channel means to detect channels requiring interpolation

average=[];
for cond=1:length(datos)
    cfg=[];
    datm{cond}=ft_timelockanalysis(cfg,datos{cond});
    average(:,:,cond)=datm{cond}.avg;
end
tiempo=datm{1}.time*1000;
cd(ruta_scripts)
plot_meds_exotimes(tiempo,average,datm)


%% INSPECT PLOTS TO IDENTIFY CHANNELS REQUIRING INTERPOLATION
% AND LIST THEM BELOW (e.g., badch = [19 31];)
% If none, write badch = [];
% -------------------------------------------------- %
badch=[1 29 35];
% -------------------------------------------------- %

%% Interpolate artifacted channels in the average and generate updated averages
load elec1005.mat  % Template with electrode names and coordinates
elec2=elec;
elec.pnt=[];
elec.label={};  
elec.label{65}='vEOG1';
elec.label{66}='vEOG2';
elec.label{67}='hEOG1';
elec.label{68}='hEOG2';
elec.label{69}='nose_ref';
for i=1:length(datm{1}.label)-5
    elec.pnt(i,1:3) = elec2.pnt(find(strcmp(elec2.label,datm{1}.label{i})==1),:);
    elec.label{i}=datm{1}.label{i};
end
elec.pnt(65:69,:)=NaN;   

cfg=[];
cfg.elec=elec;
cfg.neighbourdist=550;  
cfg.method= 'distance'; 
% Interpolation uses all channels within a 5.5 cm diameter circle
% neighbours=ft_neighbourselection(cfg, datos{1});%matlab2019_fieldtrip2011
neighbours = ft_prepare_neighbours(cfg, datos{1});

average2=average;
ch_interpol={};
for ch1=1:length(badch)
    ch=badch(ch1);
    ct=1;
    chneig=[];
    for ch2=1:length(neighbours(ch).neighblabel)
        chlab=neighbours(ch).neighblabel(ch2);
        chneig(ct)=find(strcmp(elec.label,chlab)==1);
        ct=ct+1;
    end
    
    ct=1;
    chneig2=[];
    for i=1:length(chneig)
        if sum(badch==chneig(i))==0
            chneig2(ct)=chneig(i);
            ct=ct+1;
        end
    end
    
    average2(ch,:,:)=mean(average([chneig2],:,:),1);
    ch_interpol{ch1}=chneig2;
end
plot_meds_exotimes(tiempo,average2,datm)

datos2=datos;
for cond=1:length(datos)
    for tr=1:length(datos{cond}.trial)
        for ch1=1:length(badch)
            ch=badch(ch1);
            chneig2=ch_interpol{ch1};
            datos2{cond}.trial{tr}(ch,:)=mean(datos{cond}.trial{tr}([chneig2],:),1);
        end
    end
end

exotimes.ERP.badchannels=badch;
cd (ruta)
save exotimes exotimes

%% Delay correction

delay=round(delay/2);   % Note: only valid if sampling rate is 512 Hz
offset={};
for cond=1:length(datos2)
    for i=1:length(datos2{cond}.trial)
        offset{cond}(i)= -delay;
    end
end
for cond=1:length(datos2)
    cfg=[];
    cfg.offset=offset{cond};
    datos2{cond}=ft_redefinetrial(cfg,datos2{cond});
end

%% VISUAL ARTIFACT INSPECTION: remove epochs that still contain artifacts
% To ACCEPT a trial: press the spacebar
% To REJECT a trial: press the mouse button

figure 
badtr={};
for cond=1:length(datos2)
    count=1;
    for tr=1:length(datos2{cond}.trial)
        subplot(2,1,1)          
        plot(datos2{cond}.time{tr},datos2{cond}.trial{tr}(65,:)-datos2{cond}.trial{tr}(66,:),'b'), hold on
        plot(datos2{cond}.time{tr},datos2{cond}.trial{tr}(67,:)-datos2{cond}.trial{tr}(68,:),'r'), hold off
        set(gca,'XTick',[0])
        set(gca,'XLim',[-0.3 0.8])
        set(gca,'YLim',[-100 100])
        legend({'Parpadeos','Movimiento lateral'})
        title(['Condicion: ' num2str(cond) ' - Ensayo: ' num2str(tr)])
        
        subplot(2,1,2)          
        plot(datos2{cond}.time{tr},datos2{cond}.trial{tr}(1:64,:),'k')
        set(gca,'XTick',[0])
        set(gca,'XLim',[-0.3 0.8])
        set(gca,'YLim',[-100 100])
        legend({'Señal EEG'})
       
        keydown = waitforbuttonpress;
        if (keydown == 0)
            badtr{cond}(count)=tr;
            count=count+1;
        end
 
    end
end
close(clf)
exotimes.ERP.badtrials=badtr;


%% If you prefer to inspect channels separately, use
% the following lines instead of the ones above

% figure
% badtr={};
% for cond=1:ncond
%     count=1;
%     for tr=1:length(datos2{cond}.trial)
%         pos=1;
%         for ch=1:64
%             subplot(8,8,pos)
%             plot(datos2{1}.time{1},datos2{cond}.trial{tr}(ch,:),'k')
%             axis([datos2{1}.time{1}(154) datos2{1}.time{1}(667) -100 100])
%             set(gca,'XTick',[0])
%             title([num2str(ch),' ',num2str(datos2{1}.label{ch})])
%             pos=pos+1;
%         end
%         suptitle(['Condicion: ' num2str(cond) ' - Ensayo: ' num2str(tr)])
%         keydown = waitforbuttonpress;
%         if (keydown == 0)
%             badtr{cond}(count)=tr;
%             count=count+1;
%         end
%     end
% end
% close(clf)

%% Finally, keep only clean trials
for cond=1:length(datos2)
    temp=ones(1,length(datos2{cond}.trial));
    try
        temp(badtr{cond})=0;
    end
    cfg=[];
    cfg.trials=find(temp==1);
    datos{cond}=ft_redefinetrial(cfg,datos2{cond});
end
exotimes.ERP.datos.limpios=datos;

ntrials_finales=[];
for cond=1:length(datos)
    ntrials_finales(cond)=length(datos{cond}.trial);
end
exotimes.ERP.ntrialsfinal=ntrials_finales;


cd(ruta)
save exotimes exotimes 

%% Final plots of channel means for clean data

average=[];
for cond=1:length(datos)
    cfg=[];
    datm{cond}=ft_timelockanalysis(cfg,datos{cond});
    average(:,:,cond)=datm{cond}.avg;
end
tiempo=datm{1}.time*1000;
plot_meds_exotimes(tiempo,average,datm)
