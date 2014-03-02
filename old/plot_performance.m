
%% fit model
run_fitting;

%% get values
perf = nan(numbers.nb_novelties, numbers.nb_subjects , numbers.nb_propangs , numbers.nb_threshs);

for i_novelty = 1:numbers.nb_novelties
    for i_subject = 1:numbers.nb_subjects
        % set values
        subject = i_subject;
        novelty = i_novelty;
        propabs = find(numbers.u_propabs == sdata.minpropabs(i_subject,i_novelty)); % best propang
        
        % find errors
        for i_propang = 1:numbers.nb_propangs
            for i_thresh = 1:numbers.nb_threshs
                % set values
                propang = i_propang;
                thresh  = i_thresh;
                % get value
                perf(i_novelty,i_subject,i_propang,i_thresh) = mean(sdata.modcr(subject,novelty,propabs,propang,thresh,:));
            end
        end
    end
end

%% plot
figure;

% familiar/novel cues
for i_novelty = 1:numbers.nb_novelties
    
    % figure
    subplot(1,numbers.nb_novelties,i_novelty);
    hold on;
    
    % get value
    landscape = squeeze(perf(i_novelty,:,:,:));
    landscape = squeeze(mean(landscape,1));
    
    surface(numbers.u_thresh,numbers.u_propang,landscape);
    xlabel('minmax prop');
    ylabel('propang');
    zlabel('fitting error');
    set(gca,'clim',[0.5,1]);
end
