function data = model_thresh(codez,attside,target,k,prop_abs,prop_ang,thresh)

Ho = zeros(4,3);
prop_1 = + prop_abs * cos(.5 * pi * prop_ang);
prop_2 = + prop_abs * sin(.5 * pi * prop_ang);

nb_trials = length(target);
Hos         = zeros(nb_trials,4,3);
modelchoice = nan(nb_trials,1);
modelcor    = nan(nb_trials,1);
aVc         = nan(nb_trials,4);
aVcAS       = nan(nb_trials,4);
minaVcAS    = nan(nb_trials,1);
maxaVcAS    = nan(nb_trials,1);
mmaVcAS     = nan(nb_trials,1);

for i=1:nb_trials
    
    AS = attside(1:k,i)';

    % currently, if we have no hypothesis, we assume that the currently
    % availabel stim is a target. but we don't have to do this.
    for side=AS;  % check each side in turn
        if ~sum(Ho(side,:))  % if you currently have no hypothesis about that side
            dHo                    = (1-Ho(side,codez(side,i)));
            Ho(side,codez(side,i)) = Ho(side,codez(side,i))+(dHo*prop_1);
        end
    end
    
    % get action values from hypothesis
    for side = AS;  % check each side in turn...
        aVc(i,side)=Ho(side,codez(side,i));
    end

    % combination rule
     aVcAS(i,1:k) = aVc(i,AS);
     minaVcAS(i) = min(aVcAS(i,1:k));
     maxaVcAS(i) = max(aVcAS(i,1:k));
     mmaVcAS(i) = maxaVcAS(i) - thresh;
     modelchoice(i) = double(mmaVcAS(i) >= 0);
     modelcor(i) = (target(i))==modelchoice(i);  % would the model have been correct or not?
        
    % update hypotheses
    if target(i)
        for side = AS
            dHo                    = (+1 - Ho(side,codez(side,i)));
            Ho(side,codez(side,i)) = Ho(side,codez(side,i))+(dHo*prop_1);
        end
    else
        for side = AS
            dHo                    = (-1 - Ho(side,codez(side,i)));
            Ho(side,codez(side,i)) = Ho(side,codez(side,i))+(dHo*prop_2);
        end
    end
    
    % store
    Hos(i,:,:) = Ho;
end

% store
data.aVc            = aVc;
data.Ho             = Hos;
data.aVcAS          = aVcAS;
data.maxaVcAS       = maxaVcAS;
data.minaVcAS       = minaVcAS;
data.mmaVcAS        = mmaVcAS;
data.modelchoice    = modelchoice;
data.modelcor       = modelcor;
