%% Aristotle University of Thessaloniki (AUTh)
% Department of Electrical and Computer Engineering
%% Ioannis Deirmentzoglou AEM: 10015 Email: deirmentz@ece.auth.gr 

%% Assignment 4 Part 2 Optimal Model

%% Optimal Model Parameters - Grid Search Results
% These parameters are determined from a grid search for optimal model tuning.
optimalNumFeatures = 15;  % Number of optimal features to use in the model
optimalclusterRadius = 0.4;  % Radius used for the clustering algorithm

% Load the data obtained from the grid search process.
%load('part2Class.mat');

% Preparing training, validation, and test datasets using the selected optimal features.
optimalTrainData = [trainData(:, featureIndices(1:optimalNumFeatures)) trainTargetData];
optimalValidationData = [validationData(:,featureIndices(1:optimalNumFeatures)) validationTargetData];    
optimalTestData = [testData(:, featureIndices(:,1:optimalNumFeatures)) testTargetData];

%% Clustering Per Class
% For each class, cluster the data based on the optimal features and cluster radius.
% Class 1 Clustering
optimalCluster1InputData = optimalTrainData(optimalTrainData(:, end) == 1, :);
[optimalClusterCenters1, optimalSigma1] = subclust(optimalCluster1InputData, j); % Generate cluster centers and sigma for class 1

% Class 2 Clustering
optimalCluster2InputData = optimalTrainData(optimalTrainData(:, end) == 2, :);
[optimalClusterCenters2, optimalSigma2] = subclust(optimalCluster2InputData, j); % Generate cluster centers and sigma for class 2

% Class 3 Clustering
optimalCluster3InputData = optimalTrainData(optimalTrainData(:, end) == 3, :);
[optimalClusterCenters3, optimalSigma3] = subclust(optimalCluster3InputData, j); % Generate cluster centers and sigma for class 3

% Class 4 Clustering
optimalCluster4InputData = optimalTrainData(optimalTrainData(:, end) == 4, :);
[optimalClusterCenters4, optimalSigma4] = subclust(optimalCluster4InputData, j); % Generate cluster centers and sigma for class 4

% Class 5 Clustering
optimalCluster5InputData = optimalTrainData(optimalTrainData(:, end) == 5, :);
[optimalClusterCenters5, optimalSigma5] = subclust(optimalCluster5InputData, j); % Generate cluster centers and sigma for class 5

% Calculate the total number of rules by summing the number of clusters for each class.
numRules = size(optimalClusterCenters1, 1) + size(optimalClusterCenters2, 1) + size(optimalClusterCenters3, 1) + size(optimalClusterCenters4, 1) + size(optimalClusterCenters5, 1);

% Create a Sugeno FIS model
optimalInitialFIS = sugfis;

%% ------------- Input -------------------
% For each feature in the dataset, define the input membership functions.
for i = 1:size(optimalTrainData, 2) - 1
    % Add input variables to the FIS
    optimalInitialFIS = addInput(optimalInitialFIS, [0, 1], 'Name', sprintf("in%d", i));

    % Add Gaussian membership functions for each cluster of each class
    for j = 1:size(optimalClusterCenters1, 1)
        optimalInitialFIS = addMF(optimalInitialFIS, sprintf("in%d", i), 'gaussmf', [optimalSigma1(i) optimalClusterCenters1(j, i)]);
    end
    for j = 1:size(optimalClusterCenters2, 1)
        optimalInitialFIS = addMF(optimalInitialFIS, sprintf("in%d", i), 'gaussmf', [optimalSigma2(i) optimalClusterCenters2(j, i)]);
    end
    for j = 1:size(optimalClusterCenters3, 1)
        optimalInitialFIS = addMF(optimalInitialFIS, sprintf("in%d", i), 'gaussmf', [optimalSigma3(i) optimalClusterCenters3(j, i)]);
    end
    for j = 1:size(optimalClusterCenters4, 1)
        optimalInitialFIS = addMF(optimalInitialFIS, sprintf("in%d", i), 'gaussmf', [optimalSigma4(i) optimalClusterCenters4(j, i)]);
    end
    for j = 1:size(optimalClusterCenters5, 1)
        optimalInitialFIS = addMF(optimalInitialFIS, sprintf("in%d", i), 'gaussmf', [optimalSigma5(i) optimalClusterCenters5(j, i)]);
    end
end

%% ------------- Output -------------
% Define the output membership function for classification results.
optimalInitialFIS = addOutput(optimalInitialFIS, [0, 1], 'Name', 'out1');

% Add output membership functions, set to 'constant' type
outputMembershipFunctionType = 'constant'; % Singleton output functions
optimalParams = [zeros(1, size(optimalClusterCenters1, 1)) 0.25*ones(1, size(optimalClusterCenters2, 1)) 0.5*ones(1, size(optimalClusterCenters3, 1)) 0.75*ones(1, size(optimalClusterCenters4, 1)) ones(1, size(optimalClusterCenters5, 1))];
for i = 1:numRules
    optimalInitialFIS = addMF(optimalInitialFIS, 'out1', outputMembershipFunctionType, optimalParams(i));
end

