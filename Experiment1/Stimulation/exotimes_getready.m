% %%% %%% %%% %%% %%% %%% getready %%% %%% %%% %%% %%% %%% %
% %
% % % This function shows countdown

function  exotimes_getready(c)

% % % Prepare parameters 
Screen('TextColor',c.wPtr,255); Screen('TextSize',c.wPtr,45);
Screen('TextFont',c.wPtr,'Helvetica'); 

% % % Prepare screens
t1 = '3'; t2 = '2'; t3 = '1'; tya = 'Empezamos';% tpoints = '...';

% % % Show screens
DrawFormattedText(c.wPtr,tya,'center','center'); Screen('Flip',c.wPtr); WaitSecs(0.7);
DrawFormattedText(c.wPtr,t1,'center','center'); Screen('Flip',c.wPtr); WaitSecs(0.7);
DrawFormattedText(c.wPtr,t2,'center','center'); Screen('Flip',c.wPtr); WaitSecs(0.7);
DrawFormattedText(c.wPtr,t3,'center','center'); Screen('Flip',c.wPtr); WaitSecs(0.7);
Screen('Flip', c.wPtr); 

end

