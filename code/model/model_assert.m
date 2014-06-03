
function model_assert(model)
    switch(model.name)
        %% god (perfect)
        case 'god'
            
        %% hierarchical bayesian model (optimal)
        case 'hbm'

        %% target model
        case 'ta2'
            assert(isfield(model,'alpha_m'),     'model_assert: error. ta2. alpha_m field missing');
            assert(isfield(model,'alpha_r'),     'model_assert: error. ta2. alpha_r field missing');
            assert(isfield(model,'tau'),         'model_assert: error. ta2. tau field missing');
        case 'ta3'
            assert(isfield(model,'alpha_m'),     'model_assert: error. ta3. alpha_m field missing');
            assert(isfield(model,'alpha_r'),     'model_assert: error. ta3. alpha_r field missing');
            assert(isfield(model,'tau'),         'model_assert: error. ta3. tau field missing');
            
        %% choice model
        case 'ch2'
            assert(isfield(model,'alpha_m'),     'model_assert: error. ch2. alpha_m field missing');
            assert(isfield(model,'alpha_r'),     'model_assert: error. ch2. alpha_r field missing');
            assert(isfield(model,'tau'),         'model_assert: error. ch2. tau field missing');
        case 'ch3'
            assert(isfield(model,'alpha_m'),     'model_assert: error. ch3. alpha_m field missing');
            assert(isfield(model,'alpha_r'),     'model_assert: error. ch3. alpha_r field missing');
            assert(isfield(model,'tau'),         'model_assert: error. ch3. tau field missing');
            
        %% correct model
        case 'co2'
            assert(isfield(model,'alpha_m'),     'model_assert: error. co2. alpha_m field missing');
            assert(isfield(model,'alpha_r'),     'model_assert: error. co2. alpha_r field missing');
            assert(isfield(model,'tau'),         'model_assert: error. co2. tau field missing');
        case 'co3'
            assert(isfield(model,'alpha_m'),     'model_assert: error. co3. alpha_m field missing');
            assert(isfield(model,'alpha_r'),     'model_assert: error. co3. alpha_r field missing');
            assert(isfield(model,'tau'),         'model_assert: error. co3. tau field missing');
            
        %% target & correct model
        case 'taco4'
            assert(isfield(model,'alpha_m'),     'model_assert: error. taco4. alpha_m field missing');
            assert(isfield(model,'alpha_rt'),    'model_assert: error. taco4. alpha_rt field missing');
            assert(isfield(model,'alpha_rc'),    'model_assert: error. taco4. alpha_rc field missing');
            assert(isfield(model,'tau'),         'model_assert: error. taco4. tau field missing');
            
        otherwise
            %% unknown
            error('model_assert: error. model "%s" unknown',model.name);
    end
end
