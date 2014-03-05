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
        criterion = @(ch,co) ch;
    end
    
    %% load
    load('data/sdata.mat');
    
    %% numbers
    u_model         = fieldnames(models);
    u_novel         = numbers.shared.u_novel;
    u_trial         = numbers.shared.u_trial;
    nb_model        = length(u_model);
    nb_novel        = numbers.shared.nb_novel;
    nb_trial        = numbers.shared.nb_trial;
    nb_condition    = nb_novel * nb_trial;
    
    %% bayesian information criterion
    bic = nan(1,nb_model);
    for i_model = 1:nb_model
        
        % model
        model       = models.(u_model{i_model});
        model.value = criterion(model.choice,model.correct);
        
        % human
        human       = models.human;
        human.value = criterion(human.choice,human.correct);
                
        % likelihood
        model.like = nan(1,nb_condition);
        i_condition = 0;
        for i_novel = 1:nb_novel
            for i_trial = 1:nb_trial
                i_condition = i_condition + 1;                                  ... index
                ii_novel                = (sdata.vb_novel  == u_novel(i_novel));
                ii_trial                = (sdata.exp_trial == u_trial(i_trial));
                ii_condition            = (ii_novel & ii_trial);
                novel_sum               =  sum(ii_condition);                       ... values
                model.sum               =  sum(model.value(ii_condition));
                human.mean              = mean(human.value(ii_condition));
                model.like(i_condition) = binopdf(model.sum,novel_sum,human.mean);  ... likelihood
            end
        end
        
        % BIC
        model.bic    = -2 * log(prod(model.like)) + (model.df)*log(nb_condition);
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