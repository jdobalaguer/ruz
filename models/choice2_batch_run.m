
function choice2_batch_run(u_alphat,u_alphan,u_tau)
    %% load
    sdata   = struct();
    numbers = struct();
    mdata   = dict();
    load('data/sdata.mat','sdata','numbers');
    if exist('data/models_choice2.mat','file')
        load('data/models_choice2.mat','mdata');
    else
        mbic  = dict();
        save('-v7.3','data/models_choice2.mat','mdata','mbic');
        clear mbic;
    end

    %% numbers
    u_subject  = numbers.shared.u_subject;
    u_novel    = numbers.shared.u_novel;

    nb_alphat  = length(u_alphat);
    nb_alphan  = length(u_alphan);
    nb_tau     = length(u_tau);

    %% run
    nb_loop = nb_alphat * nb_alphan * nb_tau;
    if ~exist('greed_bic','var') || nb_loop ~= numel(greed_bic)

        % initialise
        mdata_keys = mdata.keys();
        new_keys   = cell(nb_loop,1);
        new_vals   = cell(nb_loop,1);

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
                                    choice2_batch_run_par(  sdata, ...
                                                        numbers, ...
                                                        mdata_keys, ...
                                                        xx_alphat(i_loop), ...
                                                        xx_alphan(i_loop), ...
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
        clear xx_alphat xx_alphan xx_tau;
        clear i_alphat i_alphan i_tau;
        clear ii_nan;

        %% save
        save('data/models_choice2.mat','-append','mdata');
    else
        %% skip
        tools_parforprogress(1);tools_parforprogress(0);
    end
end
