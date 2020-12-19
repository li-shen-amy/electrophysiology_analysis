  % spk1
index=[229	124	127	30	175	65	274	232	198	28	43	26	177	179	192	230	34	32	4	233	39	199	123	89	128	221	125	131	237	223	231	35	46	23	215	31	25	44	130	180	220 304	316	289	310	301
    45	129	218	170	148	122	36	136	276	90	224	181	154	238	219	53	240	273	47	275	37	171	121	29	197	66	64	61	176	135	33	235	272	40	27	38	191	225	126	62	88 319	295	302	318	317
    234	193	60	80	50	116	200	214	132	41	72	22	63	24	228	236	216	59	13	49	112	81	226	91	257	169	174	277	155	270	48	241	239	71	147	14	3	42	173	178	222 290	322	308	299	306
    182	5	258	164	138	2	82	140	67	252	172	196	134	70	51	93	194	271	183	20	251	68	87	253	190	206	262	133	54	52	202	56	153	137	117	97	227	149	120	217	21 297	298	314	313	321
    195	55	269	92	160	189	168	96	57	205	7	256	152	146	242	278	100	107	201	260	249	213	15	75	73	165	255	210	115	79	184	113	19	8	69	111	12	248	58	158	156 305	291	307	315	303
    186	16	250	114	212	267	86	119	254	150	207	74	263	280	110	203	78	98	85	118	246	1	157	95	83	103	281	208	141	279	6	163	245	139	286	259	104	94	106	261	102 312	309	296	300	294
    166	18	9	11	142	76	108	265	247	284	162	209	282	185	144	244	211	188	167	287	266	285	268	283	105	159	10	145	143	101	264	151	243	77	109	161	17	99	84	204	187 311	292	320	293	288];

map = zeros(64,7,46);
spk = spk10;
for i = 1:64
    a_channel = spk{i};
    a_channel(isnan(a_channel))=0;
    peak = zeros(322,1);
    bl = zeros(322,1);
    mu = zeros(322,1);
    for j = 1:322
        peak(j) = sum(a_channel(j,200*30:250*30))/0.1;
        bl(j) = sum(a_channel(j,150*30:200*30))/0.05;
        mu(j) = peak(j)-bl(j);
    end
    for j = 1:7
        for k = 1:46
            map(i,j,k) = map(i,j,k) + peak(index(j,k));
        end
    end
end

mval = max(abs(map3(:)));
exportToPPTX('new');
for i = 1:64
    figure(1)
    img = squeeze(map3(i,:,:)/mval);
    imagesc(img(:,:));
    caxis([0,1])
    % set(gcf, 'Position', get(0, 'Screensize'));
    exportToPPTX('addslide');
    exportToPPTX('addpicture',gcf,'Scale','maxfixed');
    pause
end
exportToPPTX('save','tonal60_RFs_before.pptx');
exportToPPTX('close');
close all