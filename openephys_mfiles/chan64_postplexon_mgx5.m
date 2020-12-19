% chan64 post plexon trunct mgx5 combined
% chan64_sorted, for trunct_remove_high_fr files

load('2018-03-21_17-00-49-300-6000.mat')
[data, timestamps, info] = load_open_ephys_data('100_CH1.continuous');

n_per_trial = get_sample_number_per_trial(timestamps);
step = get_step(n_per_trial);
%num_sample = step - 2*5*30;
num_sample = step;
num_trial = length(n_per_trial)-1;

[m, n] = size(data);
chan_idx = {'01', '05', '09', '13', '17', '21', '25', '29', '33', '37', '41', '45', '49', '53', '57', '61'};

dir_tuning = cell(length(chan_idx),1);
resp_mat = cell(length(chan_idx),1);

load('d12sequence.txt');
seq = d12sequence(1:60);
OSI = zeros(16,8); % 5 contrast, 16 tetrods, 8 units
DSI = zeros(16,8);
anov = ones(16,8);
zscore = zeros(16,8);
skip_list = [];
% skip_list = cell(5,1);
% skip_list{1} = [8, 14, 19, 27, 29, 32, 47];
% skip_list{2} = [7, 13, 20, 24, 30, 32, 35, 45, 47, 53, 54, 55, 56, 57, 58, 59, 60];
% skip_list{3} = [2, 9, 12, 19, 21, 41, 52, 56];
% skip_list{4} = [9, 15, 17, 19, 29, 30, 33, 39, 45, 51,53,57,59];
% skip_list{5} = [7, 10, 13, 20, 23, 26, 30, 33, 35, 43, 46, 51, 53, 58, 60];

