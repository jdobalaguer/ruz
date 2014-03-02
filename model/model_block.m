
%#ok<*INUSD>
function varargout = model_block(model,vb_stimord,vb_novel,vb_target) 
    switch model.name
        case 'hbm'
            %% hierarchical bayesian model
            run('models/hbm.m');
            varargout = {mdata};
            return;
            
        otherwise
            %% unknown
            error(sprintf('model_block: error. model "%s" unknown',model.name));
            
    end
end