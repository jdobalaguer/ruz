
if ~strcmp(hostname(),'minime'), return; end

%% matlabpool
pctconfig('portrange',[31000,32000]);

%% pathdef
addpath(genpath('/home/jan/workspace/gitmatlab/jbtools/figures/'));
addpath(genpath('/home/jan/workspace/gitmatlab/jbtools/anonymous/'));
addpath(genpath('/home/jan/workspace/gitmatlab/jbtools/jb/'));
addpath(genpath('/home/jan/workspace/gitmatlab/jbtools/analysis_tool/'));
