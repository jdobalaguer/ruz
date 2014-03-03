%#ok<*STRNU>

function run_batch(modelname)
    
    switch modelname
        case 'god'
            %% god (perfect)
            model.name = 'god';
            run_model(model);
            
        case 'hbm'
            %% hierarchical bayesian model (optimal)
            model.name = 'hbm';
            run_model(model);
            
        case 'alcove'
            %% alcove model (kruschke 1992)
            model.name = 'alcove';
            run('models/alcove_batch.m');
            
        otherwise
            %% unknown
            error('model_block: error. model "%s" unknown',modelname);
            
    end

end