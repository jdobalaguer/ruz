
function anova_model_alphas(model)
    %% default
    if ~exist('model','var'), model = model_valid(); end
    
    %% load
    load('data/sdata.mat','numbers','models');
    fittings = models.(model).fittings;
    fittings(:,:,3) = [];
    
    %% numbers
    nb_subject = numbers.shared.nb_subject;
    nb_novel   = numbers.shared.nb_novel;
    nb_param   = size(fittings,3);
    
    %% repanova
    jb_anova(fittings, {'""','"alpha_M"','"alpha_R"'});
    
end
