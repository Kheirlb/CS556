function [condition] = checkRangeThetas(t1,t2)
condition = false;

global theta1low theta1high theta2low theta2high

if (t1 >= theta1low && t1 <= theta1high)
    if (t2 >= theta2low && t2 <= theta2high)
        condition = true;
    end
end
end