%% ------------- Rulebase -------------
% Add rules to the FIS. Each rule is represented as a row in the rulesList.
rulesList = zeros(numRules, size(optimalTrainData, 2));  % Initialize rule matrix
for i = 1:size(rulesList, 1)
    rulesList(i, :) = i;  % Set the rule index for each rule
end
rulesList = [rulesList ones(numRules, 2)];  % Append additional columns for rule weights and outputs
optimalInitialFIS = addrule(optimalInitialFIS, rulesList);

%% Plot Membership Functions Before Training
% Plot the initial membership functions for each input variable
numIn = length(optimalInitialFIS.input);
for i = 1:numIn
    figure;
    plotmf(optimalInitialFIS, 'input', i);
    xlabel(['Input ' num2str(i)], 'Interpreter', 'latex');
    ylabel('Degree of Membership', 'Interpreter', 'latex');
    title(['Input ' int2str(i)], 'Interpreter', 'latex');
    subtitle('Membership Function before training', 'Interpreter', 'latex');
end

%% FIS Options
% Set ANFIS training options.
opti_ANFISoptions = anfisOptions;
opti_ANFISoptions.InitialFIS = optimalInitialFIS;  % Use the initial FIS for training
opti_ANFISoptions.EpochNumber = 100;  % Set number of training epochs
opti_ANFISoptions.ValidationData = optimalValidationData;  % Set validation data

% Train the FIS using the training data and options specified.
[optimalTrainedFIS, optimalTrainError, ~, optimalValidationFIS, optimalValidationError] = anfis(optimalTrainData, opti_ANFISoptions);

%% Plot Membership Functions After Training
% Plot the membership functions for each input variable after training.
numTrainIn = length(optimalTrainedFIS.input);
for i = 1:numTrainIn
    figure;
    plotmf(optimalTrainedFIS, 'input', i);
    xlabel(['Input ' num2str(i)], 'Interpreter', 'latex');
    ylabel('Degree of Membership', 'Interpreter', 'latex');
    title(['Input ' int2str(i)], 'Interpreter', 'latex');
    subtitle('Membership Function after training', 'Interpreter', 'latex');
end

%% Evaluation: Predicted vs Actual Values
% Predict the outputs for the test data using the trained FIS.
yPredOptimal = evalfis(optimalValidationFIS, optimalTestData(:, 1:end-1));
yPredOptimal = round(yPredOptimal);  % Round predictions to nearest class

% Ensure predictions are within the valid range (1 to 5).
yPredOptimal = max(min(yPredOptimal, 5), 1);
predictionError = yPredOptimal - testTargetData;  % Calculate the prediction error

%% Plot Real Data Values
figure;
scatter(1:length(testTargetData), testTargetData, 'Color', 'blue');  % Scatter plot of actual test values
grid on;
xlabel('Input', 'Interpreter', 'latex');
ylabel('Real Data', 'Interpreter', 'latex');

%% Plot Predicted Data Values
figure;
scatter(1:length(yPredOptimal), yPredOptimal, 'Color', 'cyan');  % Scatter plot of predicted values
grid on;
xlabel('Input', 'Interpreter', 'latex');
ylabel('Predicted Data', 'Interpreter', 'latex');

%% Confusion Matrix
% Calculate and display the confusion matrix to evaluate the classification performance.
errorMatrix = confusionmat(testTargetData, yPredOptimal);
figure;
confusionMatrix = confusionchart(errorMatrix);

%% Learning Curve
% Plot the learning curve, showing training and validation errors over epochs.
figure;
grid on;
plot([optimalTrainError, optimalValidationError], 'Linewidth', 2);
legend('Training Error', 'Validation Error');
xlabel('Number of Iterations', 'Interpreter', 'latex');
ylabel('Error', 'Interpreter', 'latex');
title('\textbf{Learning Curve}', 'Interpreter', 'latex');

%% Learning Curve
figure;
grid on;
plot([optimalTrainError, optimalValidationError],'Linewidth',2); 
legend('Training Error', 'Validation Error');
xlabel('Number of Iterations', 'Interpreter', 'latex'); 
ylabel('Error', 'Interpreter', 'latex');
legend('Training Error', 'Validation Error', 'Interpreter', 'latex');
title('\textbf{Learning Curve}', 'Interpreter','latex');

%% Prediction error
figure;
plot(predictionError);
grid on;
title('\textbf{Prediction Error}', 'Interpreter','latex');
xlabel('Input', 'Interpreter', 'latex'); 
ylabel('Error', 'Interpreter', 'latex');

%% Calculation and Display of the requested metrics
OA_metric = OA(errorMatrix);
PA_metric = PA(errorMatrix);
UA_metric = UA(errorMatrix); 
K_hat_metric = K_hat(errorMatrix);

% Display Metrics Results 
disp(array2table(OA_metric, 'VariableNames', {'Optimal values model'}, 'Rownames', {'OA'}));
disp(array2table(PA_metric, 'VariableNames', {'Optimal values model'}, 'Rownames', {'PA(1)', 'PA(2)', 'PA(3)', 'PA(4)', 'PA(5)'}));
disp(array2table(UA_metric, 'VariableNames', {'Optimal values model'}, 'Rownames', {'UA(1)', 'UA(2)', 'UA(3)', 'UA(4)', 'UA(5)'}));
disp(array2table(K_hat_metric, 'VariableNames', {'Optimal values model'}, 'Rownames', {'K_hat'}));
