% %%% %%% %%% %%% %%% %%% getready %%% %%% %%% %%% %%% %%% %
% %
% % % This function shows countdown

function  exotimes_getreadyFade(c)

% % % Prepare parameters
Screen('TextColor',c.wPtr,255); Screen('TextSize',c.wPtr,45);
Screen('TextFont',c.wPtr,'Helvetica'); 

% % % Prepare text
t1 = '3'; t2 = '2'; t3 = '1'; tya = 'Empezamos';% tpoints = '...';

% % % Show text
DrawFormattedText(c.wPtr,tya,'center','center'); Screen('Flip',c.wPtr); WaitSecs(0.7);
DrawFormattedText(c.wPtr,t1,'center','center'); Screen('Flip',c.wPtr); WaitSecs(0.7);
DrawFormattedText(c.wPtr,t2,'center','center'); Screen('Flip',c.wPtr); WaitSecs(0.7);
DrawFormattedText(c.wPtr,t3,'center','center'); Screen('Flip',c.wPtr); WaitSecs(0.7);
Screen('Flip', c.wPtr); 

end

