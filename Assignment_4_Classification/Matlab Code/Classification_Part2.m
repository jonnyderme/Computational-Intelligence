%% Aristotle University of Thessaloniki (AUTh)
% Department of Electrical and Computer Engineering
%% Ioannis Deirmentzoglou AEM: 10015 Email: deirmentz@ece.auth.gr 

%% Assignment 4 Part 2 
%% Assignment 4 Part 2 
% Import dataset from the specified path
dataset = csvread('C:\Thmmy_Auth\Computational_Intelligence\Datasets\epileptic_seizure_data.csv',1,1);
datasetTarget = dataset(:, end);  % Target values (last column of the dataset)

% Dataset split into 60% training, 20% validation, and 20% testing sets
[trainData, validationData, testData] = split_scale(dataset, 1);
trainTargetData = trainData(:, end);  % Target values for the training set
validationTargetData = validationData(:, end);  % Target values for the validation set
testTargetData = testData(:, end);  % Target values for the test set

%% Grid Search Algorithm
% Initialization of variables for grid search to find the optimal number of features and cluster radius.
% The objective is to minimize Mean Squared Error (MSE).

% Array of different numbers of features to evaluate
numFeatures = [4 8 10 12 15]; % Different numbers of top features to use

% Array of different cluster radii to evaluate for subtractive clustering
clusterRadius = [0.2 0.4 0.6 0.8 1]; % Values that control the spread of clusters

metricsValues = zeros(length(numFeatures), length(clusterRadius), 4); % Initialize to store the calculated metrics

% Number of folds for k-fold cross-validation
folds = 5; % Cross-validation fold number
numClasses = 5; % Number of target classes in the dataset

% Features selection using the ReliefF algorithm with k nearest neighbors
numOfNearestNeighbors = 10;
[featureIndices, featureW] = relieff(dataset(:, 1:end-1), datasetTarget, numOfNearestNeighbors, 'method', 'classification');

outputMembershipFunctionType = 'constant'; % Output membership function type for the fuzzy system (singleton output)
OAValues = zeros(length(numFeatures), length(clusterRadius)); % Initialize for Overall Accuracy (OA) values
UAValues = zeros(length(numFeatures), length(clusterRadius), numClasses); % Initialize for User Accuracy (UA) values
PAValues = zeros(length(numFeatures), length(clusterRadius), numClasses); % Initialize for Producer Accuracy (PA) values
K_hatValues = zeros(length(numFeatures), length(clusterRadius)); % Initialize for Kappa coefficient (K-hat) values

MSEValues = zeros(length(numFeatures), length(clusterRadius)); % Initialize for grid MSEs
numRulesMat = zeros(length(numFeatures), length(clusterRadius)); % Initialize to store number of fuzzy rules generated

