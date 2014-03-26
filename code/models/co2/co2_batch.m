
function co2_batch()
    %% variables
    u_alpham   = 0.50;
    u_alphar   = linspace(0,1,21);
    u_tau      = linspace(0,1,21);
    model_file = 'data/models_co2.mat';
    
    %% parallel
    tools_startparallel();

    %% run
    fprintf('co2_batch: run \n');
    ta3_batch_run(u_alpham,u_alphar,u_tau,model_file);

    %% fitting
    fprintf('co2_batch: fitting \n');
    ta3_batch_fitting(u_alpham,u_alphar,u_tau,model_file);

    %% sdata
    fprintf('co2_batch: sdata \n');
    ta3_batch_sdata(u_alpham,u_alphar,u_tau,model_file,2);

    %% numbers
    fprintf('co2_batch: numbers \n');
    ta3_batch_numbers(u_alpham,u_alphar,u_tau,'co2');

end
