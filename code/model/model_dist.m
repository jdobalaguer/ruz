
function dist = model_dist(model_df,model_value,human_value,ii_frame,odd)
    switch(valid_dist())
        case 'bic'
            dist = model_bic(   model_df,model_value,human_value,ii_frame,odd);
        case 'sqdist'
            dist = model_sqdist(model_df,model_value,human_value,ii_frame,odd);
        otherwise
            error('distance "%s" not valid',valid_dist());
    end
end
