chan_idx = {'01','02','03','04','05','06','07','08',...
            '09','10','11','12','13','14','15','16',...
            '17','18','19','20','21','22','23','24',...
            '25','26','27','28','29','30','31','32',...
            '33','34','35','36','37','38','39','40',...
            '41','42','43','44','45','46','47','48',...
            '49','50','51','52','53','54','55','56',...
            '57','58','59','60','61','62','63','64'};

gosi = zeros(64,1);
gdsi = zeros(64,1);
psth = zeros(64,150);
trace_dir = zeros(64,90000);
peak = zeros(64,12);
bl = zeros(64,12);
r = zeros(64,12);
zscore = zeros(64,1);

for i = 1:length(chan_idx)
    chan_name = ['Channel', num2str(chan_idx{i})];
    chan = eval(chan_name);
    t = chan(:,3);
    t2ind = round(t*30000);
    trace = zeros(240*30000*3,1);
    trace(t2ind)=1;
    trace_trial = reshape(trace,90000,240);
    
    p = sum(trace_trial,2);
    p20 = reshape(p,20*30,[]);
    
    psth(i,:) = sum(p20,1);
    pa = max(psth(i,75:100));
    ba = mean(psth(i,end-4:end));
    ra = pa-ba;
    sd = std(psth(i,end-4:end));
    zscore(i) = ra/sd;
    
    
    figure(1)
    plot(linspace(0,3000,length(psth(i,:))), psth(i,:)/240)
    title(['channel ', num2str(i), ', zscore = ', num2str(zscore(i))]);
    
    load('d12sequence.txt');
    d12sequence = repmat(d12sequence,2,1);
    trace_trial_dir = trace_trial;
    
    for j = 0:30:330
        idx = find(d12sequence==j);
        k = round(j/30)+1;
        trace_trial_dir(:,(1:20)+(k-1)*20) = trace_trial(:,idx);
    end
    
    for j = 1:12
        idx = (1:20)+(j-1)*20;
        trace_dir(i,:) = mean(trace_trial_dir(:,idx), 2);
        p_dir = reshape(trace_dir(i,:), 20*30, []);
        psth_dir = sum(p_dir, 1);
        peak(i,j) = max(psth_dir(60:75));
        bl(i,j) = mean(psth_dir(end-4:end));
        r(i,j) = peak(i,j)-bl(i,j);
        sd(i,j) = std(psth_dir(end-4:end));
    end
    
    figure(2)
    plot(peak(i,:))
    hold on
    plot(bl(i,:),'r')
    plot(r(i,:),'k')
    hold off
    
    figure(3)
    polarplot(0:pi/6:2*pi,[r(i,:),r(i,1)]*10);
    [gosi(i), gdsi(i)] = get_gosi_gdsi(r(i,:));
    pause
end