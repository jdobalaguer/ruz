
function ruz_batch_numbers(u_alphat,u_alphan,u_tau)
    %% load
    numbers   = struct();
    load('data/sdata.mat','numbers');

    %% variables
    nb_alphat  = length(u_alphat);
    nb_alphan  = length(u_alphan);
    nb_tau     = length(u_tau);

    %% numbers
    numbers.ruz.u_alphat    = u_alphat;
    numbers.ruz.u_alphan    = u_alphan;
    numbers.ruz.u_tau       = u_tau;
    numbers.ruz.nb_alphat   = nb_alphat;
    numbers.ruz.nb_alphan   = nb_alphan;
    numbers.ruz.nb_tau      = nb_tau;
    tools_parforprogress(1);tools_parforprogress(0);

    %% save
    save('data/sdata.mat','-append','numbers');
end
