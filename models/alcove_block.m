
%{
    input variables:
    > model
    > vb_novel
    > vb_target
    > vb_stimord
    > vb_rules
%}

%% define
nb_trial = length(vb_target);

%% task variables
% features
f = [mod(ceil((1:81) / 27)-1,3)+1;...
     mod(ceil((1:81) /  9)-1,3)+1;...
     mod(ceil((1:81) /  3)-1,3)+1;...
     mod(ceil((1:81)     )-1,3)+1]';

% attentional weights
if vb_novel; a = [1,1,1,1]; nb_a = 4;
else         a = [1,1,0,0]; nb_a = 2; end

% associative weights
w = ones(2,81);

% log variables
mdata.choice  = nan(nb_trial, 1);
mdata.correct = nan(nb_trial, 1);

%% for each trial
for i_trial = 1:nb_trial
    
    %% compute response
    % distance
    ff = nan(81,4);
    d  = nan(81,1);
    for i_d = 1:81
        ff(i_d,:) = (f(i_d,:) ~= vb_stimord(i_trial,:));
        d(i_d)    = sum(a .* ff(i_d,:));
    end
    assert(~vb_novel || sum(~d)==1 , 'alcove: error. something is wrong with the distance vector');
    % generalization gradient
    s = exp(-model.specificity .* d);
    % response strength
    r = w * s;
    e = exp(model.mapping .* (r - max(r)));
    % conditional probability
    p = e(2) ./ sum(e);
    % assert
    if isnan(p)
        save('../alcove_error.mat');
        error('alcove: error. isnan(prob_target) - see alcove_error.mat');
    end
    
    %% choice and feedback
    % choice
    choice  = (rand < p);
    % correct
    correct = (vb_target(i_trial) == choice);
    % ALCOVE feedback
    if correct; t = max(r,+1);
    else        t = min(r,-1); end
    
    %% learning
    % associative learning
    d_w = model.w_step .* ((t-r)*(s'));
    % attentional learning
    d_a =  - model.a_step .* model.specificity .* sum( ((t-r)*ones(1,4)) .* (w * (((s * ones(1,4)) .* ff) )));
    % update
    w = w + d_w;
    a = a + d_a;
    
    %% save log
    mdata.choice(i_trial)  = choice;
    mdata.correct(i_trial) = correct;
    
end
