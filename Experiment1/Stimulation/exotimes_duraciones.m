% This function randomly repeats the 3 stimulus durations
% (15, 30 and 60 frames) and generates a random vector with 90 durations.

function [d] = exotimes_duraciones()

d = NaN (3,30);
duraciones(1:10) = 15;
duraciones(11:20) = 30;
duraciones(21:30) = 60;

d(1,:) = duraciones(randperm(length(duraciones)));
d(2,:) = duraciones(randperm(length(duraciones)));
d(3,:) = duraciones(randperm(length(duraciones)));

end