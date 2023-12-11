%%% SIMULATE INSULIN BOLUS AFTER A MEAL %%%

%%%%%% PARAMETERS %%%%%%
ax = 0.04; 
ag = 0.03;
% Kx / Kg = 10
Kx = [20 10];
Kg = 0.1 * Kx;
% simulate up to 930 minutes
tspan = 1:1:930;

%%%% INSULIN AFTER MEAL %%%%%
U1 = @(t) 2*(floor(t) == 180);    % branchless definition
Ucho = @(t) 20*(floor(t) == 90); % branchless definition
f = @(t,z,i) [
    -ax*z(1) + ax*z(2);                            %eqn 17 (dX)
    -ax*z(2) + Kx(i)*ax*U1(t);                     %eqn 18 (dX1)
    -z(1) + z(4);                                  %eqn 14 (dG)
     z(5);                                         %eqn 15 (dUg)
    -2*ag*z(5) - ag^2*z(4) + Kg(i)*ag^2 * Ucho(t); %eqn 16 (ddUg)
];

subplot(2, 1, 1);
hold on;
for i = 1:2
    BG_u = ode4(f, tspan, [0 0 90 0 0], i); % credit: Luis Sanchez
    plot(tspan, BG_u(:, 3));
end
title('Bock et al Fig 4')
subtitle("[BG] with meal and bolus")
xlabel('Time (min)')
axis([0 930 45 130])
ylabel('BG concentration (mg/dl)')
grid;
legend('Kx = 20','Kx = 10','Location','SouthEast')
