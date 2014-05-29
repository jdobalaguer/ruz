
function taco4_batch_fitting(u_alpham,u_alphart,u_alpharc,u_tau,model_file)
    %% warnings
    %#ok<*NASGU>
    %#ok<*PFOUS>
    
    %% load
    sdata     = struct();
    models    = struct();
    numbers   = struct();
    mdata     = dict();
    mbic      = dict();
    mcor      = dict();
    load('data/sdata.mat');
    load(model_file);

    %% variables
    u_subject  = numbers.shared.u_subject;
    u_novel    = numbers.shared.u_novel;

    nb_alpham  = length(u_alpham);
    nb_alphart = length(u_alphart);
    nb_alpharc = length(u_alpharc);
    nb_tau     = length(u_tau);
    nb_subject = length(u_subject);
    nb_novel   = length(u_novel);

    %% fitting
    nb_loop = nb_alpham * nb_alphart * nb_alpharc * nb_tau;

    % initialise
    m_keys = mbic.keys();
    m_bics = mbic.values();
    m_cors = mcor.values();
    new_keys   = cell(nb_loop,1);
    new_bics   = cell(nb_loop,1);
    new_cors   = cell(nb_loop,1);
    greed_bic  = single(nan(nb_alpham*nb_alphart*nb_alpharc*nb_tau,nb_subject,nb_novel));
    greed_cor  = single(nan(nb_alpham*nb_alphart*nb_alpharc*nb_tau,nb_subject,nb_novel));

    % variables
    criterion   = @(x,y)x;
    criterion   = valid_criterion();
    human       = models.human;

    % parameters
    xx_alpham  = nan(nb_alpham,nb_alphart,nb_alpharc,nb_tau);
    xx_alphart = nan(nb_alpham,nb_alphart,nb_alpharc,nb_tau);
    xx_alpharc = nan(nb_alpham,nb_alphart,nb_alpharc,nb_tau);
    xx_tau     = nan(nb_alpham,nb_alphart,nb_alpharc,nb_tau);
    for i_alpham  = 1:nb_alpham,    xx_alpham(i_alpham,:,:,:)   = u_alpham(i_alpham);   end
    for i_alphart = 1:nb_alphart,   xx_alphart(:,i_alphart,:,:) = u_alphart(i_alphart); end
    for i_alpharc = 1:nb_alpharc,   xx_alpharc(:,:,i_alpharc,:) = u_alpharc(i_alpharc); end
    for i_tau     = 1:nb_tau,       xx_tau(:,:,:,i_tau)         = u_tau(i_tau);         end

    % parallel loop
    tools_parforprogress(nb_loop);
    parfor i_loop = 1:nb_loop
        % LTM dict
        [   new_keys{i_loop} ,      ...
            new_bics{i_loop} ,      ...
            new_cors{i_loop} ] =    ...
                                 taco4_batch_fitting_par(   u_subject,  ...
                                                            u_novel, ...
                                                            human, ...
                                                            sdata, ...
                                                            mdata,  ...
                                                            m_keys, ...
                                                            m_bics, ...
                                                            m_cors, ...
                                                            xx_alpham(i_loop), ...
                                                            xx_alphart(i_loop), ...
                                                            xx_alpharc(i_loop), ...
                                                            xx_tau(i_loop));
        % STM tensors
        greed_bic(i_loop,:,:) = criterion(  new_bics{i_loop}(:,:,1), ...
                                            new_bics{i_loop}(:,:,2) );
        greed_cor(i_loop,:,:) = new_cors{i_loop}(:,:,2);
    end
    tools_parforprogress(0);

    % reshape greed_bic
    greed_bic = reshape(greed_bic,[nb_alpham,nb_alphart,nb_alpharc,nb_tau,nb_subject,nb_novel]);
    greed_cor = reshape(greed_cor,[nb_alpham,nb_alphart,nb_alpharc,nb_tau,nb_subject,nb_novel]);

    % remove empty simulations
    ii_nan           = any(isnan(cell2mat(new_keys)),2);
    new_keys(ii_nan) = [];
    new_bics(ii_nan) = [];
    new_cors(ii_nan) = [];

    % concatenate
    m_keys = cat(1, m_keys, new_keys);
    m_bics = cat(1, m_bics, new_bics);
    m_cors = cat(1, m_cors, new_cors);
    mbic      = dict(m_keys',m_bics');
    mcor      = dict(m_keys',m_cors');

    % clean
    clear new_keys new_vbic new_vcor;
    clear m_keys m_bics m_cors;
    clear xx_alpham xx_alphar xx_tau;
    clear i_alpham i_alphar i_tau;
    clear ii_nan;

    %% save
    save(model_file,'-append','mbic','mcor','greed_bic','greed_cor');

end
