
function correct_batch_sdata(u_alphac,u_alphaw,u_tau)
    %% load
    sdata     = struct();
    models    = struct();
    numbers   = struct();
    mdata     = dict();
    greed_bic = [];
    load('data/sdata.mat');
    load('data/models_correct.mat','mdata','greed_bic');
    
    %% numbers
    u_subject  = numbers.shared.u_subject;
    u_novel    = numbers.shared.u_novel;

    nb_alphat  = length(u_alphac);
    nb_alphaw  = length(u_alphaw);
    nb_tau     = length(u_tau);
    nb_subject = numbers.shared.nb_subject;
    nb_novel   = numbers.shared.nb_novel;

    %% variables
    model_keys         = mdata.keys();
    model_values       = mdata.values();
    
    % minimise bic
    greed_bic        = reshape(greed_bic,[nb_alphat*nb_alphaw*nb_tau,nb_subject,nb_novel]);
    [~,min_greedbic] = min(greed_bic,[],1);
    min_greedbic = squeeze(min_greedbic);
    
    % parameters
    xx_alphat = nan(nb_alphat,nb_alphaw,nb_tau);
    xx_alphaw = nan(nb_alphat,nb_alphaw,nb_tau);
    xx_tau    = nan(nb_alphat,nb_alphaw,nb_tau);
    for i_alphat = 1:nb_alphat, xx_alphat(i_alphat,:,:) = u_alphac(i_alphat);   end
    for i_alphaw = 1:nb_alphat, xx_alphaw(:,i_alphaw,:) = u_alphaw(i_alphaw);   end
    for i_tau = 1:nb_tau,       xx_tau(:,:,i_tau)       = u_tau(i_tau);         end

    %% sdata
    % initialise
    models.correct.choice  = nan(size(models.human.choice));
    models.correct.correct = nan(size(models.human.correct));
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
        alpha_c = xx_alphat(min_greedbic(i_subject,i_novel));
        alpha_w = xx_alphaw(min_greedbic(i_subject,i_novel));
        tau     = xx_tau(min_greedbic(i_subject,i_novel));
        key     = [alpha_c,alpha_w,tau];
        fittings(i_subject,i_novel,:) = key;

        % values
        model = mdata(key);
        models.correct.choice(ii_frame)  = model.choice(ii_frame);
        models.correct.correct(ii_frame) = model.correct(ii_frame);

        % progress
        tools_parforprogress();
    end
    end
    tools_parforprogress(0);

    % degrees of freedom
    models.correct.df       = 3;
    models.correct.fittings = fittings;

    %% save
    save('data/sdata.mat','-append','models');
end

