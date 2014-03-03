
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

% task variables
modelrules = ones(6,6);
modeltargets = nan(6,6);
if ~vb_novel
    modelrules(:,4:6) = 0;
    modelrules(4:6,:) = 0;
end

% log variables
mdata.nb_candidates = nan(nb_trials,1);
mdata.prob_target   = nan(nb_trials,1);
mdata.choice        = nan(nb_trials,1);
mdata.correct       = nan(nb_trials,1);
mdata.entropy_left  = nan(nb_trials,1);
mdata.entropy_right = nan(nb_trials,1);

%% for each trial
for i=1:nb_trials

    % set response for each rule
    modeltargets = zeros(6,6);
    modeltargets(vb_stimord(i,1)  ,:) = 1;
    modeltargets(vb_stimord(i,3)+3,:) = 1;
    modeltargets(:,vb_stimord(i,2)  ) = 1;
    modeltargets(:,vb_stimord(i,4)+3) = 1;

    % set model response
    allresponses = modeltargets(logical(modelrules(:)));

    % hleft
    sleft = sum(modelrules,1);
    pleft = sleft/sum(sleft);
    lleft = log2(pleft); lleft(~pleft) = 0;
    hleft = -sum(lleft.*pleft);
    
    % hright
    sright = sum(modelrules,2);
    pright = sright/sum(sright);
    lright = log2(pright); lright(~pright) = 0;
    hright = -sum(lright.*pright);
    
    % save log
    mdata.nb_candidates(i)  = length(allresponses);
    mdata.prob_target(i)    = mean(allresponses);
    mdata.choice(i)         = (mdata.prob_target(i)>=0.5);
    mdata.correct(i)        = (vb_target(i))==mdata.choice(i);
    mdata.entropy_left(i)   = hleft;
    mdata.entropy_right(i)  = hright;

    % update modelrules
    modelrules(modeltargets(:)~=vb_target(i)) = 0;
    
end
