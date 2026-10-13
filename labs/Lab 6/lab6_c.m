%% Lab 6b
w=[0,0;10,0;10,10;20,20];
V = 1;      % m/s
r = 0.1;    % wheel radius
L = 0.5;    % wheel separation
x0 = 0;    % initial 
y0 = 0;    % initial
hdg0 = 0;  % initial
tao = 0.00001;
%% task 1 moving from w1 to 2
%move from w0 to w1
d = hypot(10,0);
t1 = d/V;
yr = 0;
wr1 = V/r + (L*yr)/(2*r);
wl1 = V/r - (L*yr)/(2*r);
% turn 90 deg at w2
V = 0;
ya = deg2rad(90);
yr = 0.5;
t2 = ya/yr;
wr2 = V/r + (L*yr)/(2*r);
wl2 = V/r - (L*yr)/(2*r);
% move from w1 to w2
d = hypot(0,10);
V = 1;
t3 = d/V;
yr = 0;
wr3 = V/r + (L*yr)/(2*r);
wl3 = V/r - (L*yr)/(2*r);
% turn -45 deg
V = 0;
ya  = deg2rad(-45);
yr = -0.5;
t4 = ya/yr;
wr4 = V/r + (L*yr)/(2*r);
wl4 = V/r - (L*yr)/(2*r);
% move from w2 to w3
V = 1;
d = hypot(10,10);
t5 = d/V;
yr = 0;
wr5 = V/r + (L*yr)/(2*r);
wl5 = V/r - (L*yr)/(2*r);
tfin = t1+t2+t3+t4+t5;
%%
input_right = [0,wr1;
               t1-tao,wr1;
               t1,wr2;
               t1+t2-tao,wr2;
               t1+t2,wr3;
               t1+t2+t3-tao,wr3;
               t1+t2+t3,wr4;
               t1+t2+t3+t4-tao,wr4;
               t1+t2+t3+t4,wr5;
               t1+t2+t3+t4+t5-tao,wr5;
               t1+t2+t3+t4+t5,wr5];

input_left = [0,wl1;
              t1-tao,wl1;
              t1,wl2;
              t1+t2-tao,wl2;
              t1+t2,wl3;
              t1+t2+t3-tao,wl3;
              t1+t2+t3,wl4;
              t1+t2+t3+t4-tao,wl4;
              t1+t2+t3+t4,wl5;
              t1+t2+t3+t4+t5-tao,wl5;
              t1+t2+t3+t4+t5,wl5];
%%
simu = sim("one.slx")
%%
figure()
plot(simu.X.Data, simu.Y.Data)
hold on
plot(w(:,1),w(:,2),'ko')
xlabel('World X-axis (m)')
ylabel('World Y-axis (m)')
title('DDV Open-Loop Trajectory')
legend('Actual trajectory','Waypoints')
grid on
axis equal