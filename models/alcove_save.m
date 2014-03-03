
%% change directory
cd('..');

%% load
if exist('data/models_alcove.mat','file')
    load('data/models_alcove.mat');
else
    alcove = dict();
end

%% add variables
alcove(model.key) = mdata;

%% save
save('data/models_alcove.mat','alcove');
