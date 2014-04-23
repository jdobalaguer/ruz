%#ok<*ASGLU>

function stats_bestfitting()
    %% defaults
    model = model_valid();
    human = 'human';
    
    %% load
    sdata   = struct();
    models  = struct();
    numbers = struct();
    load('data/sdata.mat');
    
    %% assert
    assert(isfield(models,human),'stats_bestfitting: error. human does not exist');
    assert(isfield(models,model),'stats_bestfitting: error. model "%s" does not exist', model);
    
    %% numbers
    u_subject  = numbers.shared.u_subject;
    u_novel    = numbers.shared.u_novel;
    u_trial    = numbers.shared.u_trial;
    nb_subject = numbers.shared.nb_subject;
    nb_novel   = numbers.shared.nb_novel;
    nb_trial   = numbers.shared.nb_trial;
    
    %% Title
    fprintf('\n');
    cprintf('*black','"Best-fitting relative rate predicts subject performance"\n');
    
    %% Paragraph 1
    [corrs,probs] = figure_2C();
    
    % Consistent with this view, alpha_R positively predicted performance ... and tau negatively
    fprintf('\n');
    cprintf('_black','"Consistent with this view, alpha_R positively predicted performance" : \n');
    cprintf('*black','  alpha_m \n');
    fprintf('familiar :   r = %.3f, p = %.3f \n',corrs(1,1),probs(1,1));
    fprintf('novel    :   r = %.3f, p = %.3f \n',corrs(2,1),probs(2,1));
    cprintf([1,0.5,0],'alpha_M doesnt predict\n');
    cprintf('*black','  alpha_r \n');
    fprintf('familiar :   r = %.3f, p = %.3f \n',corrs(1,2),probs(1,2));
    fprintf('novel    :   r = %.3f, p = %.3f \n',corrs(2,2),probs(2,2));
    cprintf([1,0.5,0],'alpha_R negatively predicts\n');
    cprintf('*black','  tau \n');
    fprintf('familiar :   r = %.3f, p = %.3f \n',corrs(1,3),probs(1,3));
    fprintf('novel    :   r = %.3f, p = %.3f \n',corrs(2,3),probs(2,3));
    cprintf([1,0.5,0],'ignore tau\n');
    
    %% end
    fprintf('\n');
end