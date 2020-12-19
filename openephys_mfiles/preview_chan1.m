% preview afirst chan
[data, timestamps, info] = load_open_ephys_data('100_CH1.continuous');
n_per_trial = get_sample_number_per_trial(timestamps);
step = get_step(n_per_trial);
num_trial = length(n_per_trial) - 1;
num_sample = step - 2*5*30;

fdata = ffilter(data);
traces = get_traces(fdata, n_per_trial, step);
truncted_traces = traces(:, 5*30+1:step-5*30); % discard first and last 5ms
truncted_traces_t = truncted_traces';

spikes = get_spikes(traces');

spikes(spikes == 0) = NaN;

figure(1)
for j = 1:length(n_per_trial)-1
    plot(linspace(0,6,step), j*spikes(:,j),'b.');
    hold on
end
hold off

figure(2)
spikes(isnan(spikes)) = 0;
psth = sum(spikes,2);
p512 = reshape(psth,512, []);
p512 = sum(p512,1);
plot(linspace(0,6, length(p512)), p512)