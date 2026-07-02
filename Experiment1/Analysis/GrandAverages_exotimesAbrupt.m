%% Paths and valid subjects

clear
close all
clc

ruta_datos='U:\UAM\Experimentos\exotimes\análisis\datos';
ruta_gp='U:\UAM\Experimentos\exotimes\análisis\Resultados\EEG\GP\all_durations\';
sujetos={'S26','S28','S29','S30','S31','S32','S33','S34','S35','S36', ...
    'S37','S38','S39','S40','S41','S42','S43','S44','S45','S46','S47', ...
    'S48','S49','S50','S51','S52','S53','S54','S55','S56','S57','S58', ...
    'S59','S60','S61','S62','S63','S64','S65','S66','S67','S68', ...
    'S69','S70'};


%% Parameters

% Filters
f1=0.3;
f2=30;

% Baseline
lbinicio=-0.2;
lbfin=0;

% Epoch
epinicio=-0.2;
epfin=0.9;

ylim=[-14 14];

%% Average per subject

cd(ruta_datos)
cd(sujetos{1})
load exotimes
datos=exotimes.ERP.datos.limpios;
ncond=length(datos);
clear exotimes datos
cd ..

for s=1:length(sujetos)
    cd(sujetos{s})
    load exotimes
    datos=exotimes.ERP.datos.limpios;
    cfg=[];
    cfg.toilim=[epinicio epfin];
    time=ft_redefinetrial(cfg,datos{1});
    dat=zeros(64,length(time.time{1}),ncond);
    for cond=1:ncond
        cfg=[];
        cfg.bpfilter='yes';
        cfg.bpfreq=[f1 f2];
        cfg.demean='yes';
        %cfg.detrend ='yes';
        cfg.baselinewindow = [lbinicio lbfin];
        datos2{cond}=ft_preprocessing(cfg,datos{cond});
        cfg=[];
        cfg.toilim=[epinicio epfin];
        datos3{cond}=ft_redefinetrial(cfg,datos2{cond});
        cfg=[];
        meds{cond}=ft_timelockanalysis(cfg,datos3{cond});
        dat(:,:,cond)=meds{cond}.avg(1:64,:);
    end
    datos=datos3;
    tiempo=time.time{1};
    exotimes.ERP.datos.finales=datos3;
    exotimes.ERP.datos.meds=meds;
    exotimes.ERP.datos.average=dat;
    exotimes.ERP.datos.time=tiempo;
    save exotimes exotimes

    clear datos datos2 datos3 time
    disp(['Sujeto ',num2str(s)])
    cd ..
end


%% Grand average

cd(ruta_datos);
cd(sujetos{1})
nsuj=length(sujetos);
load exotimes
datos=exotimes.ERP.datos.finales;
tiempo=exotimes.ERP.datos.time;
ncond=length(datos);
cd ..
clear exotimes

% superdat(channels,timepoints,conditions,subjects)
superdat=zeros(64,length(tiempo),ncond,nsuj);
for s=1:length(sujetos)
    cd(sujetos{s})
    load exotimes
    dat=exotimes.ERP.datos.average;
    superdat(:,:,:,s)=dat;
    cd ..
end

gp=mean(superdat,4);
tiempo=tiempo*1000;

cd(ruta_gp)
save grand_average superdat gp tiempo nsuj

%% Plots per channel

cd(ruta_datos);
cd(sujetos{1})
load exotimes
% load exotimesFiltro
ncond=length(exotimes.ERP.datos.limpios);
datos=exotimes.ERP.datos.limpios;
cd ..
clear exotimes

cd(ruta_gp)
load grand_average
ylim=[-14 14];

color_sPos = [0.37 0.49 0.71];
color_sNeg = [0.19 0.28 0.42];
color_sNeu = [0.66 0.72 0.83];
color_mPos = [0.89 0.43 0.34];
color_mNeg = [0.84 0.25 0.14];
color_mNeu = [0.94 0.66 0.61];
color_lPos = [0.49 0.74 0.45];
color_lNeg = [0.32 0.59 0.28];
color_lNeu=  [0.70 0.84 0.68];


