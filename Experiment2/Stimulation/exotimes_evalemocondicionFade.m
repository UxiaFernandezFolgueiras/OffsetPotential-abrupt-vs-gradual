function [ condicion ] = exotimes_evalemocondicionFade(estimulo)
    condicion = NaN;
    if estimulo <= 40
        condicion = 1; % Positive
    elseif estimulo > 40 && estimulo <= 80
        condicion = 2; % Negative
    elseif estimulo > 80
        condicion = 3; % Neutral
    end
end

