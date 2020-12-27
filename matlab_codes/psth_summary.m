%% summarize results of batch units for all recording sessions in one experiment to a summary table
% This is for processing data after 'data_process_after_sorting.m'
%
% Read data after soting: 
%   - experiment protocol spreadsheet: e.g. 'sample_data/pcg_exp_record_ana.xlsx'
%   - read 'mat' folder: for each unit and each recording session, the processed mat file, 
%                   e.g. 'sample_data/mat/site1rec8_ch1_n5.mat'
%
% Output summary table and processed mat file to summarize results 
%      for all units and all recording session in this experiment,
%      e.g. 'sample_data\Results\procesed_1_9_2018_site1.jpg' or '.fig',
%      '.mat' files
%
% Key properties:
%   - protocol parameters: e.g.'db_list','psth_bin','ch_all','ch_sort_all'
%   - response properties: latency, psth, z-score, and so on
%         e.g. 'latency','latency_resp','mean_latency','median_latency','se_latency',...
%         'pkonset_mean','std_spon','pk_zscore','pk_zscore_valid','mean_pkzscore','se_pkzscore',...
%         'idx_resp2','idx_noresp2','pk_zscore_resp','mean_pkzscore_resp','se_pkzscore_resp',...
%         'mean_spon','psth_zscore','resp_idx_3std','psth_zscore_mean_3std','psth_zscore_mean_3std_lat',...
%         'mean_80db_lat','median_80db_lat','sorted_pkzscore_80db_idx','pk_zscore_80db_mean','pk_lat_80db_mean',...
%         'psth_all','psth_10ms_all','psth_sm_all','resp_idx_3std_noinf','idx_resp2_noinf',...
%         'psth_raw','psth_mean_3std','pk_zscore_80db_ch','mean_pk_zscore_80db_ch','se_pk_zscore_80db_ch',...
%         'latency_80db_ch','mean_latency_80db_ch','se_latency_80db_ch','pk_zscore_80db_ch_sort',...
%         'mean_pk_zscore_80db_ch_sort','se_pk_zscore_80db_ch_sort','latency_80db_ch_sort','mean_latency_80db_ch_sort',...
%         'se_latency_80db_ch_sort'
%
% By Li Shen, shen938@usc.edu
%%
clc;clear;close all;
if strcmp(computer,'MACI64')
    prepath='data/';
    code_folder='extracellular/';
elseif  strcmp(computer,'PCWIN64')
    prepath='F:\data\';
    code_folder='D:\extracellular\';
end
% lat_range=[6,20]/1000;
date='3_22_2018';

batch_eachsite=1;%0;%1;
sel_site=[];%[1,4];
db_sel=80;%70;%80;

lat_range=[6,30]/1000;
tetrode_sorting=1;

sel_dur=1;%0;%1;
dur_sel=0.05;%0.5;%0.05
isi_sel=3;

plot_all_pk=1;
% cal_ori_data=1;


pre_trg=0.099;
trial_dur=0.349;

xpn=fullfile(prepath,date);
ch_num=16;
if tetrode_sorting==1
    dest_folder=fullfile(xpn,'fig');
    dest_matfolder=fullfile(xpn,'mat');
else
    dest_folder=fullfile(xpn,'ch16','fig');
    dest_matfolder=fullfile(xpn,'ch16','mat');
end
binfolder='Bin';
folder_list=dir(dest_folder);
% if cal_ori_data==1
prop_names_sel={'unit_ch','unit','ch_maxsnr','max_snr_waveform','db','freq',...
    'lat','pkpsth','pkpsth_10ms','pkpsth_onset','pkpsth_onset10ms',...
    'pk_mean','pk_mean_3std','pk_mean_10ms','pk_mean_3std_10ms',...
    'pkonset_mean','pkonset_mean_3std','pkonset_mean_10ms','pkonset_mean_3std_10ms',...
    'wf_asym','wf_c','ch_sort','rec_no','dur','isi'};
