for i = 1:27
    [go, gd] = get_gosi_gdsi(r(i,1:12));
    figure(1)
    polarplot(0:pi/6:2*pi,r(i,:));
    title(['gosi = ', num2str(go), ', gdsi = ', num2str(gd)])
    pause
end
    