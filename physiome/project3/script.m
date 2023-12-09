ax = 0.04;
ag = 0.03;
Kx = [20 10];
Kg = 0.1 * Kx;

figure;
f = @(t, z) [
    -ax * z(1) + ax*z(2);                   % eqn 17
    -ax * z(2) + Kx(1) * ax ;                % eqn 18 
    -z(1) + z(4);                           % eqn 14
    z(5);                                   % eqn 15
    -2*ag*z(5) - ag^2 * z(4) + Kg(1) * ag^2  % eqn 16
    ];
BG_u = ode45(f, 1:1:930, [0 0 90 0 0]);
plot(BG_u.x, BG_u.y)