function [condicion] = exotimes_condiciones (s,d)

if s <= 40 && d == 15
    condicion = 1; % pos_125ms
elseif s > 40 && s <= 80 && d == 15
    condicion = 2; % neg_125
elseif s > 80 && d == 15
    condicion = 3; % neu_125
    
elseif s <= 40 && d == 30
    condicion = 4; % pos_250ms
elseif s > 40 && s <= 80 && d == 30
    condicion = 5; % neg_250ms
elseif s > 80 && d == 30
    condicion = 6; % neu_250ms
    
elseif s <= 40 && d == 60
        condicion = 7; % pos_500ms
elseif s > 40 && s <= 80 && d == 60
    condicion = 8; % neg_500ms
elseif s > 80 && d == 60
    condicion = 9; % neu_500ms
end

end
