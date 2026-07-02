% Load ERPs in EEGlab
% --------------------
%****** Navigate to EEGlab folder (if path is not set); EEGlab does not need
% to be open *****************************************************
% The MAT files to be loaded are the individual ERPs for each subject,
% in the format where all conditions are included within each individual ERP
% (see script that reorganizes ERPs from grand average)

addpath 'C:\toolbox\Mass_Univariate_ERP_Toolbox-master'
addpath 'C:\toolbox\eeglab2022.1'
eeglab

nsujs=44;
nconds=3;
puntosporepoca=615;
lineabase=-0.2; %seconds
rutameds='U:\UAM\Experimentos\exotimes\análisis\Resultados\EEG\GP\each_duration\larga\';
rutaeventos='U:\UAM\Experimentos\exotimes\análisis\Resultados\EEG\MUA\MUAconEEGlab'; 
montaje='U:\UAM\Experimentos\exotimes\análisis\Resultados\EEG\MUA\MUAconEEGlab\biosemi64.xyz'; 
rutasalida='U:\UAM\Experimentos\exotimes\análisis\Resultados\EEG\MUA\MUAconEEGlab\larga\SETs'; 
binsmua='U:\UAM\Experimentos\exotimes\análisis\Resultados\EEG\MUA\MUAconEEGlab\mua_condicsTxt.txt'; 
eventos='U:\UAM\Experimentos\exotimes\análisis\Resultados\EEG\MUA\MUAconEEGlab\eventsTxt.txt'; 

for suj=1:nsujs
    sujeto=(['suj' num2str(suj)]); 
    archivo=([sujeto '.mat']);
    rutarchivo=([rutameds archivo]);
    EEG = pop_importdata('dataformat','matlab','nbchan',64,'data',rutarchivo,'srate',512,'subject',sujeto,'pnts',puntosporepoca,'xmin',lineabase,'chanlocs',montaje);
    EEG.setname=([sujeto]);
    EEG = eeg_checkset( EEG );
    EEG = pop_importepoch( EEG, eventos, {'type'},'timeunit',1,'headerlines',0);
    EEG = eeg_checkset( EEG );
    for cond=1:nconds 
        EEG.epoch(cond).eventtype=EEG.epoch(cond).type;
        EEG.epoch(cond).eventurevent=EEG.epoch(cond).type;
    end
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',sujeto,'filepath',rutasalida);
end

%% MASS UNIVARIATE ANALYSIS: Assign BINs to epochs for each subject
for suj=1:nsujs
    sujeto=(['suj' num2str(suj)]);
    sujmua=([sujeto '.set']);
    bin_info2EEG(sujmua,binsmua,sujmua);
end