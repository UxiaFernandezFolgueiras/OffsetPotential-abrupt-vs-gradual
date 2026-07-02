%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
%                                exotimes_fade                                 %
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%
% Create a matrix (.mat) where the first column contains the condition
% numbers (e.g., 1, 2, 3) and the second column contains the corresponding
% trigger codes (e.g., 1, 128, 255); save it as "equicondpulso" in the
% root preprocessing directory (above the individual subject folders;
% e.g., c:\Psicofis\Data\Adj20\preana). This file will be used for all
% subjects in the experiment. The script loads this matrix in the 3rd block.

clear 
close all
clc

% Load subjects 
sujetos={'S11317','S21018','S31118','S41318','S51518','S61618','S71019','S81119',...
         'S91319','S101619','S111320','S121520','S131620','S141021','S151121',...
         'S161024','S171524','S181025','S191325','S201026','S211326','S221526',...
         'S231027','S241227','S251327','S261527','S271727','S281028','S291128',...
         'S301328','S311005','S321105','S331305','S341505','S351004','S361104',...
         'S371304','S381504','S391005','S401105','S411308','S421508'};

% Parametets to modify 
% Path
ruta_datos = '.\datos'; 
ruta_scripts = '.\scripts'; 

% Filters
f1=0.3; 
f2=30;

% Baseline correction
lbini=-0.2; 
lbfin=0;

%Delay
delay=0.009;

% Rest of the epoch (interval after stimulus onset)
epocapost0=0.9; 

cond_code=[1 2 3]; % emotion: pos, neg, neu
ncond=length(cond_code);

% Start loop: subject condition matrix and behavioral data
% sujeto = 1;

