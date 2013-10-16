function wwX=steplot(x,varargin);
% function steplot(x,[plottype],[inwid],[stecolors],[steshape],[stelines]);
%
% x must be a subs*data matrix. if 3d, will plot 2nd dim as separate lines.
% plottype can be 'b' (bar) or 'l' (line);
% inwid (optional) is the width of the se bars (default 1/10 of bar width).
wwX=[];
plottype='b';
inwid=[];
stecolor1=[];stecolor2=[];
steshape=[];
steline1=[];steline2=[];
mks=[];

%%%%%%%%% get variable arguments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if length(varargin)>0,plottype=varargin{1};,end
if length(varargin)>1,inwid=varargin{2};,end

%% get colours
if length(varargin)>2,
    stecolors=varargin{3};
    if length(stecolors)==2;
        stecolor1=stecolors{1};
        stecolor2=stecolors{2};
    else
         stecolor1=stecolors;
        stecolor2=stecolors;
    end
end
if length(varargin)>3,steshape=varargin{4};,end

% get linewidths
if length(varargin)>4,
    stelines=varargin{5};
    if length(stecolors)==2;
        steline1=stelines{1};
        steline2=stelines{2};
    else
         steline1=stelines;
        steline2=stelines;
    end
end


if length(varargin)>5;mks=varargin{6};end

%%%%% defaults %%%%%%%%
if isempty(plottype),plottype='l';,end
if isempty(inwid),inwid=10;,end
if isempty(stecolor1),stecolor1='k';,end
if isempty(stecolor2),stecolor2='k';,end
if isempty(steshape),steshape='o';,end
if isempty(steline1),steline1=1;,end
if isempty(steline2),steline2=1;,end
if isempty(mks),mks=10;,end
colormap gray
if ndims(x)>3
    error('cant plot a 4d matrix');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% FIRST DEAL WITH 2-D DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ndims(x)==2;

np=size(x,2);    

% get standard errors
steX=(std(x,[],1))/sqrt(size(x,1));     %standard error is std/root n
 
% get mean
mx=squeeze(mean(x));

%plot error bars first
for n=1:np;  
    line([n,n],[mx(n)-(steX(n)/2),mx(n)+(steX(n)/2)],'color',stecolor1,'linewidth',steline1);
    if size(mx,2)<100;
    line([n-1/inwid,n+1/inwid],[mx(n)-(steX(n)/2),mx(n)-(steX(n)/2)],'color',stecolor1,'linewidth',steline1);
    line([n-1/inwid,n+1/inwid],[mx(n)+(steX(n)/2),mx(n)+(steX(n)/2)],'color',stecolor1,'linewidth',steline1);
    end
end


hold on;

%%% which type of plot??? %%%%%%%%%

%%% LINE %%%%%%%%
if plottype=='l';
plot(mx,'color',stecolor2,'linewidth',steline2);

%%% POINT %%%%%%%%
elseif plottype=='p';
plot(mx,'o','color','k','markerfacecolor',stecolor1,'markeredgecolor',stecolor1,'marker',steshape,'markersize',mks);

%%% MIXED (i.e. POINTS WITH LINE) %%%%%%%%
elseif plottype=='m';
plot(mx,'o','color','k','markerfacecolor',stecolor1,'markeredgecolor',stecolor2,'marker',steshape,'markersize',mks);
plot(mx,'linewidth',steline2,'color',stecolor2);

%%% BAR %%%%%%%%%%
elseif plottype=='b';    
bar(mx,'linewidth',1,'Facecolor',[0.7 0.7 0.7],'Edgecolor',[0 0 0]);   % telling you what colour for the bars
colormap gray;
set(gca,'clim',[0 1]);
end
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% WASN'T THAT EASY? WHAT ABOUT 3-D DATA? %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif ndims(x)==3;
    
if plottype=='l';    
bw=1;        %linewidth
np=size(x,3);
X=x(:,:);        
steX=std(X,[],1)/sqrt(size(x,1));
steX=reshape(steX,size(x,2),np);

mx=squeeze(mean(x));
%figure;
plot(mx','linewidth',2);
hold on;

for l=1:size(x,2);
for n=1:np;  
    line([n,n],[mx(l,n)-(steX(l,n)/2),mx(l,n)+(steX(l,n)/2)],'color',stecolor1,'linewidth',bw);
    line([n-1/inwid,n+1/inwid],[mx(l,n)-(steX(l,n)/2),mx(l,n)-(steX(l,n)/2)],'color',stecolor1,'linewidth',bw);
    line([n-1/inwid,n+1/inwid],[mx(l,n)+(steX(l,n)/2),mx(l,n)+(steX(l,n)/2)],'color',stecolor1,'linewidth',bw);
end
end


elseif plottype=='b';

bw=2;
mx=squeeze(mean(x));

h=bar(mx');
h1=get(gca,'Children');a=get(h1);;
np=size(x,3);
X=x(:,:);        
steX=std(X,[],1)/sqrt(size(x,1));
steX=reshape(steX,size(x,2),np);

for l=1:size(x,2);
        a1=get(a(l).Children);a1.XData;
        wherex={a1.XData};wherey={a1.YData};
        whereX=wherex{1};whereY=wherey{1};
        wid=(whereX(3)-whereX(1))./inwid;
        wX=(whereX(3,:)+whereX(1,:))./2;
        wY=(whereY(2,:));
        wwX(l,:)=wX;
        for n=1:np;          
        line([wX(n) wX(n)],[wY(n)-steX(l,n) wY(n)+steX(l,n)],'color',stecolor1,'linewidth',bw);
        line([wX(n)-wid wX(n)+wid],[wY(n)-steX(l,n) wY(n)-steX(l,n)],'color',stecolor1,'linewidth',bw);
        line([wX(n)-wid wX(n)+wid],[wY(n)+steX(l,n) wY(n)+steX(l,n)],'color',stecolor1,'linewidth',bw);        
     end
end


end
end
    