
function anova_model_alphas(model)
    %% load
    load('data/sdata.mat','numbers','models');
    fittings = models.(model).fittings;
    fittings(:,:,3) = [];
    
    %% numbers
    nb_subject = numbers.shared.nb_subject;
    nb_novel   = numbers.shared.nb_novel;
    nb_param   = size(fittings,3);
    
    %% values
    fittings = reshape(fittings , [nb_subject , nb_novel*nb_param]);
    fprintf('anova_model_alphas: warning. removing %d participants \n',sum(any(isnan(fittings),2)));
    fittings(any(isnan(fittings),2),:) = [];
    
    %% repanova
    jb_repanova(fittings,[nb_param , nb_novel]);
    
end
