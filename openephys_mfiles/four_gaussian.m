
%% four gaussian
polarplot(Theta,R)
Rf = fittedmodel(Theta);
coeffs = coeffvalues(fittedmodel);
gaussian12 = cfit(f1,coeffs(1),coeffs(2),coeffs(5),coeffs(7),coeffs(9));
gaussian34 = cfit(f1,coeffs(3),coeffs(4),coeffs(6),coeffs(8),coeffs(9));
R12 = gaussian12(Theta);
R34 = gaussian34(Theta);
hold on
polarplot(Theta,Rf,'r')
polarplot(Theta,R12,'k--')
polarplot(Theta,R34,'k--')

%% two gaussian
polarplot(Theta,R)
Rf = fittedmodel(Theta);
coeffs = coeffvalues(fittedmodel);
gaussian = cfit(f1,coeffs(1),coeffs(2),coeffs(3),coeffs(4),coeffs(5));
R1 = gaussian(Theta);
hold on
polarplot(Theta,Rf,'r')
polarplot(Theta,R1,'k--')