% Initialize counters
iCount = 1; 
for i = numFeatures
    % Create a temporary training and testing dataset for the current number of features
    trainDataTemp = [trainData(:, featureIndices(1:i)) trainTargetData];
    testDataTemp = [testData(:, featureIndices(1:i)) testTargetData];
    
    jCount = 1;
    for j = clusterRadius
        % Define a random partition on the dataset for cross-validation
        % This will split the dataset into training and test sets for each fold
        cvObj = cvpartition(trainDataTemp(:, end), 'KFold', folds);

        % Array to store metrics for each fold of cross-validation
        cvOA = zeros(1, folds); % Initialize for overall accuracy in each fold
        cvUA = zeros(folds, numClasses); % Initialize for user accuracy in each fold
        cvPA = zeros(folds, numClasses); % Initialize for producer accuracy in each fold
        cvK_hat = zeros(1, folds); % Initialize for Kappa coefficient in each fold

        % Initialize for MSE and number of rules for each fold
        cvMSE = zeros(folds, 1); 
        rulesNum_k = zeros(folds, 1); 
        
        for k = 1:folds
            % Extract training and validation data for the current fold
            cv_trainData = trainDataTemp(training(cvObj, k), :);
            cv_trainTargetData = cv_trainData(:, end);
            cv_validationData = trainDataTemp(test(cvObj, k), :);

            % Perform subtractive clustering per class (clustering data based on the output class)
            cluster1InputData = trainDataTemp(trainDataTemp(:, end) == 1, :);
            [clusterCenters1, sigma1] = subclust(cluster1InputData, j); % Cluster class 1

            cluster2InputData = trainDataTemp(trainDataTemp(:, end) == 2, :);
            [clusterCenters2, sigma2] = subclust(cluster2InputData, j); % Cluster class 2

            cluster3InputData = trainDataTemp(trainDataTemp(:, end) == 3, :);
            [clusterCenters3, sigma3] = subclust(cluster3InputData, j); % Cluster class 3

            cluster4InputData = trainDataTemp(trainDataTemp(:, end) == 4, :);
            [clusterCenters4, sigma4] = subclust(cluster4InputData, j); % Cluster class 4

            cluster5InputData = trainDataTemp(trainDataTemp(:, end) == 5, :);
            [clusterCenters5, sigma5] = subclust(cluster5InputData, j); % Cluster class 5

            % Calculate the total number of rules from all clusters
            numRules = size(clusterCenters1, 1) + size(clusterCenters2, 1) + size(clusterCenters3, 1) + size(clusterCenters4, 1) + size(clusterCenters5, 1);

            % Create an initial fuzzy inference system (FIS) of type Sugeno
            initialFIS = sugfis;

            % ------------- Input -------------------
            % Add input variables and membership functions for each input feature
            for n = 1:size(trainDataTemp, 2) - 1
                % Add input variable
                initialFIS = addInput(initialFIS, [0, 1], 'Name', sprintf("in%d", n));

                % Add Gaussian membership functions for the clusters of each class
                for m = 1:size(clusterCenters1, 1)    
                    initialFIS = addMF(initialFIS, sprintf("in%d", n), 'gaussmf', [sigma1(n) clusterCenters1(m, n)]);
                end
                for m = 1:size(clusterCenters2, 1)
                    initialFIS = addMF(initialFIS, sprintf("in%d", n), 'gaussmf', [sigma2(n) clusterCenters2(m, n)]);
                end
                for m = 1:size(clusterCenters3, 1)
                    initialFIS = addMF(initialFIS, sprintf("in%d", n), 'gaussmf', [sigma3(n) clusterCenters3(m, n)]);
                end
                for m = 1:size(clusterCenters4, 1)
                    initialFIS = addMF(initialFIS, sprintf("in%d", n), 'gaussmf', [sigma4(n) clusterCenters4(m, n)]);
                end
                for m = 1:size(clusterCenters5, 1)
                    initialFIS = addMF(initialFIS, sprintf("in%d", n), 'gaussmf', [sigma5(n) clusterCenters5(m, n)]);
                end
            end

            % ------------- Output -------------------
            % Add output variable (target class prediction)
            initialFIS = addOutput(initialFIS, [0, 1], 'Name', 'out1');

            % Add output membership functions (constant type)
            params = [zeros(1, size(clusterCenters1, 1)), 0.25*ones(1, size(clusterCenters2, 1)), ...
                      0.5*ones(1, size(clusterCenters3, 1)), 0.75*ones(1, size(clusterCenters4, 1)), ...
                      ones(1, size(clusterCenters5, 1))];
            for n = 1:numRules
                initialFIS = addMF(initialFIS, 'out1', outputMembershipFunctionType, params(n));
            end

            % ----------- Rulebase -------------------
            % Create a rule base where each rule corresponds to a combination of input features and their clusters
            rulesList = zeros(numRules, size(cv_trainData, 2));
            for n = 1:size(rulesList, 1)
                rulesList(n, :) = n;
            end
            rulesList = [rulesList ones(numRules, 2)]; % Each rule is active (weight = 1)
            initialFIS = addrule(initialFIS, rulesList); % Add the rules to the FIS

            % FIS training options
            ANFISoptions = anfisOptions;
            ANFISoptions.InitialFIS = initialFIS;
            ANFISoptions.EpochNumber = 50; % Number of training epochs
            ANFISoptions.ValidationData = cv_validationData; % Use validation data for ANFIS training

            % Train the FIS using ANFIS algorithm
            [~, ~, ~, validationFIS, ~] = anfis(cv_trainData, ANFISoptions);

            % Evaluate the trained FIS model on the test data
            yPred = evalfis(validationFIS, testDataTemp(:, 1:end-1));
            yPred = round(yPred); % Round the predictions to nearest integer (for classification)

            % Ensure the predictions are within the valid class range (1 to 5)
            yPred = max(min(yPred, 5), 1);

            % Calculate confusion matrix for classification results
            errorMatrix = confusionmat(testDataTemp(:, end), yPred);

            % Calculate accuracy metrics (OA, UA, PA, and Kappa coefficient)
            cvOA(:,k) = OA(errorMatrix); 
            cvUA(:,k) = UA(errorMatrix);
            cvPA(:,k) = PA(errorMatrix);
            cvK_hat(:,k) = K_hat(errorMatrix);

            % Save the number of rules and MSE for the current fold
            rulesNum_k(k) = size(validationFIS.Rules, 2);
            cvMSE(k) = mse(yPred, testTargetData);
        end

        % Store the average number of rules and MSE across all folds
        numRulesMat(iCount, jCount) = mean(rulesNum_k);
        MSEValues(iCount, jCount) = mean(cvMSE);

        % Calculate and store the average accuracy metrics across folds
        OAValues(iCount,jCount) = sum(cvOA)/folds;
        UAValues(iCount,jCount,:) = sum(cvUA,2)/folds;
        PAValues(iCount,jCount,:) = sum(cvPA,2)/folds;
        K_hatValues(iCount,jCount) = sum(cvK_hat)/folds;

        jCount = jCount+1;
    end
    iCount = iCount + 1;
