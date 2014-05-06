%#ok<*ASGLU>

function stats_reactiontimes()
    %% defaults
    model = model_valid();
    human = 'human';
    
    %% load
    sdata   = struct();
    models  = struct();
    numbers = struct();
    load('data/sdata');
    models.human.rt = 1000*models.human.rt;
    
    %% assert
    assert(isfield(models,human),'stats_reactiontimes: error. human does not exist');
    assert(isfield(models,model),'stats_reactiontimes: error. model "%s" does not exist', model);
    
    %% numbers
    u_novel     = numbers.shared.u_novel;
    u_subject   = numbers.shared.u_subject;
    u_trial     = numbers.shared.u_trial;
    
    nb_novel    = numbers.shared.nb_novel;
    nb_subject  = numbers.shared.nb_subject;
    nb_trial    = numbers.shared.nb_trial;
        
    %% Title
    fprintf('\n');
    cprintf('*black','"Reaction times"\n');
    
    %% Paragraph 1
    m = jb_getvector(models.human.rt , sdata.exp_subject , sdata.exp_trial, sdata.vb_novel);
    
    % Consistent with this view, alpha_R positively predicted performance ... and tau negatively
    fprintf('\n');
    cprintf('_black','"Reaction times are quicker in the first trial, abruptly increase until trial 3.." : \n');
    jb_anova(m(:,1:3,:),{'','"trial"','"novel"'});
    
    % and get faster again across the rest of the block in roughly equal measure for the two conditions
    fprintf('\n');
    cprintf('_black','"and get faster again across the rest of the block in roughly equal measure for the two conditions" : \n');
    jb_anova(m(:,3:end,:),{'','"trial"','"novel"'});
    
    % post-error slowing ... interacts with novelty and with response
    % rts [subject,correct,choice,novel];
    fprintf('\n');
    cprintf('_black','"post-error slowing" ... "interacts with novelty and with response" : \n');
    rts = figure_RT1B();
    jb_anova(rts,{'','"correct"','"choice"','"novel"'});
    
    %% Corrected
    fprintf('\n');
    cprintf('_black','"post-error slowing" ... "interacts with novelty and with response" : \n');
    rts = figure_RT1B();
    % rts [subject,correct,choice,novel];
    x = squeeze(rts(:,1,2,:));
    jb_ttest(x(:,1)-x(:,2));
    
    
    %% end
    fprintf('\n');
end
