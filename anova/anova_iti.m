%#ok<*NODEF>

function anova_iti()
    
    %% load
    load('data/sdata');
    sdata.vb_slowiti = tools_discretize(sdata.time_iti,3); 
    
    %% numbers
    u_subject   = numbers.shared.u_subject;
    u_choice    = [0,1];
    u_slowiti   = unique(sdata.vb_slowiti);
    
    nb_subject  = numbers.shared.nb_subject;
    nb_choice   = 2;
    nb_slowiti  = length(u_slowiti);
    
    %% values
    ss = nan(nb_subject,nb_choice,nb_slowiti);
    rt = nan(nb_subject,nb_choice,nb_slowiti);
    for i_slowiti = 1:nb_slowiti
        for i_choice = 1:nb_choice
            for i_subject = 1:nb_subject
                % frame
                ii_resp    = (models.human.rt>0);
                ii_novel   = (sdata.vb_novel        == 0); ... familiar
                ii_correct = (models.human.correct  == 0); ... wrong
                ii_trial   = (sdata.exp_trial       >1)    ...
                           & (sdata.exp_trial       <6);   ... trial in 2:5
                % conditions
                ii_slowiti = (sdata.vb_slowiti      == u_slowiti(i_slowiti));
                ii_choice  = (models.human.choice   == u_choice(i_choice));
                ii_subject = (sdata.exp_subject     == u_subject(i_subject));
                % value
                ss(i_subject,i_choice,i_slowiti) = sum(ii_resp & ii_novel & ii_correct & ii_trial & ii_slowiti & ii_choice & ii_subject );
                rt(i_subject,i_choice,i_slowiti) = nanmean(models.human.rt(ii_resp & ii_novel & ii_correct & ii_trial & ii_slowiti & ii_choice & ii_subject ));
            end
        end
    end
    rt(:,:,3) = [];
    rt = reshape(rt,[18,4]);
    fprintf('anova_iti: warning. removing %d participants \n',sum(any(isnan(rt),2)));
    rt(any(isnan(rt),2),:) = [];
    
    %% anova
    tools_repanova(rt,[2,2]);
    
end