for i=1:length(prop_names_sel)
    if strcmp(prop_names_sel{i},'unit_ch')
        ich=i;
    elseif  strcmp(prop_names_sel{i},'db')
        idb=i;
    elseif  strcmp(prop_names_sel{i},'freq')
        ifreq=i;
    elseif  strcmp(prop_names_sel{i},'lat')
        ilat=i;
    elseif  strcmp(prop_names_sel{i},'pkonset_mean_3std')
        ipkonset_mean_3std=i;
    elseif  strcmp(prop_names_sel{i},'pkonset_mean')
        ipkonset_mean=i;
    elseif  strcmp(prop_names_sel{i},'pkpsth_onset')
        ipkonset=i;%10 not 15 corrected 2/23/18
    elseif strcmp(prop_names_sel{i},'ch_sort')
        ich_sort=i;
    elseif  strcmp(prop_names_sel{i},'dur')
        idur=i;
    elseif  strcmp(prop_names_sel{i},'isi')
        iisi=i;
    end
end

n_additem=14;%10;
clear summary_table
% summary_table(1,1:length(prop_names_sel))=prop_names_sel;
count=0;
already_get_fieldnames=1;

[num,txt,raw]=xlsread(fullfile(prepath,'pcg_exp_record_ana.xlsx'),date);
for i=1:size(raw,2)
    if strcmp(raw(1,i),'record')
        irec_para=i;%2
    elseif strcmp(raw(1,i),'site')
        isite_para=i;%4
    elseif strcmp(raw(1,i),'duration')
        idur_para=i;%7
    elseif strcmp(raw(1,i),'isi')
        iisi_para=i;%8
    elseif strcmp(raw(1,i),'paradigm')
        ipara_para=i;%8
    end
end

[all_site,~,iall_site]=unique(num(:,isite_para));

if ~batch_eachsite
    all_site=sel_site;
