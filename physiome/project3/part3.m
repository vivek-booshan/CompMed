% branchless hand solution using integer replacements for coefficients
CF = @(t) ((90 - 55) ./ (1 + exp((t - 180)/15))).*(t > 90) + 90*(t < 91) + 55*(t > 90);
MS = @(t) ((170 - 90) ./ (1 + exp(-(t - 180)/15))).*(t > 90) + 90;
subplot(2, 1, 1);
plot(t, CF(t)); grid;
axis([0 930 50 100])
title("BG Concentration")
ylabel("BG concentration (mg/dl)");
subplot(2, 1, 2);
plot(t, MS(t)); grid;
axis([0 930 80 180]);
ylabel("BG concentration (mg/dl)");
xlabel("Time (min)");
