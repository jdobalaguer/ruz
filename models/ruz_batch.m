
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
end

%% variables
u_alphat   =  0.00 : 0.10 : +1.00; ... in [0,1]
u_alphan   =  0.00 : 0.10 : +1.00; ... in [0,1]
u_tau      =  0.00 : 0.10 : +1.00; ... in [0,1]

%% run
fprintf('ruz_batch: run \n');

% loop
tools_parforprogress(length(u_alphat) * length(u_alphan) * length(u_tau));
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
    %if ~mdata.iskey(model.key)
        mdata(model.key) = run_model(model,sdata,numbers);
    %end
    
    % progress
    tools_parforprogress;
end
end
end
tools_parforprogress(0);

this_mdata = mdata(model.key);
models.ruz.choice  = this_mdata.choice;
models.ruz.correct = this_mdata.correct;
models.ruz.df      = 3;

%% fitting
% fprintf('doubt_batch: fitting \n');
% 
% % initialise
% bic             = nan(numbers.shared.nb_subject,mdata.length);
% model_values    = mdata.values;
% criterion       = model_criterion();
% human = models.human;
% human.value = criterion(human.choice,human.correct);
% 
% % loop
% tools_parforprogress(numel(bic));
% for i_model = 1:mdata.length
% for i_subject = 1:numbers.shared.nb_subject
% 
%     % criterion
%     model = model_values{i_model};
%     model.df    = 4;
%     model.value = criterion(model.choice,model.correct);
% 
%     % frame
%     ii_subject = (sdata.exp_subject == numbers.shared.u_subject(i_subject));
% 
%     % bic
%     bic(i_subject,i_model) = model_bic(model, human, ii_subject);
%     
%     % progress
%     tools_parforprogress;
% end
% end
% tools_parforprogress(0);

%% set model
% fprintf('doubt_batch: sdata \n');
% 
% % initiallise
% models.doubt.choice  = nan(size(sdata.exp_subject));
% models.doubt.correct = nan(size(sdata.exp_subject));
% models.doubt.df      = 4;
% 
% % minimise bic
% [~,i_model] = min(bic,[],2);
% 
% % loop
% tools_parforprogress(numbers.shared.nb_subject);
% for i_subject = 1:numbers.shared.nb_subject
%     % frame
%     ii_subject = (sdata.exp_subject == numbers.shared.u_subject(i_subject));
%     % values
%     models.doubt.choice(ii_subject)  = model_values{i_model(i_subject)}.choice(ii_subject);
%     models.doubt.correct(ii_subject) = model_values{i_model(i_subject)}.correct(ii_subject);
%     
%     % progress
%     tools_parforprogress;
% end
% tools_parforprogress(0);

%% save
    % sdata
save('data/sdata.mat','-append','models');
    % models
save('data/models_doubt.mat','mdata');
