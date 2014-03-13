%#ok<*INUSD>
%#ok<*STOUT>

function [mdata] = model_block(model,vb_stimord,vb_novel,vb_target,vb_rules) 
    switch model.name
        case 'god'
            %% god (perfect)
            run('models/god_block.m');
            return;
            
        case 'hbm'
            %% hierarchical bayesian model (optimal)
            run('models/hbm_block.m');
            return;
            
        case 'alcove'
            %% alcove model (kruschke 1992)
            run('models/alcove_block.m');
            return;
            
        case 'doubt'
            %% doubt (uncertainty) model
            run('models/doubt_block.m');
            return;
            
        case 'ruz'
            %% ruz model
            run('models/ruz_block.m');
            return;
            
        otherwise
            %% unknown
            error('model_block: error. model "%s" unknown',model.name);
            
    end
end