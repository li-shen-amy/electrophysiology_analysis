% chan64_sorted

load('2018-02-28_21-04-09-3sd.mat')
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
    psth = cell(num_units, 1);
    p1 = cell(num_units, 1);
    p2 = cell(num_units, 1);
    zscore{i} = [];
    res{i} = [];
    for j = 1:num_units
        t_spike{j} = round(chan(chan(:,1) == j, 3) * 30000);
        spikes{j} = zeros(m, n);
        spikes{j}(t_spike{j}, 1) = 1;
        spk{j} = zeros(length(n_per_trial)-1, step);
        for k = 1 : length(n_per_trial)-1    
            spk{j}(k,:) = spikes{j}(n_per_trial(k):n_per_trial(k)+step-1);
        end

        psth{j} = sum(spk{j}, 1);
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
        spk{j}(spk{j} == 0) = NaN;
    end
    
    figure(1)
    colors = {'k.', 'b.', 'r.', 'g.'};
    for j = 1:length(n_per_trial)-1
        for k = 1:num_units
            plot(linspace(0,rec/1000,step), j*spk{k}(j,:),colors{k});
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