
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

%% task variables

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

for i_trial = 1:nb_trials
    
    AS = attside(1:k,i_trial)';

    % currently, if we have no hypothesis, we assume that the currently
    % availabel stim is a target. but we don't have to do this.
    for side=AS;  % check each side in turn
        if ~sum(Ho(side,:))  % if you currently have no hypothesis about that side
            dHo                    = (1-Ho(side,codez(side,i_trial)));
            Ho(side,codez(side,i_trial)) = Ho(side,codez(side,i_trial));%+(dHo*prop_1);
        end
    end
    
    % get action values from hypothesis
    for side = AS;  % check each side in turn...
        aVc(i_trial,side)=Ho(side,codez(side,i_trial));
    end

    % combination rule
     aVcAS(i_trial,1:k) = aVc(i_trial,AS);
     minaVcAS(i_trial) = min(aVcAS(i_trial,1:k));
     maxaVcAS(i_trial) = max(aVcAS(i_trial,1:k));
     mmaVcAS(i_trial) = minmaxratio*minaVcAS(i_trial) + (1-minmaxratio)*maxaVcAS(i_trial);
     modelchoice(i_trial) = double(mmaVcAS(i_trial) >=0);
     modelcor(i_trial) = (target(i_trial))==modelchoice(i_trial);  % would the model have been correct or not?
        
    % update hypotheses
    if target(i_trial)
        for side = AS
            dHo                    = (+1 - Ho(side,codez(side,i_trial)));
            Ho(side,codez(side,i_trial)) = Ho(side,codez(side,i_trial))+(dHo*prop_1);
        end
    else
        for side = AS
            dHo                    = (-1 - Ho(side,codez(side,i_trial)));
            Ho(side,codez(side,i_trial)) = Ho(side,codez(side,i_trial))+(dHo*prop_2);
        end
    end
    
    % store
    Hos(i_trial,:,:) = Ho;
end

%% save log
mdata.aVc            = aVc;
mdata.Ho             = Hos;
mdata.aVcAS          = aVcAS;
mdata.maxaVcAS       = maxaVcAS;
mdata.minaVcAS       = minaVcAS;
mdata.mmaVcAS        = mmaVcAS;
mdata.modelchoice    = modelchoice;
mdata.modelcor       = modelcor;
