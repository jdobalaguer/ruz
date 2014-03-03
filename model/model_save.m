
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
            run('models/hbm_save.m');
            
        case 'alcove'
            %% alcove (kruschke 1992)
            run('models/alcove_save.m');
            
        otherwise
            error('model_save: error. model "%s" unknown',model.name);
    end

end