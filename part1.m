syms theta1 theta2 theta3 r s t u rob
u=(pi/2); r = 200; s = 120; t = 60;
DH=[theta1 r 0 u; theta2 0 s 0; theta3 0 t 0];
rob=SerialLink(DH);
format short;
sympref('FloatingPointOutput',true);
rob.fkine([theta1 theta2 theta3])

%% 29.05,-55.43,109.89
disp("rob.fkine([deg2rad(29.05) deg2rad(-55.44) deg2rad(109.89)])")
rob.fkine([deg2rad(29.05) deg2rad(-55.44) deg2rad(109.89)])

%% 29.05,3.63,-109.89
disp("rob.fkine([deg2rad(29.05) deg2rad(3.63) deg2rad(-109.89)])")
rob.fkine([deg2rad(29.05) deg2rad(3.63) deg2rad(-109.89)])

%% -150.95,176.37,109.89
disp("rob.fkine([deg2rad(-150.95) deg2rad(176.37) deg2rad(109.89)])")
rob.fkine([deg2rad(-150.95) deg2rad(176.37) deg2rad(109.89)])

%% -150.95,-124.56,-109.89
disp("rob.fkine([deg2rad(-150.95) deg2rad(-124.56) deg2rad(-109.89)])")
rob.fkine([deg2rad(-150.95) deg2rad(-124.56) deg2rad(-109.89)])


