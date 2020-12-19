% cont, sound noise
[data, timestamps, info] = load_open_ephys_data('all_channels.events');
d = diff(timestamps);
plot(d);
id = find(d<0.01);
timestamps(id+1)=[];
% process timestamps
trig_onset = timestamps(1:2:644)-40928/30000;
t_rec = input('recording time (in ms) = ');
trig_offset = trig_onset + t_rec/1000;
num_trial = length(trig_onset);

idx = [10,53,13,55,15,52,9,50,17,56,11,48,19,54,16,46,21,49,18,44,23,47,20,42,7,45,22,58,5,43,24,60,4,41,8,61,31,57,6,34,27,59,3,38,2,62,1,63,30,64,29,35,25,36,12,40,14,51,28,37,26,39,32,33];
[data, timestamps, info] = load_open_ephys_data('100_CH1.continuous');

traces = cell(64,1);
p20 = cell(64,1);
zs = cell(64,1);
res = cell(64,1);
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

vmax = -1;
for i = 1:64
    fn = ['100_CH', num2str(idx(i)), '.continuous'];
    [data, timestamps, info] = load_open_ephys_data(fn);
    fdata = ffilter(data(ind));
    dat1(i,:) = fdata';    
    vmax = max(vmax, max(abs(fdata)));
end


index = [229	124	127	30	175	65	274	232	198	28	43	26	177	179	192	230	34	32	4	233	39	199	123	89	128	221	125	131	237	223	231	35	46	23	215	31	25	44	130	180	220 304	316	289	310	301
        45	129	218	170	148	122	36	136	276	90	224	181	154	238	219	53	240	273	47	275	37	171	121	29	197	66	64	61	176	135	33	235	272	40	27	38	191	225	126	62	88 319	295	302	318	317
        234	193	60	80	50	116	200	214	132	41	72	22	63	24	228	236	216	59	13	49	112	81	226	91	257	169	174	277	155	270	48	241	239	71	147	14	3	42	173	178	222 290	322	308	299	306
        182	5	258	164	138	2	82	140	67	252	172	196	134	70	51	93	194	271	183	20	251	68	87	253	190	206	262	133	54	52	202	56	153	137	117	97	227	149	120	217	21 297	298	314	313	321
        195	55	269	92	160	189	168	96	57	205	7	256	152	146	242	278	100	107	201	260	249	213	15	75	73	165	255	210	115	79	184	113	19	8	69	111	12	248	58	158	156 305	291	307	315	303
        186	16	250	114	212	267	86	119	254	150	207	74	263	280	110	203	78	98	85	118	246	1	157	95	83	103	281	208	141	279	6	163	245	139	286	259	104	94	106	261	102 312	309	296	300	294
        166	18	9	11	142	76	108	265	247	284	162	209	282	185	144	244	211	188	167	287	266	285	268	283	105	159	10	145	143	101	264	151	243	77	109	161	17	99	84	204	187 311	292	320	293	288];

TRF = zeros(64,7,46);
for i = 1:64
    fdata = dat1(i,:);
    spike = get_spikes(fdata);
    traces{i}= zeros(num_trial, num_sample_rec);
    for j = 1:num_trial
        traces{i}(j,:) = spike((1:num_sample_rec)+(j-1)*num_sample_rec);
    end
    r = zeros(num_trial,1);
    for j = 1:num_trial
        tra = traces{i}(j,:);
        p_tra = reshape(tra, num_sample_bin, []);
        p20_tra = sum(p_tra,1);
        p20_tra(1) = p_tra(2);
        b = mean(p20_tra(1:19));
        r(j) = (p20_tra(21)+p20_tra(22))/2-b;
    end
    for j = 1:7
        for k = 1:46
            TRF(i,j,k) = TRF(i,j,k) + r(index(j,k));
        end
    end
    p = reshape(sum(traces{i},1),num_sample_bin,[]);
    p20{i} = sum(p,1);
    p20{i}(1) = p20{i}(2);
    bl = mean(p20{i}(1:19));
    sd = std(p20{i}(1:19));
    zs{i} = (p20{i}-bl)/sd;
    res{i} = p20{i}-bl;
end

pp20 = cell2mat(p20);
spont = mean(pp20(:,1:19),2)/num_trial/0.02;
r = ((pp20(:,21)+pp20(:,22))/2-mean(pp20(:,1:19),2))/num_trial/0.02;

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
    % stairs(linspace(0,t_rec,length(p20{i})), zs{i}, 'linewidth',2);
    stairs(0:bin_size:t_rec, cat(2,zs{i},zs{i}(end)), 'linewidth',2);
    zs_mat = cell2mat(zs);
    ylim([min(zs_mat(:)), max(zs_mat(:))]);
    set(gcf, 'Position', get(0, 'Screensize'));
    exportToPPTX('addslide');
    exportToPPTX('addpicture',gcf,'Scale','maxfixed');
end
exportToPPTX('save','psths_corrected_3sd.pptx');
exportToPPTX('close');
close all