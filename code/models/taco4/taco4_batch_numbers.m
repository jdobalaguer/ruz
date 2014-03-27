
function taco4_batch_numbers(u_alpham,u_alphart,u_alpharc,u_tau,model_name)
    %% load
    numbers   = struct();
    load('data/sdata.mat','numbers');

    %% variables
    nb_alpham  = length(u_alpham);
    nb_alphart = length(u_alphart);
    nb_alpharc = length(u_alpharc);
    nb_tau     = length(u_tau);

    %% numbers
    numbers.(model_name).u_alpham    = u_alpham;
    numbers.(model_name).u_alphart   = u_alphart;
    numbers.(model_name).u_alpharc   = u_alpharc;
    numbers.(model_name).u_tau       = u_tau;
    numbers.(model_name).nb_alpham   = nb_alpham;
    numbers.(model_name).nb_alphart  = nb_alphart;
    numbers.(model_name).nb_alpharc  = nb_alpharc;
    numbers.(model_name).nb_tau      = nb_tau;
    tools_parforprogress(1);tools_parforprogress(0);

    %% save
    save('data/sdata.mat','-append','numbers');
end
