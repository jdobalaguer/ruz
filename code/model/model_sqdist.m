
function sqdist = model_sqdist(model_df,model_value,human_value,ii_frame,odd)
    
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
    
    %% square distance
    d   = model_value(ii_frame)-human_value(ii_frame);
    sqdist = sum(d.*d);
    
end