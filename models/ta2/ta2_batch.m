
function ta2_batch()
    %% variables
    u_alpham   = 0.50;
    u_alphar   = linspace(0,1,21);
    u_tau      = linspace(0,1,21);
    
    %% parallel
    tools_startparallel();

    %% run
    fprintf('ta2_batch: run \n');
    ta2_batch_run(u_alpham,u_alphar,u_tau);

    %% fitting
    fprintf('ta2_batch: fitting \n');
    ta2_batch_fitting(u_alpham,u_alphar,u_tau);

    %% sdata
    fprintf('ta2_batch: sdata \n');
    ta2_batch_sdata(u_alpham,u_alphar,u_tau);

    %% numbers
    fprintf('ta2_batch: numbers \n');
    ta2_batch_numbers(u_alpham,u_alphar,u_tau);

end
