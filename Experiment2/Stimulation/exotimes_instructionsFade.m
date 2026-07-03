% %%% %%% %%% %%% %%% %%% instrucciones %%% %%% %%% %%% %%% %%% %
% %
% % % This function welcomes participant


function exotimes_instructionsFade(c)

% % % Prepare parameters  
Screen('TextColor',c.wPtr,255); Screen('TextSize',c.wPtr,35);
Screen('TextFont',c.wPtr,'Helvetica'); 

% % % Instructions
Instrucciones0 = '¡Bienvenido/a al experimento!';
Instrucciones1 = '\nA continuación se te presentará una serie de imágenes\n\nEn cada ensayo verás dos barras; fíjate en la inclinación de las barras y responde: \n- Si las dos barras tienen la MISMA orientación\n- O si cada barra tiene una orientación DISTINTA\n\nPulsa espacio para continuar';
Instrucciones2 = '\n¡IMPORTANTE!\n En ocasiones el cambio de orientación será muy sutil, debes estar atento/a\nPor favor, contesta rápido pero intenta no equivocarte\n\n¡MIRA SIEMPRE AL PUNTO DE FIJACIÓN! \n\n Pulsa espacio para continuar';
Instrucciones3 = '\nUtiliza las teclas\nIZQUIERDA = Si tienen la misma orientación, si son IGUALES\nDERECHA = Si no tienen la misma orientación, si son DIFERENTES\n\nVamos a hacer una breve práctica\n\n Pulsa espacio para continuar';


% % % Show instructions
DrawFormattedText(c.wPtr,Instrucciones0,'center','center',[],[],[],[],3,[])
Screen('Flip',c.wPtr); KbWait([]); WaitSecs(0.5);
DrawFormattedText(c.wPtr,Instrucciones1,'center','center',[],[],[],[],3,[])
Screen('Flip',c.wPtr); KbWait([]); WaitSecs(0.5);
DrawFormattedText(c.wPtr,Instrucciones2,'center','center',[],[],[],[],3,[])
Screen('Flip',c.wPtr); KbWait([]); WaitSecs(0.5);
DrawFormattedText(c.wPtr,Instrucciones3,'center','center',[],[],[],[],3,[])
Screen('Flip',c.wPtr); KbWait([]); WaitSecs(0.5);
Screen('Flip',c.wPtr); WaitSecs(1);

end