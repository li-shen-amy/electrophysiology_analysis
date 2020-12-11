% open ephys to bin
clear
clc
close all;

% addpath('C:\Users\Li''s Lab\Documents\MATLAB\openephys');
addpath('D:\extracellular\openephys');

cont_rec=1;% for continuing recording
idx = [10,53,13,55,15,52,9,50,17,56,11,48,19,54,16,46,21,49,18,44,23,47,20,42,7,45,22,58,5,43,24,60,4,41,8,61,31,57,6,34,27,59,3,38,2,62,1,63,30,64,29,35,25,36,12,40,14,51,28,37,26,39,32,33];

% folder='C:\xcy\4_23_2019';
% date_str='4_23_2019';
% folder='G:\openephys_data\4_23_2019_mm_beforecond';

date_str='4_25_2019';
folder='G:\openephys_data\4_25_2019_mm_aftercond';

flist=dir(folder);

comb_rec=1;%0;
%% triggers
trigger_count=0;
trigger_onset=[];
clear trial_num_list trigger_name
lendata_accum=0;
for fi=1:length(flist)
    if flist(fi).isdir && ~strcmp(flist(fi).name,'.') && ~strcmp(flist(fi).name,'..')
        trigger_file=fullfile(folder,flist(fi).name,'100_ADC1.continuous');
        if exist(trigger_file,'file')
            [data_triggers, timestamps_triggers, info_triggers] = load_open_ephys_data(fullfile(folder,flist(fi).name,'100_ADC1.continuous'));
            ttl=find(data_triggers>2);
            this_trigger=[ttl(1);ttl(find(diff(ttl)>1)+1)];
                trigger_onset=[trigger_onset;lendata_accum+this_trigger];
                trigger_count=trigger_count+1;
            trigger_name{trigger_count}=flist(fi).name;%'pen1_1_2019-04-23_15-15-05_noise 70';
             trial_num_list(trigger_count)=length(this_trigger);
             lendata_accum=lendata_accum+length(data_triggers);
        else
            trigger_file=fullfile(folder,flist(fi).name,'100_ADC1_2.continuous');
            if exist(trigger_file,'file')
                [data_triggers, timestamps_triggers, info_triggers] = load_open_ephys_data(fullfile(folder,flist(fi).name,'100_ADC1.continuous'));
                ttl=find(data_triggers>2);
                 this_trigger=[ttl(1);ttl(find(diff(ttl)>1)+1)];
                trigger_onset=[trigger_onset;lendata_accum+this_trigger];
                trigger_count=trigger_count+1;
                trigger_name{trigger_count}=flist(fi).name;%'pen1_1_2019-04-23_15-15-05_noise 70';
                trial_num_list(trigger_count)=length(this_trigger);
                 lendata_accum=lendata_accum+length(data_triggers);
            else
                disp(['trigger file non-exist:',trigger_file]);
            end
        end
    end
end
%%
clear factor
% count=0;
maxdata=[];
for ich=1:16
    ch_group=(ich-1)*4+1:ich*4;
    rec_count=0;
    clear pre_name lendata
    dat1=[];
    for fi=1:length(flist)
        if flist(fi).isdir && ~strcmp(flist(fi).name,'.') && ~strcmp(flist(fi).name,'..')
            
            tmp=[];
            if comb_rec==0
                dat1=[];
            end
            for i = 1:4
                ch=ch_group(i);
                fn = fullfile(folder,flist(fi).name,['100_CH', num2str(idx(ch)), '.continuous']);
                if exist(fn,'file')
                    [data, timestamps, info] = load_open_ephys_data(fn);
                    if i==1
                        rec_count=rec_count+1;
%                         pre_name{rec_count}=flist(fi).name;%'pen1_1_2019-04-23_15-15-05_noise 70';
                        lendata(rec_count)=length(data);
                    end                  
                else
                    fn = fullfile(folder,flist(fi).name,['100_CH', num2str(idx(ch)), '_2.continuous']);
                    if exist(fn,'file')
                        [data, timestamps, info] = load_open_ephys_data(fn);
                        if i==1
                            rec_count=rec_count+1;
%                             pre_name{rec_count}=flist(fi).name;%'pen1_1_2019-04-23_15-15-05_noise 70';
                        lendata(rec_count)=length(data);
                        end
                    else
                        disp(['non-exist:',fn]);
                        continue;
                    end
                end           
                tmp(i,:)=data';               
            end
            dat1=[dat1,tmp];            
        end
    end
    %% filter
    for i = 1:4%64
        dat1(i,:)=ffilter2(dat1(i,:));
    end
    %% rescale and write file
    maxdata(ich) = max(abs(dat1(:)));
    
    sat_mv=200;%250;%200;%500;
    maxdata_sat=  maxdata(ich)
    if maxdata_sat>sat_mv
        maxdata_sat=sat_mv;
    end
    factor(ich) = 32767/maxdata_sat;
    %     if factor(ich)<164
    %         dat1 = int16(dat1*164);
    %     else
    %         dat1 = int16(dat1*factor(ich)); % 16 bit
    %     end
    dat1 = int16(dat1*factor(ich)); % 16 bit
    % fid = fopen(fullfile(folder,'4_23_2019.bin'),'w','l'); % little endian
    
    %% writing .bin file
    if comb_rec==0
        fid = fopen(fullfile(folder,[pre_name{rec_count},'.bin']),'w');%,'l'); % little endian
    else
        fid = fopen(fullfile(folder,[date_str,'-',num2str(ich),'.bin']),'w');%,'l'); % little endian
    end
    fwrite(fid, dat1, 'int16');%,'l');
    fclose(fid);
end
%     end
% end
%% save record session list
% fid = fopen(fullfile(folder,'4_23_2019_readme.txt'),'w','l'); % little endian
% for fi=1:length(pre_name)
%     fprintf(fid,'%s\n',pre_name{fi},factor);
% end
% for fi=1:16
%  fprintf(fid,'factor=%.4f\n',factor(ich));
% end
% fclose(fid);
%%
Fs=30000;
trigger_onset=trigger_onset/Fs;
save(fullfile(folder,['openephys_info_',date_str]),'factor','maxdata','trigger_onset','trigger_name','trial_num_list','lendata');