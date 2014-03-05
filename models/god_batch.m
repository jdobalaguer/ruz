
%% change directory
cd('..');

%% load
    % sdata
load('data/sdata.mat','models');

%% variables

%% run
mdata = run_model(model);

%% save
    % sdata
models.god.choice  = mdata.choice;
models.god.correct = mdata.correct;
models.god.df      = 0;
save('data/sdata.mat','-append','models');