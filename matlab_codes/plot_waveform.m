function plot_waveform(mean_waveform,std_waveform,ch)
%% plot spike waveform given mean and std (for all channel, output of pipeline processing), channel number
%
% input: - mean_waveform: matrix with size [total_channel, nsample_waveform],
%                         e.g. for 16 channel, 30kHz sample rate, 1ms waveform length, size = [16, 30]
%        - std_waveform: single-side significance intervale for all
%                        waveform samples
%        - ch: selected channel (out of total_channel)
%
%%% by Li Shen, shen938@usc.edu
%%
figure,
len=size(mean_waveform,2);
patch([1:len,len:-1:1],[mean_waveform(ch,:)-std_waveform(ch),...
    mean_waveform(ch,end:-1:1)+std_waveform(ch)],0.7*ones(1,3),'edgecolor','none');
hold on
plot(mean_waveform(ch,:),'k','linewidth',1);
max_plot=max(mean_waveform(ch,:))+std_waveform(ch);
plot([1,15],max_plot*ones(1,2),'k','linewidth',1);
text(7.5,max_plot,'0.5ms','horizontalalignment','center','verticalalignment','bottom');
axis off;