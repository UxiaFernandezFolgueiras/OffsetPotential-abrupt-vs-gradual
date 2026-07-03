function exotimes_evalemo(nsuj)

p.nsuj=nsuj;
estimulos = 1:120;

% Define directories
[d] = exotimes_setupdirectories(p);

% % % Set the rest of parameters
[p] = exotimes_evalemodefaultparameters(p);

% % % Prepare screen (rects + texture)
[p,c] = exotimes_launchscreen(p);

% % % Mouse (optional)
if p.raton == 0
    HideCursor;
end

% % % Instructions
exotimes_evalemoinstructions(c);

% % % % % Ready, set, go
exotimes_getready(c);

% % % % % Fixtarion point
Screen('FillOval',c.wPtr,[255 255 255],c.rectfix);
Screen('Flip',c.wPtr);
WaitSecs(1.5);

% Initialize the counter and the control variable hay_estimulos.
count = 1;
hay_estimulos = ~isempty(estimulos);
% The loop will run as long as there are stimuli to present.

while hay_estimulos
    
    % Random index from the stimulus vector.
    i = randi (length (estimulos),1);
    estimulo = estimulos (i);

    % Create textures and image info (60 = 20 pos; 20 neg; 20 neu) +
    % valence and arousal    
    nstimname = [d.stimdir,'\',num2str(estimulo),'.jpg'];
    nstim = imread(nstimname);
    txtstim = Screen('MakeTexture',c.wPtr,nstim);
    
    nactname = [d.stimdir,'activacion.jpg']; % arousal
    nact = imread(nactname);
    txtact = Screen('MakeTexture',c.wPtr,nact);
    
    nvalname = [d.stimdir,'valencia.jpg']; %valence
    nval = imread(nvalname); 
    txtval = Screen('MakeTexture',c.wPtr,nval);
    
    
     % % % Start evalemo
    % Display the image for 500ms
    
    nhz = 1;
    while nhz < p.evalemo_hz
        Screen('DrawTexture',c.wPtr,txtstim);
        Screen('Flip',c.wPtr);
        nhz = nhz + 1;
    end
    
    % Ask about arousal
    activacion = exotimes_valorar(p, c, txtact);
    Screen('Flip',c.wPtr);
    WaitSecs(1);
    
    % Ask about valence
    valencia = exotimes_valorar(p, c, txtval);
    Screen('Flip',c.wPtr);
    WaitSecs(1);
    
    % Save
    r.evalemo(count, 1) = activacion;
    r.evalemo(count, 2) = valencia;
    r.evalemo(count, 3) = estimulo;
    r.evalemo(count, 4) = exotimes_evalemocondicion(estimulo);

    estimulos(i) = [];

    count = count + 1;
    % When there are no more stimuli, exit the loop
    hay_estimulos = ~isempty(estimulos);
    Screen('Close'); 
    
end

% % % % Farewell
exotimes_adios(c); 
sca
Screen('CloseAll')

% % % Save all the data
save([d.nsujsdir,'exotimesEvalemo_s',num2str(p.nsuj),'.mat'],'r','p');

end
