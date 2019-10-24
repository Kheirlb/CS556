n = 5000;
theta2high = 90;
theta2low = -90;

for idx = 1:n
    theta2rand(idx) = (theta2high-theta2low).*rand(1,1) + theta2low;
end 