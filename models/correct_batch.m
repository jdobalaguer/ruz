
function correct_batch()
    %% variables
    u_alphac   = linspace(0,1,3);
    u_alphaw   = linspace(0,1,3);
    u_tau      = linspace(0,1,3);
    
    %% parallel
    tools_startparallel();

    %% run
    fprintf('correct_batch: run \n');
    correct_batch_run(u_alphac,u_alphaw,u_tau);

    %% fitting
    fprintf('correct_batch: fitting \n');
    correct_batch_fitting(u_alphac,u_alphaw,u_tau);

    %% sdata
    fprintf('correct_batch: sdata \n');
    correct_batch_sdata(u_alphac,u_alphaw,u_tau);

    %% numbers
    fprintf('correct_batch: numbers \n');
    correct_batch_numbers(u_alphac,u_alphaw,u_tau);

end
