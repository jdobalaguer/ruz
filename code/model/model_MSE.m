
function dist = model_MSE(model_df,model_value,human_value,ii_frame,odd)
    
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
    mean_model = nan(1,nb_trial);
    mean_human = nan(1,nb_trial);
    for i_trial = 1:nb_trial
        ii_odd                  = (sdata.vb_odd == odd);
        ii_trial                = (sdata.exp_trial == u_trial(i_trial));    ... index
        ii_condition            = (ii_frame & ii_trial & ii_odd);           ... odd blocks
        mean_model(i_trial)     = mean(model_value(ii_condition));
        mean_human(i_trial)     = mean(human_value(ii_condition));
    end

    %% square distance
    dist = sqrt(mean(power(mean_model-mean_human,2)));
    
end