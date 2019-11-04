D = [0 4 8 12 16 20 24 28 32];
F = [0 .23 .36 .43 .52 .64 .78 .85 .92];  
plot(D,F,'.b')
p = polyfit(D,F,1);
f = polyval(p,D);
hold on
plot(D,f,'--r')