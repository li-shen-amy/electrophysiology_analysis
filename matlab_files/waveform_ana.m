function [wf_asym,wf_c,peak_trough_ratio,spk_hw,wf_asym2,mean_waveform]=waveform_ana(waveform)
% input format: each row :  waveform for each cell/trial/...
% output format: for each cell
% writtern by Li Shen, shen938@usc.edu
for i=1:size(waveform,1)
    [min_waveform(i),trough_waveform(i)]=min(waveform(i,:));
    [max_waveform(i),pk_waveform(i)]=max(waveform(i,:));
    [max2_waveform(i),pk2_waveform(i)]=max(waveform(i,trough_waveform(i):end));
    start_tmp=find(waveform(i,2:end)<0.5*min_waveform(i) & waveform(i,1:end-1)>0.5*min_waveform(i),1);
    if ~isempty(start_tmp)
        hf_start(i)=start_tmp;
    else
        hf_start(i)=NaN;%1;
    end
    emd_tmp=find(waveform(i,2:end)>0.5*min_waveform(i) & waveform(i,1:end-1)<0.5*min_waveform(i),1);
    if ~isempty(emd_tmp)
        hf_end(i)=emd_tmp;
    else
        hf_end(i)=NaN;%size(waveform,2);
    end
    if max_waveform(i)<0 || min_waveform(i)>0
        wf_asym(i)=NaN;
        wf_c(i)=NaN;
        peak_trough_ratio(i)=NaN;
        spk_hw(i)=NaN;
    else
        pk2_waveform(i)=pk2_waveform(i)+trough_waveform(i)-1;
        pp_mean_waveform(i)=max_waveform(i)-min_waveform(i);
        wf_asym(i)=(abs(max_waveform(i))-abs(min_waveform(i)))./(abs(max_waveform(i))+abs(min_waveform(i)));
        wf_c(i)=(pk2_waveform(i)-trough_waveform(i))/30;
        
        peak_trough_ratio(i)=abs(max_waveform(i))/abs(min_waveform(i));
        spk_hw(i)=(hf_end(i)-hf_start(i))/30;
        
        wf_asym2(i)=(abs(max2_waveform(i)-waveform(i,end))-abs(min_waveform(i)-waveform(i,end)))./(abs(max2_waveform(i)-waveform(i,end))+abs(min_waveform(i)-waveform(i,end)));
        
    end
end
mean_waveform=mean(waveform,1);
% max_waveform(max_waveform<0)=NaN;%0;
% min_waveform(min_waveform>0)=NaN;%0;


% pk2_waveform=pk2_waveform+trough_waveform-1;
% pp_mean_waveform=max_waveform-min_waveform;
% wf_asym=(abs(max_waveform)-abs(min_waveform))./(abs(max_waveform)+abs(min_waveform));
% wf_c=(pk2_waveform-trough_waveform)/30;
% mean_waveform=mean(waveform);
%
% peak_trough_ratio=abs(max_waveform)/abs(min_waveform);
% spk_hw=(hf_end-hf_start)/30;