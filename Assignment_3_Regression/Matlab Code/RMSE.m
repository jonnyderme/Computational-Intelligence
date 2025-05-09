%% Aristotle University of Thessaloniki (AUTh)
% Department of Electrical and Computer Engineering
%% Ioannis Deirmentzoglou AEM: 10015 Email: deirmentz@ece.auth.gr 
% Function to calculate the RMSE metric
function RMSEvalue = RMSE(yPred, y)
    RMSEvalue = sqrt(mse(yPred, y));
end