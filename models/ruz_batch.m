
%% change directory
cd('..');

%% load
    % sdata
load('data/sdata.mat');
    % models
if exist('data/models_ruz.mat','file')
    load('data/models_ruz.mat');
else
    mdata = dict();
    mbic  = dict();
end

%% variables
u_alphat   =  0.00 : 0.10 : +1.00; % in [0,1]
u_alphan   =  0.00 : 0.10 : +1.00; % in [0,1]
u_tau      =  0.00 : 0.10 : +1.00; % in [0,1]

%% parallel
tools_startparallel;

%% run
fprintf('ruz_batch: run \n');

nb_loops = length(u_alphat) * length(u_alphan) * length(u_tau);
if nb_loops ~= length(mdata.keys)

    % loop
    tools_parforprogress(nb_loops);
    for alpha_t = u_alphat
    for alpha_n = u_alphan
    for tau      = u_tau

        % set model
        model.alpha_t      = alpha_t;
        model.alpha_n      = alpha_n;
        model.tau          = tau;

        % set key
        model.key = [alpha_t,alpha_n,tau];

        % run & save
        if ~mdata.iskey(model.key)
            mdata(model.key) = run_model(model,sdata,numbers);
        end

        % progress
        tools_parforprogress;
    end
    end
    end
    tools_parforprogress(0);

    % save models
    save('data/models_ruz.mat','mdata','mbic');
end

%% fitting
fprintf('ruz_batch: fitting \n');

% initialise
bic             = nan(numbers.shared.nb_subject,numbers.shared.nb_novel,mdata.length);
model_keys      = mdata.keys;
model_values    = mdata.values;
criterion       = model_criterion();
human           = models.human;
human.value     = criterion(human.choice,human.correct);

nb_loops = numel(bic);
if nb_loops ~= length(mbic.keys)

    % loop
    tools_parforprogress(nb_loops);
    for i_model   = 1:mdata.length
    for i_subject = 1:numbers.shared.nb_subject
    for i_novel   = 1:numbers.shared.nb_novel

        % key
        key = [model_keys{i_model}, i_subject, i_novel];

        % bic
        if ~mbic.iskey(key)

            % criterion
            model       = model_values{i_model};
            model.df    = 3;
            model.value = criterion(model.choice,model.correct);

            % frame
            ii_subject = (sdata.exp_subject == numbers.shared.u_subject(i_subject));
            ii_novel   = (sdata.vb_novel    == numbers.shared.u_novel(i_novel));
            ii_frame   = (ii_subject & ii_novel);

            % bic
            mbic(key) = model_bic(model, human, ii_frame);

        end

        % save
        bic(i_subject,i_novel,i_model) = mbic(key);

        % progress
        tools_parforprogress;
    end
    end
    end
    tools_parforprogress(0);

    % save models
    save('data/models_ruz.mat','mdata','mbic');
    
    
    % minimise bic
    [~,i_model] = min(bic,[],3);
    
    % save sdata
    models.ruz.df      = 3;
    models.ruz.bic     = bic;
    models.ruz.keys    = i_model;
    save('data/sdata.mat','-append','models');
else
    i_model = models.ruz.keys;
end

%% sdata
fprintf('ruz_batch: sdata \n');

% initialise
models.ruz.choice  = nan(size(sdata.exp_subject));
models.ruz.correct = nan(size(sdata.exp_subject));

% loop
tools_parforprogress(numel(i_model));
for i_subject = 1:numbers.shared.nb_subject
for i_novel   = 1:numbers.shared.nb_novel
    
    % frame
    ii_subject = (sdata.exp_subject == numbers.shared.u_subject(i_subject));
    ii_novel   = (sdata.vb_novel    == numbers.shared.u_novel(i_novel));
    ii_frame   = (ii_subject & ii_novel);
    
    % values
    models.ruz.choice(ii_frame)  = model_values{i_model(i_subject,i_novel)}.choice(ii_frame);
    models.ruz.correct(ii_frame) = model_values{i_model(i_subject,i_novel)}.correct(ii_frame);
    
    % progress
    tools_parforprogress;
end
end
tools_parforprogress(0);

% save sdata
save('data/sdata.mat','-append','models');
