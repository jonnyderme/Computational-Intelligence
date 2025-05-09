%% Aristotle University of Thessaloniki (AUTh)
% Department of Electrical and Computer Engineering
%% Ioannis Deirmentzoglou AEM: 10015 Email: deirmentz@ece.auth.gr 
% Function to calculate the NDEI metric
function NDEIvalue = NDEI(yPred, y)
    NDEIvalue = sqrt(NMSE(yPred, y));
end