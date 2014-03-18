
function choice_batch()
    %% variables
    u_alphat   = linspace(0,1,21);
    u_alphan   = linspace(0,1,21);
    u_tau      = linspace(0,1,21);
    
    %% parallel
    tools_startparallel();

    %% run
    fprintf('choice_batch: run \n');
    choice_batch_run(u_alphat,u_alphan,u_tau);

    %% fitting
    fprintf('choice_batch: fitting \n');
    choice_batch_fitting(u_alphat,u_alphan,u_tau);

    %% sdata
    fprintf('choice_batch: sdata \n');
    choice_batch_sdata(u_alphat,u_alphan,u_tau);

    %% numbers
    fprintf('choice_batch: numbers \n');
    choice_batch_numbers(u_alphat,u_alphan,u_tau);

end
