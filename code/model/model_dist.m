
function dist = model_dist(model_df,model_value,human_value,ii_frame,odd)
    switch(valid_dist())
        case 'BIC'
            dist = model_BIC(model_df,model_value,human_value,ii_frame,odd);
        case 'MAE'
            dist = model_MAE(model_df,model_value,human_value,ii_frame,odd);
        case 'MSE'
            dist = model_MSE(model_df,model_value,human_value,ii_frame,odd);
        otherwise
            error('distance "%s" not valid',valid_dist());
    end
end
