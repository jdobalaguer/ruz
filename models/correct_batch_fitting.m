
function correct_batch_fitting(u_alphac,u_alphaw,u_tau)
    %% load
    sdata     = struct();
    models    = struct();
    numbers   = struct();
    mdata     = dict();
    mbic      = dict();
    greed_bic = [];
    load('data/sdata.mat');
    load('data/models_correct.mat');

    %% variables
    u_subject  = numbers.shared.u_subject;
    u_novel    = numbers.shared.u_novel;

    nb_alphac  = length(u_alphac);
    nb_alphaw  = length(u_alphaw);
    nb_tau     = length(u_tau);
    nb_subject = length(u_subject);
    nb_novel   = length(u_novel);

    %% fitting
    nb_loop = nb_alphac * nb_alphaw * nb_tau;
    if isempty(greed_bic) || ...
       ~isfield(numbers,'correct')   || ...
       ~isfield(numbers.correct,'u_alphac')        || ~isfield(numbers.correct,'u_alphaw')        || ~isfield(numbers.correct,'u_tau')     || ...
       ~isequal(u_alphac,numbers.correct.u_alphac) || ~isequal(u_alphaw,numbers.correct.u_alphaw) || ~isequal(u_tau,numbers.correct.u_tau)

        % initialise
        mbic_keys = mbic.keys();
        mbic_vals = mbic.values();
        new_keys   = cell(nb_loop,1);
        new_vals   = cell(nb_loop,1);
        greed_bic  = nan(nb_alphac*nb_alphaw*nb_tau,nb_subject,nb_novel);
        
        % variables
        criterion       = model_criterion();
        human           = models.human;
        human.value     = criterion(human.choice,human.correct);

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
                                     correct_batch_fitting_par( u_subject,  ...
                                                            u_novel, ...
                                                            human, ...
                                                            sdata, ...
                                                            mdata, ...
                                                            mbic_keys, ...
                                                            mbic_vals, ...
                                                            xx_alphac(i_loop), ...
                                                            xx_alphaw(i_loop), ...
                                                            xx_tau(i_loop));
            greed_bic(i_loop,:,:) = new_vals{i_loop};
        end
        tools_parforprogress(0);

        % reshape greed_bic
        greed_bic = reshape(greed_bic,[nb_alphac,nb_alphaw,nb_tau,nb_subject,nb_novel]);

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
        clear xx_alphac xx_alphaw xx_tau;
        clear i_alphac i_alphaw i_tau;
        clear ii_nan;

        %% save
        save('data/models_correct.mat','-append','mbic','greed_bic');

    else
        %% skip
        tools_parforprogress(1);tools_parforprogress(0);
    end
end