end
for isel=1:length(all_site)
    sel_site=all_site(isel);
    if ~isempty(sel_site)
        post_name=['_site',num2str(sel_site)];
    else
        post_name='';
    end
    clear psth_all psth_10ms_all psth_sm_all
    for fi=1:length(folder_list)
        if folder_list(fi).isdir && ~isempty(strfind(folder_list(fi).name,'site'))
            folder_name=folder_list(fi).name;
            under_idx=strfind(folder_name,'_');
            site=str2num(folder_name(5:under_idx(1)-1));
            ch_sort=str2num(folder_name(under_idx(1)+3:under_idx(2)-1));
            unit=str2num(folder_name(under_idx(2)+2:end));
            file_list=dir(fullfile(dest_folder,folder_list(fi).name,'*.jpg'));
            for fj=1:length(file_list)
                [~,filename,~]=fileparts(file_list(fj).name);
                rec_idx=strfind(filename,'rec');
                under1_idx=strfind(filename,'_');
                rec_no=str2num(filename(rec_idx(1)+3:under1_idx(1)-1));
                para_idx=find(num(:,irec_para)==rec_no & num(:,isite_para)==site);
                stim_dur=num(para_idx,idur_para);
                isi=num(para_idx,iisi_para);
                
                matfile=fullfile(dest_matfolder,[filename,'.mat']);
                datamat=load(matfile);
                count=count+1;
                if length(datamat.psth)>=999
                    psth_all(count,:)=datamat.psth(101:449);
                    psth_10ms_all(count,:)=datamat.psth_10ms(11:45);
                    psth_sm_all(count,:)=datamat.psth_sm(101:449);
                    %                     pre_trg=0.199;
                    %                     trial_dur=0.998;
                else
                    psth_all(count,:)=datamat.psth;
                    psth_10ms_all(count,:)=datamat.psth_10ms;
                    psth_sm_all(count,:)=datamat.psth_sm;
                    %                     pre_trg=0.099;
                    %                     trial_dur=0.349;
                end
                %%
                clear field_value
                for fk=1:length(prop_names_sel)-n_additem
                    tmp=getfield(datamat,prop_names_sel{fk});
                    if ~isempty(tmp)
                        field_value(fk)=tmp;
                    else
                        field_value(fk)=NaN;
                    end
                end
                
                pk_mean=datamat.pkpsth-datamat.mean_spon;
                pk_mean_3std=pk_mean-3*datamat.std_spon;
                field_value(fk+1)=pk_mean;
                field_value(fk+2)=pk_mean_3std;
                
                pk_mean_10ms=datamat.pkpsth_10ms-datamat.mean_spon_10ms;
                pk_mean_3std_10ms=pk_mean_10ms-3*datamat.std_spon_10ms;
                field_value(fk+3)=pk_mean_10ms;
                field_value(fk+4)=pk_mean_3std_10ms;
                
                pkonset_mean=datamat.pkpsth_onset-datamat.mean_spon;
                pkonset_mean_3std=pkonset_mean-3*datamat.std_spon;
                field_value(fk+5)=pkonset_mean;
                field_value(fk+6)=pkonset_mean_3std;
                
                pkonset_mean_10ms=datamat.pkpsth_onset10ms-datamat.mean_spon_10ms;
                pkonset_mean_3std_10ms=pkonset_mean_10ms-3*datamat.std_spon_10ms;
                field_value(fk+7)=pkonset_mean_10ms;
                field_value(fk+8)=pkonset_mean_3std_10ms;
                
                wf_asym=datamat.wf_asym(datamat.unit_ch);
                wf_c=datamat.wf_c(datamat.unit_ch);
                field_value(fk+9)=wf_asym;
                field_value(fk+10)=wf_c;
                
                field_value(fk+11)=ch_sort;
                field_value(fk+12)=rec_no;
                %                    field_value(fk+13)=datamat.mean_spon;
                %                 field_value(fk+14)=datamat.std_spon;
                field_value(fk+13)=stim_dur;
                field_value(fk+14)=isi;
                summary_table(count,1:length(prop_names_sel))=field_value;
            end
        end
    end
    T1=num2cell(summary_table);
    T=cell2table([prop_names_sel;T1]);
    % writetable(T,fullfile(prepath,['ori_data_',date,post_name,'.xlsx']));
    % save(fullfile(code_folder,['ori_data_',date,post_name]),'summary_table','prop_names_sel','psth_all','psth_10ms_all','psth_sm_all');
    
    %     load(['ori_data_',date,post_name]);
    %
    %     prop_names_sel={'unit_ch','unit','ch_maxsnr','max_snr_waveform','db','freq',...
    %         'lat','pkpsth','pkpsth_10ms','pkpsth_onset','pkpsth_onset10ms',...
    %         'pk_mean','pk_mean_3std','pk_mean_10ms','pk_mean_3std_10ms',...
    %         'pkonset_mean','pkonset_mean_3std','pkonset_mean_10ms','pkonset_mean_3std_10ms',...
    %         'wf_asym','wf_c'};
    
    
    tbin=0.001;
    psth_bin=-pre_trg:tbin:trial_dur-pre_trg;
    psth_bin=psth_bin(1:end-1);
    
    db_list=unique(summary_table(:,idb));
    db_list=db_list(db_list>0);
    if strcmp(date,'10_5_2017')
        db_list=[60,80,90];
    end
    clear latency mean_latency se_latency latency_resp median_latency mean_spon
    clear pkonset_mean ch_all ch_sort_all
    
    id_80db=find(db_list==db_sel);
    for id=1:length(db_list)
        if sel_dur && id==id_80db
            rec_idx=find(summary_table(:,idb)==db_list(id) & summary_table(:,ifreq)==0 & summary_table(:,idur)==dur_sel ...
                & summary_table(:,iisi)==isi_sel);
        else
            rec_idx=find(summary_table(:,idb)==db_list(id) & summary_table(:,ifreq)==0);
        end
        ch_all{id}=summary_table(rec_idx,ich);
        ch_sort_all{id}=summary_table(rec_idx,ich_sort);
        latency{id}=summary_table(rec_idx,ilat)+0.0005;
        
        idx_resp=find(~isnan(latency{id}) & latency{id}<lat_range(2)) ;
        latency_resp{id}=latency{id}(~isnan(latency{id}) & latency{id}>lat_range(1) & latency{id}<lat_range(2) );
        mean_latency(id)=mean(latency_resp{id});
        median_latency(id)=median(latency_resp{id});
        se_latency(id)=std(latency_resp{id})./sqrt(length(latency_resp{id}));
        
        pkonset_mean{id}=summary_table(rec_idx,ipkonset_mean);
        std_spon{id}=(pkonset_mean{id}-summary_table(rec_idx,ipkonset_mean_3std))/3;
        pk_zscore{id}=pkonset_mean{id}./std_spon{id};
        
        mean_spon{id}=summary_table(rec_idx,ipkonset)-summary_table(rec_idx,ipkonset_mean);
        
        pk_zscore_valid{id}=pk_zscore{id}(~isnan(pk_zscore{id}));
        mean_pkzscore(id)=mean(pk_zscore_valid{id}(pk_zscore_valid{id}<inf));
        se_pkzscore(id)=std(pk_zscore_valid{id}(pk_zscore_valid{id}<inf))./sqrt(length(pk_zscore_valid{id}(pk_zscore_valid{id}<inf)));
        
        idx_resp2{id}=idx_resp(pk_zscore{id}(idx_resp)>3);
        idx_noresp2{id}=setdiff(1:length(pk_zscore{id}),idx_resp2{id});
        pk_zscore_resp{id}=pk_zscore{id}(idx_resp2{id});
        mean_pkzscore_resp(id)=mean(pk_zscore_resp{id}(pk_zscore_resp{id}<inf));
        se_pkzscore_resp(id)=std(pk_zscore_resp{id}(pk_zscore_resp{id}<inf))./sqrt(length(pk_zscore_resp{id}(pk_zscore_resp{id}<inf)));
        
        psth_zscore{id}=(psth_all(rec_idx,:)-mean_spon{id})./std_spon{id};
        resp_idx_3std{id}=find(pk_zscore{id}>3);
        resp_idx_3std_noinf{id}=find(pk_zscore{id}<inf & pk_zscore{id}>3);
        psth_zscore_mean_3std{id}=mean(psth_zscore{id}(resp_idx_3std_noinf{id},:));
        idx_resp2_noinf{id}=idx_resp(pk_zscore{id}(idx_resp)>3 & pk_zscore{id}(idx_resp)<inf);
        psth_zscore_mean_3std_lat{id}=mean(psth_zscore{id}(idx_resp2_noinf{id},:));
        psth_raw{id}=psth_all(rec_idx,:);
        psth_mean_3std{id}=mean(psth_raw{id}(resp_idx_3std{id},:));
    end
    %%
    mean_80db_lat=mean_latency(id_80db);
    median_80db_lat=median_latency(id_80db);
    jitter=2;
    
    figure,
    set(gcf,'position',[501         316        1079         662]);
    subplot(231)
    for id=1:length(db_list)
        plot(db_list(id)+(rand(1,length(idx_resp2{id}))-0.5)*jitter,pk_zscore{id}(idx_resp2{id}),'k.');
        plot(db_list(id)+(rand(1,length(idx_noresp2{id}))-0.5)*jitter,pk_zscore{id}(idx_noresp2{id}),'.','color',0.5*ones(1,3));
        hold on
    end
    plot([db_list(1)-10,db_list(end)+10],[3,3],'r--');
    l2=errorbar(db_list,mean_pkzscore_resp,se_pkzscore_resp,'k','linewidth',2);
    if plot_all_pk==1
        l1=errorbar(db_list,mean_pkzscore,se_pkzscore,'k--','linewidth',2);
        legend([l1,l2],{'All Units','Only Resp Units'});
    end
    box off;
    xlabel('db');
    ylabel('Peak (zscore)');
    set(gca,'xtick',db_list);
    xlim([db_list(1)-10,db_list(end)+10]);
    if isempty(sel_site)
        title(strrep(date,'_','-'));
    else
        title([strrep(date,'_','-'),'site',num2str(sel_site)]);
    end
    
    subplot(234)
    for id=1:length(db_list)
        plot(db_list(id)+(rand(1,length(latency_resp{id}))-0.5)*jitter,latency_resp{id}*1000,'k.');
        hold on
    end
    errorbar(db_list,mean_latency*1000,se_latency*1000,'k','linewidth',2);
    box off;
    xlabel('db');
    ylabel('Latency(ms)');
    title(['Mean Lat=',num2str(mean_80db_lat*1000,3),'ms (',num2str(db_sel),'db),median=',num2str(median_80db_lat*1000),'ms'])
    set(gca,'xtick',db_list);
    xlim([db_list(1)-10,db_list(end)+10]);
    %%
    % [~,sorted_idx]=sort(summary_table(:,ipkonset_mean_3std));
    [~,sorted_pkzscore_80db_idx]=sort(pk_zscore{id_80db});
    psth_80db_disp=psth_zscore_mean_3std{id_80db};
    [pk_zscore_80db_mean,ipk_zscore_80db_mean]=max(psth_80db_disp(psth_bin>0 & psth_bin<0.04));
    pk_lat_80db_mean=psth_bin(ipk_zscore_80db_mean+find(psth_bin>0,1)-1)+0.0005;
    
    ch_80db=ch_all{id_80db};
    clear pk_zscore_80db_ch mean_pk_zscore_80db_ch se_pk_zscore_80db_ch
    clear latency_80db_ch mean_latency_80db_ch se_latency_80db_ch
    for ch=1:16
        idx=find(ch_80db==ch);
        pk_zscore_80db_ch{ch}=pk_zscore{id_80db}(idx);
        mean_pk_zscore_80db_ch(ch)=mean( pk_zscore_80db_ch{ch}(pk_zscore_80db_ch{ch}<inf));
        se_pk_zscore_80db_ch(ch)=std( pk_zscore_80db_ch{ch}(pk_zscore_80db_ch{ch}<inf))/sqrt(length(find(pk_zscore_80db_ch{ch}<inf)));
        
        latency_80db_ch{ch}=latency{id_80db}(idx);
        mean_latency_80db_ch(ch)=mean( latency_80db_ch{ch}(latency_80db_ch{ch}<inf));
        se_latency_80db_ch(ch)=std( latency_80db_ch{ch}(latency_80db_ch{ch}<inf))/sqrt(length(find(latency_80db_ch{ch}<inf)));
    end
    
    ch_sort_80db=ch_sort_all{id_80db};
    % nsort=max(ch_sort_80db);
    if tetrode_sorting==1
        nsort=4;
    else
        nsort=16;
    end
    clear pk_zscore_80db_ch_sort mean_pk_zscore_80db_ch_sort se_pk_zscore_80db_ch_sort
    clear latency_80db_ch_sort mean_latency_80db_ch_sort se_latency_80db_ch_sort
    for ch=1:nsort
        idx=find(ch_sort_80db==ch);
        pk_zscore_80db_ch_sort{ch}=pk_zscore{id_80db}(idx);
        mean_pk_zscore_80db_ch_sort(ch)=mean( pk_zscore_80db_ch_sort{ch}(pk_zscore_80db_ch_sort{ch}<inf));
        se_pk_zscore_80db_ch_sort(ch)=std( pk_zscore_80db_ch_sort{ch}(pk_zscore_80db_ch_sort{ch}<inf))...
            /sqrt(length(find(pk_zscore_80db_ch_sort{ch}<inf)));
        
        latency_80db_ch_sort{ch}=latency{id_80db}(idx);
        mean_latency_80db_ch_sort(ch)=mean( latency_80db_ch_sort{ch}(latency_80db_ch_sort{ch}<inf));
        se_latency_80db_ch_sort(ch)=std( latency_80db_ch_sort{ch}(latency_80db_ch_sort{ch}<inf))...
            /sqrt(length(find(latency_80db_ch_sort{ch}<inf)));
    end
    
    subplot(232),
    imagesc(psth_bin,1:size(psth_zscore{id_80db},1),psth_zscore{id_80db}(sorted_pkzscore_80db_idx,:));
    % axis xy;
    title('mean PSTH');colormap(jet);colorbar;
    subplot(235),
    plot(psth_bin(2:end-2),psth_zscore_mean_3std{id_80db}(2:end-2),'k','linewidth',1);
    box off;
    title(['pk=',num2str(pk_zscore_80db_mean,2),',pk lat=',num2str(pk_lat_80db_mean*1000,3),'ms']);
    xlim([psth_bin(2),psth_bin(end-2)]);
    
    subplot(233),
    for ch=1:nsort
        plot(ch+(rand(1,length(pk_zscore_80db_ch_sort{ch}))-0.5)*jitter/10,pk_zscore_80db_ch_sort{ch},'k.');
        hold on
    end
    errorbar(1:nsort,mean_pk_zscore_80db_ch_sort,se_pk_zscore_80db_ch_sort,'k^','linestyle','none');
    box off;
    xlabel('CH');
    ylabel(['PK(zscore) ',num2str(db_sel),'db']);
    set(gca,'xtick',1:nsort);
    xlim([0,nsort+1]);
    
    subplot(236),
    for ch=1:nsort
        plot(ch+(rand(1,length(latency_80db_ch_sort{ch}))-0.5)*jitter/10,latency_80db_ch_sort{ch}*1000,'k.');
        hold on
    end
    errorbar(1:nsort,mean_latency_80db_ch_sort*1000,se_latency_80db_ch_sort*1000,'k^','linestyle','none');
    box off;
    xlabel('CH');
    ylabel(['Lat ',num2str(db_sel),'db (ms)']);
    set(gca,'xtick',1:nsort);
    xlim([0,nsort+1]);
    %%
    result_folder=fullfile(code_folder,'Results');
    if ~exist(result_folder,'dir')
        mkdir(result_folder);
    end
    saveas(1,fullfile(result_folder,['procesed_',date,post_name,'.fig']));
    print(1,'-djpeg',fullfile(result_folder,['procesed_',date,post_name,'.jpg']));
    if sel_dur==1
        savename=fullfile(result_folder,['procesed_',date,post_name,'_',num2str(sel_dur)]);
    else
        savename=fullfile(result_folder,['procesed_',date,post_name]);
    end
    save(savename,'db_list','latency','latency_resp','mean_latency','median_latency','se_latency',...
        'pkonset_mean','std_spon','pk_zscore','pk_zscore_valid','mean_pkzscore','se_pkzscore',...
        'idx_resp2','idx_noresp2','pk_zscore_resp','mean_pkzscore_resp','se_pkzscore_resp',...
        'mean_spon','psth_zscore','resp_idx_3std','psth_zscore_mean_3std','psth_zscore_mean_3std_lat',...
        'mean_80db_lat','median_80db_lat','sorted_pkzscore_80db_idx','psth_bin','pk_zscore_80db_mean','pk_lat_80db_mean',...
        'summary_table','prop_names_sel','psth_all','psth_10ms_all','psth_sm_all','resp_idx_3std_noinf','idx_resp2_noinf',...
        'psth_raw','psth_mean_3std','ch_all','pk_zscore_80db_ch','mean_pk_zscore_80db_ch','se_pk_zscore_80db_ch',...
        'latency_80db_ch','mean_latency_80db_ch','se_latency_80db_ch','ch_sort_all','pk_zscore_80db_ch_sort',...
        'mean_pk_zscore_80db_ch_sort','se_pk_zscore_80db_ch_sort','latency_80db_ch_sort','mean_latency_80db_ch_sort',...
        'se_latency_80db_ch_sort');
end