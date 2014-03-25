%#ok<*INUSD>
%#ok<*STOUT>

function [mdata] = model_block(model,vb_stimord,vb_novel,vb_target,vb_rules) 
    switch model.name
        %% god (perfect)
        case 'god'
            god_block;
            
        %% hierarchical bayesian model (optimal)
        case 'hbm'
            hbm_block;      
            
        %% target model
        case 'ta2'
            ta2_block;
        case 'ta3'
            ta3_block;
            
        %% correct model
        case 'co2'
            co2_block;
        case 'co3' 
            co3_block;
            
        otherwise
            %% unknown
            error('model_block: error. model "%s" unknown',model.name);
            
    end
end