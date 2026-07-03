% discriminacion_captureKeyboard(p, estimulo)
%
% receives 2 input parameters:
% - p: the configuration structure
% - estimulo: the stimulus being evaluated
%
% returns 2 output variables:
% - acierto: 1 if the participant responded correctly, 0 if not
% - capturedKey: the key pressed by the participant, or empty string if
% no key was pressed
%
function [acierto, capturedKey] = exotimes_captureKeyboard(p, estimulo)
activacion=NaN;
valencia=NaN;
capturedKey = ' ';
[keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
if (keyIsDown)
    capturedKey = KbName(find(keyCode)); % key?
    WaitSecs(0.5)
    FlushEvents('keyDown');
end

end
