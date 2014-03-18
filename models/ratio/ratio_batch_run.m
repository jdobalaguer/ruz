
function ratio_batch_run(u_alpham,u_alphar,u_tau)
    %% load
    sdata   = struct();
    numbers = struct();
    mdata   = dict();
    load('data/sdata.mat','sdata','numbers');
    if exist('data/models_ratio.mat','file')
        load('data/models_ratio.mat','mdata');
    else
        mbic  = dict();
        save('-v7.3','data/models_ratio.mat','mdata','mbic');
        clear mbic;
    end

    %% numbers
    u_subject  = numbers.shared.u_subject;
    u_novel    = numbers.shared.u_novel;

    nb_alpham  = length(u_alpham);
    nb_alphar  = length(u_alphar);
    nb_tau     = length(u_tau);

    %% run
    nb_loop = nb_alpham * nb_alphar * nb_tau;
    if ~exist('greed_bic','var') || nb_loop ~= numel(greed_bic)

        % initialise
        mdata_keys = mdata.keys();
        new_keys   = cell(nb_loop,1);
        new_vals   = cell(nb_loop,1);

        % parameters
        xx_alpham = nan(nb_alpham,nb_alphar,nb_tau);
        xx_alphar = nan(nb_alpham,nb_alphar,nb_tau);
        xx_tau    = nan(nb_alpham,nb_alphar,nb_tau);
        for i_alpham = 1:nb_alpham, xx_alpham(i_alpham,:,:) = u_alpham(i_alpham);   end
        for i_alphar = 1:nb_alphar, xx_alphar(:,i_alphar,:) = u_alphar(i_alphar);   end
        for i_tau = 1:nb_tau,       xx_tau(:,:,i_tau)       = u_tau(i_tau);         end

        % parallel loop
        tools_parforprogress(nb_loop);
        parfor i_loop = 1:nb_loop
            [   new_keys{i_loop} ,      ...
                new_vals{i_loop} ] =    ...
                                    ratio_batch_run_par(  sdata, ...
                                                        numbers, ...
                                                        mdata_keys, ...
                                                        xx_alpham(i_loop), ...
                                                        xx_alphar(i_loop), ...
                                                        xx_tau(i_loop));
        end
        tools_parforprogress(0);

        % remove empty simulations
        ii_nan           = any(isnan(cell2mat(new_keys)),2);
        new_keys(ii_nan) = [];
        new_vals(ii_nan) = [];

        % concatenate
        mdata_keys = cat(1, mdata_keys,     new_keys);
        mdata_vals = cat(1, mdata.values(), new_vals);
        mdata      = dict(mdata_keys',mdata_vals');

        % clean
        clear greed_bic;
        clear new_keys new_vals;
        clear mdata_keys mdata_vals;
        clear xx_alpham xx_alphar xx_tau;
        clear i_alpham i_alphan i_tau;
        clear ii_nan;

        %% save
        save('data/models_ratio.mat','-append','mdata');
    else
        %% skip
        tools_parforprogress(1);tools_parforprogress(0);
    end
end
