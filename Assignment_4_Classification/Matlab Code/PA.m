%% Aristotle University of Thessaloniki (AUTh)
% Department of Electrical and Computer Engineering
%% Ioannis Deirmentzoglou AEM: 10015 Email: deirmentz@ece.auth.gr 

% Function that calculates Producer's Accuracy metric

function PA_Value = PA(errorMatrix)
    % Check if the input matrix is a valid confusion matrix
    if size(errorMatrix, 1) ~= size(errorMatrix, 2)
        error('Input matrix is not a valid confusion matrix.');
    end

    numClasses = size(errorMatrix, 1);
    PA_Value = zeros(numClasses, 1);

    for i = 1:numClasses
        PA_Value(i) = errorMatrix(i, i) / sum(errorMatrix(:, i));
    end
end
