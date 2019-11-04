function [matrix] = dh_standard(theta, d, a, alpha)
% alpha_(i - 1)
% a_(i - 1)
% d-i
% theta_i
matrix = [cosd(theta), -sind(theta)*cosd(alpha), sind(theta)*sind(alpha), a*cosd(theta);
    sind(theta), cosd(theta)*cosd(alpha), -cosd(theta)*sind(alpha), a*sind(theta);
    0, sind(alpha) cosd(alpha), d;    
    0, 0, 0, 1];
end

