% %%% %%% %%% %%% %%% setuprandomseed %%% %%% %%% %%% %%% %
% %
% % % This function generates and stores (in p) a random seed in the
% % % recommended way depending of Matlab version

function [p] = exotimes_randomseedFade(p)

% Random number
p.seed = round (sum (10*clock));

% Matlab version
p.version = version;

% % Re-initialize the random generator state
% if version < 6; rand('state',p.seed);
% else rng('default'); rng(p.seed);
% end
rand('state',p.seed);

end