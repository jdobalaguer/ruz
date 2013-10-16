
function [pf qq paramz xy]=psychofunction(human,model,binz);
% function [pf qq paramz xy]=psychofunction(human,model,binz);
 
if nargin<3;
    binz=10;
end

if nargin<4;
    rangey=[0 1];
end

if isscalar(binz);
    qq=quantile(model,[1/(binz-1):1/(binz-1):1-(1/(binz-1))]);
else
    qq=binz;
end
qq=[-Inf qq Inf];


for q=1:length(qq)-1;
    indx=find(model>=qq(q) & model<qq(q+1));
    pf(q)=mean(human(indx));
end

if nargout>2
    paramz=[0 1 4.5 0.5];
    param=statset('MaxIter',1000);
    %plot(x,y,'o','markerfacecolor',[0.7 0.7 0.7],'markeredgecolor','k');
    f = @(p,x) p(1) + p(2) ./ (1 + exp(-(x-p(3))/p(4)));
    [paramz r j] = nlinfit(1:length(qq)-1,pf,f,paramz,param);    
end

if nargout>3
    xy=[];
    hold on;    
    f = @(p,x) p(1) + p(2) ./ (1 + exp(-(x-p(3))/p(4)));
    plot(1:length(binz)-1,pf,'o');
    line(1:length(binz)-1,f(paramz,1:length(binz)-1),'linewidth',1);
end

    
