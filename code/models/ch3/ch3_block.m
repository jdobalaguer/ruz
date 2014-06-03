
%{
    input variables:
    > model
    > vb_novel
    > vb_target
    > vb_stimord
    > vb_rules
%}

%% task variables
nb_side  = 4;
nb_value = 3;
nb_trial = length(vb_target);
% log variables
mdata.choice        = false(nb_trial, 1);
mdata.correct       = false(nb_trial, 1);
mdata.minaVc        = nan(nb_trial,1);
mdata.maxaVc        = nan(nb_trial,1);
mdata.mmmaVc        = nan(nb_trial,1);
% mdata.menaVc        = nan(nb_trial,1);
% mdata.varaVc        = nan(nb_trial,1);
% mdata.skwaVc        = nan(nb_trial,1);
mdata.minHo         = nan(nb_trial,1);
mdata.maxHo         = nan(nb_trial,1);
% mdata.mmmHo         = nan(nb_trial,1);
% mdata.menHo         = nan(nb_trial,1);
% mdata.varHo         = nan(nb_trial,1);
% mdata.skwHo         = nan(nb_trial,1);

%% model variables
Ho          = zeros(nb_side,nb_value);
tau         = model.tau;

%% familiar tweaks
if ~vb_novel
    nb_side = 2;
    Ho(3:4,:) = [];
    vb_stimord(:,3:4) = [];
end

%% for each trial
for i_trial = 1:nb_trial
    %% decision-making
    
    aVc = nan(1,nb_side);
    for i_side = 1:nb_side
        i_stim = vb_stimord(i_trial,i_side);
        aVc(i_side) = Ho(i_side,i_stim);
    end
    minaVc = min(aVc);
    maxaVc = max(aVc);
    mmmaVc = (tau*minaVc) + ((1-tau)*maxaVc);
%     menaVc = mean(aVc);
%     varaVc = var(aVc);
%     skwaVc = skewness(aVc);
    minHo = min(Ho(:));
    maxHo = max(Ho(:));
%     mmmHo = (tau*minHo) + ((1-tau)*maxHo);
%     menHo = mean(Ho(:));
%     varHo = var(Ho(:));
%     skwHo = skewness(Ho(:));
    
    %% choice and feedback
    
    % choice
    choice = (mmmaVc >= 0);
    %choice = (maxHo - maxaVc <= tau);
    
    % target
    target = vb_target(i_trial);
    
    % correct
    correct = (vb_target(i_trial) == choice);
    
    
    %% learning
    
    % step
    if (~choice); alpha = model.alpha_m * (1 - model.alpha_r); end
    if ( choice); alpha = model.alpha_m * (    model.alpha_r); end
    
    % boundary
    boundary = -1 + 2*target; % +1 if correct, -1 if wrong
    
    % update
    for i_side = 1:nb_side
        i_stim = vb_stimord(i_trial,i_side);
        dHo               = (boundary - Ho(i_side,i_stim));
        Ho(i_side,i_stim) = Ho(i_side,i_stim) + alpha*dHo;
    end
    
    %% save log
    mdata.choice(i_trial)   = choice;
    mdata.correct(i_trial)  = correct;
    mdata.minaVc(i_trial)   = minaVc;
    mdata.maxaVc(i_trial)   = maxaVc;
    mdata.mmmaVc(i_trial)   = mmmaVc;
%     mdata.menaVc(i_trial)   = menaVc;
%     mdata.varaVc(i_trial)   = varaVc;
%     mdata.skwaVc(i_trial)   = skwaVc;
    mdata.minHo(i_trial)    = minHo;
    mdata.maxHo(i_trial)    = maxHo;
%     mdata.mmmHo(i_trial)    = mmmHo;
%     mdata.menHo(i_trial)    = menHo;
%     mdata.varHo(i_trial)    = varHo;
%     mdata.skwHo(i_trial)    = skwHo;
    
end

clearvars -except mdata;
