r = 100; %cm r = length 1
s = r;     % s = length 2
syms theta1 theta2 rob
% theta, d, a, alpha
% link angle, link offset, link length, link twist
DH = [theta1 0 r 0; theta2 0 s 0]
rob = SerialLink(DH)
robfk = rob.fkine([theta1 theta2])
xEq = robfk.t(1,1);
yEq = robfk.t(2,1);

%robIk = rob.ikine(robfk);