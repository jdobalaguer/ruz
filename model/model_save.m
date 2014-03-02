
function model_save(model,mdata)
    
    %% load
    load('data/sdata.mat','models');
    
    %% create field
    if ~isfield(models,model.name)
        models.(model.name) = struct();
    end
    
    %% common variables
    models.(model.name).choice  = mdata.choice;
    models.(model.name).correct = mdata.correct;
    
    %% save
    switch(model.name)
        case 'god'
            %% god (perfect)
            save('data/sdata.mat','-append','models');
            
        case 'hbm'
            %% hierarchical bayesian model (optimal)
            models.(model.name).nb_candidates = mdata.nb_candidates;
            models.(model.name).prob_target   = mdata.prob_target;
            models.(model.name).entropy_left  = mdata.entropy_left;
            models.(model.name).entropy_right = mdata.entropy_right;
            save('data/sdata.mat','-append','models');
            
        otherwise
            error('model_save: error. model "%s" unknown',model.name);
    end

end