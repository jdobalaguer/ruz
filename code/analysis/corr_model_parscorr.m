
function corr_model_parscorr(model)
    %% default
    if ~exist('model','var'), model = model_valid(); end
    
    %% load
    load('data/sdata.mat');
    
    %% numbers
    nb_novel = numbers.shared.nb_novel;
    
    %% values
    corrs = nan(1,nb_novel);
    probs = nan(1,nb_novel);
    for i_novel = 1:nb_novel
        fittings = squeeze(models.(model).fittings(:,i_novel,:));
        % linear regression
        x = fittings(:,1:end-1);
        y = fittings(:,end);
        b = pinv(x) * y;
        z = x * b;
        % correlation
        [corrs(i_novel),probs(i_novel)] = corr(z,y);
    end
    
    %% print
    fprintf('plot_model_parscorr: model %s \n',model);
    fprintf('plot_model_parscorr: familiar. correlation %.3f, %.3f \n',corrs(1),probs(1));
    fprintf('plot_model_parscorr: novel.    correlation %.3f, %.3f \n',corrs(2),probs(2));
    fprintf('\n');
    
end