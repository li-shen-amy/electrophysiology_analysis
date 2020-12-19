% detect spikes
function spike = detect_spikes(trace)
% filtered trace
[m, n] = size(trace);
spike = zeros(m, 1);
th = -3*std(trace);

j = 1;

while j <= length(trace)-11
    if trace(j) < th
        t = find(trace(j:j+10) == min(trace(j:j+10)))+j-1;
        spike(t) = 1;
        j = j + 10;
    else
        j = j + 1;
    end
end
spike = spike(:);
end