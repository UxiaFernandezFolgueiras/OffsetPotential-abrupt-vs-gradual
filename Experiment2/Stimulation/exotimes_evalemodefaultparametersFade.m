% %%% %%% %%% %%% %%% %%% defaultparameters %%% %%% %%% %%% %%% %%% %
% %
% % % This function is a subfunction used to gather subjects data

function [p] = exotimes_evalemodefaultparametersFade(p)

% % % % % Screen Resolution
p.dispres = [1920 1080]; 
p.fadetime = 30;

% % % % % Stimulus Size
p.fondo= [116 109 120]; 
p.picres = [1024 768];
p.pesopic = 1.43; 
p.pesobarra = 7; % determines bar size relative to center (larger value = closer to center)
p.barrares = [150 30]; 
p.barra = 255*ones(p.barrares); 

% % % Identify display
p.disps = Screen('Screens'); 
p.dispid = max(p.disps); 

% % % % % Refresh Rate 
p.disphz = Screen('FrameRate', p.dispid); 
p.hz_time = 1000/p.disphz; % 8.33 ms per frame/cycle

% % % % % Keys
KbName('UnifyKeyNames');
p.space = KbName('space');
p.tecla_arribacuatro = KbName('4');
p.tecla_abajomas = KbName('+');
p.tecla_q = KbName('q');
p.tecla_return = KbName('return');

p.key1 = KbName('1');
p.key2 = KbName('2');
p.key3 = KbName('3');
p.key4 = KbName('4');
p.key5 = KbName('5');
p.key7 = KbName('7');
p.key9 = KbName('9');

p.enabled_keys = RestrictKeysForKbCheck([
    p.key1,...
    p.key2,...
    p.key3,...
    p.key4,...
    p.key5,...
    p.key7,...
    p.key9,...
    p.space...
]);

p.raton = 0; 
p.windowed = 0; 
p.override = 0; 

end
