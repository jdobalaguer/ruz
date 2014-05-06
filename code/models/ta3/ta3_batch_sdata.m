
function ta3_batch_sdata(u_alpham,u_alphar,u_tau,model_file,model_name,df)
    %% load
    sdata     = struct();
    models    = struct();
    numbers   = struct();
    mdata     = dict();
    greed_bic = [];
    greed_cor = [];
    load('data/sdata.mat');
    load(model_file,'mdata','greed_bic','greed_cor');
    
    %% numbers
    u_subject  = numbers.shared.u_subject;
    u_novel    = numbers.shared.u_novel;

    nb_alpham  = length(u_alpham);
    nb_alphar  = length(u_alphar);
    nb_tau     = length(u_tau);
    nb_subject = numbers.shared.nb_subject;
    nb_novel   = numbers.shared.nb_novel;

    %% variables
    model_keys         = mdata.keys();
    model_values       = mdata.values();
    
    % minimise bic
    greed_bic        = reshape(greed_bic,[nb_alpham*nb_alphar*nb_tau,nb_subject,nb_novel]);
    [~,min_greedbic] = min(greed_bic,[],1);
    min_greedbic = squeeze(min_greedbic);
    
    % maximise correct
    greed_cor        = reshape(greed_cor,[nb_alpham*nb_alphar*nb_tau,nb_subject,nb_novel]);
    [~,max_greedcor] = max(greed_cor,[],1);
    max_greedcor = squeeze(max_greedcor);
    
    % parameters
    xx_alpham = nan(nb_alpham,nb_alphar,nb_tau);
    xx_alphar = nan(nb_alpham,nb_alphar,nb_tau);
    xx_tau    = nan(nb_alpham,nb_alphar,nb_tau);
    for i_alpham = 1:nb_alpham, xx_alpham(i_alpham,:,:) = u_alpham(i_alpham);   end
    for i_alphar = 1:nb_alphar, xx_alphar(:,i_alphar,:) = u_alphar(i_alphar);   end
    for i_tau = 1:nb_tau,       xx_tau(:,:,i_tau)       = u_tau(i_tau);         end

    %% sdata
    % initialise
    optim_name = [model_name,'opt'];
    models.(model_name).choice  = nan(size(models.human.choice));
    models.(model_name).correct = nan(size(models.human.correct));
    models.(optim_name).choice  = nan(size(models.human.choice));
    models.(optim_name).correct = nan(size(models.human.correct));
    fittings           = nan(nb_subject,nb_novel,3);
    optimals           = nan(nb_subject,nb_novel,3);

    % loop
    tools_parforprogress(2*numel(min_greedbic));
    for i_subject = 1:nb_subject
    for i_novel   = 1:nb_novel

        % frame
        ii_subject = (sdata.exp_subject == u_subject(i_subject));
        ii_novel   = (sdata.vb_novel    == u_novel(i_novel));
        ii_frame   = (ii_subject & ii_novel);

        % optimals
        alpha_m = xx_alpham(max_greedcor(i_subject,i_novel));
        alpha_r = xx_alphar(max_greedcor(i_subject,i_novel));
        tau     = xx_tau(max_greedcor(i_subject,i_novel));
        key     = [alpha_m,alpha_r,tau];
        optimals(i_subject,i_novel,:) = key;

        % model optimals
        [~,model] = ta3_batch_run_par(sdata,numbers,[],alpha_m,alpha_r,tau,false);
        u_field = fieldnames(model);
        for i_field = 1:length(u_field)
            field = u_field{i_field};
            if ~isfield(models.(optim_name),field), models.(optim_name).(field) = nan(size(ii_frame)); end
            models.(optim_name).(field)(ii_frame) = model.(field)(ii_frame);
        end
        
        % fittings
        alpha_m = xx_alpham(min_greedbic(i_subject,i_novel));
        alpha_r = xx_alphar(min_greedbic(i_subject,i_novel));
        tau     = xx_tau(min_greedbic(i_subject,i_novel));
        key     = [alpha_m,alpha_r,tau];
        fittings(i_subject,i_novel,:) = key;

        % model fittings
        [~,model] = ta3_batch_run_par(sdata,numbers,[],alpha_m,alpha_r,tau,false);
        u_field = fieldnames(model);
        for i_field = 1:length(u_field)
            field = u_field{i_field};
            if ~isfield(models.(model_name),field), models.(model_name).(field) = nan(size(ii_frame)); end
            models.(model_name).(field)(ii_frame) = model.(field)(ii_frame);
        end

    end
    end
    tools_parforprogress(0);

    % degrees of freedom
    models.(model_name).df       = df;
    models.(model_name).fittings = fittings;
    models.(model_name).optimals = optimals;

    %% save
    %save('data/sdata.mat','-append','models');
    save;
end

