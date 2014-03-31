%
% RUN_BIC
% calculate bic values for all models
%

%% warning
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
    load('data/sdata.mat');
    
    %% numbers
    u_model         = fieldnames(models);
    nb_model        = length(u_model);
    u_novel         = numbers.shared.u_novel;
    nb_novel        = numbers.shared.nb_novel;
    u_odd           = 0:1;
    nb_odd          = length(u_odd);
    
    %% bayesian information criterion
    bic_ch = nan(nb_odd,nb_model,nb_novel);
    bic_co = nan(nb_odd,nb_model,nb_novel);
    for i_odd   = 1:nb_odd
        for i_model = 1:nb_model
            for i_novel = 1:nb_novel

                % model
                model       = models.(u_model{i_model});
                model.value = criterion(model.choice,model.correct);

                % human
                human       = models.human;
                human.value = criterion(human.choice,human.correct);

                % frame
                ii_novel    = (sdata.vb_novel == u_novel(i_novel));

                % bic
                bic_ch(i_odd,i_model,i_novel) = model_bic(model.df, model.choice ,human.choice, ii_novel, u_odd(i_odd));
                bic_co(i_odd,i_model,i_novel) = model_bic(model.df, model.correct,human.correct,ii_novel, u_odd(i_odd));
            end
        end
    end
    bic = criterion(bic_ch,bic_co);
    
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
    for i_odd   = 1:nb_odd
        fprintf('run_bic: oddity %d \n',u_odd(i_odd));
        for i_model = 1:nb_model
            str_mod = sprintf('BIC(%s)',u_model{i_model});
            str_mod(end+1:15) = ' ';
            str_bif = sprintf('= %.2f',bic(i_odd,i_model,1));
            str_bif(end+1:10) = ' ';
            str_bin = sprintf('= %.2f',bic(i_odd,i_model,2));
            str_bin(end+1:10) = ' ';
            fprintf([str_mod,str_bif,str_bin,'\n']);
        end
        fprintf('\n');
    end
end