
%% matlabpool
pctconfig('portrange',[31000,32000]);

%% pathdef
if ~exist('fig_color','file');  addpath('/home/jan/workspace/gitmatlab/jbtools/figures/'); end
if ~exist('ste','file');        addpath('/home/jan/workspace/gitmatlab/jbtools/anonymous/'); end
if ~exist('jb_index','file');   addpath('/home/jan/workspace/gitmatlab/jbtools/jb/'); end
if ~exist('analysis','file');   addpath('/home/jan/workspace/gitmatlab/jbtools/analysis/'); end
