% %%% %%% %%% %%% %%% setupdirectories %%% %%% %%% %%% %%% %
% %
% % % This function is a subfunction used to set relevant directories
% % % and create subject's folder

function [d] = exotimes_setupdirectoriesFade(p)
warning('off','MATLAB:MKDIR:DirectoryExists')

d.stimdir = '.\Stims\'; % Stims
d.sujsdir = '.\Sujetos\'; % Subjects
d.xpdir = '.\'; % Root experiment
d.prctdir = '.\StimsPractica\'; % Practice stims

% Create subject folder
d.nsujsdir = ([d.sujsdir,'S',num2str(p.nsuj),'\']);
mkdir(d.nsujsdir);
warning('on','MATLAB:MKDIR:DirectoryExists');
end