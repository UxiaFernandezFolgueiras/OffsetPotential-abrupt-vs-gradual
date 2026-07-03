% %%% %%% %%% %%% %%% %%% defaultparameters %%% %%% %%% %%% %%% %%% %
% %
% % % This function is a subfunction used to gather subjects data

function [p] = exotimes_defaultparameters(p)

% % % % %Screen Resolution
p.dispres = [1920 1080];

% % % % % Stimulus Size
p.picres = [1024 768]; 
p.pesopic = 1.43; 
p.pesobarra = 7; % Determines bar size relative to center (larger value = closer to center)
p.barrares = [150 30]; 

% % % % % Bar/line matrix 
p.barra = 255*ones(p.barrares); 

% % % % % Bar and fixation pont color
p.color=  [255 255 0]; 
p.fondo= [116 109 120]; 
p.colframe = [116 109 120]; 
p.penwidth = 3; %Bar frame width
 
% % % % %Refresh rate 
p.disphz = 60;%120; % [x] % Display refresh rate
p.hz_time = 1000/p.disphz; % Durarion of a frame 

% % % % % Number of trials and blocks
p.Nblocks = 4; 
p.Ntrials = 360;     
%p.Ntxb = p.Ntrials / p.Nblocks;

% % % % % Number of trials per block
tmp = (1 : p.Ntrials / p.Nblocks : p.Ntrials);
for nblock = 1 : p.Nblocks
    p.blocktrials(nblock,:) = tmp(nblock) : (p.Ntrials/p.Nblocks)*nblock;
end % Trials assigned to each block (in normal order)

% % % % % Timinig
% Stimulus: 3 durations (125/250/500 ms = 15,30,60 frames); ITI total: 2000ms + 500ms jitter (2000 - 2500 ms)
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

% Parameters
p.raton = 0; % Hide mouse cursor when launching the task
p.windowed = 1; % Full screen
p.override = 0; % Override (1) or not (0) Display Check-up; default=0

end
