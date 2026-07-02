% MUA: generate individual ERPs from the grand average

%One ERP per subject, containing all conditions stacked (e.g., prior to MUA in EEGlab)

sujetos=size(ana,1);
condics=size(ana,2);
puntos=size(ana,3);
contador=1;

med=NaN(size(ana,4),puntos*condics);

for suj=1:sujetos
    for cond=1:condics
        for punto=1:puntos
            med(:,contador)=squeeze(ana(suj,cond,punto,:));
            contador=contador+1; % In EEGlab rows are channels and columns are timepoints (counter must be set at this level)            nombrearchivo=strcat('suj',num2str(suj));
            save (nombrearchivo, 'med')
        end
    end
    contador=1;
    disp(['^ Sujeto ',num2str(suj)])
end
clear contador    