%#ok<*INUSD>
%#ok<*STOUT>

function [mdata] = model_block(model,vb_stimord,vb_novel,vb_target,vb_rules) 
    switch model.name
        case 'god'
            %% god (perfect)
            god_block;
            return;
            
        case 'hbm'
            %% hierarchical bayesian model (optimal)
            hbm_block;
            return;
            
        case 'choice'
            %% choice model
            choice_block;
            return;
            
        case 'correct'
            %% correct model
            correct_block;
            return;
            
        otherwise
            %% unknown
            error('model_block: error. model "%s" unknown',model.name);
            
    end
end