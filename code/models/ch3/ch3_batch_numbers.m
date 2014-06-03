
function ch3_batch_numbers(u_alpham,u_alphar,u_tau,model_name)
    %% load
    numbers   = struct();
    load('data/sdata.mat','numbers');

    %% variables
    nb_alpham  = length(u_alpham);
    nb_alphar  = length(u_alphar);
    nb_tau     = length(u_tau);

    %% numbers
    numbers.(model_name).u_alpham    = u_alpham;
    numbers.(model_name).u_alphar    = u_alphar;
    numbers.(model_name).u_tau       = u_tau;
    numbers.(model_name).nb_alpham   = nb_alpham;
    numbers.(model_name).nb_alphar   = nb_alphar;
    numbers.(model_name).nb_tau      = nb_tau;
    tools_parforprogress(1);tools_parforprogress(0);

    %% save
    save('data/sdata.mat','-append','numbers');
end