for i = 1:length(chan_idx) % 64 chans
    chan_name = ['Channel', num2str(chan_idx{i})];
    chan = eval(chan_name);
    num_units = max(chan(:,2));
    t_spike = cell(num_units, 1);
    spikes = cell(num_units, 1);
    spk = cell(num_units, 1);
    spk_full = cell(num_units, 1);
    spikes_organized_accord_direction = cell(num_units, 1);
    
    dir_tuning{i} = zeros(12, num_units);
    resp_mat{i} = zeros(5, 12, num_units);
    for j = 1:num_units % up to 4 units
        % find spikes for each contrast
        t = round(chan(:,3)*30000);
        idx_j = find((chan(:,2) == j));
        t_spike{j} = t(idx_j);
        spikes{j} = zeros(num_sample*num_trial, 1);
        spikes{j}(t_spike{j}, 1) = 1;
        spk{j} = zeros(num_trial, num_sample-5*30*2);
        for k = 1 : num_trial % 60 trials
            spk{j}(k,:) = spikes{j}((5*30+1:num_sample-5*30) + (k-1)*num_sample);
        end
        
        spk_full{j} = cat(2, zeros(num_trial, 5*30), spk{j}, zeros(num_trial, 5*30)); % 60xstep
        
        skip = skip_list;
        for s = 1:length(skip)
            spk_full{j}(skip(s),:) = -ones(1, step);
        end
        % dir
        spikes_organized_accord_direction{j} = zeros(num_trial, step);
        for k = 1:12 % 12 directions
            idx = find(seq == (k-1)*30);
            spikes_organized_accord_direction{j}((1:5)+(k-1)*5,:) = spk_full{j}(idx, :);
        end
        
        mu = zeros(60, 1);
        peak = zeros(60, 1);
        resp = zeros(60, 1);
        for k = 1:60
            mu(k) = sum(spikes_organized_accord_direction{j}(k,1000*30:2000*30))/1; % 60-500
            peak(k) = sum(spikes_organized_accord_direction{j}(k,2000*30:3500*30))/1.5; % 560-2000
            if mu(k) < 0 % this trial is skipped
                peak(k) = -100;
            end
        end
        mu_r = mean(mu);
        peak_mat = reshape(peak, 5, 12);
        r = zeros(1, 12);
        for d = 1:12
            peak_1d = peak_mat(:,d);
            peak_r = mean(peak_1d(peak_1d > -100)); % not skipped
            resp_mat{i}(:,d,j) = peak_1d - mu_r;
            r(d) = peak_r - mu_r;
        end
        resp_mat{i}(resp_mat{i} == (-100-mu_r)) = NaN;
        anov(i , j) = anova1(resp_mat{i}(:,:,j), [], 'off');
        dir_tuning{i}(:,j) = r; % dir_tunings
        [OSI(i, j), DSI(i, j)] = get_gosi_gdsi(r);
    end
    
    
    
    figure(1)
    colors = {'r','g','b','y','m','c','w','k'};
    subplot(1,2,1)
    for j = 1:num_units
        spikes_organized_accord_direction{j}(spikes_organized_accord_direction{j} == -1) = 0;
        spk_full{j}(spk_full{j} == -1) = 0;
        a_unit = spikes_organized_accord_direction{j};
        psth_a_unit = mean(a_unit, 1);
        psth10_a_unit = sum(reshape(psth_a_unit, 1024, []),1);
        mu_idx = [round(1000/(1024/30)), round(2000/(1024/30))];
        mu = sum(psth10_a_unit(mu_idx(1):mu_idx(2)))/1; % 4000-5000
        peak_idx = [round(2000/(1024/30)), round(3500/(1024/30))];
        peak = sum(psth10_a_unit(peak_idx(1):peak_idx(2)))/1.5; % 2000-3500
        sd = std( psth10_a_unit(mu_idx(1):mu_idx(2))); % 4000-5000
        if sd == 0
            zscore(i, j) = -1;
        else
            zscore(i, j) = (peak-mu)/sd;
        end
        
        plot(linspace(0,6000/1000,length(psth10_a_unit)), psth10_a_unit+(j-1)*15/60, colors{j});
        xlim([0, 6000/1000])
        hold on
    end
    
    [m,n] = size(spikes_organized_accord_direction{j});
    psth_all = zeros(m,n);
    for j = 1:num_units
        psth_all = psth_all + spikes_organized_accord_direction{j};
    end
    psth_all = mean(psth_all, 1);
    psth10_all = reshape(psth_all, 1024, []);
    psth10_all = sum(psth10_all, 1);
    plot(linspace(0,6000/1000,length(psth10_all)), psth10_all+(j-1)*15/60, 'k', 'linewidth',2);
    hold off
    
    for j = 1:num_units
        spk_full{j}(spk_full{j} <= 0) = NaN;
        spikes_organized_accord_direction{j}(spikes_organized_accord_direction{j} <= 0) = NaN;
    end
    
    colors = {'r.','g.','b.','y.','m.','c.','w.','k.'};
    subplot(1,2,2)
    for j = 1:num_trial
        for k = 1:num_units
            plot(linspace(0,6000/1000,step), j* spk_full{k}(j,:),colors{k});
            xlim([0, 6000/1000])
            hold on
        end
    end
    hold off
    pause;
    
    figure(2)
    colors = {'r','g','b','y','m','c','w','k'};
    subplot(1,2,1)
    for j = 1:num_units
        r = dir_tuning{i}(:,j)';
        r1 = [r, r(1)];
        r1(r1<0)=0;
        polarplot(0:pi/6:pi*2, r1, colors{j});
        hold on
    end
    hold off
    subplot(1,2,2)
    for j = 1:num_units
        plot(linspace(0,330,12), dir_tuning{i}(:,j), colors{j})
        xlim([0, 330])
        hold on
        %             for k = 1:5 % rep
        %                 plot(linspace(0,330,12), resp_mat{i}(k,:,j), colors{j}, 'LineStyle', '--')
        %             end
        plot([0, 330], [0, 0], 'r--');
    end
    hold off
    pause
    
end