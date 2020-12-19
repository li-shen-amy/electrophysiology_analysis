% get traces: (num_trial, common_num_sample)
function traces = get_traces(data, n_per_trial, step)

    traces = zeros(length(n_per_trial)-1, step);
    for i = 1:length(n_per_trial)-1
        traces(i,:) = data(n_per_trial(i):n_per_trial(i)+step-1);
    end

end