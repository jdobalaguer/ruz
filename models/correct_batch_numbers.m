
function correct_batch_numbers(u_alphac,u_alphaw,u_tau)
    %% load
    numbers   = struct();
    load('data/sdata.mat','numbers');

    %% variables
    nb_alphac  = length(u_alphac);
    nb_alphaw  = length(u_alphaw);
    nb_tau     = length(u_tau);

    %% numbers
    numbers.correct.u_alphac    = u_alphac;
    numbers.correct.u_alphaw    = u_alphaw;
    numbers.correct.u_tau       = u_tau;
    numbers.correct.nb_alphac   = nb_alphac;
    numbers.correct.nb_alphaw   = nb_alphaw;
    numbers.correct.nb_tau      = nb_tau;
    tools_parforprogress(1);tools_parforprogress(0);

    %% save
    save('data/sdata.mat','-append','numbers');
end
