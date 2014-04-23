%#ok<*ASGLU>

function stats_modelfitting()
    %% defaults
    model = model_valid();
    human = 'human';
    
    %% load
    sdata   = struct();
    models  = struct();
    numbers = struct();
    load('data/sdata.mat');
    
    %% assert
    assert(isfield(models,human),'stats_modelfitting: error. human does not exist');
    assert(isfield(models,model),'stats_modelfitting: error. model "%s" does not exist', model);
    
    %% numbers
    u_subject  = numbers.shared.u_subject;
    u_novel    = numbers.shared.u_novel;
    u_trial    = numbers.shared.u_trial;
    nb_subject = numbers.shared.nb_subject;
    nb_novel   = numbers.shared.nb_novel;
    nb_trial   = numbers.shared.nb_trial;
    
    %% Title
    fprintf('\n');
    cprintf('*black','"Model fitting to human choice and accuracy data"\n');
    
    %% Paragraph 1
    
    % Accuracy increased across the block overall..
    fprintf('\n');
    cprintf('_black','"Accuracy increased across the block overall" : \n');
    m = jb_getvector(models.human.correct,sdata.exp_subject,sdata.exp_trial);
    jb_anova(m,{'""','"trial"'});

    % but did so faster in blocks with familiar cues
    fprintf('\n');
    cprintf('_black','"but did so faster in blocks with familiar cues." : \n');
    m = jb_getvector(models.human.correct,sdata.exp_subject,sdata.exp_trial,sdata.vb_novel);
    jb_anova(m,{'""','"trial"','"novel"'});
    
    % Participants began with a bias to respond `target` that abated across the block in roughly equal measure for the two conditions.
    fprintf('\n');
    cprintf('_black','"Participants began with a bias to respond `target` that abated across the block in roughly equal measure for the two conditions." \n');
    m = jb_getvector(models.human.choice,sdata.exp_subject,sdata.exp_trial,sdata.vb_novel);
    jb_anova(m,{'""','"trial"','"novel"'});
    cprintf([1,0.5,0],'interaction between conditions\n');
    
    %% Paragraph 2
    alphaM_fit = models.(model_valid).fittings(:,:,1);
    alphaM_opt = models.(model_valid).optimals(:,:,1);
    alphaR_fit = models.(model_valid).fittings(:,:,2);
    alphaR_opt = models.(model_valid).optimals(:,:,2);
    tau_fit    = models.(model_valid).fittings(:,:,3);
    tau_opt    = models.(model_valid).optimals(:,:,3);
    
    % specifically, mean values of alpha_R for blocks with familiar and novel cues respectively diverging reliably from the respective parameters that yielded maximal performance under this model in both cases
    fprintf('\n');
    cprintf('_black','"specifically, mean values of alpha_R were" ... "for blocks with familiar and novel cues respectively, diverging reliably from the respective parameters" ... "that yielded maximal performance under this model in both cases" \n');
    fprintf('mean fittings    : %.2f %.2f \n',mean(alphaR_fit));
    fprintf('mean optimals    : %.2f %.2f \n',mean(alphaR_opt));
    fprintf('std  fittings    : %.2f %.2f \n',std(alphaR_fit));
    fprintf('std  optimals    : %.2f %.2f \n',std(alphaR_opt));
    fprintf('familiar ttest2  : '); jb_ttest2(alphaR_fit(:,1),alphaR_opt(:,1));
    fprintf('novel    ttest2  : '); jb_ttest2(alphaR_fit(:,2),alphaR_opt(:,2));
    
    % similarly, mean values for tau were ... both showing a divergence from the performance-maximising parameters ... that was statistically reliable
    fprintf('\n');
    cprintf('_black','"similarly, mean values for tau were" ... "both showing a divergence from the performance-maximising parameters" ... "that was statistically reliable" \n');
    cprintf('*black','  alpha_m \n');
    fprintf('mean fittings    : %.2f %.2f \n',mean(alphaM_fit));
    fprintf('mean optimals    : %.2f %.2f \n',mean(alphaM_opt));
    fprintf('familiar ttest2  : '); jb_ttest2(alphaM_fit(:,1),alphaM_opt(:,1));
    fprintf('novel    ttest2  : '); jb_ttest2(alphaM_fit(:,2),alphaM_opt(:,2));
    cprintf('*black','  tau     \n');
    fprintf('mean fittings    : %.2f %.2f \n',mean(tau_fit));
    fprintf('mean optimals    : %.2f %.2f \n',mean(tau_opt));
    fprintf('familiar ttest2  : '); jb_ttest2(tau_fit(:,1),tau_opt(:,1));
    fprintf('novel    ttest2  : '); jb_ttest2(tau_fit(:,2),tau_opt(:,2));
    cprintf([1,0.5,0],'change tau to alpha_M\n');
    
    % however, values of tau were smaller ... and values of alpha_R were larger ... in the familiar relative to novel cues condition
    fprintf('\n');
    cprintf('_black','"however, values of tau were smaller ... and values of alpha_R were larger" ... "in the familiar relative to novel cues condition" \n');
    fprintf('alpha_M ttest2  : '); jb_ttest2(alphaM_fit(:,1),alphaM_fit(:,2));
    fprintf('alpha_R ttest2  : '); jb_ttest2(alphaR_fit(:,1),alphaR_fit(:,2));
    fprintf('tau     ttest2  : '); jb_ttest2(tau_fit(:,1),   tau_fit(:,2));
    cprintf([1,0.5,0],'focus on alpha_M and alpha_R\n');

    %% end
    fprintf('\n');
end