for sujeto=1:length(sujetos)
exotimesFade = struct();
ruta_sujactual = [ruta_datos '\' sujetos{sujeto}];
load ([ruta_sujactual '\Output_' sujetos{sujeto}])
clear c d p times

condic=r.Performance(6,:); 
RT=r.Performance(1,:);
corr_resp=r.Performance(2,:);

% Behavior: mean RT and accuracy
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
    corr_RT_condic{cond}=corr_RT(condic==cond_code(cond));  % RT (correct trials) for each trial
    corr_RT_condic_mean(cond)=nanmean(corr_RT_condic{cond}); % Mean RT (correct trials) per condition
    RT_condic{cond}=RT(condic==cond_code(cond));  % RT for each trial
    RT_condic_mean(cond)=nanmean(RT_condic{cond}); % Mean RT per condition
    corr_resp_condic{cond}=corr_resp(condic==cond_code(cond));   % correct responses (1) or errors (0) for each trial
    corr_resp_condic_mean(cond)=nansum(corr_resp_condic{cond});    % number of correct responses per condition
    corr_resp_condic_por(cond)=nansum(corr_resp_condic{cond})./(length(corr_resp_condic{cond})-sum(isnan(corr_resp_condic{cond})));   % proportion of correct responses per condition
end

exotimesFade.conducta.RT=RT;
exotimesFade.conducta.RT_condic=RT_condic;
exotimesFade.conducta.RT_condic_mean=RT_condic_mean;

exotimesFade.conducta.corr_RT=corr_RT;
exotimesFade.conducta.corr_RT_condic=corr_RT_condic;
exotimesFade.conducta.corr_RT_condic_mean=corr_RT_condic_mean;

exotimesFade.conducta.corr_resp=corr_resp;
exotimesFade.conducta.corr_resp_condic=corr_resp_condic;
exotimesFade.conducta.corr_resp_condic_mean=corr_resp_condic_mean;
exotimesFade.conducta.corr_resp_condic_por=corr_resp_condic_por;
exotimesFade.condiciones.condiciones=condic;

save ([ruta_sujactual '\exotimesFade'],'exotimesFade')

% Read EEG data

load ([ruta_scripts '\equicondpulsoFade'])
pulso_code=equicondpulsoFade(:,2); 
trigmax=max(equicondpulsoFade(:,2)); 
ordencondic=condic;

% Epoch definition in ms
epinims=lbini*1000; 
epfinms=epocapost0*1000;

eegfile=[ruta_sujactual '\EF' sujetos{sujeto}(2:end) '.bdf'];

cfg=[];
cfg.dataset=eegfile;
cfg.channel={'all' '-EXG6' '-EXG7' '-EXG8' '-Status'}; 
cfg.reref = 'yes';
cfg.refchannel = 'EXG5';
% offline filter
cfg.bpfilter='yes';
cfg.bpfreq=[f1 f2];
data=ft_preprocessing(cfg);

ncaneeg=length(data.cfg.channel)-5;
data.label{65}='vEOG1';
data.label{66}='vEOG2';
data.label{67}='hEOG1';
data.label{68}='hEOG2';
data.label{69}='nose_ref';

% read triggers
event=ft_read_event(eegfile);
event = event(strcmp({event.type},'STATUS'));
if size (event,2)>360
        event=event(2:end);% remove the first spurious trigger
end
data.cfg.event=event; 

% ======================================================
% Automatic check of whether triggers are correct
% ======================================================
% Assign theoretical trigger to each trial

pulsoteo=[];
for i=1:length(ordencondic)
    for j=1:length(equicondpulsoFade(:,1))
        if ordencondic(i)==equicondpulsoFade(j,1)
            pulsoteo(i)=equicondpulsoFade(j,2);
        end
    end
end

% Detect discrepancies between theoretical triggers (trig) and real triggers (event.value)
if length(event) ~= length(pulsoteo)
    advertencia=msgbox ('Número de pulsos incorrecto (hay más o menos de los que debería haber)');
end

primerens=length(pulsoteo)-length(event);
for evento=1:length(event) 
    dif(evento)=pulsoteo(evento+primerens)-event(evento).value;
end

if max(dif) ~= min(dif)
    plot (1:length(event),dif)
    error=msgbox ('Alguna correspondencia pulso teórico-pulso real no es correcta');
    return
end

clear i j evento dif

% Plot theoretical triggers (trig) alongside real triggers (event.value)
figure
plot([event.sample],[event.value],'.b')
set(gca,'YLim',[0 trigmax+5])
hold on
if length(event) ~= length(pulsoteo)
    plot([event.sample],pulsoteo+1,'.g')
    title('Correspondencia pulsos-condiciones incorrecta :(')
    legend({'Amplitud pulso','Condición teórica'})
else
    plot([event.sample],pulsoteo+1,'.g')
    title('Correspondencia pulsos-condiciones correcta :)')
    legend({'Amplitud pulso','Condición teórica'})
    set(gca,'YLim',[0 trigmax+5])
end

% Save
data.cfg.event=event;  
exotimesFade.ERP.datos.brutos=data;


% ===================================================================================
%                                          ICA
% ===================================================================================

cfg=[];
cfg.channel={'all' '-vEOG1' '-vEOG2' '-hEOG1' '-hEOG2' '-nose_ref'};
data_64=ft_preprocessing(cfg,data);

cfg=[];
cfg.method='runica';   %Infomax
comp = ft_componentanalysis(cfg,data_64);

exotimesFade.ERP.ica.comp=comp;

% =============================================================================================
% AUTOMATIC DETECTION OF BLINK ICs: mark as bad the ICs that correlate with vertical EOG
% =============================================================================================
load ([ruta_scripts '\davg_biosemi64'])
contador=1;
badica=[];
vEOG=data.trial{1}(65,:)-data.trial{1}(66,:);
hEOG=data.trial{1}(67,:)-data.trial{1}(68,:);
for ic=1:size(comp.trial{1},1)
    C=comp.trial{1}(ic,:);
    Rv=corrcoef(vEOG,C);
    Rh=corrcoef(hEOG,C);

    if Rv(1,2)>0.5 || abs(Rh(1,2))>0.6
        badica(contador)=ic;  
        contador=contador+1;
    end
end

clear contador

for u = 1:length(badica)
    figure
    topo_ica=comp.topo(:,badica(u));
    davg2=davg;
    davg2.avg=repmat(topo_ica,[1 size(davg.avg,2)]);
    cfg=[];
    cfg.layout = [ruta_scripts '\biosemi64.lay'];
    cfg.interactive='yes';
    cfg.figure='gcf';
    cfg.style='straight';
    ft_topoplotER(cfg,davg2)      % IC topography
    title(['IC #  ' num2str(badica(u))],'FontWeight','bold','FontSize',16)
    saveas(gcf,[ruta_sujactual '\IC#',num2str(badica(u))],'png') 
    u=u+1;
end

% ======================================================================
% Subtract rejected components from EEG data and apply filters
% ======================================================================

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

exotimesFade.ERP.ica.badica=badica;
exotimesFade.ERP.ica.comp=comp;
exotimesFade.ERP.datos.prepro_ica=data2;

% =========================================================================
%                    EPOCHING AND BASELINE CORRECTION
% =========================================================================
addpath (ruta_scripts)  

for cond=1:ncond
    cfg=[];
    cfg.trialfun = 'lab8_trialfun';
    cfg.prestim = lbfin-lbini;
    cfg.poststim = epocapost0;
    cfg.event = event;
    cfg.fsample = data2.fsample;
    cfg.code = pulso_code(cond); 
    cfg.resp = corr_resp;
    cfg2 = ft_definetrial(cfg);

    if cfg2.trl(1,1)<0
        cfg2.trl(1,:)=[];
    end
 
    cfg3=[];
    cfg3.trl=cfg2.trl;
    data3=ft_redefinetrial(cfg3,data2);
    
    % baseline correction
    cfg=[];
    cfg.demean='yes';   %subtracts the mean of the specified baseline window
    cfg.baselinewindow = [lbini lbfin];
    %cfg.detrend ='yes';
    datos{cond}=ft_preprocessing(cfg,data3);
end

ntrials=[];
for cond=1:ncond
    ntrials(cond)=length(datos{cond}.trial);
end

exotimesFade.ERP.datos.prepro_ica_epocas=datos;
exotimesFade.ERP.ntrials=ntrials;

% ==========================================================================
% Plot channel means to detect channels requiring interpolation
% ==========================================================================
% OPTION 1 AUTOMATIC
% Works well, except when the bad channel is Iz (channel 28); in this case
% it "drags" its neighbours (O1, Oz and O2) into interpolation. When reviewing
% bad channels across subjects, check whether these 4 channels are included:
% if so, Iz is likely the only bad one.
% Re-preprocess that subject using the non-automatic script.

medorig=[];
contador1=1;
contador2=1;
cansospampl=[];badch=[];
sumamplabsvecinos=zeros(ncaneeg,ncond);

for cond=1:ncond
    cfg=[];
    datm{cond}=ft_timelockanalysis(cfg,datos{cond});
    medorig(:,:,cond)=datm{cond}.avg;
end

tiempo=datm{1}.time*1000;

load ([ruta_scripts '\electrovecinos'])

for can=1:ncaneeg
    % Detect significant discrepancies with neighbouring channels
    vecinosindex=~isnan(electrovecinos(can,:));
    vecinos=electrovecinos(can,vecinosindex);
    vecinos=vecinos(2:length(vecinos));

    for vecino=1:length(vecinos)
        for cond=1:ncond
            sumamplabsvecinos(can,cond)=sumamplabsvecinos(can,cond)+mean(abs(medorig(vecinos(vecino),:,cond)),2);
        end
    end
    medamplabsvecinos=sumamplabsvecinos/length(vecinos);

end

medamplabs=squeeze(mean(abs(medorig(:,:,:)),2));

for can=1:ncaneeg
    if mean(abs(medamplabs(can,:)),2)>mean(medamplabsvecinos(can,:),2)*2 %| mean(abs(medorig(can,:,:)),2)<mean(medamplabsvecinos(can,:),2)/2
        cansospampl(contador2)=can;
        contador2=contador2+1;
    end
end

badch=cansospampl;

% Interpolate artifacted channels (badch)
load ([ruta_scripts '\elec1005.mat'])  % template with electrode names and coordinates
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
cfg.neighbourdist=550;% Interpolation uses all channels within a 5.5 cm diameter circle
cfg.method= 'distance'; 
neighbours = ft_prepare_neighbours(cfg, datos{1});

medinterpol=medorig;
ch_interpol={};
for ch1=1:length(badch)
    can=badch(ch1);
    ct=1;
    chneig=[];
    for ch2=1:length(neighbours(can).neighblabel)
        chlab=neighbours(can).neighblabel(ch2);
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

    medinterpol(can,:,:)=mean(medorig([chneig2],:,:),1);
    ch_interpol{ch1}=chneig2;
end

datos2=datos;
for cond=1:length(datos)
    for ens=1:length(datos{cond}.trial)
        for ch1=1:length(badch)
            can=badch(ch1);
            chneig2=ch_interpol{ch1};
            datos2{cond}.trial{ens}(can,:)=mean(datos{cond}.trial{ens}([chneig2],:),1);
        end
    end
end

exotimesFade.ERP.badchannels=badch;

% % OPTION 2 MANUAL
% medorig=[];
% for cond=1:ncond
%     cfg=[];
%     datm{cond}=ft_timelockanalysis(cfg,datos{cond});
%     medorig(:,:,cond)=datm{cond}.avg;
% end
%
% % Plots of original ERPs
% tiempo=datm{1}.time*1000;
% rgb=rand(ncond,3);
%
% figure
% posic=1;
% for can=1:ncaneeg
%     for cond=1:ncond
%           subplot(8,8,posic)
%           plot(tiempo,medorig(can,:,cond),'Color',rgb(cond,:))
%           hold on
%     end
%     axis([tiempo(1) tiempo(length(tiempo)) -30 30])
%     title([num2str(can),' ',num2str(datm{1}.label{can})])
%     posic=posic+1;
% end
% % INSPECT PLOTS TO IDENTIFY CHANNELS REQUIRING INTERPOLATION
% % AND LIST THEM BELOW (e.g., badch = [19 31];)
% % If none, write badch = [];
% -------------------------------------------------- %
% badch=[];
% -------------------------------------------------- %
%
% ==================================
% % Interpolate artifacted channels
% ==================================
%
% % plots to check interpolation results
% load ([ruta_scripts '\elec1005.mat'])  % template with electrode names and coordinates
% elec2=elec;
% elec.pnt=[];
% elec.label={};
% elec.label{65}='vEOG1';
% elec.label{66}='vEOG2';
% elec.label{67}='hEOG1';
% elec.label{68}='hEOG2';
% elec.label{69}='nose_ref';
% for i=1:length(datm{1}.label)-5
%     elec.pnt(i,1:3) = elec2.pnt(find(strcmp(elec2.label,datm{1}.label{i})==1),:);
%     elec.label{i}=datm{1}.label{i};
% end
% elec.pnt(65:69,:)=NaN;   % External channels
%
% cfg=[];
% cfg.elec=elec;
% cfg.neighbourdist=550;% Interpolation uses all channels within a 5.5 cm diameter circle
% cfg.method= 'distance'; %*************************************UPDATE
% neighbours = ft_prepare_neighbours(cfg, datos{1});
%
% medinterpol=medorig;
% ch_interpol={};
% for ch1=1:length(badch)
%     can=badch(ch1);
%     ct=1;
%     chneig=[];
%     for ch2=1:length(neighbours(can).neighblabel)
%         chlab=neighbours(can).neighblabel(ch2);
%         chneig(ct)=find(strcmp(elec.label,chlab)==1);
%         ct=ct+1;
%     end
%
%     ct=1;
%     chneig2=[];
%     for i=1:length(chneig)
%         if sum(badch==chneig(i))==0
%             chneig2(ct)=chneig(i);
%             ct=ct+1;
%         end
%     end
%
%     medinterpol(can,:,:)=mean(medorig(chneig2,:,:),1);
%     ch_interpol{ch1}=chneig2;
% end
%
% datos2=datos;
% for cond=1:length(datos)
%     for ens=1:length(datos{cond}.trial)
%         for ch1=1:length(badch)
%             can=badch(ch1);
%             chneig2=ch_interpol{ch1};
%             datos2{cond}.trial{ens}(can,:)=mean(datos{cond}.trial{ens}([chneig2],:),1);
%         end
%     end
% end
%
% exotimesFade.ERP.badchannels=badch;

% Delay correction

delay=round(delay/2); 
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

% ==================================================================================
% AUTOMATIC REJECTION OF NOISY EPOCHS (semi-automatic visual inspection option)
% ==================================================================================
% To ACCEPT a trial: press the spacebar
% To REJECT a trial: press the mouse button

% Channel classification (to assign different colors)
anteriores=[1:7,33:42];
centrales=[8:19, 32, 43:56];
posteriores=[20:31,57:64];

inivdi=103;
finvdi=411;%length(tiempo); 

for cond=1:length(datos2)
    nensxcond(cond)=length(datos2{cond}.trial);
end
nens=max(nensxcond);

% Calculate the difference between maximum and minimum in each channel and trial
contador1=0;
difintracanxcond=NaN(ncond,nens,length(datos2{1}.label));
for cond=1:ncond
    for ens=1:length(datos2{cond}.trial)
        difintracanxcond(cond,ens,:)=max(datos2{cond}.trial{ens}(:,inivdi:finvdi),[],2)-min(datos2{cond}.trial{ens}(:,inivdi:finvdi),[],2);
        contador1=contador1+1;
        difintracan(contador1,:)=difintracanxcond(cond,ens,:);
    end
end

% Threshold to detect suspicious trials (based on mean and SD)
umbral=mean(difintracan,1)+std(difintracan,0,1).*3.5;

umbral=umbral(1:ncaneeg);
difintracanxcond=difintracanxcond(:,:,1:ncaneeg);

% Detect epochs exceeding the threshold or the absolute value of +100/-100 µV
sobrepasa=zeros(ncond,nens);
canresalta=zeros(ncond,nens);
for cond=1:ncond
    for ens=1:length(datos2{cond}.trial)
        for can=1:ncaneeg
            if difintracanxcond(cond,ens,can)>umbral(can)||max(datos2{cond}.trial{ens}(can,inivdi:finvdi),[],2)>100||min(datos2{cond}.trial{ens}(can,inivdi:finvdi),[],2)<-100
                sobrepasa(cond,ens)=1;
                canresalta(cond,ens)=can; 
            end
        end
    end
end

% OPTION A: automatic rejection of trials detected in previous loop
for cond=1:ncond
    contador2=1; 
    for ens=1:length(datos2{cond}.trial)
        if sobrepasa(cond,ens)==1 
            badtr{cond}(contador2)=ens;
            contador2=contador2+1;
        end
    end
end

% OPTION B - Plot trials - activate for semi-automatic option 
figure('Position', get(0, 'Screensize'))
badtr={};
for cond=1:ncond
    contador2=1;
    for ens=1:length(datos2{cond}.trial)
        subplot(2,1,1)           % vEOG (azul) + hEOG (rojo)
        plot(datos2{cond}.time{ens},datos2{cond}.trial{ens}(65,:)-datos2{cond}.trial{ens}(66,:),'b'), hold on
        plot(datos2{cond}.time{ens},datos2{cond}.trial{ens}(67,:)-datos2{cond}.trial{ens}(68,:),'r'), hold off
        set(gca,'XTick',[0:0.1:epocapost0])
        set(gca,'XLim',[lbini epocapost0])
        set(gca,'YLim',[-100 100])
        legend('EOGv','EOGh')
        title(['Condicion: ' num2str(cond) ' - Ensayo: ' num2str(ens)])
        
        subplot(2,1,2)
        plot(datos2{cond}.time{ens},datos2{cond}.trial{ens}(anteriores,:),'color',[0.7 0 0]),hold on
        plot(datos2{cond}.time{ens},datos2{cond}.trial{ens}(centrales,:),'k'), hold on
        if canresalta(cond,ens)>0
            plot(datos2{cond}.time{ens},datos2{cond}.trial{ens}(posteriores,:),'color',[0 0 0.7]), hold on
            plot(datos2{cond}.time{ens},datos2{cond}.trial{ens}(canresalta(cond,ens),:),'color',[0 1 0],'linewidth',4), hold off
        else
            plot(datos2{cond}.time{ens},datos2{cond}.trial{ens}(posteriores,:),'color',[0 0 0.7]), hold off
        end
        set(gca,'XTick',[0:0.1:epocapost0])
        set(gca,'XLim',[lbini epocapost0])
        set(gca,'YLim',[-100 100])
        legend ('Ant(rojo)','Cent(negro)','Post(azul)',[num2str(canresalta(cond,ens)),' (verde)'])
                
%         Si se detecta ensayo sospechoso espera a decisión, si no, avanza
        if sobrepasa(cond,ens)==1 
            title ('EEG; **** barra Acepta, ratón Elimina ****', 'color','r')
            keydown = waitforbuttonpress;
            if (keydown == 0)
                badtr{cond}(contador2)=ens;
                contador2=contador2+1;
            end
        else
            title ('EEG')
            pause(0.3)
        end
        
    end
end
close(clf)

exotimesFade.ERP.badtrials=badtr;

clear nensxcond can ens difintracan contador1 contador2 sobrepasa difintracanxcond difintracan

% ========================================
% Keep only clean trials
% ========================================

for cond=1:length(datos2)
    temp=ones(1,length(datos2{cond}.trial));
    try
        temp(badtr{cond})=0;
    end
    cfg=[];
    cfg.trials=find(temp==1);
    datos{cond}=ft_redefinetrial(cfg,datos2{cond});
end
exotimesFade.ERP.datos.limpios=datos;

ntrials_finales=[];
for cond=1:length(datos)
    ntrials_finales(cond)=length(datos{cond}.trial);
end
exotimesFade.ERP.ntrialsfinal=ntrials_finales;
save ([ruta_sujactual '\exotimesFade'], 'exotimesFade') 

% ======================================================
% Calculate ERPs for clean data and generate final plots
% ======================================================

medfin=[];
for cond=1:length(datos)
    cfg=[];
    datm{cond}=ft_timelockanalysis(cfg,datos{cond});
    medfin(:,:,cond)=datm{cond}.avg;
end

rgb=rand(ncond,3);

marcasx=[epinims:100:epfinms];
for marx=1:length(marcasx)
    if marcasx(marx)==0 || marcasx(marx)==epfinms/2
        etiqx{marx}=num2str(marcasx(marx));
    else
        etiqx{marx}='';
    end
end

figure ('name',sujetos{sujeto},'NumberTitle','off','Position', get(0, 'Screensize'))
posic=1;
for can=1:64
    for cond=1:ncond
          subplot(8,8,posic)
          plot(tiempo,medfin(can,:,cond),'Color',rgb(cond,:))
          hold on
    end
    axis([tiempo(1) tiempo(length(tiempo)) -30 30])
    set(gca, 'YGrid', 'off', 'XGrid', 'on', 'XTick',marcasx,'XTickLabel',etiqx)
    title([num2str(can),' ',num2str(datm{1}.label{can})])
    posic=posic+1;
end

nomgrafmed=[ruta_sujactual '\meds.png'];
saveas(gcf,nomgrafmed)
close all

disp (['sujeto ' sujetos{sujeto} ' completado ✔'])
end