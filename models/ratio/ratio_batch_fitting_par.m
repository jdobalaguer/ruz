

function [mkey,mbic] = ratio_batch_fitting_par(u_subject,u_novel,human,sdata,mdata,mbic_keys,mbic_vals,alpha_m,alpha_r,tau)
    %% variables
    % numbers
    nb_subject = length(u_subject);
    nb_novel   = length(u_novel);
    % key
    mkey = [alpha_m,alpha_r,tau];
    % criterion
    criterion  = model_criterion();
    % model
    model      = mdata(mkey);
    model.value = criterion(model.choice,model.correct);
    model.df    = 3;

    %% mkey, mbic
    if isempty(mbic_keys) || ~ismember(mkey,cell2mat(mbic_keys),'rows')
        %% fitting
        mbic = uint8(nan(nb_subject,nb_novel,2));
        for i_subject = 1:nb_subject
        for i_novel   = 1:nb_novel

            % frame
            ii_subject = (sdata.exp_subject == u_subject(i_subject));
            ii_novel   = (sdata.vb_novel    == u_novel(i_novel));
            ii_frame   = (ii_subject & ii_novel);

            % bic
            mbic(i_subject,i_novel,1) = model_bic(model.df, model.choice,  human.choice,  ii_frame);
            mbic(i_subject,i_novel,2) = model_bic(model.df, model.correct, human.correct, ii_frame);

        end
        end
    else
    %% already exists
        [~,locb]   = ismember(mkey,cell2mat(mbic_keys),'rows');
        mkey       = [nan,nan,nan];
        mbic       = mbic_vals{locb};
    end
    
    % progress
    tools_parforprogress();
    
end