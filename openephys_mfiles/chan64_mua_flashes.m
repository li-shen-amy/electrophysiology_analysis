% flashes
[data, timestamps, info] = load_open_ephys_data('all_channels.events');
d = diff(timestamps);
plot(d);
% process timestamps
trig_onset = timestamps(1:2:end);
t_rec = input('recording time (in ms) = ');
trig_offset = trig_onset + t_rec/1000;
num_trial = length(trig_onset);

idx = [10,53,13,55,15,52,9,50,17,56,11,48,19,54,16,46,21,49,18,44,23,47,20,42,7,45,22,58,5,43,24,60,4,41,8,61,31,57,6,34,27,59,3,38,2,62,1,63,30,64,29,35,25,36,12,40,14,51,28,37,26,39,32,33];
[data, timestamps, info] = load_open_ephys_data('100_CH1.continuous');
dat1 = zeros(64, length(data));

traces = cell(64,1);
p20 = cell(64,1);
sample_rate = 30; %kHz
bin_size = 20; %ms

num_sample_rec = sample_rate*t_rec;
num_sample_bin = sample_rate*bin_size;

for i = 1:64
    fn = ['100_CH', num2str(idx(i)), '.continuous'];
    [data, timestamps, info] = load_open_ephys_data(fn);
    fdata = ffilter(data);
    dat1(i,:) = fdata';
end

% maxdata = max(abs(dat1(:)));
% factor = 32767/maxdata;
% dat2 = int16(dat1*factor); % 16 bit
% 
% fid = fopen('2018-03-28_18-43-18-300-6000.bin','w','l');
% fwrite(fid, dat2, 'int16','l');
% fclose(fid);

for i = 1:64
    fdata = dat1(i,:);
    spike = get_spikes(fdata);
    traces{i}= zeros(num_trial, num_sample_rec);
    for j = 1:num_trial
        t = spike(timestamps>=trig_onset(j)&timestamps<trig_offset(j));
        traces{i}(j,:)=t(1:num_sample_rec);
    end
    p = reshape(sum(traces{i},1),num_sample_bin,[]);
    p20{i} = sum(p,1); 
end 

exportToPPTX('new');
for i = 1:8
    figure(i)
    for j = 1:8
    subplot(2,4,j)
    trace = traces{j+(i-1)*8};
    trace(trace==0) = NaN;
    for k = 1:num_trial
            plot(linspace(0,t_rec,num_sample_rec), k* trace(k,:),'b.','markersize',4);
            hold on
    end
    plot(linspace(0,t_rec,length(p20{j+(i-1)*8})), p20{j+(i-1)*8}/max(p20{j+(i-1)*8})*(num_trial+1), 'r', 'linewidth',2);
    hold off 
    xlim([0, t_rec])
    ylim([0,num_trial+1])
    end
    set(gcf, 'Position', get(0, 'Screensize'));
    exportToPPTX('addslide');
    exportToPPTX('addpicture',gcf,'Scale','maxfixed');
end
exportToPPTX('save','psths.pptx');
exportToPPTX('close');
    