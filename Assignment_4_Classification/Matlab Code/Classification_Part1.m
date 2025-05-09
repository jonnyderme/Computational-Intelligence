%% Aristotle University of Thessaloniki (AUTh)
% Department of Electrical and Computer Engineering
%% Ioannis Deirmentzoglou AEM: 10015 Email: deirmentz@ece.auth.gr 

%% Assignment 4 Part 1

% Import dataset from the specified path
dataset = importdata('C:\Thmmy_Auth\Computational_Intelligence\Datasets\haberman.data');

% Dataset split into 60% training, 20% validation, and 20% testing sets
[trainData, validationData, testData] = split_scale(dataset, 1);
trainTargetData = trainData(:, end);              % Extract the target data for training
validationTargetData = validationData(:, end);    % Extract the target data for validation
testTargetData = testData(:, end);                % Extract the target data for testing
numClasses = 2; 

% Calculate frequencies of each class in training, validation, and test datasets
calculate_frequencies(trainData, validationData, testData);

% Array to hold the names of the models
modelNames = {};   

%% Class Independent Models
% Two Takagi-Sugeno-Kang (TSK) models with different cluster radii

%% TSK model 1 : Class-Independent Model with small cluster radius
modelNames{1} = 'TSK_model_1';
clusterRadius(1) = 0.2;  % Small cluster influence range
FISoptions(1) = genfisOptions('SubtractiveClustering');
FISoptions(1).ClusterInfluenceRange = clusterRadius(1);
% Generate the initial Fuzzy Inference System (FIS) using subtractive clustering
initialFIS(1) = genfis(trainData(:, 1:end-1), trainTargetData, FISoptions(1));

%% TSK model 2 : Class-Independent Model with large cluster radius
modelNames{2} = 'TSK_model_2';
clusterRadius(2) = 0.8;  % Large cluster influence range
FISoptions(2) = genfisOptions('SubtractiveClustering');
FISoptions(2).ClusterInfluenceRange = clusterRadius(2);
initialFIS(2) = genfis(trainData(:, 1:end-1), trainTargetData, FISoptions(2));

% Set ANFIS (Adaptive Neuro-Fuzzy Inference System) training options
ANFISoptions = anfisOptions;
ANFISoptions.ValidationData = validationData;     % Use validation data
ANFISoptions.EpochNumber = 80;                    % Set the number of training epochs

% Arrays to store classification metrics
OAValues = zeros(1,length(modelNames)); 
PAValues = zeros(numClasses,length(modelNames));
UAValues = zeros(numClasses,length(modelNames));
K_hatValues = zeros(1,length(modelNames)) ;

% Loop through each TSK model and perform training
for i = 1:length(modelNames)
    % Train the ANFIS model using the specified initial FIS
    ANFISoptions.InitialFIS = initialFIS(i);
    [~, trainError(:, i), ~, validationFIS(i), validationError(:, i)] = anfis(trainData, ANFISoptions);

    % Plot Membership Functions (MFs) for each input feature in the model
    for j = 1:size(trainData, 2) - 1
        figure;
        plotmf(validationFIS(i), 'input', j);  % Plot MFs for each input feature
        xlabel(['Input ' num2str(j)], 'Interpreter', 'latex');
        ylabel('Degree of Membership', 'Interpreter', 'latex');
        title(['Input ' int2str(j)], 'Interpreter', 'latex');
        subtitle(['TSK\_model\_' num2str(i)], 'Interpreter','latex');
    end

    % Plot learning curve (training and validation errors)
    figure;
    plot([trainError(:, i) validationError(:, i)],'LineWidth',2);
    grid on;
    xlabel('Number of Iterations', 'Interpreter', 'latex'); 
    ylabel('Error', 'Interpreter', 'latex');
    legend('Training Error', 'Validation Error', 'Interpreter', 'latex');
    title('\textbf{Learning Curve}', 'Interpreter','latex');
    subtitle(['TSK\_model\_' num2str(i)], 'Interpreter','latex');

    % Predict the output for the test dataset
    yPred(:, i) = evalfis(validationFIS(i), testData(:, 1:end-1));
    yPred(:, i) = round(yPred(:, i));  % Round predictions to nearest class
    yPred(:, i) = min(max(1, yPred(:, i)), 2);  % Ensure values fall within class bounds (1 or 2)

    % Create and plot confusion matrix (error matrix)
    errorMatrix = confusionmat(testTargetData, yPred(:, i));
    figure;
    confMatrix = confusionchart(errorMatrix);  % Use 'confMatrix' instead of 'cm'
    confMatrix.Title = ['Error matrix for TSK\_model\_' num2str(i)];

    % Calculate classification metrics: Overall Accuracy (OA), Producer's Accuracy (PA),
    % User's Accuracy (UA), and Kappa (K_hat)
    OAValues(i) = OA(errorMatrix);  % Overall accuracy
    PAValues(:, i) = PA(errorMatrix);  % Producer's accuracy per class
    UAValues(:, i) = UA(errorMatrix);  % User's accuracy per class
    K_hatValues(i) = K_hat(errorMatrix);  % Kappa statistic for agreement

    % Record the number of rules in the model
    modelRules(i) = size(validationFIS(i).Rules, 2); 
end

%% Class-Dependent Models 
% TSK models with separate clustering per class and different cluster radii

%% TSK model 3 : Class-dependent clustering with small cluster radius
modelNames{3} = 'TSK_model_3';
clusterRadius(3) = 0.2;  % Small cluster radius for class-dependent model
FISoptions(3) = genfisOptions('SubtractiveClustering');
initialFIS(3) = sugfis;  % Initialize FIS with Sugeno-type system

