
function ratio2_batch()
    %% variables
    u_alpham   = linspace(0,1,21);
    u_alphar   = 0.5;
    u_tau      = linspace(0,1,21);
    
    %% parallel
    tools_startparallel();

    %% run
    fprintf('ratio2_batch: run \n');
    ratio2_batch_run(u_alpham,u_alphar,u_tau);

    %% fitting
    fprintf('ratio2_batch: fitting \n');
    ratio2_batch_fitting(u_alpham,u_alphar,u_tau);

    %% sdata
    fprintf('ratio2_batch: sdata \n');
    ratio2_batch_sdata(u_alpham,u_alphar,u_tau);

    %% numbers
    fprintf('ratio2_batch: numbers \n');
    ratio2_batch_numbers(u_alpham,u_alphar,u_tau);

end
