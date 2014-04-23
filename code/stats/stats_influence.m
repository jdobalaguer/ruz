%#ok<*ASGLU>

function stats_influence()
    %% load
    numbers = struct(); load('data/sdata.mat','numbers');
    v = figure_2D();

    %% numbers
    u_subject  = numbers.shared.u_subject;
    u_novel    = numbers.shared.u_novel;
    u_trial    = numbers.shared.u_trial;
    u_target   = numbers.shared.u_target;
    
    nb_subject = numbers.shared.nb_subject;
    nb_novel   = numbers.shared.nb_novel;
    nb_trial   = numbers.shared.nb_trial;
    nb_target  = numbers.shared.nb_target;
    
    nb_side    = 2;
    nb_count   = 4;
    
    %% reshape & concatenate
    s = [nb_side,nb_novel,nb_subject,nb_target,nb_count];
    % v{:} = [side,novel,subject,target,count]
    v{1} = shiftdim(v{1},2);
    v{2} = shiftdim(v{2},2);
    % v{:} = [subject,target,count,side,novel]
    v    = reshape(v,[1,1,1,1,1,2]);
    m    = cell2mat(v);
    % m    = [subject,target,count,side,novel,model]
    
    %% Title
    fprintf('\n');
    cprintf('*black','"Influence of feedback history"\n');
    
    %% Paragraph 1
    
    % Consistent with this view, alpha_R positively predicted performance ... and tau negatively
    fprintf('\n');
    cprintf('_black','"A three-way interaction between these factors indicated that the slope of the line relating feedback history to choice was steeper for targets than nontargets, but that this difference was particularly acute in the novel cues condition" : \n');
    cprintf('_black','"analysis of variance crossing the factors cues (novel, familiar) x feedback (confirmatory, disconfirmatory) x bin (1-4).  \n');
    cprintf('*black','  model \n');
    jb_anova(v{1},{'""','"target"','"count"','"side"','"novel"'});
    cprintf('*black','  human \n');
    jb_anova(v{2},{'""','"target"','"count"','"side"','"novel"'});
    cprintf([1,0.5,0],'calling it "confirmatory/disconfirmatory refers here to target? it makes it very ambiguous."\n');
    
    %% end
    fprintf('\n');
end