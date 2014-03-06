
function bic = model_bic(model,human,ii_frame)
    %% load
    load('data/sdata.mat','sdata','numbers');
    sdata.exp_trial = tools_discretize(sdata.exp_trial,4);
    numbers.shared.u_trial  = unique(sdata.exp_trial);
    numbers.shared.nb_trial = length(numbers.shared.u_trial);
    
    %% default
    if ~exist('ii_frame','var')
        ii_frame = ones(size(sdata.exp_subject));
    end
    
    %% numbers
    u_novel         = numbers.shared.u_novel;
    u_trial         = numbers.shared.u_trial;
    nb_novel        = numbers.shared.nb_novel;
    nb_trial        = numbers.shared.nb_trial;
    nb_condition    = nb_novel * nb_trial;
    
    %% likelihood
    model.like = nan(1,nb_condition);
    i_condition = 0;
    for i_novel = 1:nb_novel
        for i_trial = 1:nb_trial
            i_condition = i_condition + 1;                                  ... index
            ii_novel                = (sdata.vb_novel  == u_novel(i_novel));
            ii_trial                = (sdata.exp_trial == u_trial(i_trial));
            ii_condition            = (ii_frame & ii_novel & ii_trial);
            novel_sum               =  sum(ii_condition);                       ... values
            model.sum               =  sum(model.value(ii_condition));
            human.mean              = mean(human.value(ii_condition));
            model.like(i_condition) = binopdf(model.sum,novel_sum,human.mean);  ... likelihood
        end
    end

    %% BIC
    bic    = -2 * log(prod(model.like)) + (model.df)*log(nb_condition);
end