for ch=1:64
    figure('Position',[500 100 800 600])

    plot(tiempo,gp(ch,:,1),'Color', color_sPos,'LineWidth',1.5)
    grid on
    hold on
    plot(tiempo,gp(ch,:,2),'Color', color_sNeg,'LineWidth',1.5)
    grid on
    hold on
    plot(tiempo,gp(ch,:,3),'Color', color_sNeu,'LineWidth',1.5)
    grid on
    hold on
    plot(tiempo,gp(ch,:,4),'Color', color_mPos,'LineWidth',1.5)
    grid on
    hold on
    plot(tiempo,gp(ch,:,5),'Color', color_mNeg,'LineWidth',1.5)
    grid on
    hold on
    plot(tiempo,gp(ch,:,6),'Color', color_mNeu,'LineWidth',1.5)
    grid on
    hold on
    plot(tiempo,gp(ch,:,7),'Color', color_lPos,'LineWidth',1.5)
    grid on
    hold on
    plot(tiempo,gp(ch,:,8),'Color', color_lNeg,'LineWidth',1.5)
    grid on
    hold on
    plot(tiempo,gp(ch,:,9),'Color', color_lNeu,'LineWidth',1.5)
    grid on
    hold on

    legend ('sPos', 'sNeg','sNeu', 'mPos', 'mNeg', 'mNeu', 'lPos', 'lNeg', 'lNeu', 'Location', 'southwest')
    legend('boxoff')
    axis([tiempo(1) tiempo(end) ylim])
    title([num2str(ch),' ',num2str(datos{1}.label{ch})])
    filename = [num2str(ch),' ',num2str(datos{1}.label{ch})];
    print(filename, '-dpng', '-r300')

end

%% plot by emotion and duration
cd(ruta_datos);
cd(sujetos{1})
load exotimes
datos=exotimes.ERP.datos.limpios;
clear exotimes

ruta_emocion = 'U:\UAM\Experimentos\exotimes\análisis\Resultados\EEG\GP\0.3-30\emoción';
ruta_duracion = 'U:\UAM\Experimentos\exotimes\análisis\Resultados\EEG\GP\0.3-30\duración';
nueva=gp;
ruta_sepneca= 'U:\UAM\Congresos\2023 - SEPNECA\imagenes';

nuevaPos = nueva(:,:,[1,4,7]);
nuevaNeg = nueva(:,:,[2,5,8]);
nuevaNeu = nueva(:,:,[3,6,9]);
nuevaCorta = nueva(:,:,[1,2,3]);
nuevaMedia = nueva(:,:,[4,5,6]);
nuevaLarga = nueva(:,:,[7,8,9]);
nuevatotal = nueva(:,:,:);

mediaPos = NaN (size (gp,1),size (gp,2));
mediaNeg = NaN (size (gp,1),size (gp,2));
mediaNeu = NaN (size (gp,1),size (gp,2));
mediaCorta = NaN (size (gp,1),size (gp,2));
mediaMedia = NaN (size (gp,1),size (gp,2));
mediaLarga = NaN (size (gp,1),size (gp,2));
mediaTotal = NaN (size (gp,1),size (gp,2));

for ch = 1: size (gp,1)
    for p = 1: size (gp,2)
        mediaPos(ch,p) =  mean(nuevaPos(ch,p,:));
        mediaNeg(ch,p) =  mean(nuevaNeg(ch,p,:));
        mediaNeu(ch,p) =  mean(nuevaNeu(ch,p,:));
        mediaCorta(ch,p) = mean(nuevaCorta(ch,p,:));
        mediaMedia(ch,p) = mean(nuevaMedia(ch,p,:));
        mediaLarga(ch,p) = mean(nuevaLarga(ch,p,:));
        mediaTotal(ch,p) = mean(nuevatotal(ch,p,:));
    end
end
