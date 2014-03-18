
function choice2_batch()
    %% variables
    u_alphat   = linspace(0,1,21);
    u_alphan   = 0.4;
    u_tau      = linspace(0,1,21);
    
    %% parallel
    tools_startparallel();

    %% run
    fprintf('choice2_batch: run \n');
    choice2_batch_run(u_alphat,u_alphan,u_tau);

    %% fitting
    fprintf('choice2_batch: fitting \n');
    choice2_batch_fitting(u_alphat,u_alphan,u_tau);

    %% sdata
    fprintf('choice2_batch: sdata \n');
    choice2_batch_sdata(u_alphat,u_alphan,u_tau);

    %% numbers
    fprintf('choice2_batch: numbers \n');
    choice2_batch_numbers(u_alphat,u_alphan,u_tau);

end
