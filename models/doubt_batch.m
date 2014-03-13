
%% change directory
cd('..');

%% load
    % sdata
load('data/sdata.mat');
    % models
if exist('data/models_doubt.mat','file')
    load('data/models_doubt.mat');
else
    mdata = dict();
end

%% variables
u_alphatw   =  0.10; % 0.0 : 0.1 : +1.0; ... in [0,1]
u_alphatc   =  0.10; % 0.0 : 0.1 : +1.0; ... in [0,1]
u_alphanw   =  0.00; % 0.0 : 0.1 : +1.0; ... in [0,1]
u_alphanc   =  0.00; % 0.0 : 0.1 : +1.0; ... in [0,1]
u_tau       =  0.10; %                   ... in [0,Inf]
u_theta     =  0.95; %-0.8 : 0.2 : +0.8; ... in [-1,+1]

%% run
fprintf('doubt_batch: run \n');

% loop
tools_parforprogress(length(u_alphatw) * length(u_alphatc) * length(u_alphanw) * length(u_alphanc) * length(u_tau) * length(u_theta));
for alpha_tw = u_alphatw
for alpha_tc = u_alphatc
for alpha_nw = u_alphanw
for alpha_nc = u_alphanc
for tau      = u_tau
for theta    = u_theta
    
    % set model
    model.alpha_tw      = alpha_tw;
    model.alpha_tc      = alpha_tc;
    model.alpha_nw      = alpha_nw;
    model.alpha_nc      = alpha_nc;
    model.tau           = tau;
    model.theta         = theta;
    
    % set key
    model.key = [alpha_tw,alpha_tc,alpha_nw,alpha_nc];
    
    % run & save
    %if ~mdata.iskey(model.key)
        mdata(model.key) = run_model(model,sdata,numbers);
    %end
    
    % progress
    tools_parforprogress;
end
end
end
end
end
end
tools_parforprogress(0);

this_mdata = mdata(model.key);
models.doubt.choice  = this_mdata.choice;
models.doubt.correct = this_mdata.correct;
models.doubt.df      = 6;

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
