%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                            EXOTIMES_FADE                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% NOTES for researcher:
% nsuj: subject number (e.g.: 12).
% nage: subject age (e.g.:23).

function [p, d, c, r, times] = exotimesFade(nsuj,nage)

p.driveLetter = 'C'; % [x] to define
p.nsuj = nsuj;
p.nage = nage;
p.triggers = 1; %always = 1 for real experiment (0 for testig at home)

% Define directories of interest
[d] = exotimes_setupdirectoriesFade(p);

% Define response keys:
p.teclasame = '4';
p.tecladiff = '+';

% % %  Generate a random seed and set it
[p] = exotimes_randomseedFade (p);

% % % Set the rest of parameters
[p] = exotimes_defaultparametersFade (p);

% % % Set up Triggers
if p.triggers == 1
    [t] = exotimes_settriggersFade;
else
    t = [];
end
%% ******************** ready...

% % % Invoke libraries
AssertOpenGL
GetSecs   % This is because the first time you access a mex file it takes several 100 ms

% % % Override (or not) Display Check-up
if p.override == 1
    Screen('Preference', 'SkipSyncTests', p.override);
end

try
    % % % Set up SCREEN (create rects and bar texture)
    [p,c] = exotimes_launchscreenFade(p);

    % % % Mouse (optional)
    if p.raton == 0
        HideCursor;
    end

    % % % % % Instructions
    exotimes_instructionsFade(c)
    exotimes_getreadyFade(c)

    % % % % % Practice block
    exotimes_practicaFade(c,p,d)

    % % % % % Final instructions before starting
    exotimes_goodluckFade(c)
    exotimes_recuerdaFade(c)
    exotimes_getreadyFade(c)


    % % % % % % % % % Experiment starts % % % % % % % % % %
    nblock = 1;
    times.t0 = NaN;
    times.stim = NaN(1,p.Ntrials);
    times.iti = NaN(1,p.Ntrials);
    times.resp = [];
    r = [];

    % % % % % Show Block % % % % % % % % % % % % % % % %
    while nblock <= (p.Nblocks-1)

        % % % % % Show Block
        [r,nblock,times] = exotimes_runblockFade(p,c,d,r,t,nblock,times);

        % % % % % Inter-block pause
        exotimes_pausaFade(c,p,nblock)

        % % % % % Remind instructions
        exotimes_recuerdaFade(c)
        exotimes_getreadyFade(c)

        % % % % % Advance to next block
        nblock = nblock + 1;
    end

    % % % % % Show Last Block % % % % % % % % % % % % % % % %
    [r,~,times] = exotimes_runblockFade(p,c,d,r,t,nblock,times);

    % % % % % Farewell
    exotimes_adiosFade(c);

    % % % Gather all the data
    assignin('base', 'p', p);
    assignin('base', 'd', d);
    assignin('base', 'c', c);
    assignin('base', 'r', r); %Note: If no responses are given in a block, r is not returned as output and may cause issues. This is not resolved but participants are expected to respond.
    assignin('base', 'times', times);

    % % % % % Close
catch
    % % Save variables
    assignin('base', 'p', p);
    assignin('base', 'd', d);
    assignin('base', 'c', c);
    assignin('base', 'r', r); %Note: If no responses are given in a block, r is not returned as output and may cause issues. This is not resolved but participants are expected to respond.
    assignin('base', 'times', times);
end

sca % Close Psychtoolbox window
Screen('CloseAll')

% % % Save all the data
save([d.nsujsdir,'Output_s',num2str(p.nsuj),'.mat'],'p','d','c','r','t','times');

end