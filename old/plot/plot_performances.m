
%% fit model
run_fitting;

%% get values
perf = nan(numbers.nb_novelties, numbers.nb_subjects , numbers.nb_propabss , numbers.nb_propangs , numbers.nb_threshs);

ii_propabs = 1:25:numbers.nb_propabss;

for i_novelty = 1:numbers.nb_novelties
    for i_subject = 1:numbers.nb_subjects
        for i_propabs = 1:length(ii_propabs)
            % set values
            subject = i_subject;
            novelty = i_novelty;
            propabs = ii_propabs(i_propabs);

            % find errors
            for i_propang = 1:numbers.nb_propangs
                for i_thresh = 1:numbers.nb_threshs
                    % set values
                    propang = i_propang;
                    thresh  = i_thresh;
                    % get value
                    perf(i_novelty,i_subject,i_propabs,i_propang,i_thresh) = mean(sdata.modcr(subject,novelty,propabs,propang,thresh,:));
                end
            end
        end
    end
end

%% plot
figure;
% familiar/novel cues
i_subplot = 1;
for i_propabs = 1:length(ii_propabs)
    for i_novelty = 1:numbers.nb_novelties

        % figure
        subplot(length(ii_propabs),numbers.nb_novelties,i_subplot);
        i_subplot = i_subplot + 1;
        hold on;

        % get value
        landscape = squeeze(perf(i_novelty,:,i_propabs,:,:));
        landscape = squeeze(mean(landscape,1));

        surface(numbers.u_thresh,numbers.u_propang,landscape);
        xlabel('minmax prop');
        ylabel('propang');
        zlabel('fitting error');
    end
end
