% get spikes
function spikes = get_spikes(traces)
    [m, n] = size(traces);    
    trace = traces(:);
    spike = detect_spikes(trace);
    spikes = reshape(spike, m, n);   
end