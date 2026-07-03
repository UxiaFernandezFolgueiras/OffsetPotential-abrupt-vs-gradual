% %%% %%% %%% %%% %%% %%% farewell %%% %%% %%% %%% %%% %%% %
% %
% % % This function welcomes participant


function exotimes_adiosFade(c)

% % % Prepare parameters
Screen('TextColor',c.wPtr,255); Screen('TextSize',c.wPtr,35);
Screen('TextFont',c.wPtr,'Helvetica'); 

% % % Instructions
Farewell = '\nHas terminado esta parte\n\n¡Muchas gracias por tu participación!';

% % % Show instructions
DrawFormattedText(c.wPtr,Farewell,'center','center',[],[],[],[],3,[])
Screen('Flip',c.wPtr); KbWait([]); WaitSecs(0.5);
Screen('Flip',c.wPtr); WaitSecs(1);

end