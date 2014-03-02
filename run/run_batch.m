
function run_batch(modelname)
    
    switch modelname
        case 'hbm'
            %% hierarchical bayesian model
            model.name = modelname;
            run_model(model);
            
    end

end