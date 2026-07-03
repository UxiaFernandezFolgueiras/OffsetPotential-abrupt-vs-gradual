% This function randomly selects 30 images from each emotion category
% (pos, neg, neu) and generates a vector [s] with those 90 images

function [s] = exotimes_stimuliFade()

pos = 1:40;
neg = 41:80;
neu = 81:120;
total_r_pos = pos(randperm(length(pos)));
total_r_neg = neg(randperm(length(neg)));
total_r_neu = neu(randperm(length(neu)));

r_pos = total_r_pos(1:30);
r_neg = total_r_neg(1:30);
r_neu = total_r_neu(1:30);

stimuli = [r_pos r_neg r_neu];
s = stimuli(randperm(length(stimuli)));

end