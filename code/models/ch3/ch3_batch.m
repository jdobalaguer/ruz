
function ch3_batch()
    %% variables
    u_alpham   = linspace(0,2,21);
    u_alphar   = linspace(0,1,21);
    u_tau      = linspace(0,1,21);
    model_name = 'ch3';
    model_df   = 3;
    model_file = 'data/models_ch3.mat';
    
    %% parallel
    tools_startparallel();

    %% run
    fprintf('ch3_batch: run \n');
    ch3_batch_run(u_alpham,u_alphar,u_tau,model_file);

    %% fitting
    fprintf('ch3_batch: fitting \n');
    ch3_batch_fitting(u_alpham,u_alphar,u_tau,model_file);

    %% sdata
    fprintf('ch3_batch: sdata \n');
    ch3_batch_sdata(u_alpham,u_alphar,u_tau,model_file,model_name,model_df);

    %% numbers
    fprintf('ch3_batch: numbers \n');
    ch3_batch_numbers(u_alpham,u_alphar,u_tau,model_name);

end
