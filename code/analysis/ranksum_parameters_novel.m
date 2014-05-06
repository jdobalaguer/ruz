
function ranksum_parameters_novel(model)
    %% defaults
    if ~exist('model','var'), model = model_valid(); end
    
    %% load
    load('data/sdata.mat','models');
    fittings = models.(model).fittings;
    optimals = models.(model).optimals;
    
    %% models
    switch(model)
        case 'ta2'
            u_pars = {'alpha_M','alpha_R','tau    '};
        case 'ta3'
            u_pars = {'alpha_M','alpha_R','tau    '};
        case 'co2'
            u_pars = {'alpha_M','alpha_R','tau    '};
        case 'co3'
            u_pars = {'alpha_M','alpha_R','tau    '};
        case 'taco4'
            u_pars = {'alpha_M ','alpha_RT','alpha_RC','tau     '};
        otherwise
            error('plot_model_alphas: error. unknown model "%s"',model);
    end
    
    %% numbers
    nb_pars = length(u_pars);
    
    %% adaptation between conditions
    cprintf('red','adaptation between conditions \n');
    % fittings
    fprintf('fittings on %s \n',model);
    for i_pars = 1:nb_pars
        fprintf('  p(%s) = %.3f \n',u_pars{i_pars},...
                                    ranksum(fittings(:,1,i_pars) , fittings(:,2,i_pars)));
    end
    fprintf('\n');
    
    % optimals
    fprintf('optimals on %s \n',model);
    for i_pars = 1:nb_pars
        fprintf('  p(%s) = %.3f \n',u_pars{i_pars},...
                                    ranksum(optimals(:,1,i_pars) , optimals(:,2,i_pars)));
    end
    fprintf('\n');
    
    %% deviance from optimality
    cprintf('red','deviance from optimality \n');
    % familiar
    fprintf('familiar on %s \n',model);
    for i_pars = 1:nb_pars
        fprintf('  p(%s) = %.3f \n',u_pars{i_pars},...
                                    ranksum(fittings(:,1,i_pars) , optimals(:,1,i_pars)));
    end
    % novel
    fprintf('novel on %s \n',model);
    for i_pars = 1:nb_pars
        fprintf('  p(%s) = %.3f \n',u_pars{i_pars},...
                                    ranksum(fittings(:,2,i_pars) , optimals(:,2,i_pars)));
    end

end