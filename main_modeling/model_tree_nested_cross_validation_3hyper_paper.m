%%%%%%%%%%%%%%for the paper

%%%%%%%%%%%preparing the data
data = table_data;
idx = find(data.F1 == 0);
data(idx, :) = [];
% Filter data to include only '4hits' and 'noncancer' phenotypes
data_filtered = data(ismember(data.Phenotype, {'4hits', 'noncancer'}), :);

% Separate features and labels
X = table2array(data_filtered(:, 5:end));
y = strcmp(data_filtered.Phenotype, '4hits');  % Convert '4hits' to logical 1, 'noncancer' to logical 0

unique_dates = unique(data_filtered.Date);

% Initialize variables for evaluation metrics  external validation
accuracy = zeros(length(unique_dates), 1);
precision = zeros(length(unique_dates), 1);
recall = zeros(length(unique_dates), 1);
F1_score = zeros(length(unique_dates), 1);
AUC = zeros(length(unique_dates), 1);
MCC = zeros(length(unique_dates), 1);
TSS = zeros(length(unique_dates), 1);
kappa = zeros(length(unique_dates), 1);

Xroc_cells = cell(length(unique_dates), 1);
Yroc_cells = cell(length(unique_dates), 1);


Xprec_cells = cell(length(unique_dates), 1);
Yprec_cells = cell(length(unique_dates), 1);



rng(42);  % For reproducibility

% Define the range of model parameters to test
numTreesOptions = [5,10,20,30,40,50,100,200,300,400,500,1000];
maxNumSplitsOptions = [3, 5, 8, 10, 20,30,40,50,100];  % Adjust based on your dataset
numVarsToSampleOptions = [4, 5, 6, 7, 8,9,10,20];  % Starting around sqrt(30)



% Initialize an empty structure for storing best parameters for each date
bestParams = struct('Date', {}, 'NumTrees', {}, 'MaxNumSplits', {}, 'NumVarsToSample', {},'BestInternalAUC', {});

for i = 1:length(unique_dates)
    % External CV: Split data into training and testing sets based on the date
    test_date = unique_dates{i};
    train_indices = ~strcmp(data_filtered.Date, test_date);
    X_train = X(train_indices, :);
    y_train = y(train_indices);
    X_test = X(~train_indices, :);
    y_test = y(~train_indices);

    train_dates = unique(data_filtered.Date(train_indices));  % Dates for internal CV
    
internal_accuracy = zeros(length(numTreesOptions), length(maxNumSplitsOptions), length(numVarsToSampleOptions), length(train_dates));
internal_precision = zeros(length(numTreesOptions), length(maxNumSplitsOptions), length(numVarsToSampleOptions), length(train_dates));
internal_recall = zeros(length(numTreesOptions), length(maxNumSplitsOptions), length(numVarsToSampleOptions), length(train_dates));
internal_F1_score = zeros(length(numTreesOptions), length(maxNumSplitsOptions), length(numVarsToSampleOptions), length(train_dates));
internal_AUC = zeros(length(numTreesOptions), length(maxNumSplitsOptions), length(numVarsToSampleOptions), length(train_dates));
internal_MCC = zeros(length(numTreesOptions), length(maxNumSplitsOptions), length(numVarsToSampleOptions), length(train_dates));
internal_TSS = zeros(length(numTreesOptions), length(maxNumSplitsOptions), length(numVarsToSampleOptions), length(train_dates));
internal_kappa = zeros(length(numTreesOptions), length(maxNumSplitsOptions), length(numVarsToSampleOptions), length(train_dates));
    

