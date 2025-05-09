%% Aristotle University of Thessaloniki (AUTh)
% Department of Electrical and Computer Engineering
%% Ioannis Deirmentzoglou AEM: 10015 Email: deirmentz@ece.auth.gr 
% Function to calculate the R2 metric
function R2value = R2(yPred, y)
    R2value = 1-sum((y - yPred).^2)/sum((y - mean(y)).^2);
end
