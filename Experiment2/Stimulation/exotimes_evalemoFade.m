function exotimes_evalemoFade(nsuj)

p.nsuj=nsuj;
estimulos = 1:120;

% % % Set the rest of parameters
[p] = exotimes_evalemodefaultparametersFade(p);

% Define directories
[d] = exotimes_setupdirectoriesFade(p);

% % % Prepare screen (rects + texture)
[p,c] = exotimes_launchscreenFade(p);

% % % Mouse (optional)
if p.raton == 0
    HideCursor;
end

% % % Instructions
exotimes_evalemoinstructionsFade(c);

% % % % % Ready, set, go
exotimes_getreadyFade(c);

% % % % % Fixtarion point
Screen('FillOval',c.wPtr,[255 255 255],c.rectfix);
Screen('FrameOval', c.wPtr, [116 109 120], c.rectfix,p.penwidth);
Screen('Flip',c.wPtr);
WaitSecs(1.5);

% Initialize the counter and the control variable hay_estimulos.
count = 1;
hay_estimulos = ~isempty(estimulos);
% The loop will run as long as there are stimuli to present.
while hay_estimulos
    
    % Random index from the stimulus vector.
    i = randi(length(estimulos),1);
    estimulo = estimulos(i);
    % Create textures and image info (60 = 20 pos; 20 neg; 20 neu) +
    % valence, arousal and afterimage

    nstimname = [d.stimdir,'\',num2str(estimulo),'.jpg'];
    nstim = imread(nstimname);
    txtstim = Screen('MakeTexture',c.wPtr,nstim);
    
    nhuellaname = [d.stimdir,'huella.jpg']; % afterimage
    nhuella = imread(nhuellaname); 
    txthuella = Screen('MakeTexture',c.wPtr,nhuella);
    
    nactname = [d.stimdir,'activacion.jpg']; % arousal
    nact = imread(nactname); 
    txtact = Screen('MakeTexture',c.wPtr,nact);
    
    nvalname = [d.stimdir,'valencia.jpg']; % valence
    nval = imread(nvalname); 
    txtval = Screen('MakeTexture',c.wPtr,nval);
       
    
    % % % Start evalemo
    % Display the image for p.fadetime (250ms)
    duracion_evalemo = p.fadetime;
    iniciofade_evalemo = duracion_evalemo - p.fadetime;
    
    nhz = 1;    
    
    while nhz < duracion_evalemo

        Screen('DrawTexture',c.wPtr,txtstim);
        if nhz > iniciofade_evalemo
            nmask = nhz - iniciofade_evalemo;
            Screen('DrawTexture',c.wPtr,p.mascaras(nmask),[],c.rect);
        end
       
        Screen('Flip',c.wPtr);
        nhz = nhz + 1;
    end
    
    WaitSecs(2)
    % Ask about afterimage/aftereffect
    huella = exotimes_valorarFade(p, c, txthuella);
    Screen('Flip',c.wPtr);
    WaitSecs(1);

    % Ask about arousal
    activacion = exotimes_valorarFade(p, c, txtact);
    Screen('Flip',c.wPtr);
    WaitSecs(1);
    
    % Ask about valence
    valencia = exotimes_valorarFade(p, c, txtval);
    Screen('Flip',c.wPtr);
    WaitSecs(1);
          
    % Save data
    r.evalemo(count, 1) = huella;
    r.evalemo(count, 2) = activacion;
    r.evalemo(count, 3) = valencia;
    r.evalemo(count, 4) = estimulo;
    r.evalemo(count, 5) = exotimes_evalemocondicionFade(estimulo);

    estimulos(i) = [];

    count = count + 1;
    % When there are no more stimuli, exit the loop
    hay_estimulos = ~isempty(estimulos);

end

% % % % Farewell
exotimes_adiosFade(c); 
sca
Screen('CloseAll')

% % % Save all the data
save([d.nsujsdir,'exotimesEvalemoFade_s',num2str(p.nsuj),'.mat'],'r','p');

end
