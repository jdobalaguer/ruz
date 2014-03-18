
function ratio2_batch_numbers(u_alpham,u_alphar,u_tau)
    %% load
    numbers   = struct();
    load('data/sdata.mat','numbers');

    %% variables
    nb_alpham  = length(u_alpham);
    nb_alphar  = length(u_alphar);
    nb_tau     = length(u_tau);

    %% numbers
    numbers.ratio2.u_alpham    = u_alpham;
    numbers.ratio2.u_alphar    = u_alphar;
    numbers.ratio2.u_tau       = u_tau;
    numbers.ratio2.nb_alpham   = nb_alpham;
    numbers.ratio2.nb_alphar   = nb_alphar;
    numbers.ratio2.nb_tau      = nb_tau;
    tools_parforprogress(1);tools_parforprogress(0);

    %% save
    save('data/sdata.mat','-append','numbers');
end
