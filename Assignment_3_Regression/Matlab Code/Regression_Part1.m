%% Aristotle University of Thessaloniki (AUTh)
% Department of Electrical and Computer Engineering
%% Ioannis Deirmentzoglou AEM: 10015 Email: deirmentz@ece.auth.gr 

%% Assignment 3 Part 1 
% Import dataset from the specified path
dataset = importdata('C:\Thmmy_Auth\Computational_Intelligence\Datasets\airfoil_self_noise.dat');

% Dataset split into 60% training, 20% validation, and 20% testing sets
[trainData, validationData, testData] = split_scale(dataset, 1);  
trainTargetData = trainData(:, end);  % Target values for training set (last column)
validationTargetData = validationData(:, end);  % Target values for validation set
testTargetData = testData(:, end);  % Target values for test set

% Array to hold the names of the models
modelNames = {};

% Initialize options for different TSK models

%% TSK Model 1: Grid Partitioning with 2 generalized bell-shaped membership functions
modelNames{1} = 'TSK_Model_1';  
FISoptions(1) = genfisOptions('GridPartition');  % Using grid partitioning to generate fuzzy rules
FISoptions(1).InputMembershipFunctionType = 'gbellmf';  % Generalized bell-shaped MF
FISoptions(1).NumMembershipFunctions = 2;  % 2 membership functions for each input
FISoptions(1).OutputMembershipFunctionType = 'constant';  % Output MF type is constant (singleton)
initialFIS(1) = genfis(trainData(:, 1:end-1), trainTargetData, FISoptions(1));  % Generate initial FIS for model 1

%% TSK Model 2: Grid Partitioning with 3 generalized bell-shaped membership functions
modelNames{2} = 'TSK_Model_2';
FISoptions(2) = genfisOptions('GridPartition');
FISoptions(2).InputMembershipFunctionType = 'gbellmf';  % Bell-shaped MFs
FISoptions(2).NumMembershipFunctions = 3;  % 3 membership functions per input for model 2
FISoptions(2).OutputMembershipFunctionType = 'constant';  % Output MF type is constant
initialFIS(2) = genfis(trainData(:, 1:end-1), trainTargetData, FISoptions(2));  % Generate FIS for model 2

%% TSK Model 3: Grid Partitioning with 2 generalized bell-shaped membership functions, linear output
modelNames{3} = 'TSK_Model_3';
FISoptions(3) = genfisOptions('GridPartition');
FISoptions(3).InputMembershipFunctionType = 'gbellmf';  % Bell-shaped MFs
FISoptions(3).NumMembershipFunctions = 2;  % 2 membership functions per input
FISoptions(3).OutputMembershipFunctionType = 'linear';  % Linear output MF type (polynomial for more complexity)
initialFIS(3) = genfis(trainData(:, 1:end-1), trainTargetData, FISoptions(3));  % Generate FIS for model 3

%% TSK Model 4: Grid Partitioning with 3 generalized bell-shaped membership functions, linear output
modelNames{4} = 'TSK_Model_4';
FISoptions(4) = genfisOptions('GridPartition');
FISoptions(4).InputMembershipFunctionType = 'gbellmf';  % Bell-shaped MFs
FISoptions(4).NumMembershipFunctions = 3;  % 3 membership functions per input
FISoptions(4).OutputMembershipFunctionType = 'linear';  % Linear output MF type
initialFIS(4) = genfis(trainData(:, 1:end-1), trainTargetData, FISoptions(4));  % Generate FIS for model 4

% Number of TSK models created
numModels = length(initialFIS);

% Define performance metrics to be calculated: MSE, RMSE, NMSE, NDEI, R2
metricsNames = {'MSE', 'RMSE', 'NMSE', 'NDEI', 'R2'};
metricsValues = nan(length(metricsNames), numModels) ;  % Initialize matrix to store metric results

% Set ANFIS (Adaptive Neuro-Fuzzy Inference System) options
ANFISoptions = anfisOptions;
ANFISoptions.ValidationData = validationData;  % Use validation data for checking generalization
ANFISoptions.EpochNumber = 100;  % Set number of training iterations (epochs)

% Loop over each model to train and evaluate them
for i = 1:numModels
    % Set initial FIS for the current model
    ANFISoptions.InitialFIS = initialFIS(i);
    
    % Train ANFIS model and capture training and validation errors
    [~, trainError(:, i), ~, validationFIS(i), validationError(:, i)] = anfis(trainData, ANFISoptions);

    % Plot membership functions for each input in the model
    for j = 1:size(trainData, 2) - 1
        figure;
        plotmf(validationFIS(i), 'input', j);  % Plot membership functions of each input
        xlabel(['Input ' num2str(j)], 'Interpreter', 'latex');
        ylabel('Degree of Membership', 'Interpreter', 'latex');
        title(['Input ' int2str(j)], 'Interpreter', 'latex');
        subtitle(['TSK\_model\_' num2str(i)], 'Interpreter', 'latex');
    end

    % Plot the learning curve (training vs validation error)
    figure;
    plot([trainError(:, i) validationError(:, i)]);
    grid on;
    xlabel('Number of Iterations', 'Interpreter', 'latex');
    ylabel('Error', 'Interpreter', 'latex');
    legend('Training Error', 'Validation Error', 'Interpreter', 'latex');
    title('\textbf{Learning Curve}', 'Interpreter', 'latex');
    subtitle(['TSK\_model\_' num2str(i)], 'Interpreter', 'latex');

    % Evaluate the model on test data to compute prediction error
    yPred(:, i) = evalfis(validationFIS(i), testData(:, 1:end-1));  % Predicted values for the test data
    predictionError(:, i) = yPred(:, i) - testTargetData;  % Calculate prediction error (actual - predicted)

    % Plot prediction error for the current model
    figure;
    plot(predictionError(:, i));
    grid on;
    xlabel('Input', 'Interpreter', 'latex');
    ylabel('Error', 'Interpreter', 'latex');
    title('\textbf{Prediction Error}', 'Interpreter', 'latex');
    subtitle(['TSK\_model\_' num2str(i)], 'Interpreter', 'latex');

    % Calculate the requested performance metrics (MSE, RMSE, NMSE, NDEI, R2)
    metricsValues(1, i) = mse(yPred(:, i), testTargetData);  % Mean Squared Error (MSE)
    metricsValues(2, i) = RMSE(yPred(:, i), testTargetData);  % Root Mean Squared Error (RMSE)
    metricsValues(3, i) = NMSE(yPred(:, i), testTargetData);  % Normalized Mean Squared Error (NMSE)
    metricsValues(4, i) = NDEI(yPred(:, i), testTargetData);  % Non-Dimensional Error Index (NDEI)
    metricsValues(5, i) = R2(yPred(:, i), testTargetData);  % Coefficient of determination (R-squared)
end

% Display the calculated metrics for each model
disp(array2table(metricsValues, 'VariableNames', modelNames, 'Rownames', metricsNames));
