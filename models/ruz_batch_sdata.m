
% initialise
models.ruz.choice  = nan(size(sdata.exp_subject));
models.ruz.correct = nan(size(sdata.exp_subject));
model_keys         = mdata.keys();
model_values       = mdata.values();
fittings           = nan(nb_subject,nb_novel,3);

% minimise bic
greed_bic   = shiftdim(greed_bic,3);
greed_bic   = reshape(greed_bic,[nb_subject,nb_novel,nb_alphat*nb_alphan*nb_tau]);
[~,min_greedbic] = min(greed_bic,[],3);

% loop
tools_parforprogress(numel(min_greedbic));
for i_subject = 1:nb_subject
for i_novel   = 1:nb_novel

    % frame
    ii_subject = (sdata.exp_subject == numbers.shared.u_subject(i_subject));
    ii_novel   = (sdata.vb_novel    == numbers.shared.u_novel(i_novel));
    ii_frame   = (ii_subject & ii_novel);

    % keys
    key = model_keys{min_greedbic(i_subject,i_novel)};
    fittings(i_subject,i_novel,:) = key;

    % values
    models.ruz.choice(ii_frame)  = model_values{min_greedbic(i_subject,i_novel)}.choice(ii_frame);
    models.ruz.correct(ii_frame) = model_values{min_greedbic(i_subject,i_novel)}.correct(ii_frame);

    % progress
    tools_parforprogress();
end
end
tools_parforprogress(0);

% degrees of freedom
models.ruz.df       = 3;
models.ruz.fittings = fittings;

% save sdata
save('data/sdata.mat','-append','models');