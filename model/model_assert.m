
function model_assert(model)
    switch(model.name)
        case 'god'
            %% god (perfect)
            % no conditions
            
        case 'hbm'
            %% hierarchical bayesian model (optimal)
            % no conditions
            
        case 'alcove'
            %% alcove model (kruschke 1992)
            assert(isfield(model,'mapping'),     'model_assert: error. alcove. mapping field missing');
            assert(isfield(model,'specificity'), 'model_assert: error. alcove. specificity field missing');
            assert(isfield(model,'w_step'),      'model_assert: error. alcove. w_step field missing');
            assert(isfield(model,'a_step'),      'model_assert: error. alcove. a_step field missing');

        case 'ruz'
            %% ruz model
            assert(isfield(model,'alpha_t'),     'model_assert: error. doubt. alpha_t field missing');
            assert(isfield(model,'alpha_n'),     'model_assert: error. doubt. alpha_n field missing');
            assert(isfield(model,'tau'),         'model_assert: error. doubt. tau field missing');
            
        otherwise
            %% unknown
            error('model_assert: error. model "%s" unknown',model.name);
    end
end