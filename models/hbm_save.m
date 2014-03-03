
%% change directory
cd('..');

%% add variables
models.hbm.nb_candidates = mdata.nb_candidates;
models.hbm.prob_target   = mdata.prob_target;
models.hbm.entropy_left  = mdata.entropy_left;
models.hbm.entropy_right = mdata.entropy_right;

%% save
save('data/sdata.mat','-append','models');
