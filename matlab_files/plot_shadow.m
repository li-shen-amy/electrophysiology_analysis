function [line_handle,shase_handle]=plot_shadow(x,mean_y,sd_y,color,alpha)
%% plot mean with sd/se shadow
% example: plot_shadow([0:10],[0:10],0.1*ones(1,10),'k',0.5);
%%% by Li Shen shen938@usc.edu
%% 
x=reshape(x,1,length(x));
mean_y=reshape(mean_y,1,length(mean_y));
sd_y=reshape(sd_y,1,length(sd_y));

shase_handle=patch([x,x(end:-1:1)],[mean_y+sd_y,mean_y(end:-1:1)-sd_y(end:-1:1)],color,'facealpha',alpha,'edgecolor','none');
hold on
line_handle=plot(x,mean_y,'color',color);
    