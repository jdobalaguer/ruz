
function choice_batch_fitting(u_alphat,u_alphan,u_tau)
    %% load
    sdata     = struct();
    models    = struct();
    numbers   = struct();
    mdata     = dict();
    mbic      = dict();
    greed_bic = [];
    load('data/sdata.mat');
    load('data/models_choice.mat');

    %% variables
    u_subject  = numbers.shared.u_subject;
    u_novel    = numbers.shared.u_novel;

    nb_alphat  = length(u_alphat);
    nb_alphan  = length(u_alphan);
    nb_tau     = length(u_tau);
    nb_subject = length(u_subject);
    nb_novel   = length(u_novel);

    %% fitting
    nb_loop = nb_alphat * nb_alphan * nb_tau;
    if isempty(greed_bic) || ...
       ~isfield(numbers,'choice')   || ...
       ~isfield(numbers.choice,'u_alphat')        || ~isfield(numbers.choice,'u_alphan')        || ~isfield(numbers.choice,'u_tau')     || ...
       ~isequal(u_alphat,numbers.choice.u_alphat) || ~isequal(u_alphan,numbers.choice.u_alphan) || ~isequal(u_tau,numbers.choice.u_tau)

        % initialise
        mbic_keys = mbic.keys();
        mbic_vals = mbic.values();
        new_keys   = cell(nb_loop,1);
        new_vals   = cell(nb_loop,1);
        greed_bic  = nan(nb_alphat*nb_alphan*nb_tau,nb_subject,nb_novel);
        
        % variables
        criterion       = model_criterion();
        human           = models.human;
        human.value     = criterion(human.choice,human.correct);

        % parameters
        xx_alphat = nan(nb_alphat,nb_alphan,nb_tau);
        xx_alphan = nan(nb_alphat,nb_alphan,nb_tau);
        xx_tau    = nan(nb_alphat,nb_alphan,nb_tau);
        for i_alphat = 1:nb_alphat, xx_alphat(i_alphat,:,:) = u_alphat(i_alphat);   end
        for i_alphan = 1:nb_alphat, xx_alphan(:,i_alphan,:) = u_alphan(i_alphan);   end
        for i_tau = 1:nb_tau,       xx_tau(:,:,i_tau)       = u_tau(i_tau);         end

        % parallel loop
        tools_parforprogress(nb_loop);
        parfor i_loop = 1:nb_loop
            [   new_keys{i_loop} ,      ...
                new_vals{i_loop} ] =    ...
                                     choice_batch_fitting_par( u_subject,  ...
                                                            u_novel, ...
                                                            human, ...
                                                            sdata, ...
                                                            mdata, ...
                                                            mbic_keys, ...
                                                            mbic_vals, ...
                                                            xx_alphat(i_loop), ...
                                                            xx_alphan(i_loop), ...
                                                            xx_tau(i_loop));
            greed_bic(i_loop,:,:) = new_vals{i_loop};
        end
        tools_parforprogress(0);

        % reshape greed_bic
        greed_bic = reshape(greed_bic,[nb_alphat,nb_alphan,nb_tau,nb_subject,nb_novel]);

        % remove empty simulations
        ii_nan           = any(isnan(cell2mat(new_keys)),2);
        new_keys(ii_nan) = [];
        new_vals(ii_nan) = [];

        % concatenate
        mbic_keys = cat(1, mbic_keys, new_keys);
        mbic_vals = cat(1, mbic_vals, new_vals);
        mbic      = dict(mbic_keys',mbic_vals');

        % clean
        clear new_keys new_vals;
        clear mbic_keys mbic_vals;
        clear xx_alphat xx_alphan xx_tau;
        clear i_alphat i_alphan i_tau;
        clear ii_nan;

        %% save
        save('data/models_choice.mat','-append','mbic','greed_bic');

    else
        %% skip
        tools_parforprogress(1);tools_parforprogress(0);
    end
end
