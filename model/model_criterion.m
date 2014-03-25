
function criterion = model_criterion()
    %criterion = @(ch,co) ch;
    criterion = @(ch,co) (ch+co)*0.5;
    %criterion = @(ch,co) co;
end
