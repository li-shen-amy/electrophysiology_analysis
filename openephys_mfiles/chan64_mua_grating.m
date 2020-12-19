% cont rec
[data, timestamps, info] = load_open_ephys_data('all_channels.events');
d = diff(timestamps);
plot(d);
id = find(d<0.01);
timestamps(id+1)=[];
% process timestamps
% trig_onset = timestamps(1:2:644)-86528/30000;
trig_onset = timestamps(1:2:end-2)-50432/30000;
t_rec = input('recording time (in ms) = ');
trig_offset = trig_onset + t_rec/1000;
num_trial = length(trig_onset);

idx = [10,53,13,55,15,52,9,50,17,56,11,48,19,54,16,46,21,49,18,44,23,47,20,42,7,45,22,58,5,43,24,60,4,41,8,61,31,57,6,34,27,59,3,38,2,62,1,63,30,64,29,35,25,36,12,40,14,51,28,37,26,39,32,33];
[data, timestamps, info] = load_open_ephys_data('100_CH1.continuous');


traces = cell(64,1);
p20 = cell(64,1);
zs = cell(64,1);
sample_rate = 30; %kHz
bin_size = 20; %ms
num_bin = round(t_rec/bin_size);


num_sample_rec = sample_rate*t_rec;
num_sample_bin = sample_rate*bin_size;

ind = zeros(num_trial*num_sample_rec,1);
for i = 1:num_trial
    ind((1:num_sample_rec)+(i-1)*num_sample_rec) = round(trig_onset(i)*1000*sample_rate):round(trig_offset(i)*1000*sample_rate)-1;
end

dat1 = zeros(64, num_trial*num_sample_rec);

global th
vmax = -1;
for i = 1:64
    fn = ['100_CH', num2str(idx(i)), '.continuous'];
    [data, timestamps, info] = load_open_ephys_data(fn);
    fdata = ffilter(data(ind));
    dat1(i,:) = fdata';    
    vmax = max(vmax, max(abs(fdata)));
    th(i) = -3*std(fdata);
end

for i = 1:64
    fdata = dat1(i,:);
    spike = get_spikes(fdata, i);
    traces{i}= zeros(num_trial, num_sample_rec);
    for j = 1:num_trial
        traces{i}(j,:) = spike((1:num_sample_rec)+(j-1)*num_sample_rec);
    end
    p = reshape(sum(traces{i},1),num_sample_bin,[]);
    p20{i} = sum(p,1);
    p20{i}(1) = p20{i}(2);
    bl = mean(p20{i}(1:10));
    sd = std(p20{i}(1:10));
    zs{i} = (p20{i}-bl)/sd;
end

exportToPPTX('new');
for i = 1:64
    figure(1)
    trace = traces{i};
    trace(trace==0) = NaN;
    yyaxis left
    for k = 1:num_trial
        plot(linspace(0,t_rec,num_sample_rec), k* trace(k,:),'b.','markersize',3);
        hold on
    end
    hold off
    xlim([0, t_rec])
    ylim([0,num_trial+1])    
    yyaxis right
    % stairs(linspace(0,t_rec,length(p20{i})), p20{i}/max(p20{i})*(num_trial+1), 'r', 'linewidth',2);
    stairs(linspace(0,t_rec,length(p20{i})), zs{i}, 'linewidth',2);
    zs_mat = cell2mat(zs);
    ylim([min(zs_mat(:)), max(zs_mat(:))]);
    set(gcf, 'Position', get(0, 'Screensize'));
    exportToPPTX('addslide');
    exportToPPTX('addpicture',gcf,'Scale','maxfixed');
end
exportToPPTX('save','psths_corrected_3sd.pptx');
exportToPPTX('close');
close all

pp20 = cell2mat(p20);