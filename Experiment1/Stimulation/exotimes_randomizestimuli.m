% %%% %%% %%% %%% %%% %%% randomizestimuli %%% %%% %%% %%% %%% %%% %
% %
% % % This function is a subfunction used to gather subjects data

function [e,p,d] = exotimes_randomizestimuli(p,d)

load([d.xpdir,'Alltrials_times.mat']);
Alltrials = Alltrials_times;
Alltrials(:,8) = p.jitter_hz_vec(randperm(p.Ntrials)); 
% randomize all trials
p.randomorder = randperm(p.Ntrials);
e = Alltrials(p.randomorder,:);

% AllTrials matrix structure (columns)
% 1. Photo ID (1:120; 1:40-pos; 41:80-neg; 81:120-neu)
% 2. Duration: 1=125, 2=250, 3=500 ms
% 3. Congruent/incongruent bar (1:2; same=1, different=2)
% 4. Left bar (18-180º, 10 segments)
% 5. Right bar (same as left at half; differs by one segment)
% 6. Condition (1:9; [pos125 neg125 neu125 pos250 neg250 neu250 pos500 neg500 neu500])
% 7. Index (1:360)

end

% e = stimuli
% p = parameters
% c = coordinates (Psychtoolbox stuff)
% r = response
% d = directories
