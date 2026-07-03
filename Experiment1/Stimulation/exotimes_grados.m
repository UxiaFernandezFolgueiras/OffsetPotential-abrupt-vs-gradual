

function [g] = exotimes_grados()

inclinaciones_iguales  = [18 18;36 36; 54 54; 72 72;90 90; 108 108; 126 126; 144 144; 162 162; 180 180];
concordantes = [inclinaciones_iguales; inclinaciones_iguales; inclinaciones_iguales; inclinaciones_iguales; inclinaciones_iguales];
con_totales = concordantes(randperm(length(concordantes)),:); % randomized congruent combinations
con = con_totales (1:45,:);% select 45 out of 50 randomized congruent combinations

inclinaciones_diferentes  = [18 180;36 18; 54 36; 72 54;90 72; 108 90; 126 108; 144 126; 162 144; 180 162];
discordantes = [inclinaciones_diferentes; inclinaciones_diferentes; inclinaciones_diferentes; inclinaciones_diferentes; inclinaciones_diferentes];
dis_totales = discordantes(randperm(length(discordantes)),:); % randomized congruent combinations
dis = dis_totales (1:45,:);% select 45 out of 50 randomized congruent combinationss

grados = [con; dis];% matrix with left & right bar inclination degrees for congruent & incongruent trials
g = grados(randperm(length(grados)),:);% randomize the degree matrix

end