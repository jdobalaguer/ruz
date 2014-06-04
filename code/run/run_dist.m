%
% RUN_DIST
% calculate distances for all models
%

%% warning
%#ok<*NODEF>

%function varargout = run_dist(criterion)
    %%
    % help('run_dist')
    %
    % syntax:       run_bic([criterion])
    % description:  estimates de bayesian information criterion for each model
    % arguments:    criterion: criterion to use
    % 
    % examples:     run_dist()
    % examples:     run_dist(@(ch,co)ch)
    % examples:     run_dist(@(ch,co)co)
    % 
    
    %% criterion
    if ~exist('criterion','var')
        criterion = valid_criterion();
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
    u_subject       = numbers.shared.u_subject;
    nb_subject      = numbers.shared.nb_subject;
    
    %% bayesian information criterion
    bic_ch = nan(nb_odd,nb_model,nb_novel,nb_subject);
    bic_co = nan(nb_odd,nb_model,nb_novel,nb_subject);
    for i_odd   = 1:nb_odd
        for i_model = 1:nb_model
            for i_novel = 1:nb_novel
                for i_subject = 1:nb_subject

                    % model
                    model       = models.(u_model{i_model});
                    model.value = criterion(model.choice,model.correct);

                    % human
                    human       = models.human;
                    human.value = criterion(human.choice,human.correct);

                    % frame
                    ii_sub      = (sdata.exp_subject == u_subject(i_subject));
                    ii_novel    = (sdata.vb_novel    == u_novel(i_novel));
                    ii_frame    = (ii_sub & ii_novel);

                    % bic
                    bic_ch(i_odd,i_model,i_novel,i_subject) = model_dist(model.df, model.choice ,human.choice, ii_frame, u_odd(i_odd));
                    bic_co(i_odd,i_model,i_novel,i_subject) = model_dist(model.df, model.correct,human.correct,ii_frame, u_odd(i_odd));
                    
                end
            end
        end
    end
    bic = criterion(bic_ch,bic_co);
    
    %% return
    if nargout
        varargout = {bic};
        return;
    end
    
    %% print BIC scores
    
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
            str_bmf = sprintf('= %.4f',mean(bic(i_odd,i_model,1,:),4));
            str_bmf(end+1:10) = ' ';
            str_bef = sprintf('± %.4f',ste( bic(i_odd,i_model,1,:),4));
            str_bef(end+1:10) = ' ';
            str_bmn = sprintf('= %.4f',mean(bic(i_odd,i_model,2,:),4));
            str_bmn(end+1:10) = ' ';
            str_ben = sprintf('± %.4f',ste( bic(i_odd,i_model,2,:),4));
            str_ben(end+1:10) = ' ';
            fprintf([str_mod,str_bmf,str_bef,str_bmn,str_ben,'\n']);
        end
        fprintf('\n');
    end
    
    %% print t-test
    
    % criterion
    fprintf('\n');
    fprintf('run_bic: criterion "%s" \n',func2str(criterion));
    fprintf('\n');
    
    for i_odd   = 1:nb_odd
        for i_novel   = 1:nb_novel
            fprintf('run_bic: oddity %d novel %d \n',u_odd(i_odd),u_novel(i_novel));
            for i_model1 = 1:nb_model
                str_mod = sprintf('BIC(%s)',u_model{i_model1});
                str_mod(end+1:15) = ' ';
                fprintf(str_mod);
                for i_model2 = 1:nb_model
                    bic1    = squeeze(bic(i_odd,i_model1,i_novel,:));
                    bic2    = squeeze(bic(i_odd,i_model2,i_novel,:));
                    [h,p,c,s]   = ttest(bic1,bic2,'tail','left');
                    t = s.tstat;
                    if isnan(h), h = 0; end
                    if isnan(p), p = 1; end
                    if isnan(t), t = 0; end
                    str_val = sprintf('%+0.4f',p);
                    str_val(end:7) = ' '; 
                    if h
                        cprintf('red',str_val);
                    else
                        cprintf('black',str_val);
                    end
                end
                fprintf('\n');
            end
            fprintf('\n');
        end
    end
    
    %% return
    varargout = {};
    
%end