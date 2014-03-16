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
            
        case 'alcove'
            %% alcove model (kruschke 1992)
            alcove_block;
            return;
            
        case 'ruz'
            %% ruz model
            ruz_block;
            return;
            
        otherwise
            %% unknown
            error('model_block: error. model "%s" unknown',model.name);
            
    end
end