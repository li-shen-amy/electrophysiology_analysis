% get common sample number for all trials
function step = get_step(n_per_trial)

    d2 = diff(n_per_trial);
    step = min(d2);
    if mod(step + 1, 1024) == 0
        step = step + 1;
    elseif mod(step - 1, 1024) == 0
            step = step - 1;
    end
    step = d2(end);
end