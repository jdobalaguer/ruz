
function criterion = model_criterion()
    criterion = @(ch,co) (ch+co)*0.5;
end
