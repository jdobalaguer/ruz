
%% change directory
cd('..');

%% load
    % sdata
load('data/sdata.mat','models');
    % models
if exist('data/models_hbm.mat','file'); load('data/sdata.mat');
else                                    hbm = struct();
end

%% variables

%% run
mdata = run_model(model);

%% save
    % sdata
models.hbm.choice  = mdata.choice;
models.hbm.correct = mdata.correct;
save('data/sdata.mat','-append','models');
    % models
hbm.nb_candidates = mdata.nb_candidates;
hbm.prob_target   = mdata.prob_target;
hbm.entropy_left  = mdata.entropy_left;
hbm.entropy_right = mdata.entropy_right;
save('data/models_hbm.mat','hbm');