
function ta2_batch()
    %% variables
    u_alpham   = 0.5;
    u_alphar   = linspace(0,1,2);
    u_tau      = linspace(0,1,2);
    model_name = 'ta2';
    model_df   = 2;
    model_file = 'data/models_ta2.mat';
    
    %% parallel
    tools_startparallel();

    %% run
    fprintf('ta2_batch: run \n');
    ta3_batch_run(u_alpham,u_alphar,u_tau,model_file);

    %% fitting
    fprintf('ta2_batch: fitting \n');
    ta3_batch_fitting(u_alpham,u_alphar,u_tau,model_file);

    %% sdata
    fprintf('ta2_batch: sdata \n');
    ta3_batch_sdata(u_alpham,u_alphar,u_tau,model_file,model_name,model_df);

    %% numbers
    fprintf('ta2_batch: numbers \n');
    ta3_batch_numbers(u_alpham,u_alphar,u_tau,model_name);

end
