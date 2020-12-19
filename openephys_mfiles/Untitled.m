map3 = map(:,2:7,:);
mval = max(abs(map3(:)));
for iter = 1:64
    try
        m = squeeze(map3(iter,:,:));
        rfs = smoothts(m);
        [x1, y1] = meshgrid(linspace(1,46,46),linspace(1,6,6));
        [x2, y2] = meshgrid(linspace(1,46,46*5),linspace(1,6,6*5));
        
        rfi = interp2(x1,y1,rfs,x2,y2,'linear');
        sponFiringRate = mean(rfi(7,:));
        thr = sponFiringRate+0.3*max(rfi(:)-sponFiringRate);%
        % thr = 3 * sponFiringRate;
        
        rfi_clear = rfi;
        rfi_clear(rfi<thr) = 0;
        % rfi(rfi<0)=0;
        [c,h] = contour(rfi_clear,[thr thr],'-r', 'LineWidth',2);
        [v,i] = max(c(2,c(1,:)==thr));
        bigcontour = c(:,i+1:i+v);
        c(:,c(1,:)==thr)=[];
        cord = convhull(c(1,:),c(2,:));
        cord = cord(1:end-1,:);
        
        figure(1)
        imagesc(m)
        figure(2)
        imagesc(rfs)
        figure(3)
        % imagesc(rfi_clear)
        imagesc(rfi)
        hold on
        plot(c(1,cord),c(2,cord),'r','LineWidth',2)
        hold off
        figure(4)
        plot(bigcontour(1,:),bigcontour(2,:),'-b')
        hold on
        plot(c(1,cord),c(2,cord),'r','LineWidth',2)
        xlim([1, size(rfi,2)])
        ylim([1, size(rfi,1)])
        axis ij
        hold off
        area(iter) = polyarea(c(1,cord),c(2,cord))/25;
        %         Area(iter) = sum(bw(:))/25;
        pause;
    catch
        area(iter) = 0;
        %         Area(iter) = 0;
        pause;
    end
end