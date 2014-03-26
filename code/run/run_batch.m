%
% RUN_BATCH [modelname]
% simulate a model
%

%% warnings
%#ok<*STRNU>

function run_batch(modelname)
    
    switch modelname
        %% god (perfect)
        case 'god'
            god_batch();
            
        %% hierarchical bayesian model (optimal)
        case 'hbm'
            hbm_batch();
            
        %% target model
        case 'ta2'
            ta2_batch();
        case 'ta3'
            ta3_batch();

        %% correct model
        case 'co2'
            co2_batch();
        case 'co3'
            co3_batch();
            
        %% unknown
        otherwise
            error('run_batch: error. model "%s" unknown',modelname);
            
    end

end
