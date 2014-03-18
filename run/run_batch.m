%#ok<*STRNU>

function run_batch(modelname)
    
    switch modelname
        case 'god'
            %% god (perfect)
            god_batch();
            
        case 'hbm'
            %% hierarchical bayesian model (optimal)
            hbm_batch();
            
        case 'choice'
            %% choice model
            choice_batch();

	case 'choice2'
	    %% choice model (2 parameters)
            choice2_batch();
            
        case 'correct'
            %% correct model
            correct_batch();
            
        otherwise
            %% unknown
            error('model_block: error. model "%s" unknown',modelname);
            
    end

end
