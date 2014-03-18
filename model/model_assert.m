
function model_assert(model)
    switch(model.name)
        case 'god'
            %% god (perfect)
            % no conditions
            
        case 'hbm'
            %% hierarchical bayesian model (optimal)
            % no conditions

        case 'choice'
            %% choice model
            assert(isfield(model,'alpha_t'),     'model_assert: error. choice. alpha_t field missing');
            assert(isfield(model,'alpha_n'),     'model_assert: error. choice. alpha_n field missing');
            assert(isfield(model,'tau'),         'model_assert: error. choice. tau field missing');
            
        case 'correct'
            %% correct model
            assert(isfield(model,'alpha_c'),     'model_assert: error. correct. alpha_c field missing');
            assert(isfield(model,'alpha_w'),     'model_assert: error. correct. alpha_w field missing');
            assert(isfield(model,'tau'),         'model_assert: error. correct. tau field missing');
            
        otherwise
            %% unknown
            error('model_assert: error. model "%s" unknown',model.name);
    end
end