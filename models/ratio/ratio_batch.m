
function ratio_batch()
    %% variables
    u_alpham   = linspace(0,1,21);
    u_alphar   = linspace(0,1,21);
    u_tau      = linspace(0,1,21);
    
    %% parallel
    tools_startparallel();

    %% run
    fprintf('ratio_batch: run \n');
    ratio_batch_run(u_alpham,u_alphar,u_tau);

    %% fitting
    fprintf('ratio_batch: fitting \n');
    ratio_batch_fitting(u_alpham,u_alphar,u_tau);

    %% sdata
    fprintf('ratio_batch: sdata \n');
    ratio_batch_sdata(u_alpham,u_alphar,u_tau);

    %% numbers
    fprintf('ratio_batch: numbers \n');
    ratio_batch_numbers(u_alpham,u_alphar,u_tau);

end
