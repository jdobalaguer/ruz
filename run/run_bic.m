%#ok<*NODEF>

function varargout = run_bic(criterion)
    %%
    % help('run_bic')
    %
    % syntax:       run_bic([criterion])
    % description:  estimates de bayesian information criterion for each model
    % arguments:    criterion: criterion to use
    % 
    % examples:     run_bic()
    % examples:     run_bic(@(ch,co)ch)
    % examples:     run_bic(@(ch,co)co)
    % 
    
    %% criterion
    if ~exist('criterion','var')
        criterion = model_criterion();
    end
    
    %% load
    load('data/sdata.mat','models');
    
    %% numbers
    u_model         = fieldnames(models);
    nb_model        = length(u_model);
    
    %% bayesian information criterion
    bic = nan(1,nb_model);
    for i_model = 1:nb_model
        
        % model
        model       = models.(u_model{i_model});
        model.value = criterion(model.choice,model.correct);
        
        % human
        human       = models.human;
        human.value = criterion(human.choice,human.correct);
                
        % bic
        model.bic    = model_bic(model,human);
        bic(i_model) = model.bic;
        
        % save
        models.(u_model{i_model}) = model;
    end
    
    %% return
    if nargout
        varargout = {bic};
        return;
    end
    
    %% print
    varargout = {};
    
    % criterion
    fprintf('\n');
    fprintf('run_bic: criterion "%s" \n',func2str(criterion));
    fprintf('\n');
    
    % BIC
    for i_model = 1:nb_model
        str_mod = sprintf('BIC(%s)',u_model{i_model});
        str_mod(end+1:15) = ' ';
        str_bic = sprintf('= %.2f \n',models.(u_model{i_model}).bic);
        fprintf([str_mod,str_bic]);
    end
    fprintf('\n');
end