% %%% %%% %%% %%% %%% practica %%% %%% %%% %%% %%% %
% %
% % % This function runs the practice session

function exotimes_practicaFade(c,p,d)

% Stimulus order
imagenes = {'1.jpg','2.jpg','3.jpg','4.jpg','5.jpg','6.jpg','7.jpg','8.jpg','9.jpg','10.jpg'};
nbarizqprac = [54 162 126 36 90 180 90 18 108 144];
nbarderprac = [54 162 108 36 108 36 72 18 108 126];
length_trialspr = length (imagenes);
% Response order
nconcord = [1 1 2 1 2 2 2 1 1 2];
accu = 0;
respvec = NaN(1,length_trialspr);

% Predefine structure and iterations
salimosdeaqui = 0;
% % % Fixation point
Screen('FillOval',c.wPtr,p.color,c.rectfix);
Screen('FrameOval',c.wPtr,p.colframe,c.rectfix,p.penwidth);
Screen('Flip',c.wPtr);
WaitSecs(2);

while salimosdeaqui == 0

    for npractica = 1 : length_trialspr

        thistrialprac = imread([d.prctdir,imagenes{npractica}]);

        % % % Stimuli
        txtprac = Screen('MakeTexture',c.wPtr,thistrialprac);
        txtbarra = Screen('MakeTexture',c.wPtr,p.barra);
        FlushEvents('keyDown');

        nhz = 1;
        duracionpr = p.fadetime;
        iniciofadepr = duracionpr - p.fadetime;
        tic
        while nhz <= duracionpr

            Screen('DrawTexture',c.wPtr,txtprac,[],c.rectstim);
            Screen('DrawTexture',c.wPtr,txtbarra,[],c.rectizq,nbarizqprac(npractica),[],[],p.color);
            Screen('DrawTexture',c.wPtr,txtbarra,[],c.rectder,nbarderprac(npractica),[],[],p.color);

            if p.penwidth > 0
                %rect frame izq
                Screen('glPushMatrix', c.wPtr);
                Screen('glTranslate', c.wPtr, c.cxizq, c.cyizq);
                Screen('glRotate', c.wPtr, nbarizqprac(npractica));
                Screen('glTranslate', c.wPtr, -c.cxizq, -c.cyizq);
                Screen('FrameRect', c.wPtr, p.colframe, CenterRectOnPoint(c.rectizq, c.cxizq, c.cyizq), p.penwidth);
                Screen('glPopMatrix', c.wPtr);

                %rect frame der
                Screen('glPushMatrix', c.wPtr);
                Screen('glTranslate', c.wPtr, c.cxder, c.cyder);
                Screen('glRotate', c.wPtr, nbarderprac(npractica));
                Screen('glTranslate', c.wPtr, -c.cxder, -c.cyder);
                Screen('FrameRect', c.wPtr, p.colframe, CenterRectOnPoint(c.rectder, c.cxder, c.cyder), p.penwidth);
                Screen('glPopMatrix', c.wPtr);
            end


            % fade out
            if nhz > iniciofadepr
                nmask = nhz - iniciofadepr;
                Screen('DrawTexture',c.wPtr,p.mascaras(nmask),[],c.rect);
            end

            Screen('FillOval',c.wPtr,p.color,c.rectfix);
            Screen('FrameOval',c.wPtr,p.colframe,c.rectfix,p.penwidth);
            Screen('Flip',c.wPtr);

            if isnan(respvec(1,npractica))
                [keyIsDown, ~, keyCode, ~] = KbCheck;
                if (keyIsDown)
                    pressedKey = KbName(find(keyCode));
                    correctresp = nconcord(npractica); %  1 = same; 2 = diff;
                    if correctresp == 1; if strcmp(pressedKey,p.teclasame) == 1; accu = 1; else accu = 0; end; end
                    if correctresp == 2; if strcmp(pressedKey,p.tecladiff) == 1; accu = 1; else accu = 0; end; end
                    FlushEvents('keyDown');
                    respvec(1,npractica) = accu;
                end
            end
            % respvec = []; respvec = [respvec accu];
            nhz = nhz + 1;
        end
        toc
        % 2) Blank ITI time
        nhz = 1;
        while nhz <= 120

            Screen('FillOval',c.wPtr,p.color,c.rectfix);
            Screen('FrameOval',c.wPtr,p.colframe,c.rectfix,p.penwidth);
            Screen('Flip',c.wPtr);
            nhz = nhz + 1;

            if isnan(respvec(1,npractica))
                [keyIsDown, ~, keyCode, ~] = KbCheck;
                if (keyIsDown)
                    pressedKey = KbName(find(keyCode));
                    correctresp = nconcord(npractica); %  1 = same; 2 = diff;
                    if correctresp == 1; if strcmp(pressedKey,p.teclasame) == 1; accu = 1; else accu = 0; end; end
                    if correctresp == 2; if strcmp(pressedKey,p.tecladiff) == 1; accu = 1; else accu = 0; end; end
                    FlushEvents('keyDown');
                    respvec(1,npractica) = accu;
                end
            end
        end
    end
    % % % Prepare output
    Screen('TextColor',c.wPtr,255);
    Screen('TextSize',c.wPtr,30);
    Screen('TextFont',c.wPtr,'Helvetica');

    % % % feedback
    bienhecho = '¡Muy bien!\n\nParece que estás listo/a para comenzar :)';
    malhecho = 'Parece que te has equivocado en alguno\n\nPulsa espacio y repetimos';

    if sum (respvec) >= 7
        DrawFormattedText(c.wPtr,bienhecho,'center','center',[],[],[],[],3,[])
        Screen('Flip',c.wPtr); KbWait([]); WaitSecs(0.5);
        salimosdeaqui = 1;
    else
        DrawFormattedText(c.wPtr,malhecho,'center','center',[],[],[],[],3,[])
        Screen('Flip',c.wPtr); KbWait([]); WaitSecs(0.5);
        exotimes_recuerdaFade(c)
        salimosdeaqui = 0;
    end

end
end
