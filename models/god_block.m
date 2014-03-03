
%{
    input variables:
    > model
    > vb_novel
    > vb_target
    > vb_stimord
    > vb_rules
%}

%% define
nb_trials = length(vb_target);

% log variables
mdata.choice        = nan(nb_trials,1);
mdata.correct       = nan(nb_trials,1);

%% for each trial
for i=1:nb_trials

    % save log
    mdata.choice(i)         = any(vb_rules(i,:) == vb_stimord(i,[1,2]));
    mdata.correct(i)        = (vb_target(i))==mdata.choice(i);
    
end
