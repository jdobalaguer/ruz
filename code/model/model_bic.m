
function bic = model_bic(model_df,model_value,human_value,ii_frame,odd)
    %% load
    sdata = struct();
    load('data/sdata.mat','sdata','numbers');
    sdata.exp_trial         = jb_discretize(sdata.exp_trial,4);
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
    model_like = nan(1,nb_trial);
    for i_trial = 1:nb_trial
        ii_odd                  = (sdata.vb_odd == odd);
        ii_trial                = (sdata.exp_trial == u_trial(i_trial));    ... index
        ii_condition            = (ii_frame & ii_trial & ii_odd);           ... odd blocks
        frame_sum               = sum(ii_condition);                        ... values
        model_sum               = sum(model_value(ii_condition));
        human_mean              = mean(human_value(ii_condition));
        model_like(i_trial)     = binopdf(model_sum,frame_sum,human_mean);  ... likelihood
    end

    %% BIC
    bic    = -2 * sum(log(model_like)) + (model_df)*log(nb_trial);
end