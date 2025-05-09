%% Aristotle University of Thessaloniki (AUTh)
% Department of Electrical and Computer Engineering
%% Ioannis Deirmentzoglou AEM: 10015 Email: deirmentz@ece.auth.gr 

function calculate_frequencies(trnData, chkData, tstData)
    %% Calculate the frequency of each class on each subset

    %% For the training data (trnData)
    % Extract class ID
    trainID = trnData(:, 4);

    % Count occurrences of ID=1 and ID=2
    trainID1 = sum(trainID == 1);
    trainID2 = sum(trainID == 2);

    % Calculate percentages
    numTrainPoints = numel(trainID);
    trainPerc1 = (trainID1 / numTrainPoints) * 100;
    trainPerc2 = (trainID2 / numTrainPoints) * 100;

    % Print results for training data
    fprintf('Percentage of training data in class 1: %.2f%%\n', trainPerc1);
    fprintf('Percentage of training data in class 2: %.2f%%\n', trainPerc2);

    %% For the check data (chkData)
    % Extract class ID
    validationID = chkData(:, 4);

    % Count occurrences of ID=1 and ID=2
    validationID1 = sum(validationID == 1);
    validationID2 = sum(validationID == 2);

    % Calculate percentages
    numCheckPoints = numel(validationID);
    checkPerc1 = (validationID1 / numCheckPoints) * 100;
    checkPerc2 = (validationID2 / numCheckPoints) * 100;

    % Print results for check data
    fprintf('Percentage of check data in class 1: %.2f%%\n', checkPerc1);
    fprintf('Percentage of check data in class 2: %.2f%%\n', checkPerc2);

    %% For the test data (tstData)
    % Extract class ID
    testID = tstData(:, 4);

    % Count occurrences of ID=1 and ID=2
    testID1 = sum(testID == 1);
    testID2 = sum(testID == 2);

    % Calculate percentages
    numTestPoints = numel(testID);
    testPerc1 = (testID1 / numTestPoints) * 100;
    testPerc2 = (testID2 / numTestPoints) * 100;

    % Print results for test data
    fprintf('Percentage of test data in class 1: %.2f%%\n', testPerc1);
    fprintf('Percentage of test data in class 2: %.2f%%\n', testPerc2);
end
