
function ta3_batch()
    %% variables
    u_alpham   = linspace(0,1,21);
    u_alphar   = linspace(0,1,21);
    u_tau      = linspace(0,1,21);
    
    %% parallel
    tools_startparallel();

    %% run
    fprintf('ta3_batch: run \n');
    ta3_batch_run(u_alpham,u_alphar,u_tau);

    %% fitting
    fprintf('ta3_batch: fitting \n');
    ta3_batch_fitting(u_alpham,u_alphar,u_tau);

    %% sdata
    fprintf('ta3_batch: sdata \n');
    ta3_batch_sdata(u_alpham,u_alphar,u_tau);

    %% numbers
    fprintf('ta3_batch: numbers \n');
    ta3_batch_numbers(u_alpham,u_alphar,u_tau);

end
