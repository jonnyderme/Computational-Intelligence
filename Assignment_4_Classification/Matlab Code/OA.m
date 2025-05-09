%% Aristotle University of Thessaloniki (AUTh)
% Department of Electrical and Computer Engineering
%% Ioannis Deirmentzoglou AEM: 10015 Email: deirmentz@ece.auth.gr 

% Function that calculates Overall Accuracy metric
function OA_Value = OA(errorMatrix)
    
    % Check if the input matrix is a valid confusion matrix
    if size(errorMatrix, 1) ~= size(errorMatrix, 2)
        error('Input matrix is not a valid confusion matrix.');
    end
    OA_Value = trace(errorMatrix) / sum(errorMatrix, "all");
end