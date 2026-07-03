% %%% %%% %%% %%% %%% %%% runBlock %%% %%% %%% %%% %%% %%% %
% %
% % % Run experiment

function [r,nblock,times] = exotimes_runblock(p,c,d,r,t,nblock,times)

% Mark t0 as reference time for all future timestamps
if nblock == 1
    times.t0 = GetSecs;
end

% Prepare indices for upcoming stimuli
Performance = [];
clear thisTrials; 
thisTrials =  exotimes_stimuli(); 
durations = exotimes_duraciones();
grados = exotimes_grados();

% % % % % Fixation point
Screen('FillOval',c.wPtr,p.color,c.rectfix);
Screen('Flip',c.wPtr);
WaitSecs(3)

length_trials = length(thisTrials);

contador_durpos = 1;
contador_durneg = 1;
contador_durneu = 1;

for ntrial = 1:length_trials
    
    clear nima nduracion nconincon nbarizq nbarder ncond ntrialabs njitter nstimname nstim ntrigger 
    nima = thisTrials(ntrial); % image ID (1:120)
    
    if nima <= 40
        nduracion = durations(1,contador_durpos); % positive durations (1st row of durations).
        contador_durpos = contador_durpos + 1;
    elseif nima > 40 && nima <= 80
         nduracion = durations(2,contador_durneg); % negative durations (2nd row of durations).
         contador_durneg = contador_durneg + 1;
    elseif nima > 80
         nduracion = durations(3,contador_durneu); % Neutral durations (3rd row of durations).
         contador_durneu = contador_durneu + 1;
    end
        
    nbarizq = grados(ntrial,1);
    nbarder = grados(ntrial,2);
    nconincon = nbarizq == nbarder; % congruent (1) o incongruent (0)
    ncond = exotimes_condiciones(nima, nduracion); % from 1 to 9
    ntrialabs = ntrial + ((nblock - 1) * length_trials);
    if ntrial == 1
        first_ntrialabs = ntrialabs;
    end
    njitter = p.jitter_hz_vec(ntrialabs);
    
    if p.triggers == 1
        ntrigger = t.values(ncond);
    end
    
    nstimname = [d.stimdir,num2str(nima),'.jpg'];
    nstim = imread(nstimname); % lee imagen
     
    txtstim = Screen('MakeTexture',c.wPtr,nstim);
    txtbarra = Screen('MakeTexture',c.wPtr,p.barra);
    
    Performance(1,ntrial) = NaN;
    FlushEvents('keyDown'); 
    
    % 1) Display stimuli for stimulus duration
    nhz = 1;
    while nhz <= nduracion 
        
        Screen('DrawTexture',c.wPtr,txtstim,[],c.rectstim);
        Screen('DrawTexture',c.wPtr,txtbarra,[],c.rectizq,nbarizq,[],[],p.color);
        Screen('DrawTexture',c.wPtr, txtbarra,[],c.rectder,nbarder,[],[],p.color);
        Screen('FillOval',c.wPtr,p.color,c.rectfix);
        
        if p.penwidth > 0
            %rect left frame 
            Screen('glPushMatrix', c.wPtr);
            Screen('glTranslate', c.wPtr, c.cxizq, c.cyizq);
            Screen('glRotate', c.wPtr, nbarizq);
            Screen('glTranslate', c.wPtr, -c.cxizq, -c.cyizq);
            Screen('FrameRect', c.wPtr, p.colframe, CenterRectOnPoint(c.rectizq, c.cxizq, c.cyizq), p.penwidth);
            Screen('glPopMatrix', c.wPtr);

            %rect right frame 
            Screen('glPushMatrix', c.wPtr);
            Screen('glTranslate', c.wPtr, c.cxder, c.cyder);
            Screen('glRotate', c.wPtr, nbarder);
            Screen('glTranslate', c.wPtr, -c.cxder, -c.cyder);
            Screen('FrameRect', c.wPtr, p.colframe, CenterRectOnPoint(c.rectder, c.cxder, c.cyder), p.penwidth);
            Screen('glPopMatrix', c.wPtr);
        end
        
        Screen('Flip',c.wPtr);
        
        if nhz == 1
            times.stim(ntrialabs) = GetSecs - times.t0;
            if p.triggers == 1
                t.device.sendTrigger(ntrigger); % send trigger
            end
        end
        nhz = nhz + 1;
        
        if isnan(Performance(1,ntrial)) == 1
            [keyIsDown, ~, keyCode, ~] = KbCheck;
            if (keyIsDown)
                times.resp(ntrialabs) = GetSecs - times.t0;
                rt(ntrialabs) = times.resp(ntrialabs) - times.stim(ntrialabs); % RT
                pressedKey = KbName(find(keyCode)); % KEY?
                if nconincon == true; if strcmp(pressedKey,p.teclasame) == 1; accu = 1; else accu = 0; end; end
                if nconincon == false; if strcmp(pressedKey,p.tecladiff) == 1; accu = 1; else accu = 0; end; end
                FlushEvents('keyDown');
            end
            
            % Save
            try Performance(1,ntrial) = rt(ntrialabs); 
                Performance(2,ntrial) = accu;
                Performance(3,ntrial) = nima; 
                Performance(4,ntrial) = nduracion;
                Performance(5,ntrial) = nconincon;               
                Performance(6,ntrial) = ncond;
                if p.triggers == 1
                    Performance(7,ntrial) = ntrigger;
                end
                Performance(8,ntrial)= njitter;
                Performance(9,ntrial) = ntrialabs;
                Performancestr{1,ntrial} = pressedKey;
            catch
                Performance(1,ntrial) = NaN;
                Performance(2,ntrial) = NaN;
                Performance(3,ntrial) = nima;
                Performance(4,ntrial) = nduracion;
                Performance(5,ntrial) = nconincon;
                Performance(6,ntrial) = ncond;
                if p.triggers == 1
                    Performance(7,ntrial) = ntrigger;
                end
                Performance(8,ntrial)= njitter;
                Performance(9,ntrial) = ntrialabs;
                Performancestr{1,ntrial} = ' ';
            end 
        end        
    end    
    
    % 2) Display blank during ITI (+ jitter) duration
    nhz = 1;
    while nhz <= p.iti_hz + njitter
        
        Screen('FillOval',c.wPtr,p.color,c.rectfix);
        Screen('Flip',c.wPtr);
             
        if nhz == 1
            times.iti(ntrialabs) = GetSecs - times.t0;
        end
        nhz = nhz + 1;
        
        if isnan(Performance(1,ntrial)) == 1
            [keyIsDown, ~, keyCode, ~] = KbCheck;
            if (keyIsDown)
                times.resp(ntrialabs) = GetSecs - times.t0;
                rt(ntrialabs) = times.resp(ntrialabs) - times.stim(ntrialabs); % RT
                pressedKey = KbName(find(keyCode)); % KEY?
                if nconincon == true; if strcmp(pressedKey,p.teclasame) == 1; accu = 1; else accu = 0; end; end
                if nconincon == false; if strcmp(pressedKey,p.tecladiff) == 1; accu = 1; else accu = 0; end; end
                FlushEvents('keyDown');
            end
            
            % Save
            try Performance(1,ntrial) = rt(ntrialabs); 
                Performance(2,ntrial) = accu;
                Performance(3,ntrial) = nima; 
                Performance(4,ntrial) = nduracion;
                Performance(5,ntrial) = nconincon;               
                Performance(6,ntrial) = ncond;
                if p.triggers == 1
                    Performance(7,ntrial) = ntrigger;
                end
                Performance(8,ntrial)= njitter;
                Performance(9,ntrial) = ntrialabs;
                Performancestr{1,ntrial} = pressedKey;
            catch
                Performance(1,ntrial) = NaN;
                Performance(2,ntrial) = NaN;
                Performance(3,ntrial) = nima;
                Performance(4,ntrial) = nduracion;
                Performance(5,ntrial) = nconincon;
                Performance(6,ntrial) = ncond;
                if p.triggers == 1
                    Performance(7,ntrial) = ntrigger;
                end
                Performance(8,ntrial)= njitter;
                Performance(9,ntrial) = ntrialabs;
                Performancestr{1,ntrial} = ' ';
            end                
        end
    end
    
    Screen('Close');
end 

% % % % % Save
r.Performance(:,first_ntrialabs:ntrialabs) = Performance;
r.Performancestr(:,first_ntrialabs:ntrialabs) = Performancestr;

save([d.nsujsdir,'nPerformance_s',num2str(p.nsuj),'_Bloque',num2str(nblock),'.mat'],'Performance','Performancestr','r','thisTrials', 'durations', 'grados')

end
