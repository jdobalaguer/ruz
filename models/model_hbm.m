
function data = model_hbm(codez,attside,target,k)

    %% define
    nb_trials = length(target);
    
    % task variables
    modelrules = ones(6,6);
    modeltargets = nan(6,6);
    if k==2
        modelrules(:,4:6) = 0;
        modelrules(4:6,:) = 0;
    end
    
    % log variables
    modelcands = [];
    modelprobs = [];
    modelchoice = [];
    modelcor   = [];
    modelhleft = [];
    modelhright = [];
    
    %% for each trial
    for i=1:nb_trials

        % AS(1)   = relevant left
        % AS(2)   = relevant right
        % AS(3)   = irrelevant left
        % AS(4)   = irrelevant right
        AS = attside(:,i)';
        
        % set response for each rule
        modeltargets = zeros(6,6);
        modeltargets(codez(AS(1),i)  ,:) = 1;
        modeltargets(codez(AS(3),i)+3,:) = 1;
        modeltargets(:,codez(AS(2),i)  ) = 1;
        modeltargets(:,codez(AS(4),i)+3) = 1;
        
        % set model response
        allresponses = modeltargets(logical(modelrules(:)));
        
        % save log
        modelcands(i)  = length(allresponses);
        modelprobs(i)  = mean(allresponses);
        modelchoice(i) = (modelprobs(i)>=0.5);
        modelcor(i)    = (target(i))==modelchoice(i);
        
        sleft = sum(modelrules,1);
        pleft = sleft/sum(sleft);
        lleft = log2(pleft); lleft(~pleft) = 0;
        hleft = -sum(lleft.*pleft);
        modelhleft(i)  = hleft;
        
        sright = sum(modelrules,2);
        pright = sright/sum(sright);
        lright = log2(pright); lright(~pright) = 0;
        hright = -sum(lright.*pright);
        modelhright(i)  = hright;
        
        % update modelrules
        modelrules(modeltargets(:)~=target(i)) = 0;
    end

    % store
    data.modelcands     = modelcands;
    data.modelprobs     = modelprobs;
    data.modelchoice    = modelchoice;
    data.modelcor       = modelcor;
    data.modelhleft     = modelhleft;
    data.modelhright    = modelhright;

end