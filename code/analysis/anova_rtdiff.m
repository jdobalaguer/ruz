
function anova_rtdiff()
    
    %% load
    load('data/sdata');
    sdata.exp_trial = tools_discretize(sdata.exp_trial,4);
    numbers.shared.u_trial  = unique(sdata.exp_trial);
    numbers.shared.nb_trial = length(numbers.shared.u_trial);
    
    %% numbers
    u_trial     = numbers.shared.u_trial;
    u_choice    = [0,1];
    u_subject   = numbers.shared.u_subject;
    
    nb_trial    = numbers.shared.nb_trial;
    nb_novel    = numbers.shared.nb_novel;
    nb_correct  = 2;
    nb_choice   = 2;
    nb_subject  = numbers.shared.nb_subject;
    
    %% values
    rt = nan(nb_subject,nb_choice);
    for i_subject = 1:nb_subject
        for i_choice = 1:nb_choice
            % frame
            ii_resp    = (models.human.rt>0.2);
            ii_novel   = (sdata.vb_novel        == 0);
            ii_correct = (models.human.correct  == 1);
            ii_subject = (sdata.exp_subject     == u_subject(i_subject));
            ii_FRAME   = (ii_resp & ii_novel & ii_correct & ii_subject);
            % next trial
            ii_nstart  =~(sdata.exp_start);
            ii_nend    =~(sdata.exp_end);
            ii_trial   = (sdata.exp_trial       == u_trial(end));
            ii_NEXT    = logical([0 ; ii_trial(1:end-1)]) & ii_nstart & ii_nend;
            % choice
            ii_CHOICE  = (models.human.choice   == u_choice(i_choice));
            % value
            rt_frame   = nanmean(models.human.rt(ii_FRAME & ii_NEXT));
            rt_2       = models.human.rt(ii_CHOICE & ii_FRAME & ii_NEXT);
            rt(i_subject,i_choice) = 1000*nanmean(rt_2 - rt_frame);
        end
    end
    
    %% ttest
    [h,p,ci,stats] = ttest(rt(:,1)-rt(:,2));
    fprintf('Effect 01: t-test  t(%d)=%.3f,	p=%.2f \n',stats.df,stats.tstat,p);
    
end