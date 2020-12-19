% chan64_RF
%%
clear
close all
seq_322 = [229	124	127	30	175	65	274	232	198	28	43	26	177	179	192	230	34	32	4	233	39	199	123	89	128	221	125	131	237	223	231	35	46	23	215	31	25	44	130	180	220 304	316	289	310	301						                           
45	129	218	170	148	122	36	136	276	90	224	181	154	238	219	53	240	273	47	275	37	171	121	29	197	66	64	61	176	135	33	235	272	40	27	38	191	225	126	62	88 319	295	302	318	317
234	193	60	80	50	116	200	214	132	41	72	22	63	24	228	236	216	59	13	49	112	81	226	91	257	169	174	277	155	270	48	241	239	71	147	14	3	42	173	178	222 290	322	308	299	306
182	5	258	164	138	2	82	140	67	252	172	196	134	70	51	93	194	271	183	20	251	68	87	253	190	206	262	133	54	52	202	56	153	137	117	97	227	149	120	217	21 297	298	314	313	321
195	55	269	92	160	189	168	96	57	205	7	256	152	146	242	278	100	107	201	260	249	213	15	75	73	165	255	210	115	79	184	113	19	8	69	111	12	248	58	158	156 305	291	307	315	303
186	16	250	114	212	267	86	119	254	150	207	74	263	280	110	203	78	98	85	118	246	1	157	95	83	103	281	208	141	279	6	163	245	139	286	259	104	94	106	261	102 312	309	296	300	294
166	18	9	11	142	76	108	265	247	284	162	209	282	185	144	244	211	188	167	287	266	285	268	283	105	159	10	145	143	101	264	151	243	77	109	161	17	99	84	204	187 311	292	320	293	288];

pre = input('delay = '); % large noise at the biginning
post = input('stop = ');
TRF = zeros(322, 64);
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
    
    spks = cat(3, spks, spk);
    for iter = 1: length(seq_322)
        psth = spk(iter,:);
        p1 = reshape(psth,256,[]);
        p2 = sum(p1,1);
        
        bl_pre = floor(pre/(length(psth)/30)*length(p2));
        bl_post = floor(post/(length(psth)/30)*length(p2));
        range = cat(2, 1:bl_pre, length(p2)-bl_post+1:length(p2));
        
        mu = mean(p2(range));
        sigma = std(p2(range));
        peak = max(p2(10:20));
        
        z = (peak-mu)/sigma;
        if z <= 2
            res = 0;
        else
            res = peak-mu;
        end
        
        TRF(seq_322(iter),k) = res;
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

TRF2 = reshape(TRF,[7,46,64]);

for i = 1:64
    map = TRF2(:,:,i);
    m = max(TRF2(:));
    imagesc(map/m);
    colormap(gray)
    axis square
    axis off
    caxis([0,1])
    pause
end