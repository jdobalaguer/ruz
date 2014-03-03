
%% change directory
cd('..');

%% variables
u_mapping     = 0.50 : 0.50 :  3.00;    ... example  2.84;
u_specificity = 4.00 : 4.00 : 16.00;    ... example 14.00;
u_wstep       = 0.04 : 0.04 :  0.30;    ... example  0.21;
u_astep       = 0.04 : 0.04 :  0.30;    ... example  0.01;

%% run
tools_parforprogress(   length(u_mapping) * length(u_specificity) ...
                      * length(u_wstep) * length(u_astep));

for mapping     = u_mapping
for specificity = u_specificity
for w_step      = u_wstep
for a_step      = u_astep

    %% set model
    model.mapping       = mapping;
    model.specificity   = specificity;
    model.w_step        = w_step;
    model.a_step        = a_step;
    
    %% set key
    model.key = [mapping,specificity,w_step,a_step];
    fprintf('alcove_batch: key[%.2f,%.2f,%.2f,%.2f] \n',model.key);
    
    %% run
    load('data/models_alcove.mat','alcove');
    model.run = ~alcove.iskey(model.key);
    clear alcove;
    if model.run; run_model(model); end

    tools_parforprogress;
end
end
end
end
tools_parforprogress(0);
