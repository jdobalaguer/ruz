
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
    
    %% choice and feedback
    
    % choice
    choice = any(mmmaVc >= 0);
    
    % target
    target = vb_target(i_trial);
    
    % correct
    correct = (vb_target(i_trial) == choice);
    
    
    %% learning
    
    % step
    if (~target); alpha = model.alpha_m * (1 - model.alpha_r); end
    if ( target); alpha = model.alpha_m * (    model.alpha_r); end
    
    % boundary
    boundary = -1 + 2*target; % +1 if correct, -1 if wrong
    
    % update
    for i_side = 1:nb_side
        i_stim = vb_stimord(i_trial,i_side);
        dHo               = (boundary - Ho(i_side,i_stim));
        Ho(i_side,i_stim) = Ho(i_side,i_stim) + alpha*dHo;
    end
    
    %% save log
    mdata.choice(i_trial)      = choice;
    mdata.correct(i_trial)     = correct;
    mdata.minaVc(i_trial)      = minaVc;
    mdata.maxaVc(i_trial)      = maxaVc;
    mdata.mmmaVc(i_trial)      = mmmaVc;
    
end

clearvars -except mdata;
