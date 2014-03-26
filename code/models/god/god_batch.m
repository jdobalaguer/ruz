
function god_batch()
    %% model
    model.name = 'god';

    %% load
        % sdata
    load('data/sdata.mat');

    %% variables

    %% run
    mdata = run_model(model,sdata,numbers);

    %% save
        % sdata
    models.god.choice  = mdata.choice;
    models.god.correct = mdata.correct;
    models.god.df      = 0;
    save('data/sdata.mat','-append','models');
end
