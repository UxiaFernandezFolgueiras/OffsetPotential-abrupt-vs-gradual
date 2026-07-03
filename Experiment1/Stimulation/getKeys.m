function keyPressed = getKeys(keysWanted) % keysWanted is a matrix list of keys you are
% waiting for e.g, [124 125 kbName('space')]
FlushEvents('keydown');
success = 0;
while success == 0
    pressed = 0;
    while pressed == 0
        [pressed, ~, kbData] = KbCheck;
    end;
    for i = 1:length(keysWanted)
        if kbData(keysWanted(i)) == 1
            success = 1;
            keyPressed = keysWanted(i);
            FlushEvents('keydown');
            break;
        end;
    end;
    FlushEvents('keydown');
end;