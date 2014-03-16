
function alcove_batch()
    %% model
    model.name = 'alcove';

    %% load
        % sdata
    load('data/sdata.mat');
        % models
    if exist('data/models_alcove.mat','file')
        load('data/models_alcove.mat');
    else
        mdata = dict();
    end

    %% variables
    u_mapping     = 1.00 : 1.00 :  2.00;    ... example  2.84;
    u_specificity = 8.00 : 8.00 : 16.00;    ... example 14.00;
    u_wstep       = 0.10 : 0.10 :  0.20;    ... example  0.21;
    u_astep       = 0.10 : 0.10 :  0.20;    ... example  0.01;

    %% run
    fprintf('alcove_batch: run \n');

    % loop
    tools_parforprogress(length(u_mapping) * length(u_specificity) * length(u_wstep) * length(u_astep));
    for mapping     = u_mapping
    for specificity = u_specificity
    for w_step      = u_wstep
    for a_step      = u_astep

        % set model
        model.mapping       = mapping;
        model.specificity   = specificity;
        model.w_step        = w_step;
        model.a_step        = a_step;

        % set key
        model.key = [mapping,specificity,w_step,a_step];
        %fprintf('alcove_batch: key[%.2f,%.2f,%.2f,%.2f] \n',model.key);

        % run & save
        if ~mdata.iskey(model.key)
            mdata(model.key) = run_model(model,sdata,numbers);
        end

        % progress
        tools_parforprogress;
    end
    end
    end
    end
    tools_parforprogress(0);

    %% fitting
    fprintf('alcove_batch: fitting \n');

    % initialise
    bic             = nan(numbers.shared.nb_subject,mdata.length);
    model_values    = mdata.values;
    criterion       = model_criterion();
    human = models.human;
    human.value = criterion(human.choice,human.correct);

    % loop
    tools_parforprogress(numel(bic));
    for i_model = 1:mdata.length
    for i_subject = 1:numbers.shared.nb_subject

        % criterion
        model = model_values{i_model};
        model.df    = 4;
        model.value = criterion(model.choice,model.correct);

        % frame
        ii_subject = (sdata.exp_subject == numbers.shared.u_subject(i_subject));

        % bic
        bic(i_subject,i_model) = model_bic(model, human, ii_subject);

        % progress
        tools_parforprogress;
    end
    end
    tools_parforprogress(0);

    %% set model
    fprintf('alcove_batch: sdata \n');

    % initiallise
    models.alcove.choice  = nan(size(sdata.exp_subject));
    models.alcove.correct = nan(size(sdata.exp_subject));
    models.alcove.df      = 4;

    % minimise bic
    [~,i_model] = min(bic,[],2);

    % loop
    tools_parforprogress(numbers.shared.nb_subject);
    for i_subject = 1:numbers.shared.nb_subject
        % frame
        ii_subject = (sdata.exp_subject == numbers.shared.u_subject(i_subject));
        % values
        models.alcove.choice(ii_subject)  = model_values{i_model(i_subject)}.choice(ii_subject);
        models.alcove.correct(ii_subject) = model_values{i_model(i_subject)}.correct(ii_subject);

        % progress
        tools_parforprogress;
    end
    tools_parforprogress(0);

    %% save
        % sdata
    save('data/sdata.mat','-append','models');
        % models
    save('data/models_alcove.mat','mdata');
end
