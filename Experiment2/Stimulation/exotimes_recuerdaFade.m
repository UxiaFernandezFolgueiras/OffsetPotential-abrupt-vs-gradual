% %%% %%% %%% %%% %%% %%% Buttons %%% %%% %%% %%% %%% %%% %
% %
% % % Block's cortesy page

function exotimes_recuerdaFade(c)

% % % Prepare parameters
Screen('TextColor',c.wPtr,255); Screen('TextSize',c.wPtr,35);
Screen('TextFont',c.wPtr,'Helvetica'); 

% % % Instructions
Recuerda = 'Utiliza las teclas \n\n IZQUIERDA = Si tienen la misma orientación, si son IGUALES\nDERECHA = Si no tienen la misma orientación, si son DIFERENTES\n\n\n Pulsa espacio para continuar';

% % % Show nstructions
DrawFormattedText(c.wPtr,Recuerda,'center','center',[],[],[],[],3,[])
Screen('Flip',c.wPtr); KbWait([]); WaitSecs(0.5);
Screen('Flip',c.wPtr); WaitSecs(0.5);

end