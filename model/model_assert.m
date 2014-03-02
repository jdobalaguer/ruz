
function model_assert(model)
    switch(model.name)
        case 'god'
            %% god (perfect)
            % no conditions
            
        case 'hbm'
            %% hierarchical bayesian model (optimal)
            % no conditions
            
        case 'reinforcer'
            %% reinforcer
            assert(isfield(model,'alpha'));
            assert(isfield(model,'tau'));
            
        otherwise
            %% unknown
            error('model_assert: error. model "%s" unknown',model.name);
    end
end