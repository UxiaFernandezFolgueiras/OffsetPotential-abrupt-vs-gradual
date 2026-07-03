% %%% %%% %%% %%% %%% instrucciones prueba discriminación %%% %%% %%% %%% %%% %
% %
% % % This function welcomes participant

function exotimes_evalemoinstructions(c)

% % % Prepare parameters
Screen('TextColor',c.wPtr,255); Screen('TextSize',c.wPtr,20);
Screen('TextFont',c.wPtr,'Helvetica'); 

% % % Instructions
Instrucciones1 = 'A continuación se presentarán una serie de imágenes.\n\nTu tarea consiste en evaluarlas en dos escalas diferentes: \n- una de ACTIVACIÓN \n- otra de VALENCIA\n\n\nPulsa espacio para continuar';
Instrucciones2 = ['\n\n\n\n ACTIVACIÓN: cuánto de relajante-activante te resulta la imagen (1 muy relajante - 5 muy activante)\n\n','VALENCIA: cuánto de negativo-positivo te resulta la imagen (1 muy negativo - 5 muy positivo)\n\n\n\nPulsa espacio para continuar'];

% % % Show instructions
DrawFormattedText(c.wPtr,Instrucciones1,'center','center',[],[],[],[],3,[])
Screen('Flip',c.wPtr);
KbWait([]);
WaitSecs(0.5);

DrawFormattedText(c.wPtr,Instrucciones2,'center','center',[],[],[],[],3,[])
Screen('Flip',c.wPtr);
KbWait([]);
WaitSecs(0.5);
Screen('Flip',c.wPtr);
WaitSecs(1);

end