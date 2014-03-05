
%% change directory
cd('..');

%% load
    % sdata
load('data/sdata.mat','models');

%% variables

%% run
this_mdata = run_model(model);

%% save
    % sdata
models.hbm.choice  = this_mdata.choice;
models.hbm.correct = this_mdata.correct;
models.hbm.df      = 0;
save('data/sdata.mat','-append','models');
    % models
mdata.nb_candidates = this_mdata.nb_candidates;
mdata.prob_target   = this_mdata.prob_target;
mdata.entropy_left  = this_mdata.entropy_left;
mdata.entropy_right = this_mdata.entropy_right;
save('data/models_hbm.mat','mdata');