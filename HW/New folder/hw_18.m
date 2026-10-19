% Given system
s = tf('s');
Gsys = 100/(s*(s+4));

% Specifications
ts_max = 4;
PO_max = 2;

% Root locus
figure();
rlocus(Gsys)
title('HW18 - Root Locus')

% 
zeta = 0.7797;
sigma_d = 1;
theta_zeta = 38.8;
omega_d = 0.8029;

hold on

% sd's
sd_1 = -1;
plot(real(sd_1), imag(sd_1), 'rx')
sd_2 = -2+1.608i;
plot(real(sd_2), imag(sd_2), 'rx')
sd_3 = -2;
plot(real(sd_3), imag(sd_3), 'rx')
sd_4 = -2+1.4i;
plot(real(sd_4), imag(sd_4), 'rx')

% plot the line trough zero to the root locus to show wheere po = 2% is saisfied
plot([0 real(sd_2)], [0 imag(sd_2)], '--m')

hold off

% solve for all k
sd = [sd_1,sd_2,sd_3,sd_4];
K = [];
for i = 1:length(sd)
    G = evalfr(Gsys, sd(i));
    gain = 1/abs(G);
    K(end+1) = gain;
end

% compute setling timw and po usijng T?(S)=p/(1-L)
ts = [];
PO = [];
for i = 1:length(K)
    T = feedback(K(i)*Gsys,1);
    info = stepinfo(T);

    ts(end+1) = info.SettlingTime;
    PO(end+1) = info.Overshoot;
end
