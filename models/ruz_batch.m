%#ok<*NASGU>
%#ok<*NODEF>
%#ok<*PFOUS>

function ruz_batch()

    %% variables
    u_alphat   = linspace(0,1,11);
    u_alphan   = linspace(0,1,11);
    u_tau      = linspace(0,1,11);
    
    %% parallel
    tools_startparallel;

    %% run
    fprintf('ruz_batch: run \n');
    ruz_batch_run(u_alphat,u_alphan,u_tau);
    return;

    %% fitting
    fprintf('ruz_batch: fitting \n');
    ruz_batch_fitting;


    %% sdata
    fprintf('ruz_batch: sdata \n');
    ruz_batch_sdata;

    %% numbers
    fprintf('ruz_batch: numbers \n');
    ruz_batch_numbers;

end
