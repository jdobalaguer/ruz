
function co3_batch()
    %% variables
    u_alpham   = linspace(0,2,21);
    u_alphar   = linspace(0,1,21);
    u_tau      = linspace(0,1,21);
    model_name = 'co3';
    model_df   = 3;
    model_file = 'data/models_co3.mat';
    
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
