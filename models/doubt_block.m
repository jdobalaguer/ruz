
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
mdata.choice        = nan(nb_trial, 1);
mdata.correct       = nan(nb_trial, 1);
mdata.uncertainty   = nan(nb_trial, 1);

%% model variables
Ho          = zeros(nb_side,nb_value);
tau         = model.tau;
theta       = model.theta;

%% familiar tweaks
if ~vb_novel
    nb_side = 2;
    Ho(3:4,:) = [];
    vb_stimord(:,3:4) = [];
end

%% for each trial
for i_trial = 1:nb_trial
    %% decision-making
    
    prob        = nan(nb_side,nb_value);
    uncertainty = nan(1,nb_side);
    greedy      = nan(1,nb_side);
    for i_side = 1:nb_side
        max_Ho = max(Ho(i_side,:));
        
        % probability of value
        if tau==0;  prob(i_side,:) = (Ho(i_side,:) == max_Ho);
        else        prob(i_side,:) = exp((Ho(i_side,:) - max(Ho(i_side,:)))./tau);
        end
        prob(i_side,:)      = prob(i_side,:) / sum(prob(i_side,:));             % normalise probabilities
        
        % uncertainty
        uncertainty(i_side) = nansum(-prob(i_side,:) .* log(prob(i_side,:)));   % shannon's uncertainty
        uncertainty(i_side) = uncertainty(i_side) ./ log(3);                    % normalise uncertainty
        choice_unce(i_side) = (uncertainty(i_side) > theta);
        
        % greedy
        choice_gree(i_side) = (Ho(i_side,vb_stimord(i_trial,i_side)) == max_Ho);
        
        % choice
        choice_comb(i_side) =  choice_unce(i_side) || choice_gree(i_side);
    end
    
    %% choice and feedback
    
    % choice
    choice = any(choice_comb);
    
    % target
    target = vb_target(i_trial);
    
    % correct
    correct = (vb_target(i_trial) == choice);
    
    
    %% learning
    
    % step
    if (~target && ~correct); alpha = model.alpha_nw; end
    if (~target &&  correct); alpha = model.alpha_nc; end
    if ( target && ~correct); alpha = model.alpha_tw; end
    if ( target &&  correct); alpha = model.alpha_tc; end
    
    % update
    boundary = -1 + 2*target; % +1 if correct, -1 if wrong
    for i_side = 1:nb_side
        i_stim = vb_stimord(i_trial,i_side);
        dHo               = (boundary - Ho(i_side,i_stim));
        Ho(i_side,i_stim) = Ho(i_side,i_stim) + alpha*dHo;
    end
    
    %% save log
    mdata.choice(i_trial)      = choice;
    mdata.correct(i_trial)     = correct;
    mdata.uncertainty(i_trial) = min(uncertainty);
    
end
