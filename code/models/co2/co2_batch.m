
function co2_batch()
    %% variables
    u_alpham   = 0.50;
    u_alphar   = linspace(0,1,21);
    u_tau      = linspace(0,1,21);
    model_name = 'co2';
    model_df   = 2;
    model_file = 'data/models_co2.mat';
    
    %% parallel
    tools_startparallel();

    %% run
    fprintf('co3_batch: run \n');
    co3_batch_run(u_alpham,u_alphar,u_tau,model_file);

    %% fitting
    fprintf('co3_batch: fitting \n');
    co3_batch_fitting(u_alpham,u_alphar,u_tau,model_file);

    %% sdata
    fprintf('co3_batch: sdata \n');
    co3_batch_sdata(u_alpham,u_alphar,u_tau,model_file,model_name,model_df);

    %% numbers
    fprintf('co3_batch: numbers \n');
    co3_batch_numbers(u_alpham,u_alphar,u_tau,model_name);

end