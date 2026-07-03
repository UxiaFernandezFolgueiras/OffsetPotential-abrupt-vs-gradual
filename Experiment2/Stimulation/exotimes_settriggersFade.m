% %%% %%% %%% %%% %%% set triggers %%% %%% %%% %%% %%% %
% %
% % % This function ensures interfacing with hardware at Lab8 and sets
% % the value of the triggers

function [t] = exotimes_settriggersFade

% Trigger pulse setup via USB
t.device = BioSemiSerialPort();  % open serial port
% Possible outputs: Emotion * Duration
t.values(1) = 15;    % pos_250
t.values(2) = 150;   % neg_250
t.values(3) = 255;   % neu_250

end
