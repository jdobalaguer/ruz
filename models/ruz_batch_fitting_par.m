

function ruz_batch_fitting_par(mbic_keys,alpha_t,alpha_n,tau)
%{
    inputs
    - u_subject, u_novel
    - mbic_keys
    - model

    outputs
    - new_keys, new_vals
    - greed_bic
%}
    
    %% initialise
    % numbers
    nb_subject = length(u_subject);
    nb_novel   = length(u_novel);
    % criterion
    criterion       = model_criterion();
    % human
    human           = models.human;
    human.value     = criterion(human.choice,human.correct);
    % mbic

    %% loop subject/novel
    for i_subject = 1:nb_subject
    for i_novel   = 1:nb_novel

        % keys
        mkey = [alpha_t,alpha_n,tau];

        % bic
        if ~mbic.iskey(mbic_key)

            % model
            model       = mdata(mdata_key);
            model.value = criterion(model.choice,model.correct);
            model.df    = 3;

            % frame
            ii_subject = (sdata.exp_subject == u_subject(i_subject));
            ii_novel   = (sdata.vb_novel    == u_novel(i_novel));
            ii_frame   = (ii_subject & ii_novel);

            % bic
            mbic(mbic_key) = model_bic(model, human, ii_frame);

        end

        % save
        greed_bic(i_subject,i_novel) = mbic(mbic_key);

        % progress
        tools_parforprogress();
        
    end
    end
    
end