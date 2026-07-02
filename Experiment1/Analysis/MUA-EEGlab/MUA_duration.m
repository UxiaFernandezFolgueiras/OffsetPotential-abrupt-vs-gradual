%% MASS UNIVARIATE ANALYSIS

% https://openwetware.org/wiki/Mass_Univariate_ERP_Toolbox:_within-subject_t-tests#Within-Subject_t-Tests

clear; clc

ruta_MUA = 'U:\UAM\Experimentos\exotimes\exotimesFade\analisis\resultados\eeg\MUA\SETs';
addpath 'C:\toolbox\Mass_Univariate_ERP_Toolbox-master'
addpath 'C:\toolbox\eeglab2022.1' 


%Make sure all EEGLAB functions are on the MATLAB path
[ALLEEG, EEG, CURRENTSET, ALLCOM] = eeglab;
close all; 

GND=sets2GND('gui','bsln',[-200 0]);

cd(ruta_MUA)
load GND.GND -MAT

% Information ans plot GND
headinfo(GND) 
gui_erp(GND) 
plot_wave(GND,[1 2 3]); 
plot_wave(GND,[1 2 3],'include_chans', {'O1' 'O2' 'OZ'}); 

% Subtract conditions to run statistics (create bins)
GND=bin_dif(GND,2,1,'Exotimes neg-pos');% compute difference between conditions (neg-pos)
GND=bin_dif(GND,3,1,'Exotimes neu-pos'); %bin 16 % bin_dif is only used with clustGND, not FclustGND
GND=bin_dif(GND,3,2,'Exotimes neu-neg'); %bin 16 % bin_dif is only used with clustGND, not FclustGND

gui_erp(GND,'bin',1)

%% Time point by time point analysis, tmax permutation test

%To determine when and where the ERPs to standards and targets differ, we will perform a permutation 
% test based on the one-sample/repeated measures t-statistic using every
% time point at every electrode q
% from 100 to 900 ms post-stimulus (i.e., 5226 comparisons). 
% The permutation test will control the family-wise error rate (i.e., the probability of making one or more false discoveries)
% across the full set of comparisons. The motivation for choosing this time window is that there are unlikely to be effects
% before 100 ms and effects after 900 ms are not of interest since they occur long after subjects have made a response. 
% We do this with the function tmaxGND.m:


GND = tmaxGND(GND,4,'time_wind',[310 510],'output_file','negpos_mediabi-FWE.txt');
GND = tmaxGND(GND,5,'time_wind',[310 510],'output_file','neupos_mediabi-FWE.txt');
GND = tmaxGND(GND,6,'time_wind',[310 510],'output_file','neuneg_mediabi-FWE.txt');