%% TSK model 4: Class-dependent clustering with large cluster radius
modelNames{4} = 'TSK_model_4';
clusterRadius(4) = 0.8;  % Large cluster radius for class-dependent model
FISoptions(4) = genfisOptions('SubtractiveClustering');
initialFIS(4) = sugfis;

% Set output membership function type for class-dependent models
outputMembershipFunctionType = 'constant';  % Use singleton (constant) output

% Loop for class-dependent models (TSK 3 and TSK 4)
for i = 3:length(modelNames)
    % Cluster the data separately for each class (class 1 and class 2)
    cluster1InputData = trainData(trainTargetData == 1, :);  % Data for class 1
    [clusterCenters1, sigma1] = subclust(cluster1InputData, clusterRadius(i));
    cluster2InputData = trainData(trainTargetData == 2, :);  % Data for class 2
    [clusterCenters2, sigma2] = subclust(cluster2InputData, clusterRadius(i));

    % Define the number of rules based on clusters for both classes
    numOfRules = size(clusterCenters1, 1) + size(clusterCenters2, 1);

    % Add input variables and their membership functions (MFs) to the FIS
    for j = 1:size(trainData, 2) - 1
        % Add input variable to FIS
        initialFIS(i) = addInput(initialFIS(i), [0,1], 'Name', sprintf("in%d", j));

        % Add MFs for class 1
        for k = 1:size(clusterCenters1, 1)
            initialFIS(i) = addMF(initialFIS(i), sprintf("in%d", j), 'gaussmf', [sigma1(j) clusterCenters1(k, j)]);
        end

        % Add MFs for class 2
        for k = 1:size(clusterCenters2, 1)
            initialFIS(i) = addMF(initialFIS(i), sprintf("in%d", j), 'gaussmf', [sigma2(j) clusterCenters2(k, j)]);
        end
    end

    % Add output and output membership functions (constant/singleton type)
    initialFIS(i) = addOutput(initialFIS(i), [0, 1], 'Name', 'out1');
    params = [zeros(1, size(clusterCenters1, 1)) ones(1, size(clusterCenters2, 1))];  % Output membership values
    for j = 1:numOfRules
        initialFIS(i) = addMF(initialFIS(i), 'out1', outputMembershipFunctionType, params(j));
    end

    % Add rules to the FIS
    rulesList = [repmat((1:numOfRules)', 1, size(trainData, 2)) ones(numOfRules, 2)];
    initialFIS(i) = addrule(initialFIS(i), rulesList);

    % Train the model using ANFIS
    ANFISoptions.InitialFIS = initialFIS(i);
    [~, trainError(:, i), ~, validationFIS(i), validationError(:, i)] = anfis(trainData, ANFISoptions);

    % Plot Membership Functions (MFs) for each input feature
    for j = 1:size(trainData, 2) - 1
        figure;
        plotmf(validationFIS(i), 'input', j);
        xlabel(['Input ' num2str(j)], 'Interpreter', 'latex');
        ylabel('Degree of Membership', 'Interpreter', 'latex');
        title(['Input ' int2str(j)], 'Interpreter', 'latex');
        subtitle(['TSK\_model\_' num2str(i)], 'Interpreter','latex');
    end

    % Plot learning curve for training and validation errors
    figure;
    plot([trainError(:, i) validationError(:, i)],'LineWidth',2);
    grid on;
    xlabel('Number of Iterations', 'Interpreter', 'latex'); 
    ylabel('Error', 'Interpreter', 'latex');
    legend('Training Error', 'Validation Error', 'Interpreter', 'latex');
    title('\textbf{Learning Curve}', 'Interpreter','latex');
    subtitle(['TSK\_model\_' num2str(i)], 'Interpreter','latex');

    % Predict the output for the test dataset
    yPred(:, i) = evalfis(validationFIS(i), testData(:, 1:end-1));
    yPred(:, i) = round(yPred(:, i));  % Round predictions to nearest class
    yPred(:, i) = min(max(1, yPred(:, i)), 2);  % Ensure valid class labels (1 or 2)

    % Create and plot confusion matrix (error matrix)
    errorMatrix = confusionmat(testTargetData, yPred(:, i));
    figure;
    confMatrix = confusionchart(errorMatrix);  
    confMatrix.Title = ['Error matrix for TSK\_model\_' num2str(i)];

    % Calculate classification metrics: Overall Accuracy (OA), Producer's Accuracy (PA),
    % User's Accuracy (UA), and Kappa statistic (K_hat)
    OAValues(i) = OA(errorMatrix);  % Overall accuracy
    PAValues(:, i) = PA(errorMatrix);  % Producer's accuracy per class
    UAValues(:, i) = UA(errorMatrix);  % User's accuracy per class
    K_hatValues(i) = K_hat(errorMatrix);  % Kappa statistic for agreement

    % Record the number of rules in the current model
    modelRules(i) = size(validationFIS(i).Rules, 2);  % 'modelRules' instead of 'numOfModelRules'
end

% Display classification metrics in tables for comparison
disp(array2table(OAValues, 'VariableNames', modelNames, 'Rownames', {'Overall Accuracy (OA)'}));
disp(array2table(PAValues, 'VariableNames', modelNames, 'Rownames', {'Producer Accuracy Class 1', 'Producer Accuracy Class 2'}));
disp(array2table(UAValues, 'VariableNames', modelNames, 'Rownames', {'User Accuracy Class 1', 'User Accuracy Class 2'}));
disp(array2table(K_hatValues, 'VariableNames', modelNames, 'Rownames', {'Kappa Statistic (K_hat)'}));
disp(array2table(modelRules, 'VariableNames', modelNames, 'Rownames', {'Number of Rules'}));
