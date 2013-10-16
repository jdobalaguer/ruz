
%% fit model
run_fitting;

%% get values
perf = nan(numbers.nb_novelties, numbers.nb_subjects , numbers.nb_propangs);

for i_novelty = 1:numbers.nb_novelties
    for i_subject = 1:numbers.nb_subjects
        % set values
        subject = i_subject;
        novelty = i_novelty;
        i_propabs = find(numbers.u_propabs == sdata.minpropabs(i_subject,i_novelty)); % best propang
        
        % find errors
        for i_propang = 1:numbers.nb_propangs
            % set i_thresh
            propang = numbers.u_propang(i_propang);
            thresh = 1 - propang;
            i_thresh = find(numbers.u_thresh < thresh,1,'last');
            newthresh = numbers.u_thresh(i_thresh);
            % get value
            if ~isempty(i_thresh)
                perf(i_novelty,i_subject,i_propang) = mean(sdata.modcr(subject,novelty,i_propabs,i_propang,i_thresh,:));
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
    landscape = squeeze(perf(i_novelty,:,:));
    landscape = squeeze(nanmean(landscape,1));
    
    plot(numbers.u_propang,landscape);
    xlabel('propang');
    ylabel('performance');
    set(gca,'ylim',[0.5,1]);
end
