% cont, sound noise analysis
chan_idx = {'01','02','03','04','05','06','07','08',...
            '09','10','11','12','13','14','15','16',...
            '17','18','19','20','21','22','23','24',...
            '25','26','27','28','29','30','31','32',...
            '33','34','35','36','37','38','39','40',...
            '41','42','43','44','45','46','47','48',...
            '49','50','51','52','53','54','55','56',...
            '57','58','59','60','61','62','63','64'};

t_rec = input('t_rec (ms) = ');
chan = eval('Channel01');
num_sample_rec = round(t_rec*30);

[data, timestamps, info] = load_open_ephys_data('all_channels.events');
d = diff(timestamps);
plot(d);
id = find(d<0.01);
timestamps(id+1)=[];

num_trial = length(timestamps(1:2:end));

bin_size = 1; % ms
p20 = cell(64,1);
zs = cell(64,1);
res = cell(64,1);
trace_trial = cell(64,1);

bl_trial = zeros(64, num_trial);
sd_trial = zeros(64, num_trial);
pk_trial = zeros(64, num_trial);
rs_trial = zeros(64, num_trial);
zs_trial = zeros(64, num_trial);

for i = 1:length(chan_idx)
    chan_name = ['Channel', num2str(chan_idx{i})];
    chan = eval(chan_name);
    t = chan(:,3);
    t2ind = round(t*30000);
    trace = zeros(num_trial*num_sample_rec,1);
    trace(t2ind)=1;
    trace_trial{i} = reshape(trace,num_sample_rec,num_trial);
    for j = 1:num_trial
        a_trial = trace_trial{i}(:,j);
        p_a_trial = reshape(a_trial, bin_size*30, []);
        p20_a_trial = sum(p_a_trial, 1);
        p20_a_trial(1:2) = p20_a_trial(3:4);
        bl_trial(i,j) = mean(p20_a_trial(1:200))/(bin_size/1000);
        sd_trial(i,j) = std(p20_a_trial(1:200))/(bin_size/1000);
        pk_trial(i,j) = mean(p20_a_trial(207:227))/(bin_size/1000);
        rs_trial(i,j) = pk_trial(i,j)-bl_trial(i,j);
        zs_trial(i,j) = rs_trial(i,j)/sd_trial(i,j);
    end
    
    p = reshape(sum(trace_trial{i},2), bin_size*30, []);
    
    p20{i} = sum(p,1);
    p20{i}(1:2) = p20{i}(3:4);
    bl = mean(p20{i}(1:200));
    sd = std(p20{i}(1:200));
    zs{i} = (p20{i}-bl)/sd;
    res{i} = (p20{i}-bl)/num_trial/(bin_size/1000);
end

exportToPPTX('new');
for i = 1:length(chan_idx)
    trace = trace_trial{i}';
    figure(1)
    trace(trace==0) = NaN;
    yyaxis left
    for k = 1:num_trial
        plot(linspace(0,t_rec,num_sample_rec), k* trace(k,:),'b.','markersize',4);
        hold on
    end
    hold off
    xlim([0, t_rec])
    ylim([0,num_trial+1])
    
    yyaxis right
    plot(0:bin_size:t_rec, cat(2,res{i},res{i}(end)), 'linewidth',1);
    res_mat = cell2mat(res);
    ylim([min(res_mat(:)), max(res_mat(:))]);
    
    set(gcf, 'Position', get(0, 'Screensize'));
    exportToPPTX('addslide');
    exportToPPTX('addpicture',gcf,'Scale','maxfixed');
end
exportToPPTX('save','psths_sua_corrected_3sd.pptx');
exportToPPTX('close');
close all

pp20 = cell2mat(p20);
spont = mean(pp20(:,1:200),2)/num_trial/(bin_size/1000);
sd = std(pp20(:,1:200)/num_trial/(bin_size/1000),[],2);
r = (mean(pp20(:,211:261),2)-mean(pp20(:,1:200),2))/num_trial/(bin_size/1000);
z = r./sd;