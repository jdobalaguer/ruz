
function plot_correct_matchtrial(model)
    if ~usejava('swing'); return; end
    
    %% load
    load('data/sdata');
    sdata.vb_diffstimord    = [0,0,0,0 ; (diff(sdata.vb_stimord,[],1) ~= 0)];
    sdata.vb_diffstimord    = all(sdata.vb_diffstimord,2);
    sdata.vb_difftarget     = [0 ; diff(sdata.vb_target,[],1) ~= 0];
    if exist('model','var'); models.human = model; end
    
    %% numbers
    u_subject   = numbers.shared.u_subject;
    u_novel     = numbers.shared.u_novel;
    u_target    = numbers.shared.u_target;
    u_trial     = numbers.shared.u_trial;
    u_trial(1) = [];
    
    nb_subject  = numbers.shared.nb_subject;
    nb_novel    = numbers.shared.nb_novel;
    nb_target   = numbers.shared.nb_target;
    nb_trial    = length(u_trial);
    
    %% value
    diffperfor  = nan(nb_subject,nb_trial,nb_novel,nb_target);
    performance = nan(nb_subject,nb_trial,nb_novel,nb_target);
    for i_subject = 1:nb_subject
        for i_novel = 1:nb_novel
            for i_target = 1:nb_target
                for i_trial = 1:nb_trial
                    % index
                    ii_subject = (sdata.exp_subject     == u_subject(i_subject));
                    ii_novel   = (sdata.vb_novel        == u_novel(i_novel));
                    ii_trial   = (sdata.exp_trial       == u_trial(i_trial));
                    ii_dtarget = (sdata.vb_difftarget);
                    ii_target  = (sdata.vb_target       == u_target(i_target));
                    % value
                    x = nanmean(models.human.correct(sdata.vb_diffstimord & ii_subject & ii_novel & ii_trial & ii_dtarget & ii_target));
                    p = nanmean(models.human.correct(                       ii_subject & ii_novel & ii_trial              & ii_target));
                    diffperfor( i_subject,i_trial,i_novel,i_target) = x;
                    performance(i_subject,i_trial,i_novel,i_target) = p;
                end
            end
        end
    end
    
    %% plot
    % figure
    f = figure();
    
    % colours
    colours = 'gr';
    
    % titles
    titles = {'FAMILIAR','NOVEL'};
    
    j_subplot = 0;
    for i_novel = 1:nb_novel
        for i_target = 1:nb_target
            % values
            value = diffperfor(:,:,i_novel,i_target);
            vmean = nanmean(value,1);
            vste  = nanste(value,1);
            perfo = performance(:,:,i_novel,i_target);
            pmean = nanmean(perfo,1);
            pste  = nanste(perfo,1);

            % subplot
            j_subplot = j_subplot + 1;
            subplot(nb_target,nb_novel,j_subplot);

            % plot
            fig_plot(u_trial,vmean,vste,colours(i_novel));
            
            % performance
            fig_plot(u_trial,pmean,pste,[0,0,0]);

            % axis
            sa.title   = titles{i_novel};
            sa.xlabel  = 'trial';
            sa.ylabel  = 'performance';
            sa.xtick   = [4,8,12,16];
            sa.xlim    = [1,16];
            sa.ytick   = 0:0.2:1;
            sa.ylim    = [0,1];
            fig_axis(sa);
        end
    end
    
end