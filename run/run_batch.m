
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
            
        otherwise
            %% unknown
            error('model_block: error. model "%s" unknown',modelname);
            
    end

end