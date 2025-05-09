%% Aristotle University of Thessaloniki (AUTh)
% Department of Electrical and Computer Engineering
%% Ioannis Deirmentzoglou AEM: 10015 Email: deirmentz@ece.auth.gr 

%% Assignment 3 Part 2 Optimal Model

%% Optimal Model Parameters - Grid Search
optimalNumFeatures = 15;   % Optimal number of features to be used in the model
optimalClusterRadius = 0.4;  % Optimal cluster radius for subtractive clustering

% Import and prepare training, validation, and test datasets based on selected features
optimalTrainData = [trainData(:, featureIndices(1:optimalNumFeatures)) trainTargetData];
optimalValidationData = [validationData(:, featureIndices(1:optimalNumFeatures)) validationTargetData];
optimalTestData = [testData(:, featureIndices(1:optimalNumFeatures)) testTargetData];

% Clustering Method
clusterMethod = 'SubtractiveClustering';  % Using subtractive clustering for fuzzy rule generation

% Set up options for fuzzy inference system (FIS) generation using subtractive clustering
optimalFISoptions = genfisOptions(clusterMethod, 'ClusterInfluenceRange', optimalClusterRadius);

% Generate the initial fuzzy inference system (FIS) based on the training data and options defined
optimalInitialFIS = genfis(optimalTrainData(:, 1:end-1), trainTargetData, optimalFISoptions);

%% Plot Membership Functions Before Training
numIn = length(optimalInitialFIS.input);  % Get the number of inputs from the FIS.
for i = 1:numIn
    figure;
    plotmf(optimalInitialFIS, 'input', i);  % Plot membership functions for each input
    xlabel(['Input ' num2str(i)], 'Interpreter', 'latex');  
    ylabel('Degree of Membership', 'Interpreter', 'latex');  
    title(['Input ' int2str(i)], 'Interpreter', 'latex');  
    subtitle('Before train process', 'Interpreter', 'latex'); 
end

% Configure ANFIS training options
optimalANFISoptions = anfisOptions;
optimalANFISoptions.InitialFIS = optimalInitialFIS;  % Set the initial FIS generated earlier
optimalANFISoptions.ValidationData = optimalValidationData;  % Set validation data for training
optimalANFISoptions.EpochNumber = 100;  % Set the number of training epochs

% Train the model using ANFIS
[optimalTrainedFIS, optimalTrainError, ~, optimalValidationFIS, optimalValidationError] = anfis(optimalTrainData, optimalANFISoptions);

%% Plot Membership Functions After Training
% Plot membership functions for each input after training the FIS
numTrainIn = length(optimalTrainedFIS.input);  % Get number of inputs in the trained FIS
for i = 1:numTrainIn
    figure;
    plotmf(optimalTrainedFIS, 'input', i);  % Plot membership functions after training
    xlabel(['Input ' num2str(i)], 'Interpreter', 'latex');  
    ylabel('Degree of Membership', 'Interpreter', 'latex');  
    title(['Input ' int2str(i)], 'Interpreter', 'latex');  
    subtitle('After train process', 'Interpreter', 'latex');  
end

%% Learning Curve
figure;
grid on;
plot([optimalTrainError, optimalValidationError],'LineWidth',2);  % Plot the training and validation errors
legend('Training Error', 'Validation Error');  
xlabel('Number of Iterations', 'Interpreter', 'latex');  
ylabel('Error', 'Interpreter', 'latex'); 
legend('Training Error', 'Validation Error', 'Interpreter', 'latex');  
title('\textbf{Learning Curve}', 'Interpreter','latex');  

% Plot prediction error and compare predicted and real values
yPredOptimal = evalfis(optimalValidationFIS, optimalTestData(:, 1:end-1));  % Predict values using the validation FIS
predictionError = yPredOptimal - testTargetData;  % Calculate the prediction error

%% Real data values
% Plot scatter plot of real data values for comparison
figure;
scatter(1:length(testTargetData), testTargetData, 'Color', 'blue');  
grid on;
xlabel('Input', 'Interpreter', 'latex');  
ylabel('Real Data', 'Interpreter', 'latex');  

%% Predicted data values
% Plot scatter plot of predicted data values
figure;
scatter(1:length(yPredOptimal), yPredOptimal, 'Color', 'cyan');  
grid on;
xlabel('Input', 'Interpreter', 'latex');  
ylabel('Predicted Data', 'Interpreter', 'latex'); 
title('\textbf{Predicted Data Values}', 'Interpreter','latex'); 

%% Prediction error
% Plot the prediction error to visualize how well the model performed
figure;
plot(predictionError);  % Plot the prediction error
grid on;
title('\textbf{Prediction Error}', 'Interpreter','latex'); 
xlabel('Input', 'Interpreter', 'latex');
ylabel('Error', 'Interpreter', 'latex');  

%% Calculate the requested metrics
% Define the list of metric names for performance evaluation
metricsNames = {'MSE', 'RMSE', 'NMSE', 'NDEI', 'R2'};

% Initialize an array to store the calculated metric values
metricsValues = zeros(length(metricsNames), 1);

% Calculate different metrics based on the predicted and test data
metricsValues(1) = mse(yPredOptimal, testTargetData);  % Mean Squared Error (MSE)
metricsValues(2) = RMSE(yPredOptimal, testTargetData);  % Root Mean Squared Error (RMSE)
metricsValues(3) = NMSE(yPredOptimal, testTargetData);  % Normalized Mean Squared Error (NMSE)
metricsValues(4) = NDEI(yPredOptimal, testTargetData);  % Non-Dimensional Error Index (NDEI)
metricsValues(5) = R2(yPredOptimal, testTargetData);  % Coefficient of Determination (R-squared)

% Display the calculated metrics in a table format.
disp(array2table(metricsValues, 'VariableNames', {'Optimal Model'}, 'Rownames', metricsNames)); 

