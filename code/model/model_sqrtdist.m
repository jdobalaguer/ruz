
function sqdist = model_sqrtdist(model_df,model_value,human_value,ii_frame,odd)
    
    %% warning
    %#ok<*INUSL>
    
    %% load
    sdata = struct();
    load('data/sdata.mat','sdata','numbers');
    numbers.shared.u_trial  = unique(sdata.exp_trial);
    numbers.shared.nb_trial = length(numbers.shared.u_trial);
    
    %% default
    if ~exist('ii_frame','var')
        ii_frame = ones(size(sdata.exp_subject));
    end
    
    %% numbers
    u_trial         = numbers.shared.u_trial;
    nb_trial        = numbers.shared.nb_trial;
    
    %% likelihood
    model_sqdist = nan(1,nb_trial);
    for i_trial = 1:nb_trial
        ii_odd                  = (sdata.vb_odd == odd);
        ii_trial                = (sdata.exp_trial == u_trial(i_trial));    ... index
        ii_condition            = (ii_frame & ii_trial & ii_odd);           ... odd blocks
        mean_model              = mean(model_value(ii_condition));
        mean_human              = mean(human_value(ii_condition));
        model_sqdist(i_trial)   = abs(mean_model - mean_human);             ... sqdist
    end

    %% square distance
    sqdist = mean(model_sqdist);
    
end