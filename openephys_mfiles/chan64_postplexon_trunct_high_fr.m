% chan64_sorted, for trunct_remove_high_fr files

load('2018-02-28_21-14-31-trunct_remove_high_fr.mat')
[data, timestamps, info] = load_open_ephys_data('100_CH1.continuous');

pre = input('pre = ');
post = input('post = ');
rec = input('rec = ');
stim_on = input('stim_on = ');
stim_off = input('stim_off = ');

d = diff(timestamps);
d = sort(d,'descend');
n_per_trial = [];
for i = 1:length(timestamps)-1
    if timestamps(i+1) - timestamps(i) > 0.9
        n_per_trial = [n_per_trial i];
    end
end
n_per_trial = [n_per_trial length(timestamps)];
n_per_trial = [1 n_per_trial];

d2 = diff(n_per_trial);
step = min(d2);
if mod(step + 1, 1024) == 0
    step = step + 1;
elseif mod(step - 1, 1024) == 0
        step = step - 1;
end

num_sample = step - 2*5*30;
num_trial = length(n_per_trial)-1;

[m, n] = size(data);
chan_idx = {'01', '05', '09', '13', '17', '21', '25', '29', '33', '37', '41', '45', '49', '53', '57', '61'};
zscore = cell(length(chan_idx), 1);
res = cell(length(chan_idx), 1);

for i = 1:length(chan_idx)
    chan_name = ['Channel', num2str(chan_idx{i})];
    chan = eval(chan_name);
    num_units = max(chan(:,2));
    t_spike = cell(num_units, 1);
    spikes = cell(num_units, 1);
    spk = cell(num_units, 1);
    spk_full = cell(num_units, 1);
    psth = cell(num_units, 1);
    p1 = cell(num_units, 1);
    p2 = cell(num_units, 1);
    zscore{i} = [];
    res{i} = [];
    for j = 1:num_units
        t_spike{j} = round(chan(chan(:,2) == j, 3) * 30000);
        spikes{j} = zeros(num_sample*num_trial, 1);
        spikes{j}(t_spike{j}, 1) = 1;
        spk{j} = zeros(num_trial, num_sample);
        for k = 1 : num_trial  
            spk{j}(k,:) = spikes{j}((1:num_sample) + (k-1)*num_sample);
        end
         
        spk_full{j} = cat(2, zeros(num_trial, 5*30), spk{j}, zeros(num_trial, 5*30));
        psth{j} = sum(spk_full{j}, 1);
        
        p1{j} = reshape(psth{j}, 256, []);
        p2{j} = sum(p1{j}, 1);
        bl_pre = floor(pre/(length(psth{j})/30)*length(p2{j}));
        bl_post = floor(post/(length(psth{j})/30)*length(p2{j}));
        range = cat(2, 2:bl_pre, length(p2{j})-bl_post+1:length(p2{j})-1); % discard first and last bin
        mu = mean(p2{j}(range));
        sigma = std(p2{j}(range));
        bin_index_stim_on = floor(stim_on/(length(psth{j})/30)*length(p2{j}));
        bin_index_stim_off = ceil(stim_off/(length(psth{j})/30)*length(p2{j}));
        peak = max(p2{j}(bin_index_stim_on:bin_index_stim_off));
        zscore{i} = cat(1, zscore{i}, (peak-mu)/sigma);
        res{i} = cat(1, res{i}, peak-mu);
    end
    
    for j = 1:num_units
        spk_full{j}(spk_full{j} == 0) = NaN;
    end
    
    figure(1)
    colors = {'k.', 'b.', 'r.', 'g.'};
    for j = 1:num_trial
        for k = 1:num_units
            plot(linspace(0,rec/1000,step), j*spk_full{k}(j,:),colors{k});
            hold on
        end
    end
    hold off
    
    pause;
    
    figure(2)
    colors = {'k', 'b', 'r', 'g'};
    for j = 1:num_units
        plot(p2{j}, colors{j})
        hold on
    end
    hold off
    pause;
    
end

