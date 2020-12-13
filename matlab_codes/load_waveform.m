function [wf_asym,wf_c,mean_waveform,mean_spon,recal]=load_waveform(matfolder,site,rec,ch_list,unit_list,if_recal,pen)
%% load or execute waveform analysis given filename related information and channel, unit, penetration, if or not re-calculation needed
% previous processing: txt_neurodata_reader_offlinesorter_electrode_1.m
% need function: waveform_ana.m
%
% input: mat_folder: folder where matdata is stored, e.g. 'F:\data\12_11_2020\mat'
%        site: recording site, consistent with rawdata filename
%        rec: recording number, consistent with rawdata filename
%        ch_list: all channels to be processed
%        unit_list: all units number to be processed
%        if_recal: 1 - will re-calculate mean, spike trough/peak asymmetry,
%                  spike duration;
%                  0 - will not re-calculate, only load information from
%                  existing processed data files
%        pen: penetration, consistent with rawday filename, Default: same
%        as site
%
% output: wf_asym: trough/peak asymmetry
%        wf_c: spike duration
%        mean_waveform: average of waveforms for all spikes
%        mean_spon: average spike rate of spontaneous activity
%        recal: if re-calculated, results are saved in variable 'recal'
%
% writtern by Li Shen, shen938@usc.edu


if nargin<8
    pen=site;
end

% matfolder=['F:\data\',date_str,'\mat'];
recal=[];

for i=1:length(ch_list)
    ch=ch_list(i);
    unit=unit_list(i);
    matname=fullfile(matfolder,['site',num2str(site),'rec',num2str(rec),'_ch',num2str(ch),'_n',num2str(unit),'.mat']);
    if exist(matname,'file')
        datamat=load(matname);
    else
        matname=fullfile(matfolder,['site',num2str(site),'pen',num2str(pen),'rec',num2str(rec),'_ch',num2str(ch),'_n',num2str(unit),'.mat']);
        datamat=load(matname);
    end
    ch_maxsnr=datamat.ch_maxsnr;
    wf_asym(i)=datamat.wf_asym(ch_maxsnr);
    wf_c(i)=datamat.wf_c(ch_maxsnr);
    mean_waveform(i,:)=datamat.mean_waveform(ch_maxsnr,:);
    mean_spon(i,:)=datamat.mean_spon;
    
    if if_recal==1
        waveform_tobeana=datamat.waveform_raw{ch_maxsnr};
        [wf_asym_tmp,wf_c_tmp,peak_trough_ratio_tmp,spk_hw_tmp,wf_asym2_tmp,~]=waveform_ana(waveform_tobeana');
        [wf_asym_meanwf_tmp,wf_c_tmp_meanwf_tmp,peak_trough_ratio_meanwf_tmp,spk_hw_meanwf_tmp,wf_asym2_meanwf_tmp,~]=waveform_ana_mean(datamat.mean_waveform(ch_maxsnr,:));
        recal.wf_asym(i)=mean(wf_asym_tmp(~isnan(wf_asym_tmp)));
        recal.wf_c(i)=mean(wf_c_tmp(~isnan(wf_c_tmp)));
        recal.peak_trough_ratio(i)=mean(peak_trough_ratio_tmp(~isnan(peak_trough_ratio_tmp)));
        recal.spk_hw(i)=mean(spk_hw_tmp(~isnan(spk_hw_tmp)));
        recal.wf_asym2(i)=mean(wf_asym2_tmp(~isnan(wf_asym2_tmp)));
        
        recal.median_wf_asym(i)=median(wf_asym_tmp(~isnan(wf_asym_tmp)));
        recal.median_wf_c(i)=median(wf_c_tmp(~isnan(wf_c_tmp)));
        recal.median_peak_trough_ratio(i)=median(peak_trough_ratio_tmp(~isnan(peak_trough_ratio_tmp)));
        recal.median_spk_hw(i)=median(spk_hw_tmp(~isnan(spk_hw_tmp)));
        recal.median_wf_asym2(i)=median(wf_asym2_tmp(~isnan(wf_asym2_tmp)));
        
        recal.mean_wf_asym(i)=wf_asym_meanwf_tmp;
        recal.mean_wf_c(i)=wf_c_tmp_meanwf_tmp;
        recal.mean_peak_trough_ratio(i)=peak_trough_ratio_meanwf_tmp;
        recal.mean_spk_hw(i)=spk_hw_meanwf_tmp;
        recal.mean_wf_asym2(i)=wf_asym2_meanwf_tmp;
    end
end