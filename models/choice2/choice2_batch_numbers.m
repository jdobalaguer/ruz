
function choice2_batch_numbers(u_alphat,u_alphan,u_tau)
    %% load
    numbers   = struct();
    load('data/sdata.mat','numbers');

    %% variables
    nb_alphat  = length(u_alphat);
    nb_alphan  = length(u_alphan);
    nb_tau     = length(u_tau);

    %% numbers
    numbers.choice2.u_alphat    = u_alphat;
    numbers.choice2.u_alphan    = u_alphan;
    numbers.choice2.u_tau       = u_tau;
    numbers.choice2.nb_alphat   = nb_alphat;
    numbers.choice2.nb_alphan   = nb_alphan;
    numbers.choice2.nb_tau      = nb_tau;
    tools_parforprogress(1);tools_parforprogress(0);

    %% save
    save('data/sdata.mat','-append','numbers');
end
