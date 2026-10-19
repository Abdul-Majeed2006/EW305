s = tf('s');
Gsys = 100/(s*(s+20)*(s+100));
figure;
rlocus(Gsys);
title('HW16 Root Locus');
xlabel('Real Axis');
ylabel('Imaginary Axis');
