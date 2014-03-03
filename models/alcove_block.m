
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
mdata.choice  = nan(nb_trial,1);
mdata.correct = nan(nb_trial,1);
mdata.r       = nan(nb_trial,2);

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
    prob_target = e(2) ./ sum(e);
    %assert(~isnan(prob_target),'alcove: error. isnan(prob_target)');
    
    %% choice and feedback
    % choice
    choice  = (rand < prob_target);
    % correct
    correct = (vb_target(i_trial) == choice);
    % ALCOVE feedback
    if correct; t = max(r,+1);
    else        t = min(r,-1); end
    
    %% learning
    % associative learning
    for i_w = 1:2
        w(i_w,:) = w(i_w,:) + (model.w_step .* (t(i_w)-r(i_w)) .* s');
    end
    % attentional learning
    for i_a = 1:nb_a
        a(i_a) = a(i_a) - model.a_step .* model.specificity .* sum( (t-r) .* (w * (s.*ff(i_a)) ));
    end
    
    %% save log
    mdata.choice(i_trial)   = choice;
    mdata.correct(i_trial)  = correct;
    mdata.r(i_trial,:)      = r;
    
end
