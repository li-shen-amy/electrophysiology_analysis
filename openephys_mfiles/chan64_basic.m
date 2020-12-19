%% for auditory
idx = [10,53,13,55,15,52,9,50,17,56,11,48,19,54,16,46,21,49,18,44,23,47,20,42,7,45,22,58,5,43,24,60,4,41,8,61,31,57,6,34,27,59,3,38,2,62,1,63,30,64,29,35,25,36,12,40,14,51,28,37,26,39,32,33];
[data, timestamps, info] = load_open_ephys_data('100_CH1.continuous');
dat1 = zeros(64, length(data));
n_per_trial = get_sample_number_per_trial(timestamps);
step = get_step(n_per_trial)
num_trial = length(n_per_trial) - 1;
num_sample = step;
t_rec = round(num_sample/30); % ms

for i = 1:64
    [data, timestamps, info] = load_open_ephys_data(['100_CH',num2str(idx(i)),'.continuous']);
    fdata = ffilter(data);
    dat1(i,:) = fdata;    
end

% maxdata = max(abs(dat1k(:)));
% factor = 32767/maxdata;
% dat2 = int16(dat1k*factor); % 16 bit
% 
% fid = fopen('2018-04-12_18-03-04-300-6000k.bin','w','l');
% fwrite(fid, dat2, 'int16','l');
% fclose(fid);

spk = cell(64,1);
p2 = cell(64,1);
exportToPPTX('new');
for k = 1:64
    fdata = dat1(k,:);
    spikes = get_spikes(fdata);
    
    spk{k} = zeros(length(n_per_trial)-1, step);
    for i = 1:length(n_per_trial)-1
        spk{k}(i,:) = spikes(n_per_trial(i):n_per_trial(i)+step-1);
    end
    
    psth = sum(spk{k}, 1);
    p1 = reshape(psth,128,[]);
    p2{k} = sum(p1, 1);
    p2{k}(1) = p2{k}(2);
    spk{k}(spk{k}==0)=NaN;
    figure(1)
    for i = 1:num_trial
        plot(linspace(0,t_rec,step), i*spk{k}(i,:),'b.','markersize',4);
        hold on
    end
    plot(linspace(0,t_rec,length(p2{k})),p2{k}/max(p2{k})*length(n_per_trial),'r','linewidth',2)
    % plot(linspace(0,t_rec,length(p2{k})),p2{k}/128,'r','linewidth',2)

    xlim([0, t_rec]);
    ylim([0, length(n_per_trial)])
    hold off
    set(gcf, 'Position', get(0, 'Screensize'));
    exportToPPTX('addslide');
    exportToPPTX('addpicture',gcf,'Scale','maxfixed');
end
exportToPPTX('save','psths.pptx');
exportToPPTX('close');
close all