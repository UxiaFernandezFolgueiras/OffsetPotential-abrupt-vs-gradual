% https://github.com/YarmoM/matlab-easing/blob/master/easing.m
% https://easings.net/
% This function calls easing, which contains the mathematical function
% we need (linear, quadratic, cubic, etc).

function alpha = getaplha (tiempo_actual, tiempo_final, duracion_fade)
   
    alpha_maximo = 255;
    tiempo_inicio = tiempo_final - duracion_fade;
    if tiempo_actual > tiempo_inicio
        tiempo_degradado = tiempo_actual - tiempo_inicio;
        funcion =  easing(tiempo_degradado, 0, alpha_maximo, duracion_fade,'circout');% quadout/quintout; change last parameter for function [linear=1 (or empty); circout]
        alpha = min(funcion, alpha_maximo); 
    else
        alpha = 0;
    end

end
