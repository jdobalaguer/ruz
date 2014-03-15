
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
    save('-v7.3','data/models_ruz.mat','mdata','mbic');
end

%% variables
u_alphat   = linspace(0,1,3);
u_alphan   = linspace(0,1,3);
u_tau      = linspace(0,1,3);
u_subject  = numbers.shared.u_subject;
u_novel    = numbers.shared.u_novel;

nb_alphat  = length(u_alphat);
nb_alphan  = length(u_alphan);
nb_tau     = length(u_tau);
nb_subject = length(u_subject);
nb_novel   = length(u_novel);

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
    for tau     = u_tau

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
    save('-v7.3','data/models_ruz.mat','-append','mdata');
else
    tools_parforprogress(0);
end

%% fitting
fprintf('ruz_batch: fitting \n');

if ~exist('greed_bic','var') || ...
   ~isfield(numbers,'ruz')   || ...
   ~isfield(numbers.ruz,'u_alphat')        || ~isfield(numbers.ruz,'u_alphan')        || ~isfield(numbers.ruz,'u_tau')     || ...
   ~isequal(u_alphat,numbers.ruz.u_alphat) || ~isequal(u_alphan,numbers.ruz.u_alphan) || ~isequal(u_tau,numbers.ruz.u_tau)

    % initialise
    greed_bic       = nan(nb_alphat,nb_alphan,nb_tau,nb_subject,nb_novel);
    criterion       = model_criterion();
    human           = models.human;
    human.value     = criterion(human.choice,human.correct);

    % loop
    nb_loops = numel(greed_bic);
    tools_parforprogress(nb_loops);
    for i_alphat   = 1:nb_alphat
    for i_alphan   = 1:nb_alphan
    for i_tau      = 1:nb_tau
        for i_subject = 1:nb_subject
        for i_novel   = 1:nb_novel

            % keys
            mdata_key = [u_alphat(i_alphat),u_alphan(i_alphan),u_tau(i_tau)];
            mbic_key  = [mdata_key,u_subject(i_subject),u_novel(i_novel)];

            % bic
            if ~mbic.iskey(mbic_key)

                % model
                model       = mdata(mdata_key);
                model.value = criterion(model.choice,model.correct);
                model.df    = 3;

                % frame
                ii_subject = (sdata.exp_subject == u_subject(i_subject));
                ii_novel   = (sdata.vb_novel    == u_novel(i_novel));
                ii_frame   = (ii_subject & ii_novel);

                % bic
                mbic(mbic_key) = model_bic(model, human, ii_frame);

            end

            % save
            greed_bic(i_alphat,i_alphan,i_tau,i_subject,i_novel) = mbic(mbic_key);

            % progress
            tools_parforprogress;
        end
        end
    end
    end
    end
    tools_parforprogress(0);

    % save models
    save('-v7.3','data/models_ruz.mat','-append','mbic','greed_bic');
    
else
    tools_parforprogress(0);
end

%% sdata
fprintf('ruz_batch: sdata \n');

% initialise
models.ruz.choice  = nan(size(sdata.exp_subject));
models.ruz.correct = nan(size(sdata.exp_subject));
model_keys         = mdata.keys();
model_values       = mdata.values();
fittings           = nan(nb_subject,nb_novel,3);

% minimise bic
greed_bic   = shiftdim(greed_bic,3);
greed_bic   = reshape(greed_bic,[nb_subject,nb_novel,nb_alphat*nb_alphan*nb_tau]);
[~,min_greedbic] = min(greed_bic,[],3);

% loop
tools_parforprogress(numel(min_greedbic));
for i_subject = 1:nb_subject
for i_novel   = 1:nb_novel
    
    % frame
    ii_subject = (sdata.exp_subject == numbers.shared.u_subject(i_subject));
    ii_novel   = (sdata.vb_novel    == numbers.shared.u_novel(i_novel));
    ii_frame   = (ii_subject & ii_novel);
    
    % keys
    key = model_keys{min_greedbic(i_subject,i_novel)};
    fittings(i_subject,i_novel,:) = key;
    
    % values
    models.ruz.choice(ii_frame)  = model_values{min_greedbic(i_subject,i_novel)}.choice(ii_frame);
    models.ruz.correct(ii_frame) = model_values{min_greedbic(i_subject,i_novel)}.correct(ii_frame);
    
    % progress
    tools_parforprogress;
end
end
tools_parforprogress(0);

% degrees of freedom
models.ruz.df       = 3;
models.ruz.fittings = fittings;

% save sdata
save('data/sdata.mat','-append','models');

%% numbers
fprintf('ruz_batch: numbers \n');

numbers.ruz.u_alphat    = u_alphat;
numbers.ruz.u_alphan    = u_alphan;
numbers.ruz.u_tau       = u_tau;
numbers.ruz.nb_alphat   = nb_alphat;
numbers.ruz.nb_alphan   = nb_alphan;
numbers.ruz.nb_tau      = nb_tau;

% progress
tools_parforprogress(0);

% save sdata
save('data/sdata.mat','-append','numbers');
