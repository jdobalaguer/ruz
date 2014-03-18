
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
            
        case 'choice2'
            %% choice model (2 parameters)
            assert(isfield(model,'alpha_t'),     'model_assert: error. choice2. alpha_t field missing');
            assert(isfield(model,'tau'),         'model_assert: error. choice2. tau field missing');
            
        case 'correct'
            %% correct model
            assert(isfield(model,'alpha_c'),     'model_assert: error. correct. alpha_c field missing');
            assert(isfield(model,'alpha_w'),     'model_assert: error. correct. alpha_w field missing');
            assert(isfield(model,'tau'),         'model_assert: error. correct. tau field missing');
            
        case 'ratio'
            %% ratio model
            assert(isfield(model,'alpha_m'),     'model_assert: error. ratio. alpha_m field missing');
            assert(isfield(model,'alpha_r'),     'model_assert: error. ratio. alpha_r field missing');
            assert(isfield(model,'tau'),         'model_assert: error. ratio. tau field missing');
            
        case 'ratio2'
            %% ratio model (2 parameters)
            assert(isfield(model,'alpha_r'),     'model_assert: error. ratio2. alpha_r field missing');
            assert(isfield(model,'tau'),         'model_assert: error. ratio2. tau field missing');

        otherwise
            %% unknown
            error('model_assert: error. model "%s" unknown',model.name);
    end
end