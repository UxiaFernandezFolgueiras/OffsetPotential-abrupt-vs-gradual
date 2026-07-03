% %%% %%% %%% %%% %%% %%% pausa %%% %%% %%% %%% %%% %%% %
% %
% % % Block's cortesy page 

function exotimes_pausaFade(c,p,nblock,t)

% % % Prepare parameters 
Screen('TextColor',c.wPtr,255); Screen('TextSize',c.wPtr,35);
Screen('TextFont',c.wPtr,'Helvetica'); 

% % % Instructions
EsteBloque = 'PAUSA \nDescansa y espera a que te avisemos para continuar\n\nÁnimo y mantén la concentración :)';

% % % Show instructions
DrawFormattedText(c.wPtr,EsteBloque,'center','center',[],[],[],[],3,[])
Screen('Flip',c.wPtr); WaitSecs(2); KbWait([]); WaitSecs(1);
Screen('Flip',c.wPtr); WaitSecs(0.5);

end