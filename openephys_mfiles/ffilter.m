function filtered_data = ffilter(raw_data)
% correct one!
lower_end = 300;
higher_end = 6000;
sampling_rate = 30000;
[b, a] = butter(2, [lower_end, higher_end]/(sampling_rate/2), 'bandpass');
filtered_data = filter(b, a, raw_data);
    
end