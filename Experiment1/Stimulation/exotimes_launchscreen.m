% %%% %%% %%% %%% %%% launcher %%% %%% %%% %%% %%% %
% %
% % % This function runs pthe practice session

function [p,c] = exotimes_launchscreenFade(p)

% what is your actual screen resolution?
set(0,'units','pixels'); tmp = get(0,'ScreenSize'); p.dispresreal = [0 0 tmp(3:4)]; % Le quito los 1s porque PsychToolBox empieza a a contar en 0)

% If it differs from p.dispres(1), display a warning
if p.dispresreal(3) ~= p.dispres(1)
    warning(['La resolucion de la pantalla no es ',num2str(p.dispres(1)),'. Si aun asi quieres continuar pulsa espacio']),class(p.dispresreal);
    KbWait([]);
else
end

if p.windowed == 0
    [c.wPtr,c.rect] = Screen('OpenWindow',max(Screen('Screens')),p.fondo); 
else
    rect = [0 0 500 300];
    [c.wPtr,c.rect] = Screen('OpenWindow',max(Screen('Screens')), p.fondo, rect);
end

% This line is required to support transparency.
Screen(c.wPtr,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% Creates a full-screen image with a flat color (gray) to use as a mask.
c.alphamatrix = NaN(c.rect(3), c.rect(4), 3);
for i=1:c.rect(3)
    for j=1:c.rect(4)
        c.alphamatrix(i,j,:) = p.fondo;
    end
end

% Useful coordinatess
c.xcenter = c.rect(3)/2; c.ycenter = c.rect(4)/2;

% Fixation point coordinates
c.rectfix = [c.xcenter-7 c.ycenter-7 c.xcenter+7 c.ycenter+7];

% Stimulus image coordinates
c.rectstim = [c.xcenter-p.picres(1)/p.pesopic c.ycenter-p.picres(2)/p.pesopic c.xcenter+p.picres(1)/p.pesopic c.ycenter+p.picres(2)/p.pesopic];
% [x] Otherway: % c.stimScreen = CenterRect([0 0 p.picres],[p.dispresreal]);

% Bar coordinates 
c.rectbarra = [c.xcenter-p.picres(1)/p.pesobarra c.ycenter-p.picres(2)/p.pesobarra c.xcenter+p.picres(1)/p.pesobarra c.ycenter+p.picres(2)/p.pesobarra];

% Left bar coordinates
c.rectizq = [c.rectbarra(1)-((size(p.barra,2)/2)+1) c.ycenter-(size(p.barra,1)/2) c.rectbarra(1)+((size(p.barra,2)/2)+1) c.ycenter+(size(p.barra,1)/2)];

% Right bar coordinates
c.rectder = [c.rectbarra(3)-((size(p.barra,2)/2)+1) c.ycenter-(size(p.barra,1)/2) c.rectbarra(3)+((size(p.barra,2)/2)+1) c.ycenter+(size(p.barra,1)/2)];

% Left FrameRect coordinates (center of left bar frame)
c.cxizq = c.rectizq (1) + (c.rectizq (3) - c.rectizq (1))/2;
c.cyizq = c.rectizq (2) + (c.rectizq (4) - c.rectizq (2))/2;

% Right FrameRect coordinates (center of right bar frame)
c.cxder = c.rectder (1) + (c.rectder (3) - c.rectder (1))/2;
c.cyder = c.rectder (2) + (c.rectder (4) - c.rectder (2))/2;

% Clean screen
Screen('Flip', c.wPtr);

GetSecs % This is because the first time you acces to a mex file it takes some hundreds milliseconds

end