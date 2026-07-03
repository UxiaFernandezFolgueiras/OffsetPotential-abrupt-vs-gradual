% %%% %%% %%% %%% %%% %%% goodluck %%% %%% %%% %%% %%% %%% %
% %
% % % Experiment's cortesy page

function exotimes_goodluck(c)

% % % Prepare parameters 
Screen('TextColor',c.wPtr,255); Screen('TextSize',c.wPtr,35);
Screen('TextFont',c.wPtr,'Helvetica'); % Screen('TextStyle',c.wPtr,1);

% % % Instructions
Instrucciones1 = 'El experimento está dividido en 3 bloques de 5 minutos cada uno\n Habrá una pausa entre ellos para descansar\n Emplea la pausa para relajarte y espera a que te avisemos para continuar\n\n Es importante que MIRES SIEMPRE AL PUNTO DE FIJACIÓN\n\n Ahora te avisamos para comenzar el bloque';

% % % Show Instructions
DrawFormattedText(c.wPtr,Instrucciones1,'center','center',[],[],[],[],3,[])
Screen('Flip',c.wPtr); KbWait([]); WaitSecs(1);
Screen('Flip',c.wPtr); WaitSecs(0.5);

end