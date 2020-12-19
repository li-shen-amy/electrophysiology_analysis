clear all
[data, timestamps, info] = load_open_ephys_data('100_CH1.continuous');
d = diff(timestamps);
d = sort(d,'descend');