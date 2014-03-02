
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
            model.mapping       = 2.84;
            model.specificity   = 3;    ... example 14.00;
            model.w_step        = 0.5;  ... example  0.21;
            model.a_step        = 0;    ... example  0.01;
            run_model(model);
            
        otherwise
            %% unknown
            error('model_block: error. model "%s" unknown',modelname);
            
    end

end