
function ruz_batch_sdata(u_alphat,u_alphan,u_tau)
    %% load
    sdata     = struct();
    models    = struct();
    numbers   = struct();
    mdata     = dict();
    greed_bic = [];
    load('data/sdata.mat');
    load('data/models_ruz.mat','mdata','greed_bic');
    
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
    greed_bic        = reshape(greed_bic,[nb_alphat*nb_alphan*nb_tau,nb_subject,nb_novel);
    [~,min_greedbic] = min(greed_bic,[],1);
    greed_bic        = squeeze(greed_bic);
    
    %% sdata
    % initialise
    models.ruz.choice  = nan(size(models.human.choice));
    models.ruz.correct = nan(size(models.human.correct));
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
        key = model_keys{min_greedbic(i_subject,i_novel)};
        fittings(i_subject,i_novel,:) = key;

        % values
        models.ruz.choice(ii_frame)  = model_values{min_greedbic(i_subject,i_novel)}.choice(ii_frame);
        models.ruz.correct(ii_frame) = model_values{min_greedbic(i_subject,i_novel)}.correct(ii_frame);

        % progress
        tools_parforprogress();
    end
    end
    tools_parforprogress(0);

    % degrees of freedom
    models.ruz.df       = 3;
    models.ruz.fittings = fittings;

    %% save
    save('data/sdata.mat','-append','models');
end