clear;
index=[];
index=[229	124	127	30	175	65	274	232	198	28	43	26	177	179	192	230	34	32	4	233	39	199	123	89	128	221	125	131	237	223	231	35	46	23	215	31	25	44	130	180	220 304	316	289	310	301						                           
45	129	218	170	148	122	36	136	276	90	224	181	154	238	219	53	240	273	47	275	37	171	121	29	197	66	64	61	176	135	33	235	272	40	27	38	191	225	126	62	88 319	295	302	318	317
234	193	60	80	50	116	200	214	132	41	72	22	63	24	228	236	216	59	13	49	112	81	226	91	257	169	174	277	155	270	48	241	239	71	147	14	3	42	173	178	222 290	322	308	299	306
182	5	258	164	138	2	82	140	67	252	172	196	134	70	51	93	194	271	183	20	251	68	87	253	190	206	262	133	54	52	202	56	153	137	117	97	227	149	120	217	21 297	298	314	313	321
195	55	269	92	160	189	168	96	57	205	7	256	152	146	242	278	100	107	201	260	249	213	15	75	73	165	255	210	115	79	184	113	19	8	69	111	12	248	58	158	156 305	291	307	315	303
186	16	250	114	212	267	86	119	254	150	207	74	263	280	110	203	78	98	85	118	246	1	157	95	83	103	281	208	141	279	6	163	245	139	286	259	104	94	106	261	102 312	309	296	300	294
166	18	9	11	142	76	108	265	247	284	162	209	282	185	144	244	211	188	167	287	266	285	268	283	105	159	10	145	143	101	264	151	243	77	109	161	17	99	84	204	187 311	292	320	293	288];


fp=[200 4000]/5000;%
fs=[100 4500]/5000;%
wp=3;%
ws=30;%
[n,fc]=buttord(fp,fs,wp,ws); 
[b,a]=butter(n,fc); 

nu=1;    %%%%rep



starttime=550;
endtime=1500;

number=0;
spikeall(8,47)=0;
dataa(3500,322*nu)=0;
for rep=1:nu

data=[];
data=inputlvb(3500);   
dataa(:,(1+(rep-1)*322):(322+(rep-1)*322))=data;
spike=[];
for i=1:7
    for j=1:46
        data1=filter(b,a,data(:,index(i,j))); 
        tr=data1(600:1500);

    k=0;
    ii=1;
    while(ii<(endtime-starttime))  
      if data1(ii+starttime)>=0.03  %%%threshold
         ss=-10000; 
         for jj=1:10 
            if data1(ii+jj+starttime)>=ss;
               ss=data1(ii+jj+starttime);
               aa=ii+jj;
               aaa=ss;
            end;
        end; 
        k=k+1;
        ii=ii+10;
      end
       ii=ii+1;   
    end
       spike(8-i,j)=k;  
         ah=0.95-i/8;
         al=0.15+0.030*(j-1);
         %figure(1),axes('position',[al/2  ah  .025/2  .1])
         %plot(tr);hold on;axis off;axis([0  1000  -0.1  0.2]); 
    end
end


spike(8,:)=0;
spike(:,47)=0;

scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/4 scrsz(3)/4 scrsz(4)/4]) 
pcolor(spike)
caxis([0 10]);
colorbar;
spikeall=spikeall+spike;

end

spike(8,:)=0;
spike(:,47)=0;

scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/4 scrsz(3)/4 scrsz(4)/4]) 
pcolor(spikeall)
caxis([0 10]);
colorbar;







fp=[200 4000]/5000;%
fs=[100 4500]/5000;%
wp=3;%
ws=30;%
[n,fc]=buttord(fp,fs,wp,ws); 
[b,a]=butter(n,fc); 

starttime=20;
endtime=3490;
st0=600;
st1=1500;
data=[];
data=dataa;
lengthFM=length(data(1,:));
number=0;
for i1=1:lengthFM
    data1=filter(b,a,data(:,i1)); 
    data2=data(:,i1);
    k=0;
    i=1;
    while(i<(endtime-starttime))  
      if data1(i+starttime)>=0.03 %%%
         ss=-10000; 
         for j=1:10 
            if data1(i+j+starttime)>=ss;
               ss=data1(i+j+starttime);
               aa=i+j;
               aaa=ss;
            end;
        end; 
        k=k+1;
        number=number+1;
        stimulispike(i1,k)=(aa/10+starttime/10);
        i=i+10;
      end
      spike(i1,1)=k;
   i=i+1;   
    end
    
     ii=1;
    k=0;              % first segment
    while(ii<(st1-st0))  
       if data1(ii+st0)>=0.03
       ss=-10000; 
         for j=1:10 
            if data1(ii+j+st0)>=ss;
               ss=data1(ii+j+st0);
               aa=ii+j;
               aaa=ss;
            end;
        end; 
        k=k+1;
        stimulispike1(i1,k)=(aa/10+st0/10);
        ii=ii+10;
       end
      spike(i1,2)=k; 
      ii=ii+1;   
    end  
 
end

histn=[];
scrsz = get(0,'ScreenSize');
figure('Position',[1 scrsz(4)/4 scrsz(3)/4 scrsz(4)/4]) 
histn(:,1)=hist(stimulispike(:),0:2:350);
histn(1:5,1)=0;

plot(smooth(histn),'r');hold on;
plot(histn);
