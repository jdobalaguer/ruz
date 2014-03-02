
function y = tools_discretize(x,n)
    if ~exist('n','var'); n = 2; end
    
    p = linspace(0,1,n+1);
    q = quantile(x,p);
    
    y = ones(size(x));
    for i_q = 2:length(q)-1
        y(x>q(i_q)) = i_q;
    end
    
end