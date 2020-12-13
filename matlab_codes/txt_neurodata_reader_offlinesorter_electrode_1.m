%%pipline: txt_neurondata_reader_offlinesorter_electrode_1.m-->
%%psth_summary-->
clc;clear;close all;
if strcmp(computer,'MACI64')
    prepath='/Users/Emily/Google Drive/data/';
elseif  strcmp(computer,'PCWIN64')
    prepath='F:\data\';
    %     prepath='H:\';
    % prepath='H:\TH-cre LC recording\';
end
sep_tet=0;
% date='5_27_2018';
% date='7_20_2018';
% date='10_26_2018';
% date='10_25_2018';
% date='12_13_2018';
% date='12_19_2018';
% date='12_25_2018';
% date='12_26_2018';
% date='12_12_2018';
% date='1_4_2019';
% date='1_5_2019';
% date='1_9_2019';
% date='1_30_2019';
% date='2_6_2019';
% date='2_25_2019';
% date='3_1_2019';
% date='3_17_2019';
% date='3_20_2019';
% date='3_24_2019';
% date='3_25_2019';
% date='3_26_2019';
% date='4_4_2019';
% date='4_5_2019';
% date='4_20_2019';
% date='4_19_2019';
% date='3_8_2018';
% date='3_22_2019';
% ele_10cm=0;

% date='5_7_2019';%ele_10cm=1;
% date='5_16_2019';
% date='5_17_2019';
% date='5_20_2019';
% date='5_21_2019';
% date='6_24_2019';
% date='6_25_2019';
% date='7_2_2019';
% date='7_8_2019';
% date='7_29_2019';
% date='7_30_2019';
% date='8_9_2019';
% date='8_19_2019';
% date='8_20_2019';
% date='9_26_2019';
% date='9_28_2019';
% date='10_2_2019';
% date='10_10_2019';
% date='10_14_2019';
% date='10_16_2019';
% date='10_30_2019';
% date='11_5_2019';
% date='11_15_2019';
% date='11_19_2019';
% date='2_11_2020';
% date='10_11_2019';
% date='8_14_2020';
date='8_15_2020';
ele_10cm=1;
sep_tet=1;
demean=1;%0;

ch_num=16;
if sep_tet==1
    tet=4;%% which tet do you want to ana?
    pre_name=['_t',num2str(tet),'_com'];
    %     ch_num=4;
else
    pre_name='_com';
    %     ch_num=16;
end

fra_rep=8;
% fra_rep=7;
pre_fra=0;%0.1;
cut_shift=0.002;

tetrode_sorting=1;
% tetrode_sorting=0;
% wfexp_ext='.wfexp.txt';
wfexp_ext='.txt';
if strcmp(date,'10_5_2017')
    wf_length_sorter=46;
elseif strcmp(date,'10_10_2017')
    wf_length_sorter=32;
else
    wf_length_sorter=30;
end
% ch_num=16;
plot_fig=1;
save_mat=1;
% only_noise=1;
% only_fra=0;

if ele_10cm==1
    chmap=[13,14,15,16,11,12,9,10,7,8,5,6,3,4,1,2];
else
    chmap=1:16;
end

index=[229	124	127	30	175	65	274	232	198	28	43	26	177	179	192	230	34	32	4	233	39	199	123	89	128	221	125	131	237	223	231	35	46	23	215	31	25	44	130	180	220 304	316	289	310	301
    45	129	218	170	148	122	36	136	276	90	224	181	154	238	219	53	240	273	47	275	37	171	121	29	197	66	64	61	176	135	33	235	272	40	27	38	191	225	126	62	88 319	295	302	318	317
    234	193	60	80	50	116	200	214	132	41	72	22	63	24	228	236	216	59	13	49	112	81	226	91	257	169	174	277	155	270	48	241	239	71	147	14	3	42	173	178	222 290	322	308	299	306
    182	5	258	164	138	2	82	140	67	252	172	196	134	70	51	93	194	271	183	20	251	68	87	253	190	206	262	133	54	52	202	56	153	137	117	97	227	149	120	217	21 297	298	314	313	321
    195	55	269	92	160	189	168	96	57	205	7	256	152	146	242	278	100	107	201	260	249	213	15	75	73	165	255	210	115	79	184	113	19	8	69	111	12	248	58	158	156 305	291	307	315	303
    186	16	250	114	212	267	86	119	254	150	207	74	263	280	110	203	78	98	85	118	246	1	157	95	83	103	281	208	141	279	6	163	245	139	286	259	104	94	106	261	102 312	309	296	300	294
    166	18	9	11	142	76	108	265	247	284	162	209	282	185	144	244	211	188	167	287	266	285	268	283	105	159	10	145	143	101	264	151	243	77	109	161	17	99	84	204	187 311	292	320	293	288];

