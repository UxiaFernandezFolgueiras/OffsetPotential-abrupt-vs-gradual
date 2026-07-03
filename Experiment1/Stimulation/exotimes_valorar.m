function [ valoracion ] = exotimes_valorar(p, c, txt)

% Display a texture and record the key pressed (1-5; 7-9).
% IMPORTANT:
% The function RestrictKeysForKbCheck() must be run first,
% passing the keyCodes for 1 to 5 and the spacebar keyCode.
% Display the texture.

Screen('DrawTexture', c.wPtr, txt);
Screen('Flip',c.wPtr);
while (true)
    % Wait for the participant to press a key.
    [~, keyCodes, ~] = KbWait();
    % Keys are restricted to 1-5, 7-9 and the spacebar
    % in _defaultparameters(). If the key pressed is not
    % the spacebar, exit the loop.
    if (~keyCodes(p.space))
        break
    end
end
% Get the pressed key from the keyCodes vector. The pressed key
% code is 1 and all other values are 0.
keyCode = find(keyCodes, 1);
% Get the key name and convert it to integer to record the response.
valoracion = str2double(KbName(keyCode));
end
