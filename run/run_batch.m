%#ok<*STRNU>

function run_batch(modelname)
    
    switch modelname
        case 'god'
            %% god (perfect)
            model.name = 'god';
            run('models/god_batch.m');
            
        case 'hbm'
            %% hierarchical bayesian model (optimal)
            model.name = 'hbm';
            run('models/hbm_batch');
            
        case 'alcove'
            %% alcove model (kruschke 1992)
            model.name = 'alcove';
            run('models/alcove_batch.m');
            
        otherwise
            %% unknown
            error('model_block: error. model "%s" unknown',modelname);
            
    end

end