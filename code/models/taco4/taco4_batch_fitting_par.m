

function [mkey,mbic,mcor] = taco4_batch_fitting_par(u_subject,u_novel,human,sdata,mdata,mbic_keys,mbic_vals,mcor_vals,alpha_m,alpha_rt,alpha_rc,tau)
    %% variables
    % numbers
    nb_subject = length(u_subject);
    nb_novel   = length(u_novel);
    % key
    mkey = [alpha_m,alpha_rt,alpha_rc,tau];
    % criterion
    criterion  = model_criterion();
    % model
    model       = mdata(mkey);
    model.value = criterion(model.choice,model.correct);
    model.df    = 3;

    %% mkey, mbic
    if isempty(mbic_keys) || ~ismember(mkey,cell2mat(mbic_keys),'rows')
        %% fitting
        mbic = single(nan(nb_subject,nb_novel,2));
        mcor = single(nan(nb_subject,nb_novel,2));
        for i_subject = 1:nb_subject
        for i_novel   = 1:nb_novel

            % frame
            ii_subject = (sdata.exp_subject == u_subject(i_subject));
            ii_novel   = (sdata.vb_novel    == u_novel(i_novel));
            ii_frame   = (ii_subject & ii_novel);

            % bic
            mbic(i_subject,i_novel,1) = model_dist(model.df, model.choice,  human.choice,  ii_frame, 0);
            mbic(i_subject,i_novel,2) = model_dist(model.df, model.correct, human.correct, ii_frame, 0);

            mcor(i_subject,i_novel,1) = mean(model.choice(ii_frame)); %single rescaling
            mcor(i_subject,i_novel,2) = mean(model.correct(ii_frame));%single rescaling
        end
        end
    else
    %% already exists
        [~,locb]   = ismember(mkey,cell2mat(mbic_keys),'rows');
        mkey       = [nan,nan,nan,nan];
        mbic       = mbic_vals{locb};
        mcor       = mcor_vals{locb};
    end
    
    % progress
    tools_parforprogress();
    
end