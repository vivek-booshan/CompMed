function [max_alpha]= test_performance(phat,y)

%This function stakes in models for each patient (phat) and the actual patient
%classes (y), and computes an array of confusion matrices (C) for different
%thresholds alphas

alphas = [0:0.01:1]';
C = [];

for i=1:length(alphas)  %threshold loop
   
    C{i} = zeros(2,2);
    
    thresh = alphas(i);
    
    for p=1:length(y)  %patient loop
        
        if(phat(p)>= thresh)
            yhat(p)=1;
        else
            yhat(p)=0;
        end
    
        %populate confusion matrix
        if(y(p)==1 && yhat(p)==1)   %true positive
            C{i}(1,1) = C{i}(1,1)+1;
        elseif(y(p)==1 && yhat(p)==0) %false negative
            C{i}(2,1) = C{i}(2,1)+1;
        elseif(y(p)==0 && yhat(p)==1) %false positive
            C{i}(1,2) = C{i}(1,2)+1;
        elseif(y(p)==0 && yhat(p)==0) %true negative
            C{i}(2,2) = C{i}(2,2)+1;
        end
    end

end

%plot ROC curve and compute AUC
for i=1:length(alphas)
    
    %%% CHANGE %%%
    tpr(i) = (C{i}(1,1))/(C{i}(1,1)+C{i}(2,1)) ;
    fpr(i) = 1 - (C{i}(2,2))/(C{i}(1,2)+C{i}(2,2)) ;
    %%% CHANGE %%%

    accuracy(i) = (C{i}(1,1)+ C{i}(2,2))/sum(sum(C{i})); 

end

[max_acc, I] = max(accuracy);
max_alpha = alphas(I);

AUC = abs(trapz(fpr, tpr));
figure(2)
clf
plot(fpr, tpr)
hold on 
plot(fpr(I), tpr(I), 'g*');
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

        