%%% [INCOMPLETE] PROBLEM 3 (credit: project3_tips.pdf; Luis Sanchez)
syms kg ag G s
%%%%%% PARAMETERS %%%%%%
G = 90;
ax = 0.04; 
ag = 0.03;
% Kx / Kg = 10
Kx = 100;
kg = 0.1 * Kx;

F1 = (1/s) * kg/(1 + s*(1/ag) )^2 + (1/s)*G;
f1 = ilaplace(F1);

t = 1:1:930;

f1_result = G + kg - kg*exp(-ag*t) - ag*kg*t.*exp(-ag*t);

plot(t, f1_result)
ylim([80 180])

