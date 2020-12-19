% get sample number for each trial
function n_per_trial = get_sample_number_per_trial(timestamps)

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
    
end