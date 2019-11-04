setConstraints;

L1 = l1;
L2 = l2;
xSpace = [];
ySpace = [];
skip = 5;

for n = theta1low:skip:theta1high
    dh1 = dh_standard(n,0,L1,0);
    for m = theta2low:skip:theta2high
        dh2 = dh_standard(m,0,L2,0);
        result = dh1*dh2;
        xSpace = [xSpace, result(1,4)];
        ySpace = [ySpace, result(2,4)];
    end
end

plot(xSpace,ySpace);