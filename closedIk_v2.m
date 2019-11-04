function [thetaVector] = closedIk_v2(x,y,l1,l2)

t2rad1 = acos((x^2 + y^2 - l1^2 - l2^2)/(2*l1*l2));
t1rad1 = atan2(y,x) - atan2(l2*sin(t2rad1), l1 + l2*cos(t2rad1));

t2rad2 = -acos((x^2 + y^2 - l1^2 - l2^2)/(2*l1*l2));
t1rad2 = atan2(y,x) - atan2(l2*sin(t2rad2), l1 + l2*cos(t2rad2));

t2deg1 = rad2deg(t2rad1);
t1deg1 = rad2deg(t1rad1);
t2deg2 = rad2deg(t2rad2);
t1deg2 = rad2deg(t1rad2);

if checkRangeThetas(t1deg1,t2deg1)
    thetaVector = [t1deg1, t2deg1];
end

if checkRangeThetas(t1deg2,t2deg2)
    thetaVector = [thetaVector, t1deg2, t2deg2];
end

end

