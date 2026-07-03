function [condicion] = exotimes_condicionesFade (s)

if s <= 40
    condicion = 1; % pos_2505ms
elseif s > 40 && s <= 80
    condicion = 2; % neg_250
elseif s > 80
    condicion = 3; % neu_250
end
