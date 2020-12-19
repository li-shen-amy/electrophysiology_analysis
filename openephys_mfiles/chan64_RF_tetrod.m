% chan64 RF: plexon sorted, tetrodx16
%%
clear
close all
load('2018-02-28_21-14-31-trunct_remove_high_fr.mat')
seq_6x8 = load('seq6x8.txt');
pre = input('delay = ');
post = input('stop = ');
idx = [10,53,13,55,15,52,9,50,17,56,11,48,19,54,16,46,21,49,18,44,23,47,20,42,7,45,22,58,5,43,24,60,4,41,8,61,31,57,6,34,27,59,3,38,2,62,1,63,30,64,29,35,25,36,12,40,14,51,28,37,26,39,32,33];
chan_idx = {'01', '05', '09', '13', '17', '21', '25', '29', '33', '37', '41', '45', '49', '53', '57', '61'};
zscore = cell(length(chan_idx), 1);
res = cell(length(chan_idx), 1);
RF_ON = cell(length(chan_idx), 4); % 4 units
RF_OFF = cell(length(chan_idx), 4);

[data, timestamps, info] = load_open_ephys_data(['100_CH1.continuous']);
n_per_trial = get_sample_number_per_trial(timestamps);
step = get_step(n_per_trial);
num_sample = (step-2*5*30);
num_trial = length(n_per_trial)-1;

for i = 1:length(chan_idx)
    chan_name = ['Channel', num2str(chan_idx{i})];
    chan = eval(chan_name);
    num_units = max(chan(:,2));
    t_spike = cell(num_units, 1);
    spikes = cell(num_units, 1);
    spk_s = cell(num_units, 1);
    spk = cell(num_units, 1);
    for j = 1:num_units
        t_spike{j} = round(chan(chan(:,2) == j, 3) * 30000);
        spikes{j} = zeros(num_sample*num_trial, 1);
        spikes{j}(t_spike{j}, 1) = 1;
        spk_s{j} = zeros(num_trial, num_sample);
        for k = 1 : num_trial
            spk_s{j}(k,:) = spikes{j}((1:num_sample) + (k-1)*num_sample);
        end
        
        spk{j} = cat(2, zeros(num_trial, 5*30), spk_s{j}, zeros(num_trial, 5*30));
        RF_ON{i, j} = zeros(48, 1);
        RF_OFF{i, j} = zeros(48, 1);
        for iter = 1: length(seq_6x8)
            psth = spk{j}(iter, :);
            p1 = reshape(psth,256,[]);
            p2 = sum(p1,1);
            
            bl_pre = floor(pre/(length(psth)/30)*length(p2));
            bl_post = floor(post/(length(psth)/30)*length(p2));
            range = cat(2, 2:bl_pre, length(p2)-bl_post+1:length(p2));
            
            mu = mean(p2(range));
            sigma = std(p2(range));
            peak = max(p2);
            
%             z = (peak-mu)/sigma;
%             if z <= 2
%                 res = 0;
%             else
%                 res = peak-mu;
%             end
            res = peak - mu;

            if seq_6x8(iter,2) == 1
                RF_ON{i ,j}(seq_6x8(iter,1)+1, 1) = RF_ON{i ,j}(seq_6x8(iter,1)+1, 1) + res;
            elseif seq_6x8(iter,2) == 3
                RF_OFF{i ,j}(seq_6x8(iter,1)+1, 1) = RF_OFF{i, j}(seq_6x8(iter,1)+1, 1) + res;
            end
        end
    end
        
    %         spk(spk == 0) = NaN;
    %         figure(1)
    %         for i = 1:length(n_per_trial)-1
    %             plot(linspace(0,1,step), i*spk(i,:),'b.');
    %             hold on
    %         end
    %         hold off
    %         pause;
end

RF2_ON = cell(length(chan_idx), 4);
RF2_OFF = cell(length(chan_idx), 4);
for i = 1:16
    for j = 1:4
        map_ON = RF_ON{i, j};
        map_OFF = RF_OFF{i, j};
        map2_ON = zeros(6,8);
        map2_OFF = zeros(6, 8);
        if sum(map_ON(:)) > 0
            for k = 1:6
                map2_ON(k, :) = map_ON((1+(k-1)*8):(8+(k-1)*8));
                map2_OFF(k, :) = map_OFF((1+(k-1)*8):(8+(k-1)*8));
            end
        end
        RF2_ON{i ,j} = map2_ON;
        RF2_OFF{i ,j} = map2_OFF;
    end
end

figure(4)
for i = 1:16
    for j = 1:4
        map_on = RF2_ON{i, j};
        large_map = cell2mat(RF2_ON);
        subplot(16,4,j + (i-1)*4)
        imagesc(map_on/max(large_map(:)))
        axis square
        axis off
        colormap(gray)
        caxis([0,1]);
    end
end
        