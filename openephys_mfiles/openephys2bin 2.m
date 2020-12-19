% open ephys to bin

clear

[data, timestamps, info] = load_open_ephys_data('100_CH1.continuous');
n_per_trial = get_sample_number_per_trial(timestamps);
step = get_step(n_per_trial);
num_trial = length(n_per_trial) - 1;
num_sample = step - 2*5*30;
dat1 = zeros(64, num_trial*num_sample);

idx = [10,53,13,55,15,52,9,50,17,56,11,48,19,54,16,46,21,49,18,44,23,47,20,42,7,45,22,58,5,43,24,60,4,41,8,61,31,57,6,34,27,59,3,38,2,62,1,63,30,64,29,35,25,36,12,40,14,51,28,37,26,39,32,33];
big20 = zeros(20,64);
psth10 = zeros(64, round(step/1024));
n_spike = zeros(64,1);

for i = 1:64
    fn = ['100_CH', num2str(idx(i)), '.continuous'];
    [data, timestamps, info] = load_open_ephys_data(fn);
    
    fdata = ffilter(data);
    n_per_trial = get_sample_number_per_trial(timestamps);
    step = get_step(n_per_trial);
    
    traces = get_traces(fdata, n_per_trial, step);
    truncted_traces = traces(:, 5*30:step-5*30-1); % discard first and last 5ms
    truncted_traces_t = truncted_traces';
    dat1(i,:) = truncted_traces_t(:);
    
    spikes = get_spikes(traces');
    traces_spike_number = sum(spikes(150:end-150,:), 1);
    
    psth1 = sum(spikes, 2);
    psth10(i, :) = sum(reshape(psth1,1024,[]),1);
    psth10(i,1) = psth10(i,2);
    n_spike(i) = sum(psth10(i,2:end-1), 2);
    
    [val, ind] = sort(traces_spike_number, 'descend');
    big20(:,i) = ind(1:20);
    
%     figure(1)
%     subplot(1,2,1)
%     bar(psth10(i, 2:end-1), 'k');
%     
%     subplot(1,2,2);
%     spikes(spikes == 0) = NaN;
%     
%     for j = 1:length(n_per_trial)-1
%         plot(linspace(0,2.5,step), j*spikes(:,j),'b.');
%         hold on
%     end
%     hold off
% 
%     pause;
end

tbl = tabulate(big20(:));
tbl2 = sortrows(tbl,-2);
trials_to_delete = [];

% data_bin_to_delete = zeros(1, num_sample*length(trials_to_delete));
% for i = 1:length(trials_to_delete)
%     dbtd = (1:num_sample)+(trials_to_delete(i)-1)*num_sample;
%     data_bin_to_delete((1:num_sample)+(i-1)*num_sample) = dbtd;
% end
% dat1(:, data_bin_to_delete) = [];

maxdata = max(abs(dat1(:)));
factor = 32767/maxdata;
dat2 = int16(dat1*factor); % 16 bit

fid = fopen('2018-03-14_23-40-54.bin','w','l'); % little endian
fwrite(fid, dat2, 'int16','l');
fclose(fid);

% mean_trace = mean(dat1, 1);
% dat3 = dat1 - repmat(mean_trace, 64,1);
% maxdata = max(abs(dat3(:)));
% 
% factor = 32767/maxdata;
% dat4 = int16(dat3 * factor); % 16 bit
% 
% fid = fopen('2018-03-14_23-07-42_remove-motion.bin','w','l'); % little endian
% fwrite(fid, dat4, 'int16','l');
% fclose(fid);
% 
% maxdata = max(abs(dat1_wv(:)));
% factor = 32767/maxdata;
% dat2_wv = int16(dat1_wv * factor); % 16 bit
% 
% fid = fopen('2018-03-14_23-07-42_wavelet.bin','w','l'); % little endian
% fwrite(fid, dat2_wv, 'int16','l');
% fclose(fid);
% 
% mean_trace_wv = mean(dat1_wv,1);
% dat3_wv = dat1_wv - repmat(mean_trace_wv, 64, 1);
% 
% maxdata = max(abs(dat3_wv(:)));
% factor = 32767/maxdata;
% dat4_wv = int16(dat3_wv * factor); % 16 bit
% 
% fid = fopen('2018-03-14_23-07-42_wavelet_remove_motion.bin','w','l'); % little endian
% fwrite(fid, dat4_wv, 'int16','l');
% fclose(fid);