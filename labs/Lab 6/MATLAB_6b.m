%Lab 6
r=0.1; %m  wheel radius
L=0.5; %m  wheelbase distance
V=2; %m/s  Forward speed
Yr=0; %rad/s  Yaw rate

% Initial Conditions
hdg0=0; %rad  Initial Heading
x0=0;   %m  x position
y0=0;   %m  y position
tfin=10;  %s  simulation stop time

%Computation of the Wheel
% Right wheel angular velocity
WR=(V/r)+((L*Yr)/(2*r)); 
% Left wheel angular velocity
WL=(V/r)-((L*Yr)/(2*r)); 

out1=sim('one.slx'); % complete version
out2=sim('two.slx'); % version with subsystem