end

%% Plot: MSE vs Number of Rules
figure;
grid on;
% Flatten matrices to row vectors for plotting
scatter(reshape(numRulesMat, 1, []), reshape(MSEValues, 1, []), 'red', 'filled');
[minVal, minIndex] = min(MSEValues, [], 'all');
[minRow, minCol] = ind2sub(size(MSEValues), minIndex);
yline(minVal, 'LineStyle', '--', 'Label', 'MSE Minimum value', 'LabelHorizontalAlignment', 'center')
xline(numRulesMat(minRow, minCol), 'LineStyle', '--', 'Label', ['MSE Minimum = ' num2str(numRulesMat(minRow, minCol))], 'LabelHorizontalAlignment', 'left')
xlabel('Number of Rules', 'Interpreter', 'latex');
ylabel('MSE', 'Interpreter', 'latex');

%% 3D Plot: MSE as a function of number of features and cluster radius
figure;
[numOfFeatures_Xgrid, clusterRadius_Ygrid] = meshgrid(numFeatures, clusterRadius);
surf(numOfFeatures_Xgrid, clusterRadius_Ygrid, MSEValues');
xlabel('Number of Features', 'Interpreter', 'latex');
ylabel('Cluster Radius', 'Interpreter', 'latex');
zlabel('MSE', 'Interpreter', 'latex');
title('Relationship between Cluster Radius, Number of Features and Mean Squared Error', 'Interpreter', 'latex');

%% Plot the 3-D graph between mean errors, features_number and R_values
% Create a grid of (R_Values, feature numbers) combinations
[R, Features] = meshgrid(clusterRadius, numFeatures);
% Reshape the error array to match the grid
errors = reshape(MSEValues, numel(clusterRadius), numel(numFeatures));

% Create a 3D scatter plot
figure;
scatter3(R(:), Features(:), sqrt(errors(:)), 'filled');
xlabel('Radius of clusters', 'Interpreter', 'latex');
ylabel('Number of Features', 'Interpreter', 'latex');
zlabel('Mean Error');
title('Relationship between Cluster Radius, Number of Features and Mean Error', 'Interpreter', 'latex');

%% Find the optimal TSK model
[minError, minErrorIndex] = min(errors(:));
[optimalNumFeaturesInd, optimalClusterRadiusInd] = ind2sub(size(errors), minErrorIndex);
optimalClusterRadius = clusterRadius(optimalClusterRadiusInd);
optimalNumFeatures = numFeatures(optimalNumFeaturesInd);

% Print the details of the optimal model
fprintf('Optimal TSK Model:\n');
fprintf('--------------------------\n');
fprintf('Minimum Error (MSE): %.4f\n', minError);
fprintf('Optimal Cluster Radius: %.2f\n', optimalClusterRadius);
fprintf('Optimal Number of Features: %d\n', optimalNumFeatures);
