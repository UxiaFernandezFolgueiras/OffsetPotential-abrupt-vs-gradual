% %%% %%% %%% %%% %%% setupdirectories %%% %%% %%% %%% %%% %
% %
% % % This function is a subfunction used to set relevant directories
% % % and create subject's folder

function [d] = exotimes_setupdirectories_fade(p)
warning('off','MATLAB:MKDIR:DirectoryExists')

d.stimdir = '.\Stims\'; % Stimuli
d.sujsdir = '.\Sujetos\'; % Subjects
d.xpdir = '.\'; % Root experiment
d.prctdir = '.\StimsPractica\'; % Practice stimuli

% Create subject folder
d.nsujsdir = ([d.sujsdir,'S',num2str(p.nsuj),'\']);
mkdir(d.nsujsdir);
warning('on','MATLAB:MKDIR:DirectoryExists');
end