% chan64_RF: MUA
%%
clear
close all
seq_6x8 = load('seq6x8.txt');
pre = input('delay = ');
post = input('stop = ');
RF_ON = zeros(48,64);
RF_OFF = zeros(48,64);
idx = [10,53,13,55,15,52,9,50,17,56,11,48,19,54,16,46,21,49,18,44,23,47,20,42,7,45,22,58,5,43,24,60,4,41,8,61,31,57,6,34,27,59,3,38,2,62,1,63,30,64,29,35,25,36,12,40,14,51,28,37,26,39,32,33];
for k = 1:64
    [data, timestamps, info] = load_open_ephys_data(['100_CH',num2str(idx(k)),'.continuous']);
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
    fdata = ffilter(data);
    [m, n] = size(fdata);
    th = -3*std(fdata);
    j = 1;
    spikes = zeros(m, n);
    while j <= length(fdata)-11
        if fdata(j) < th
            t = find(fdata(j:j+10) == min(fdata(j:j+10)))+j-1;
            spikes(t, n) = 1;
            j = j + 10;
        else
            j = j + 1;
        end
    end
    
    d2 = diff(n_per_trial);
    step = min(d2);
    if mod(step + 1, 1024) == 0
        step = step + 1;
    elseif mod(step - 1, 1024) == 0
        step = step - 1;
    end
    spk = zeros(length(n_per_trial)-1, step);
    for i = 1:length(n_per_trial)-1
        spk(i,:) = spikes(n_per_trial(i):n_per_trial(i)+step-1);
    end
    
    for iter = 1: length(n_per_trial)-1
        psth = spk(iter,:);
        p1 = reshape(psth,256,[]);
        p2 = sum(p1,1);
        
        bl_pre = floor(pre/(length(psth)/30)*length(p2));
        bl_post = floor(post/(length(psth)/30)*length(p2));
        range = cat(2, 2:bl_pre, length(p2)-bl_post+1:length(p2));
        
        mu = mean(p2(range));
        sigma = std(p2(range));
        peak = max(p2);
        
        z = (peak-mu)/sigma;
        if z <= 2
            res = 0;
        else
            res = peak-mu;
        end
        
        if seq_6x8(iter,2) == 1
            RF_ON(seq_6x8(iter,1)+1,k) = RF_ON(seq_6x8(iter,1)+1,k) + res;
        elseif seq_6x8(iter,2) == 3
            RF_OFF(seq_6x8(iter,1)+1,k) = RF_OFF(seq_6x8(iter,1)+1,k) + res;
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

RF2_ON = zeros(6,8,64);
RF2_OFF = zeros(6,8,64);
for i = 1:64
    map_ON = RF_ON(:,i);
    map_OFF = RF_OFF(:,i);
    map2_ON = zeros(6,8);
    map2_OFF = zeros(6,8);
    for j = 1:6
        map2_ON(j, :) = map_ON((1+(j-1)*8):(8+(j-1)*8));
        map2_OFF(j, :) = map_OFF((1+(j-1)*8):(8+(j-1)*8));
    end
    RF2_ON(:,:,i) = map2_ON;
    RF2_OFF(:,:,i) = map2_OFF;
end

for i = 1:64
    map = RF2_OFF(:,:,i);
    m = max(RF2_OFF(:));
    imagesc(map/m);
    colormap(gray)
    axis square
    axis off
    caxis([0,1])
    pause
end