freq_list_fra=logspace(3.30103,4.50515,46);
db_list_fra=70:-10:10;%10:70;

[num,txt,raw]=xlsread(fullfile(prepath,'pcg_exp_record_ana.xlsx'),date);
idb=0;
ifreq=0;
for i=1:size(raw,2)
    if strcmp(raw(1,i),'fs')
        iFs=i;%1
    elseif strcmp(raw(1,i),'record')
        irec=i;%2
    elseif strcmp(raw(1,i),'penitration')
        ipen=i;%3
    elseif strcmp(raw(1,i),'site')
        isite=i;%4
    elseif strcmp(raw(1,i),'paradigm')
        ipara=i;%5
    elseif strcmp(raw(1,i),'scal_len')
        iscanlen=i;%6
    elseif strcmp(raw(1,i),'duration')
        idur=i;%7
    elseif strcmp(raw(1,i),'isi')
        iisi=i;%8
    elseif strcmp(raw(1,i),'trial')
        itrial=i;%9
    elseif strcmp(raw(1,i),'pre_trg')
        ipre_trg=i;%9
    elseif strcmp(raw(1,i),'db')
        idb=i;
    elseif strcmp(raw(1,i),'frequency')
        ifreq=i;
    end
end
[all_site,~,iall_site]=unique(num(:,isite));
clear idx_rec len_com_all trials_all stim_dur_list_all
clear session_title_list_all rec_list_all trial_dur_list_all
for si=1:length(all_site)
    idx_rec{si}=find(num(:,isite)==all_site(si));
    len_com_all(si)=length(idx_rec{si});
    trials_all{si}=[0,num(idx_rec{si},itrial)'];
    stim_dur_list_all{si}=num(idx_rec{si},idur);
    session_title_list_all{si}=raw(idx_rec{si}+1,ipara)';
    pre_trg_list_all{si}=num(idx_rec{si},ipre_trg);
    rec_list_all{si}=num(idx_rec{si},irec);
    pen_list_all{si}=num(idx_rec{si},ipen);
    trial_dur_list_all{si}=num(idx_rec{si},iscanlen)-cut_shift;%-0.002;
    if idb>0
        db_list_all{si}=num(idx_rec{si},idb);
    end
    if ifreq>0
        freq_list_all{si}=num(idx_rec{si},ifreq);
    end
end

Fs=30000;
tbin=0.001;% tbin=0.01;
count2rate=1/tbin;

winl=5;
w=hamming(2*winl+1);% 5ms

xpn=fullfile(prepath,date);
if tetrode_sorting==1
    ntrode=4;
    ch_per=4;
    % ch_tetrode=1:4;
    post_name='';
%     post_name='_tet';%_negthre';
    %       post_name='_ch1';
    %             post_name='_upthre';
    %     dest_folder=fullfile(xpn,'ch1upthre','fig');
    %     dest_matfolder=fullfile(xpn,'ch1upthre','mat');
    dest_folder=fullfile(xpn,'fig');
    dest_matfolder=fullfile(xpn,'mat');
else
    ntrode=1;
    ch_per= 16;
    % ch_tetrode=1;
    %     post_name='-ch16';
    post_name='_rethreshold';
    dest_folder=fullfile(xpn,'ch16','fig');
    dest_matfolder=fullfile(xpn,'ch16','mat');
end

if demean==1
    post_name='_demean';
    dest_folder=fullfile(xpn,'demean','fig');
    dest_matfolder=fullfile(xpn,'demean','mat');
end

waveform_from_raw=1;
if waveform_from_raw==1
    extract_s_before=15;
    extract_s_after=30;
    wf_length=extract_s_before+extract_s_after+1;
else
    wf_length=wf_length_sorter;
end

pre_format=3;
format_str1='%f,%f,%f';
format_str2=format_str1;
for i=1:wf_length_sorter*ntrode
    format_str2=[format_str2,',%d'];
end
binfolder='Bin';

evoke_dur=0.1;
% stim_dur=0.05;
nstim=size(index,1)*size(index,2);
% trial_num_fra=fra_rep*nstim;
win_start_dejitter=0;%0.003;
%%
for si=1%1:length(all_site)
    %     if readpara==1
    len_com= len_com_all(si);
    trials=trials_all{si};
    stim_dur_list=  stim_dur_list_all{si};
    session_title_list= session_title_list_all{si};
    pre_trg_list=pre_trg_list_all{si};
    rec_list=rec_list_all{si};
    pen_list=pen_list_all{si};
    trial_dur_list=trial_dur_list_all{si};
    trial_dur_list=reshape(trial_dur_list,1,length(trial_dur_list));
    if idb>0
        db_list=db_list_all{si};
    end
    if ifreq>0
        freq_list=freq_list_all{si};
    end
    %     end
    trial_dur_all=[0,trial_dur_list];
    trial_dur_session=cumsum(trial_dur_all.*trials);
    
    
    %     xfn=[date,'_',num2str(all_site(si)),'_',num2str(rec_list(1)),'_com',post_name,'.txt'];
    %     xfn=[date,'_',num2str(all_site(si)),'_com',post_name,'.txt'];
    %     xfn=[date,'_',num2str(all_site(si)),'_com',post_name,wfexp_ext];
    xfn=[date,'_',num2str(all_site(si)),pre_name,post_name,wfexp_ext];
    fn=fullfile(xpn,binfolder,xfn); % returns the full path to the selected file
    haswaveform=0;
    
    fid=fopen(fn,'r'); % returns the identifiler
    raw_sptime=fscanf(fid,format_str1,[pre_format,inf]);
    if size(raw_sptime,2)<2
        fid=fopen(fn,'r');
        raw_sptime=fscanf(fid,format_str2,[pre_format+wf_length_sorter*ntrode,inf]);
        if size(raw_sptime,2)<2
            disp(['read error:',fn]);
        end
        haswaveform=1;
        waveform_raw0=raw_sptime(pre_format+1:wf_length_sorter*ntrode+pre_format,:);
    end
    fclose(fid);
    
    if waveform_from_raw==1 && sep_tet==0
        rawdata_fn=strrep(fn,wfexp_ext,'.bin');
        rawdata_fn=strrep(rawdata_fn,post_name,'');
        fid=fopen(rawdata_fn,'r');
        raw_data=fread(fid,[ch_num,inf],'int16');
        fclose(fid);
    end
    
    timestamp_all=raw_sptime(2,:);
    unit_no=raw_sptime(1,:);
    ch_all=raw_sptime(3,:);
    
    %       timestamp_all=raw_sptime(3,:);
    %     unit_no=raw_sptime(2,:);
    %     ch_all=raw_sptime(1,:);
    
    for ch_unit=tet%1%1:ch_per
        for unit=1:max(unit_no)
            %             if unit~=1
            %                 continue;
            %             end
            savefolder=['site',num2str(all_site(si)),'_ch',num2str(ch_unit),'_n',num2str(unit)];%,'_new'];
            
            if sep_tet==1
                idx_unit=find( unit_no==unit & ch_all==1);
            else
                idx_unit=find(unit_no==unit & ch_all==ch_unit);
            end
