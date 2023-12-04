function [max_alpha]= test_performance(phat,y)

%This function stakes in models for each patient (phat) and the actual patient
%classes (y), and computes an array of confusion matrices (C) for different
%thresholds alphas

alphas = (0:0.01:1)';
C = zeros(2, 2, 101);

for i=1:length(alphas)  %threshold loop
    
    thresh = alphas(i);
    
    yhat = zeros(length(y), 1);
    for p = 1:length(y)  %patient loop
        
        if(phat(p) >= thresh)
            yhat(p)=1;
        else
            yhat(p)=0;
        end
        
        % populate confusion matrix
        if (y(p) && yhat(p))
            C(1, 1, i) = C(1, 1, i) + 1;
        elseif (y(p))
            C(2, 1, i) = C(2, 1, i) + 1;
        elseif (yhat(p))
            C(1, 2, i) = C(1, 2, i) + 1;
        else
            C(2, 2, i) = C(2, 2, i) + 1;
        end

    end

end


tpr = C(1, 1, :) ./ sum(C(:, 1, :)); 
tpr = reshape(tpr, [1, length(alphas)]);

fpr = 1 - C(2, 2, :) ./ sum(C(:, 2, :)); 
fpr = reshape(fpr, [1, length(alphas)]);

accuracy = (C(1, 1, :) + C(2, 2, :)) ./ sum(sum(C(:, :, :)));
accuracy = reshape(accuracy, [1, length(alphas)]);


[max_acc, I] = max(accuracy);
max_alpha = alphas(I);

AUC = abs(trapz(fpr, tpr));
figure;
clf
plot(fpr, tpr)
hold on 
plot(fpr(I), tpr(I), 'r*');
hline = plot(0:0.001:1, 0:0.001:1, 'r:');
legend(hline, 'line of no discrimination')
legend('boxoff')
hold off
xlabel('False Positive (1 - Specificity)')
ylabel('True Positive (Sensitivity)')
title('ROC Curve');
text(fpr(I), tpr(I)-0.1,...
    sprintf('max accuracy = %f\nalpha = %f', max_acc, max_alpha));
text(0.75, 0.25, sprintf('AUC = %f', AUC));

        
