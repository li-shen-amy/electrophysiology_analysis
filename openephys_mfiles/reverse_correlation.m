% reverse correlation
% t_spike, t_trig, shift, m_seq
function s = reverse_correlation(t_spike, t_trig, shift, m_seq)
t_spike_shift = t_spike - shift;
n = histc(t_spike_shift, t_trig);
n = n(1:end-1);
map = zeros(16,16);
for i = 1:length(m_seq)
%     if n(i)>1
%         n(i)=0;
%     end
    map = map + n(i)*m_seq(:,:,i);
end
s = std(map(:));
figure(1);
imagesc(map/max(abs(map(:))));
end