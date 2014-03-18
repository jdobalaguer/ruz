
function correct_batch_run(u_alphac,u_alphaw,u_tau)
    %% load
    sdata   = struct();
    numbers = struct();
    mdata   = dict();
    load('data/sdata.mat','sdata','numbers');
    if exist('data/models_correct.mat','file')
        load('data/models_correct.mat','mdata');
    else
        mbic  = dict();
        save('-v7.3','data/models_correct.mat','mdata','mbic');
        clear mbic;
    end

    %% numbers
    u_subject  = numbers.shared.u_subject;
    u_novel    = numbers.shared.u_novel;

    nb_alphac  = length(u_alphac);
    nb_alphaw  = length(u_alphaw);
    nb_tau     = length(u_tau);

    %% run
    nb_loop = nb_alphac * nb_alphaw * nb_tau;
    if ~exist('greed_bic','var') || nb_loop ~= numel(greed_bic)

        % initialise
        mdata_keys = mdata.keys();
        new_keys   = cell(nb_loop,1);
        new_vals   = cell(nb_loop,1);

        % parameters
        xx_alphac = nan(nb_alphac,nb_alphaw,nb_tau);
        xx_alphaw = nan(nb_alphac,nb_alphaw,nb_tau);
        xx_tau    = nan(nb_alphac,nb_alphaw,nb_tau);
        for i_alphac = 1:nb_alphac, xx_alphac(i_alphac,:,:) = u_alphac(i_alphac);   end
        for i_alphaw = 1:nb_alphac, xx_alphaw(:,i_alphaw,:) = u_alphaw(i_alphaw);   end
        for i_tau = 1:nb_tau,       xx_tau(:,:,i_tau)       = u_tau(i_tau);         end

        % parallel loop
        tools_parforprogress(nb_loop);
        parfor i_loop = 1:nb_loop
            [   new_keys{i_loop} ,      ...
                new_vals{i_loop} ] =    ...
                                    correct_batch_run_par(  sdata, ...
                                                        numbers, ...
                                                        mdata_keys, ...
                                                        xx_alphac(i_loop), ...
                                                        xx_alphaw(i_loop), ...
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
        clear xx_alphac xx_alphaw xx_tau;
        clear i_alphac i_alphaw i_tau;
        clear ii_nan;

        %% save
        save('data/models_correct.mat','-append','mdata');
    else
        %% skip
        tools_parforprogress(1);tools_parforprogress(0);
    end
end
