%#ok<*STRNU>

function run_batch(modelname)
    
    switch modelname
        case 'god'
            %% god (perfect)
            god_batch();
            
        case 'hbm'
            %% hierarchical bayesian model (optimal)
            hbm_batch();
            
        case 'alcove'
            %% alcove model (kruschke 1992)
            alcove_batch();
            
        case 'ruz'
            %% ruz model
            ruz_batch();
            
        otherwise
            %% unknown
            error('model_block: error. model "%s" unknown',modelname);
            
    end

end