% Initialize variables to store the best hyperparameter values
bestNumTrees = 0;
bestMaxNumSplits = 0;
bestNumVarsToSample = 0;
bestInternalAUC = 0;  % Assuming AUC is the metric to optimize; adjust if using a different metric

    
    % Hyperparameter tuning in the internal CV
    for nTrees = numTreesOptions
        for maxNumSplits = maxNumSplitsOptions
            for numVarsToSample = numVarsToSampleOptions
                
                internalAUC = zeros(length(train_dates), 1);  % Store AUC for each internal fold
                internalaccuracy = zeros(length(train_dates), 1);
                
                for j = 1:length(train_dates)
                    internal_test_date = train_dates{j};
                    internal_train_indices = ~strcmp(data_filtered.Date(train_indices), internal_test_date);
                    internal_test_indices = strcmp(data_filtered.Date(train_indices), internal_test_date);

                    X_internal_train = X_train(internal_train_indices, :);
                    y_internal_train = y_train(internal_train_indices);
                    X_internal_validation = X_train(internal_test_indices, :);
                    y_internal_validation = y_train(internal_test_indices);

                    % Normalize the internal training and validation data
                    [X_internal_train_normalized, mu, sigma] = normalize_features(X_internal_train);
                    X_internal_validation_normalized = (X_internal_validation - mu) ./ sigma;

                    % Train a model on the internal training set with the current set of hyperparameters
                    t = templateTree('Reproducible', true, 'MaxNumSplits', maxNumSplits, 'NumVariablesToSample', numVarsToSample);
                    model_internal = fitcensemble(X_internal_train_normalized, y_internal_train, 'Method', 'Bag', ...
                                                  'NumLearningCycles', nTrees, 'Learners', t);

                    % Evaluate on the internal validation set
                    [y_internal_pred, scores_internal] = predict(model_internal, X_internal_validation_normalized);
                    [~, ~, ~, AUCValue] = perfcurve(y_internal_validation, scores_internal(:,2), 1);
                    internalAUC(j) = AUCValue;
                    %internal_AUC(nTreesIdx, maxNumSplitsIdx, numVarsToSampleIdx, j) = AUCValue;
                end
                
                % Calculate the mean internal AUC for the current set of hyperparameters
                meanInternalAUC = mean(internalAUC);
                meanInternalaccuracy = mean(internalaccuracy);
                % Update the best hyperparameters if the current mean AUC is better
                if meanInternalAUC > bestInternalAUC
                    bestInternalAUC = meanInternalAUC;
                    bestNumTrees = nTrees;
                    bestMaxNumSplits = maxNumSplits;
                    bestNumVarsToSample = numVarsToSample;
                end
                
            end
        end
    end

   accuracy_internal(i) = meanInternalaccuracy;
   % Store the best parameters for the current date
    bestParams(i) = struct('Date', test_date, 'NumTrees', bestNumTrees, 'MaxNumSplits', bestMaxNumSplits, 'NumVarsToSample', bestNumVarsToSample,'BestInternalAUC', bestInternalAUC);

    % Normalize the training data
    [X_train_normalized, mu, sigma] = normalize_features(X_train);
    
    % Retrain the model on the entire training set using the best hyperparameters
    t = templateTree('Reproducible', true, 'MaxNumSplits', bestMaxNumSplits, 'NumVariablesToSample', bestNumVarsToSample);
    model_external = fitcensemble(X_train_normalized, y_train, 'Method', 'Bag', ...
                                  'NumLearningCycles', bestNumTrees, 'Learners', t);

    % Evaluate the model on the external test set
    % Normalize the test set using the training set's parameters
    X_test_normalized = (X_test - mu) ./ sigma;
    [y_test_pred, scores_test] = predict(model_external, X_test_normalized);

    % Predict labels for the external test set
   % [y_pred, scores] = predict(model, X_test_normalized);
    positive_class_scores = scores_test(:, 2);

    % Calculate and store the external evaluation metrics
    cm = confusionmat(y_test, y_test_pred);
    Conf(:,:,i) = cm;
    accuracy(i) = sum(diag(cm)) / sum(cm, 'all');
    precision(i) = cm(2, 2) / sum(cm(:, 2));
    recall(i) = cm(2, 2) / sum(cm(2, :));
    F1_score(i) = 2 * (precision(i) * recall(i)) / (precision(i) + recall(i));
    [Xroc, Yroc, ~, AUC(i)] = perfcurve(y_test, positive_class_scores, 1);
    [Xpre, Ypre] = perfcurve(y_test, positive_class_scores,1, 'xCrit', 'reca', 'yCrit', 'prec');
    
    Xroc_cells{i} = Xroc;
    Yroc_cells{i} = Yroc;

    
    Xprec_cells{i} = Xpre;
    Yprec_cells{i} = Ypre;


    %%%%%% Calculate and store the external new metrics
    TP = cm(2, 2);
    TN = cm(1, 1);
    FP = cm(1, 2);
    FN = cm(2, 1);

    % Calculate Matthews Correlation Coefficient (MCC)
    numerator = (TP * TN) - (FP * FN);
    denominator = sqrt((TP + FP) * (TP + FN) * (TN + FP) * (TN + FN));
    MCC(i) = numerator / denominator;

    % Calculate True Skill Statistic (TSS) = Sensitivity + Specificity - 1
    sensitivity = TP / (TP + FN);
    specificity = TN / (TN + FP);
    TSS(i) = sensitivity + specificity - 1;

    % Calculate Cohen's Kappa (κ)
    total = sum(cm(:));
    sum_rows = sum(cm, 2);
    sum_cols = sum(cm, 1);
    expected = ((sum_rows(1) * sum_cols(1)) + (sum_rows(2) * sum_cols(2))) / (total^2);
    observed = sum(diag(cm));
    kappa(i) = (observed - expected) / (total - expected);
   

end

% Display or analyze the overall performance metrics here
% For example, display the average external test accuracy
disp(['Average external test accuracy: ', num2str(mean(accuracy))]);
importance_scores = predictorImportance(model_external);
% Display feature importance
figure;
bar(importance_scores);
xlabel('Feature Index');
ylabel('Importance Score');
title('Feature Importance Scores');