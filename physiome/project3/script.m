ax = 0.04;
ag = 0.03;
Kx = [20 10];
Kg = 0.1 * Kx;
UI = 2; Ucho = 10 * UI
figure;
f = @(t, z) [
    -ax * z(1) + ax*z(2);                   % eqn 17
    -ax * z(2) + Kx(1) * ax * UI ;                % eqn 18 
    -z(1) + z(4);                           % eqn 14
    z(5);                                   % eqn 15
    -2*ag*z(5) - ag^2 * z(4) + Kg(1) * ag^2 * Ucho % eqn 16
    ];
BG_u = ode45(f, 1:1:930, [0 0 90 0 0]);
plot(BG_u.x, BG_u.y)

%%
syms kg ag G s;
F1 = (1/s) * (kg / (1 + s*(1/ag))^2) + (1/s)*G;
f1 = ilaplace(F1);

t = 1:1:930;
G = 90;
kg = 2;
ag = 0.03;
f1 = G + kg + kg*exp(-ag*t) - ag*kg*t.*exp(-ag*t);
plot(t, f1);