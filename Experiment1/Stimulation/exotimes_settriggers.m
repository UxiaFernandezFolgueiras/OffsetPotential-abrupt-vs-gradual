% %%% %%% %%% %%% %%% set triggers %%% %%% %%% %%% %%% %
% %
% % % This function ensures interfacing with hardware at Lab8 and sets
% % the value of the triggers


function [t] = exotimes_settriggers

%Trigger pulse setup via USB
t.device = BioSemiSerialPort();  % open serial port

% Possible outputs: Emoción * Duration
t.values(1) = 15;    % pos_125
t.values(2) = 45;    % neg_125
t.values(3) = 75;    % neu_125
t.values(4) = 105;   % pos_250
t.values(5) = 135;   % neg_250
t.values(6) = 165;   % neu_250
t.values(7) = 195;   % pos_500
t.values(8) = 225;   % neg_500
t.values(9) = 255;   % neu_500

end
