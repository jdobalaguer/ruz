
function taco4_batch()
    %% variables
    u_alpham   = linspace(0,1,11);
    u_alphart  = linspace(0,1,11);
    u_alpharc  = linspace(0,1,11);
    u_tau      = linspace(0,1,11);
    model_name = 'taco4';
    model_df   = 4;
    model_file = 'data/models_taco4.mat';
    
    %% parallel
    tools_startparallel();

    %% run
    fprintf('taco4_batch: run \n');
    taco4_batch_run(u_alpham,u_alphart,u_alpharc,u_tau,model_file);

    %% fitting
    fprintf('taco4_batch: fitting \n');
    taco4_batch_fitting(u_alpham,u_alphart,u_alpharc,u_tau,model_file);

    %% sdata
    fprintf('taco4_batch: sdata \n');
    taco4_batch_sdata(u_alpham,u_alphart,u_alpharc,u_tau,model_file,model_name,model_df);

    %% numbers
    fprintf('taco4_batch: numbers \n');
    taco4_batch_numbers(u_alpham,u_alphart,u_alpharc,u_tau,model_name);

end