%         idx_unit=find(  (unit_no<10) & ch_all==1);
            
            timestamp=timestamp_all(idx_unit);
            if ~isempty(timestamp)
                for figi=2:length(trials)
                    rec=rec_list(figi-1);
                    if 1%rec>25
                        pen=pen_list(figi-1);
                        savefile= ['site',num2str(all_site(si)),'pen',num2str(pen),'rec',num2str(rec),'_ch',num2str(ch_unit),'_n',num2str(unit)];%,'_new'];
                        savename=fullfile(dest_folder,savefolder,...
                            savefile);
                        %                        if exist([savename,'.jpg'],'file')
                        %                            continue;
                        %                        end
                        pre_trg=pre_trg_list(figi-1)-cut_shift/2;%-0.001;%0.199;%0.999;
                        session_title=session_title_list{figi-1};
                        if 1%~strcmp(session_title,'led')
                            %%
                            
                            if strcmp(session_title,'fra') %&& ~strcmp(session_title,'2_5_2018')
                                pre_trg=pre_trg+pre_fra;%0.1;
                            end
                            
                            trial_num=trials(figi);
                            
                            
                            %                 if only_noise==1
                            %                     if strcmp(session_title,'fra')
                            %                         continue;
                            %                     end
                            %                 elseif only_fra==1
                            %                     if ~strcmp(session_title,'fra')
                            %                         continue;
                            %                     end
                            %                     pre_trg=pre_trg+0.1;
                            %                 end
                            
                            stim_dur=stim_dur_list(figi-1);
                            trial_dur=trial_dur_all(figi);
                            
                            psth_bin=0:tbin:trial_dur;
                            timebin=psth_bin-pre_trg;
                            starti=find(psth_bin>pre_trg,1);
                            spon_bin=find(psth_bin<pre_trg);
                            
                            psth_bin10ms=0:0.01:trial_dur;
                            spon_bin10ms=find(psth_bin10ms<pre_trg-win_start_dejitter);
                            timebin10ms=psth_bin10ms-pre_trg;
                            
                            stim_range=find(psth_bin>pre_trg+win_start_dejitter & psth_bin<=pre_trg+stim_dur);
                            stim_range10ms=find(psth_bin10ms>pre_trg+win_start_dejitter & psth_bin10ms<=pre_trg+stim_dur);
                            onset_range=find(psth_bin>pre_trg+win_start_dejitter & psth_bin<=pre_trg+0.04);
                            onset_range10ms=find(psth_bin10ms>pre_trg+win_start_dejitter & psth_bin10ms<=pre_trg+0.04);
                            
                            trial_trg=trial_dur_session(figi-1):trial_dur:trial_dur_session(figi);
                            [nsp_trial,tmp]=histc(timestamp,trial_trg);
                            time_rel_trg=[];
                            sp_trial=[];
                            clear data_trial
                            clear psth_count_trial spon_count evoke_count evoke_count_stim
                            for i=1:trial_num
                                data_trial{i}=timestamp(tmp==i)-trial_trg(i);
                                %                     if ~isempty(data_trial{i})
                                time_rel_trg=[time_rel_trg,data_trial{i}];
                                sp_trial=[sp_trial,tmp(tmp==i)];
                                %                     end
                                %         psth_count_trial{i}=histc(data_trial{i},psth_bin);
                                %         spon_count(i)=length(find(data_trial{i}<pre_trg-win_start_dejitter));
                                spcount_trial_evoke100(i)=length(find(data_trial{i}>pre_trg & data_trial{i}<pre_trg+evoke_dur));
                                %         evoke_count_stim(i)=length(find(data_trial{i}>pre_trg+win_start_dejitter & data_trial{i}<pre_trg+stim_dur));
                                
                            end
                            sp_count=length(time_rel_trg);
                            if sp_count>1
                                %                     idx_unit_session=idx_unit(sp_trial>0);
                                psth=histc(time_rel_trg,psth_bin);
                                psth=psth/trial_num*count2rate;
                                psth_10ms=histc(time_rel_trg,psth_bin10ms);
                                psth_10ms=psth_10ms/trial_num*100;
                                clear psth_trial spcount_trial psth_sm_trial spon_trial
                                for i=1:trial_num
                                    psth_trial{i}=histc(data_trial{i},psth_bin);
                                    spcount_trial(i)=sum(psth_trial{i}(stim_range));
                                    spon_trial(i)=sum(psth_trial{i}(spon_bin));
                                    if isempty(psth_trial{i})
                                        psth_sm_trial(i,:)= NaN*ones(1,length(timebin));
                                    else
                                        tmp=conv( psth_trial{i},w);
                                        psth_sm_trial(i,:)= tmp(winl+1:end-winl);
                                    end
                                end
                                sptime_raster=time_rel_trg-pre_trg;
                                
                                mean_spon=mean(psth(spon_bin));
                                std_spon=std(psth(spon_bin));
                                mean_spon_10ms=mean(psth_10ms(spon_bin10ms));
                                std_spon_10ms=std(psth_10ms(spon_bin10ms));
                                
                                artifact_time=0.005;
                                stim_range_rem_arti=find(psth_bin>pre_trg+artifact_time & psth_bin<=pre_trg+stim_dur);
                                pkpsth=max(psth(stim_range));
                                %                             pkpsth=max(psth(stim_range_rem_arti));
                                pkpsth_10ms=max(psth_10ms(stim_range10ms));
                                %                         onset_range_rem_arti=find(psth_bin>pre_trg+artifact_time & psth_bin<=pre_trg+0.04);
                                pkpsth_onset=max(psth(onset_range));
                                %                           pkpsth_onset=max(psth(onset_range_rem_arti));
                                pkpsth_onset10ms=max(psth_10ms(onset_range10ms));
                                
                                psth_sm=conv(psth,w);
                                psth_sm=psth_sm(winl+1:end-winl);
                                %                         db=db_list(figi-1);
                                
                                tbin_plot=find(timebin>0 & timebin<0.05);
                                tbin_plot_rem_arti=find(timebin>artifact_time & timebin<0.05);
                                lat=timebin(tbin_plot(find(psth(tbin_plot)>mean_spon+3*std_spon & psth(tbin_plot)>max(psth(spon_bin)),1)));
                                %                             lat=timebin(tbin_plot_rem_arti(find(psth(tbin_plot_rem_arti)>mean_spon+3*std_spon,1)));
                                
                                if idb>0
                                    db=db_list(figi-1);
                                else
                                    db=0;
                                end
                                if ifreq>0
                                    freq=freq_list(figi-1);
                                else
                                    freq=0;
                                end
                                %                         if db~=30
                                %                             continue;
                                %                         end
                                %%
                                if strcmp(session_title,'fra')
                                    clear fra_evoke_count fra_spon_count fra_stim_count
                                    for fi=1:size(index,1)
                                        for fj=1:size(index,2)
                                            for fk=1:fra_rep
                                                fra_evoke_count(fi,fj,fk)=spcount_trial_evoke100(index(fi,fj)+nstim*(fk-1));
                                                fra_spon_count(fi,fj,fk)=spon_trial(index(fi,fj)+nstim*(fk-1));
                                                fra_stim_count(fi,fj,fk)=spcount_trial(index(fi,fj)+nstim*(fk-1));
                                            end
                                        end
                                    end
                                    fra_evoke_all_count=sum(fra_evoke_count,3);
                                    fra_spon_all_count=sum(fra_spon_count,3);
                                    fra_stim_all_count=sum(fra_stim_count,3);
                                    
                                    fra_evoke_spon=fra_evoke_all_count/evoke_dur/fra_rep-mean_spon;%fra_spon_all_count/pre_trg/fra_rep;
                                    fra_stim_spon=fra_stim_all_count/stim_dur/fra_rep-mean_spon;%fra_spon_all_count/pre_trg/fra_rep;
                                    
                                    fra_evoke_zscore=(fra_evoke_all_count/evoke_dur/fra_rep-mean_spon)./std_spon;%fra_spon_all_count/pre_trg/fra_rep;
                                    fra_stim_zscore=(fra_stim_all_count/stim_dur/fra_rep-mean_spon)./std_spon;%fra_spon_all_count/pre_trg/fra_rep;
                                    clear fra_evoke_spon_sm fra_stim_spon_sm  fra_evoke_zscore_sm fra_stim_zscore_sm
                                    for i=1:size(fra_stim_spon,1)
                                        fra_stim_spon_sm(i,:)=smooth(fra_stim_spon(i,:),5);
                                        fra_evoke_spon_sm(i,:)=smooth(fra_evoke_spon(i,:),5);
                                        fra_evoke_zscore_sm(i,:)=smooth(fra_evoke_zscore(i,:),5);
                                        fra_stim_zscore_sm(i,:)=smooth(fra_stim_zscore(i,:),5);
                                    end
                                end
                                %%
                                if plot_fig==1
                                    %%
                                    close all;
                                    figure(1),
                                    
                                    if strcmp(session_title,'fra')
                                        set(gcf,'position',[35,100, 880   857]);
                                        axes('position',[0.05   0.83    0.6174    0.14]);
                                    else
                                        set(gcf,'position',[35,280,703,420]);
                                        axes('position',[0.1000   0.65    0.6174    0.22]);
                                    end
                                    %                             sel=find(~ismember(sp_trial,[4,35,40,41,47,50]));
                                    %                             [~,~,ic]=unique(sp_trial(sel));
                                    plot(sptime_raster,sp_trial,'k.');
                                    %                               plot(sptime_raster(sel),ic,'k.');
                                    %                 imagesc(timebin,1:trial_num,psth_sm_trial);colormap(jet);
                                    box off;
                                    session_title_add=session_title;
                                    if  db>0
                                        session_title_add=[num2str(db),'db ',session_title_add];
                                    end
                                    if freq>0
                                        session_title_add=[num2str(freq),'Hz ',session_title_add];
                                    end
                                    title([session_title_add,' Ch',num2str(ch_unit),' Unit',num2str(unit),',n=',num2str(sp_count)]);
                                    hold on,
                                    plot([0,0],[0,trial_num]);
                                    plot([0,stim_dur],[-1,-1],'k','linewidth',2);
                                    axis([-pre_trg+0.001,timebin(end-1),-2,trial_num]);
                                    %%
                                    if strcmp(session_title,'fra')
                                        axes('position',[0.05    0.65   0.6174    0.14]);
                                    else
                                        axes('position',[0.1000    0.3838   0.6174    0.22]);
                                    end
                                    plot(timebin,psth,'k');
                                    %                         plot(timebin10ms,psth_10ms,'k');
                                    title('PSTH');hold on
                                    box off;
                                    plot([0,0],[0,max(psth(2:end-1))]);
                                    %                         plot([0,0],[0,max(psth_10ms)]);
                                    ylabel('Rate(sp/s)');
                                    plot([0,stim_dur],[-1,-1],'k','linewidth',2);
                                    plot([-pre_trg,max(timebin)],mean_spon*ones(1,2),'r');
                                    %                         plot([-pre_trg,max(timebin10ms)],mean_spon_10ms*ones(1,2),'r');
                                    %                         axis([-pre_trg,max(timebin10ms),-2,inf]);
                                    axis([-pre_trg+0.001,timebin(end-1),-2,max(psth(2:end-1))]);
                                    %%
                                    if strcmp(session_title,'fra')
                                        axes('position',[0.05   0.46    0.6174     0.14]);
                                    else
                                        axes('position',[0.1000   0.1100    0.6174    0.22]);
                                    end
                                    bar(timebin,psth,'k');
                                    %                         plot(timebin10ms,psth_10ms,'k');
                                    title(['pk-mean=',num2str(pkpsth-mean_spon,2),' lat=',num2str(lat*1000)]);hold on
                                    box off;
                                    plot([0,0],[0,max(psth(tbin_plot))]);
                                    %                         plot([0,0],[0,max(psth_10ms)]);
                                    ylabel('Rate(sp/s)');
                                    plot([0,stim_dur],[-1,-1],'k','linewidth',2);
                                    plot([-pre_trg,max(timebin)],mean_spon*ones(1,2),'r');
                                    %                         plot([-pre_trg,max(timebin10ms)],mean_spon_10ms*ones(1,2),'r');
                                    %                         axis([-pre_trg,max(timebin10ms),-2,inf]);
                                    axis([-0.05,0.05,-2,max(psth(tbin_plot))]);
                                    
                                    if strcmp(session_title,'fra')
                                        axes('position',[0.05  0.24    0.2    0.15]);
                                        %                                 imagesc(freq_list_fra,db_list_fra,fra_evoke_spon);axis xy;
                                        imagesc(freq_list_fra,db_list_fra,fra_stim_all_count);axis xy;
                                        colorbar;
                                        title('Ori(50ms)');colormap(jet);
                                        axes('position',[0.28   0.24   0.2   0.15]);
                                        imagesc(freq_list_fra,db_list_fra,fra_stim_spon);axis xy;
                                        colorbar;
                                        title('Rate(50ms)');
                                        axes('position',[ 0.52  0.24    0.2    0.15]);
                                        imagesc(freq_list_fra,db_list_fra,fra_evoke_zscore);axis xy;
                                        colorbar;
                                        title('zscore(100ms)');colormap(jet);
                                        axes('position',[  0.75  0.24  0.2   0.15]);
                                        imagesc(freq_list_fra,db_list_fra,fra_stim_zscore);axis xy;
                                        colorbar;
                                        title('zscore(50ms)');
                                        
                                        axes('position',[0.05  0.04    0.2    0.15]);
                                        imagesc(freq_list_fra,db_list_fra,fra_evoke_spon_sm);axis xy;
                                        colorbar;
                                        title('Rate sm(100ms)');
                                        axes('position',[0.28   0.04   0.2   0.15]);
                                        imagesc(freq_list_fra,db_list_fra,fra_stim_spon_sm);axis xy;
                                        colorbar;
                                        title('Rate sm(50ms)');
                                        axes('position',[ 0.52    0.04  0.2    0.15]);
                                        imagesc(freq_list_fra,db_list_fra,fra_evoke_zscore);axis xy;
                                        colorbar;
                                        title('zscore sm(100ms)');colormap(jet);
                                        axes('position',[  0.75   0.04  0.2   0.15]);
                                        imagesc(freq_list_fra,db_list_fra,fra_stim_zscore);axis xy;
                                        colorbar;
                                        title('zscore sm(50ms)');
                                    end
                                end
                                
                                clear ach min_waveform max_waveform mean_waveform
                                clear max_mean_waveform pk_mean_waveform min_mean_waveform trough_mean_waveform
                                clear max2_mean_waveform pk2_mean_waveform std_waveform
                                if waveform_from_raw==1
                                    ch_plot=16;
                                    timestamp_all_num=round(timestamp*Fs);
                                    waveform_raw=[];
                                    
                                    for ch=1:ch_num%chmap%1:ch_plot
                                        if sep_tet==1
                                            if rem(ch,4)==1
                                                rawdata_fn=fullfile(xpn,binfolder,[date,'_',num2str(all_site(si)),'_t',num2str(int8(ch/4)+1),'_com',post_name,'.bin']);
                                                fid=fopen(rawdata_fn,'r');
                                                raw_data=fread(fid,[4,inf],'int16');
                                                fclose(fid);
                                            end
                                        end
                                        for spk=1:length(sp_trial)
                                            if max([1,timestamp_all_num(spk)-extract_s_before])+wf_length-1<=size(raw_data,2)
                                                if rem(ch,4)==0
                                                    ch_sel=4;
                                                else
                                                    ch_sel= rem(ch,4);
                                                end
                                                waveform_raw{ch}(:,spk)=raw_data(ch_sel,...
                                                    max([1,timestamp_all_num(spk)-extract_s_before])...
                                                    :max([1,timestamp_all_num(spk)-extract_s_before])+wf_length-1);
                                            end
                                        end
                                        if plot_fig==1
                                            if ch_plot==16
                                                if  strcmp(session_title,'fra')
                                                    ach(ch)=axes('position',[0.7+rem(ch-1,2)*0.15 0.43+0.065*floor((ch-1)/2)+rem(ch-1,2)*0.03  0.1019    0.061]);
                                                else
                                                    ach(ch)=axes('position',[0.76+rem(ch-1,2)*0.102 0.05+0.11*floor((ch-1)/2)+rem(ch-1,2)*0.05  0.1019    0.09]);
                                                    
                                                end
                                            elseif ch_plot==8
                                                ach(ch)=axes('position',[0.76+rem(ch,2)*0.102 0.05+0.22*floor((ch-1)/2)  0.1019    0.18]);
                                            elseif ch_plot==11
                                                ach(ch)=axes('position',[0.76+rem(ch,2)*0.102 0.05+0.16*floor((ch-1)/2)+rem(ch-1,2)*0.0727  0.1019    0.1309]);
                                            elseif ch_plot==1
                                                ach(ch)=axes('position',[0.7700    0.5838    0.2038    0.3412]);
                                            elseif ch_plot==4
                                                ach(ch)=axes('position',[0.76+rem((ch_unit-1)*4+ch-1,2)*0.102 0.05+0.11*floor(((ch_unit-1)*4+ch-1)/2)+rem((ch_unit-1)*4+ch-1,2)*0.05  0.1019    0.09]);
                                                
                                            end
                                        end
                                    end
                                else
                                    ch_plot=4;
                                    if plot_fig==1
                                        for ch=1:ch_plot
                                            if  strcmp(session_title,'fra')
                                                ach(ch)=axes('position',[0.7+rem((ch_unit-1)*4+ch-1,2)*0.102 0.05+0.11*floor(((ch_unit-1)*4+ch-1)/2)+rem((ch_unit-1)*4+ch-1,2)*0.05+0.1805  0.1019    0.0738]);
                                                
                                            else
                                                ach(ch)=axes('position',[0.76+rem((ch_unit-1)*4+ch-1,2)*0.102 0.05+0.11*floor(((ch_unit-1)*4+ch-1)/2)+rem((ch_unit-1)*4+ch-1,2)*0.05  0.1019    0.09]);
                                            end
                                        end
                                    end
                                end
                                
                                if ~isempty(waveform_raw)
                                    for ch=1:ch_plot%chmap%1:ch_plot
                                        min_waveform(ch)=min(min(waveform_raw{ch}));
                                        max_waveform(ch)=max(max(waveform_raw{ch}));
                                        %  maxabs_waveform(ch)=max([abs(min_waveform(ch)),abs(max_waveform(ch))]);
                                        mean_waveform(ch,:)=mean(waveform_raw{ch}');
                                        [min_mean_waveform(ch),trough_mean_waveform(ch)]=min(mean_waveform(ch,:));
                                        [max_mean_waveform(ch),pk_mean_waveform(ch)]=max(mean_waveform(ch,:));
                                        [max2_mean_waveform(ch),pk2_mean_waveform(ch)]=max(mean_waveform(ch,trough_mean_waveform(ch):end));
                                        std_waveform(ch)=std(waveform_raw{ch}(max([1,trough_mean_waveform(ch)-9]),:),0,2);
                                    end
                                    pk2_mean_waveform=pk2_mean_waveform+trough_mean_waveform-1;
                                    pp_mean_waveform=max_mean_waveform-min_mean_waveform;
                                    snr_waveform=pp_mean_waveform./std_waveform;
                                    wf_asym=(max2_mean_waveform-abs(min_mean_waveform))./(max2_mean_waveform+abs(min_mean_waveform));
                                    wf_c=(pk2_mean_waveform-trough_mean_waveform)/30;
                                    [max_snr_waveform,ch_maxsnr]=max(snr_waveform);
                                    [~,unit_ch]=max(pp_mean_waveform);
                                    lowbd=min(min_mean_waveform-4*std_waveform);
                                    highbd=max(max_mean_waveform+4*std_waveform);
                                    if plot_fig==1
                                        for ch=1:ch_num%ch_plot%chmap%1:ch_plot
                                            axes(ach(ch));hold on
                                            if ch_num>1
                                                patch([1:wf_length,wf_length:-1:1],[mean_waveform(ch,:)+3*std_waveform(ch),mean_waveform(ch,end:-1:1)-3*std_waveform(ch)],0.9*ones(1,3),'edgecolor','none');
                                            else
                                                plot(mean_waveform(ch,:)+3*std_waveform(ch),'color',0.5*ones(1,3));
                                                plot(mean_waveform(ch,:)-3*std_waveform(ch),'color',0.5*ones(1,3));
                                            end
                                            axis([1,wf_length,lowbd,highbd]);
                                            axis off
                                            if ch==unit_ch
                                                t=title(['snr=',num2str(max_snr_waveform,2)]);
                                                set(t,'fontsize',10,'fontname','Times');
                                            end
                                            if max_snr_waveform>=4
                                                plot(mean_waveform(ch,:),'r','linewidth',2);
                                            else
                                                plot(mean_waveform(ch,:),'g','linewidth',2);
                                            end
                                        end
                                        if ~exist(dest_folder,'dir')
                                            mkdir(dest_folder);
                                        end
                                    end
                                    %%
                                    if ~exist(dest_matfolder,'dir')
                                        mkdir(dest_matfolder);
                                    end
                                    
                                    if plot_fig==1
                                        if ~exist(fullfile(dest_folder,savefolder),'dir')
                                            mkdir(fullfile(dest_folder,savefolder));
                                        end
                                        print(1,'-djpeg',[savename,'.jpg']);
                                    end
                                    
                                    if save_mat==1
                                        if strcmp(session_title,'fra')
                                            save(fullfile(dest_matfolder,savefile),...
                                                'ch_unit','data_trial','sptime_raster','session_title',...
                                                'sp_count','sp_trial','psth_trial','spcount_trial','spon_trial','psth','psth_sm',...
                                                'mean_spon','pkpsth','std_spon','unit_ch','unit','waveform_raw','std_waveform',...
                                                'mean_waveform','lowbd','highbd','snr_waveform','max_snr_waveform',...
                                                'ch_maxsnr','wf_asym','wf_c','pp_mean_waveform','max2_mean_waveform',...
                                                'min_mean_waveform','trough_mean_waveform','pk2_mean_waveform',...
                                                'psth_sm_trial','psth_10ms','mean_spon_10ms','std_spon_10ms','pkpsth_10ms',...
                                                'db','freq','lat','pkpsth_onset','pkpsth_onset10ms','spcount_trial_evoke100',...
                                                'fra_evoke_count','fra_spon_count','fra_stim_count',...
                                                'fra_evoke_all_count','fra_spon_all_count','fra_stim_all_count',...
                                                'fra_evoke_spon','fra_stim_spon','fra_evoke_zscore','fra_stim_zscore','psth_bin');
                                        else
                                            save(fullfile(dest_matfolder,savefile),...
                                                'ch_unit','data_trial','sptime_raster','session_title',...
                                                'sp_count','sp_trial','psth_trial','spcount_trial','spon_trial','psth','psth_sm',...
                                                'mean_spon','pkpsth','std_spon','unit_ch','unit','waveform_raw','std_waveform',...
                                                'mean_waveform','lowbd','highbd','snr_waveform','max_snr_waveform',...
                                                'ch_maxsnr','wf_asym','wf_c','pp_mean_waveform','max2_mean_waveform',...
                                                'min_mean_waveform','trough_mean_waveform','pk2_mean_waveform',...
                                                'psth_sm_trial','psth_10ms','mean_spon_10ms','std_spon_10ms','pkpsth_10ms',...
                                                'db','freq','lat','pkpsth_onset','pkpsth_onset10ms','spcount_trial_evoke100','psth_bin');
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end