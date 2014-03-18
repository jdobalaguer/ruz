
function choice_batch_sdata(u_alphat,u_alphan,u_tau)
    %% load
    sdata     = struct();
    models    = struct();
    numbers   = struct();
    mdata     = dict();
    greed_bic = [];
    load('data/sdata.mat');
    load('data/models_choice.mat','mdata','greed_bic');
    
    %% numbers
    u_subject  = numbers.shared.u_subject;
    u_novel    = numbers.shared.u_novel;

    nb_alphat  = length(u_alphat);
    nb_alphan  = length(u_alphan);
    nb_tau     = length(u_tau);
    nb_subject = numbers.shared.nb_subject;
    nb_novel   = numbers.shared.nb_novel;

    %% variables
    model_keys         = mdata.keys();
    model_values       = mdata.values();
    
    % minimise bic
    greed_bic        = reshape(greed_bic,[nb_alphat*nb_alphan*nb_tau,nb_subject,nb_novel]);
    [~,min_greedbic] = min(greed_bic,[],1);
    min_greedbic = squeeze(min_greedbic);
    
    % parameters
    xx_alphat = nan(nb_alphat,nb_alphan,nb_tau);
    xx_alphan = nan(nb_alphat,nb_alphan,nb_tau);
    xx_tau    = nan(nb_alphat,nb_alphan,nb_tau);
    for i_alphat = 1:nb_alphat, xx_alphat(i_alphat,:,:) = u_alphat(i_alphat);   end
    for i_alphan = 1:nb_alphat, xx_alphan(:,i_alphan,:) = u_alphan(i_alphan);   end
    for i_tau = 1:nb_tau,       xx_tau(:,:,i_tau)       = u_tau(i_tau);         end

    %% sdata
    % initialise
    models.choice.choice  = nan(size(models.human.choice));
    models.choice.correct = nan(size(models.human.correct));
    fittings           = nan(nb_subject,nb_novel,3);

    % loop
    tools_parforprogress(numel(min_greedbic));
    for i_subject = 1:nb_subject
    for i_novel   = 1:nb_novel

        % frame
        ii_subject = (sdata.exp_subject == u_subject(i_subject));
        ii_novel   = (sdata.vb_novel    == u_novel(i_novel));
        ii_frame   = (ii_subject & ii_novel);

        % keys
        alpha_t = xx_alphat(min_greedbic(i_subject,i_novel));
        alpha_n = xx_alphan(min_greedbic(i_subject,i_novel));
        tau     = xx_tau(min_greedbic(i_subject,i_novel));
        key     = [alpha_t,alpha_n,tau];
        fittings(i_subject,i_novel,:) = key;

        % values
        model = mdata(key);
        models.choice.choice(ii_frame)  = model.choice(ii_frame);
        models.choice.correct(ii_frame) = model.correct(ii_frame);

        % progress
        tools_parforprogress();
    end
    end
    tools_parforprogress(0);

    % degrees of freedom
    models.choice.df       = 3;
    models.choice.fittings = fittings;

    %% save
    save('data/sdata.mat','-append','models');
end

