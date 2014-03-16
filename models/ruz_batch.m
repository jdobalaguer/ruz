
function ruz_batch()
    %% variables
    u_alphat   = linspace(0,1,21);
    u_alphan   = linspace(0,1,21);
    u_tau      = linspace(0,1,21);
    
    %% parallel
    tools_startparallel();

    %% run
    fprintf('ruz_batch: run \n');
    ruz_batch_run(u_alphat,u_alphan,u_tau);

    %% fitting
    fprintf('ruz_batch: fitting \n');
    ruz_batch_fitting(u_alphat,u_alphan,u_tau);

    %% sdata
    fprintf('ruz_batch: sdata \n');
    ruz_batch_sdata(u_alphat,u_alphan,u_tau);

    %% numbers
    fprintf('ruz_batch: numbers \n');
    ruz_batch_numbers(u_alphat,u_alphan,u_tau);

end
