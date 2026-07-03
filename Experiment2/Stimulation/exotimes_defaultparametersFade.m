% %%% %%% %%% %%% %%% %%% defaultparameters %%% %%% %%% %%% %%% %%% %
% %
% % % This function is a subfunction used to gather subjects data

function [p] = exotimes_defaultparametersFade(p)

% % % % % Screen Resolution
p.dispres = [1920 1080];
p.fadetime = 30;

% % % % % Stimulus Size 
p.picres = [1024 768]; 
p.pesopic = 1.43; % Stimulus size scaling factor
p.pesobarra = 7; % Determines bar size relative to center (larger value = closer to center)
p.barrares = [150 30];

% % % % % Bar matrix 
p.barra = 255*ones(p.barrares); % % 255*ones(200,30);

% % % % % Bar and fixation point color
p.color=  [255 255 0]; % yellow; [255 0 0]; % red; [255 255 255]; % white; [63 105 205]; % blue
p.fondo= [116 109 120];%[255 255 255]; % gray LCh: 47, 7, X
p.colframe = [116 109 120]; % bar frame color
p.penwidth = 3; % bar frame width

% % % % % Refresh Rate 
p.disphz = 120; % [x] % Display refresh rate
p.hz_time = 1000/p.disphz; % Duration of one frame
% % % % % Number of trials and blocks
p.Nblocks = 4; 
p.Ntrials = 360; 
%p.Ntxb = p.Ntrials / p.Nblocks;

% % % % % Number of trials per block 
tmp = (1 : p.Ntrials / p.Nblocks : p.Ntrials);
for nblock = 1 : p.Nblocks
    p.blocktrials(nblock,:) = tmp(nblock) : (p.Ntrials/p.Nblocks)*nblock;
end % Trials assigned to each block (in normal order)

% % % % % Timing 
% Stimulus: 1 duration (250 ms = 30 frames); total ITI: 2000 ms + 500 ms jitter (2000-2500 ms duration)
p.iti_time = 2000;
p.iti_hz = round (p.iti_time/p.hz_time);
p.Njitters = 10; 
p.njittersxjitter = p.Ntrials/p.Njitters;  
p.jitter_time = 50 : 50 : 500; 
p.jitter_time_vec = [];
for njitter = 1 : p.njittersxjitter
    p.jitter_time_vec = [p.jitter_time_vec p.jitter_time];
end
p.jitter_hz_vec = round(p.jitter_time_vec/p.hz_time);

% % % % % Response keys
KbName('UnifyKeyNames');
p.space = KbName('space');
p.samecorrect = KbName('4');
p.diffcorrect = KbName('+');
p.enabled_keys = RestrictKeysForKbCheck([p.samecorrect,p.diffcorrect,p.space]);

% % % Identify display
p.disps = Screen('Screens');
p.dispid = max(p.disps);

% Parameters you may want to change
p.raton = 0; % [x] Hide mouse cursor when launching the task
p.windowed = 0; % [x] Full screen
p.override = 0; % [x] Force Psychtoolbox to continue despite sync failure. Override (1) or not (0) Display Check-up; default=0
end
