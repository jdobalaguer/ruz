%#ok<*NASGU>

function ta2_batch_fitting(u_alpham,u_alphar,u_tau)
    %% load
    sdata     = struct();
    models    = struct();
    numbers   = struct();
    mdata     = dict();
    mbic      = dict();
    greed_bic = [];
    load('data/sdata.mat');
    load('data/models_ta2.mat');

    %% variables
    u_subject  = numbers.shared.u_subject;
    u_novel    = numbers.shared.u_novel;

    nb_alpham  = length(u_alpham);
    nb_alphar  = length(u_alphar);
    nb_tau     = length(u_tau);
    nb_subject = length(u_subject);
    nb_novel   = length(u_novel);

    %% fitting
    nb_loop = nb_alpham * nb_alphar * nb_tau;

    % initialise
    mbic_keys = mbic.keys();
    mbic_vals = mbic.values();
    new_keys  = cell(nb_loop,1);
    new_vals  = cell(nb_loop,1);
    greed_bic = uint8(nan(nb_alpham*nb_alphar*nb_tau,nb_subject,nb_novel));

    % variables
    criterion   = @(x,y)x;
    criterion   = model_criterion();
    human       = models.human;

    % parameters
    xx_alpham = nan(nb_alpham,nb_alphar,nb_tau);
    xx_alphar = nan(nb_alpham,nb_alphar,nb_tau);
    xx_tau    = nan(nb_alpham,nb_alphar,nb_tau);
    for i_alpham = 1:nb_alpham, xx_alpham(i_alpham,:,:) = u_alpham(i_alpham);   end
    for i_alphar = 1:nb_alphar, xx_alphar(:,i_alphar,:) = u_alphar(i_alphar);   end
    for i_tau    = 1:nb_tau,    xx_tau(:,:,i_tau)       = u_tau(i_tau);         end

    % parallel loop
    tools_parforprogress(nb_loop);
    parfor i_loop = 1:nb_loop
        % LTM dict
        [   new_keys{i_loop} ,      ...
            new_vals{i_loop} ] =    ...
                                 ta2_batch_fitting_par(  u_subject,  ...
                                                            u_novel, ...
                                                            human, ...
                                                            sdata, ...
                                                            mdata, ...
                                                            mbic_keys, ...
                                                            mbic_vals, ...
                                                            xx_alpham(i_loop), ...
                                                            xx_alphar(i_loop), ...
                                                            xx_tau(i_loop));
        % STM tensor
        greed_bic(i_loop,:,:) = criterion(  new_vals{i_loop}(:,:,1), ...
                                            new_vals{i_loop}(:,:,2) );
    end
    tools_parforprogress(0);

    % reshape greed_bic
    greed_bic = reshape(greed_bic,[nb_alpham,nb_alphar,nb_tau,nb_subject,nb_novel]);

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
    clear xx_alpham xx_alphar xx_tau;
    clear i_alpham i_alphar i_tau;
    clear ii_nan;

    %% save
    save('data/models_ta2.mat','-append','mbic','greed_bic');

end
