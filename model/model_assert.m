
function model_assert(model)
    switch(model.name)
        case 'hbm'
            %% hierarchical bayesian model
            % no conditions
            
        case 'reinforcer'
            %% reinforcer
            assert(isfield(model,'alpha'));
            assert(isfield(model,'tau'));
            
        otherwise
            %% unknown
            error(sprintf('model_assert: error. model "%s" unknown',model.name));
    end
end