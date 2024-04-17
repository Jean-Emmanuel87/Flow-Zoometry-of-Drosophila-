function [accuracy, precision, recall, F1_score, AUC, MCC, TSS, kappa, bestParams, Xroc_cells, Yroc_cells, Xprec_cells, Yprec_cells, internalFoldAccuracies] = trainAndEvaluateModel(data)
    
    % trainAndEvaluateModel: Trains and evaluates a random forest model using cross-validation.
    %
    % Inputs:
    %   data - A table containing the dataset with features, phenotype labels, and dates.
    %          The table must contain the following columns:
    %          - Phenotype: Categorical column specifying the class/phenotype of each sample.
    %          - F1 to FN: Feature columns used as inputs for the model (starting from the 5th column).
    %          - Date: Column used to split the data into unique external validation sets.
    %
    % Outputs:
    %   accuracy, precision, recall, F1_score - Vectors containing the respective metric for each external validation set.
    %   AUC, MCC, TSS, kappa - Vectors containing additional evaluation metrics for each external validation set.
    %   bestParams - A structure array storing the best hyperparameters for each external validation set.
    %   Xroc_cells, Yroc_cells - Cell arrays containing ROC curve data for each external validation set.
    %   Xprec_cells, Yprec_cells - Cell arrays containing precision-recall curve data for each external validation set.

    % Filter and preprocess the data
    idx = find(data.F1 == 0);
    data(idx, :) = [];
    data_filtered = data(ismember(data.Phenotype, {'4hit', 'noncancer'}), :);
    X = table2array(data_filtered(:, 5:end));
    y = strcmp(data_filtered.Phenotype, '4hit');
    unique_dates = unique(data_filtered.Date);

    % Initialize performance metrics
    [accuracy, precision, recall, F1_score, AUC, MCC, TSS, kappa] = deal(zeros(length(unique_dates), 1));
    [Xroc_cells, Yroc_cells, Xprec_cells, Yprec_cells] = deal(cell(length(unique_dates), 1));

    rng(42);  % For reproducibility

    % Hyperparameter options (could be function inputs)
    numTreesOptions = [5, 10, 20, 30, 40, 50, 100, 200, 300, 400, 500, 1000];
    maxNumSplitsOptions = [3, 5, 8, 10, 20, 30, 40, 50, 100];
    numVarsToSampleOptions = [4, 5, 6, 7, 8, 9, 10, 20];

    % Initialize structure for storing best parameters
    bestParams = struct('Date', {}, 'NumTrees', {}, 'MaxNumSplits', {}, 'NumVarsToSample', {}, 'BestInternalAUC', {});

    % Main loop for training and evaluation
    for i = 1:length(unique_dates)
        % External CV: Split data based on date
        test_date = unique_dates{i};
        train_indices = ~strcmp(data_filtered.Date, test_date);
        X_train = X(train_indices, :);
        y_train = y(train_indices);
        X_test = X(~train_indices, :);
        y_test = y(~train_indices);

        % Normalize the external training data (done once per external loop)
        [X_train_normalized, mu, sigma] = zscore(X_train);

        % Best hyperparameters initialization
        bestInternalAUC = 0;
        bestNumTrees = 0;
        bestMaxNumSplits = 0;
        bestNumVarsToSample = 0;


    train_dates = unique(data_filtered.Date(train_indices)); 

       tempInternalFoldAccuracies = zeros(length(train_dates), length(numTreesOptions) * length(maxNumSplitsOptions) * length(numVarsToSampleOptions));

       %%% number of date in the process 
        
         model_count = 1;

        % Hyperparameter tuning (internal cross-validation)
        for nTrees = numTreesOptions
            for maxNumSplits = maxNumSplitsOptions
                for numVarsToSample = numVarsToSampleOptions
                    internalAUC = zeros(length(unique(data_filtered.Date(train_indices))), 1);
                    internalAccuracy = zeros(length(unique(data_filtered.Date(train_indices))), 1);
                    for j = 1:length(train_dates)
                        % Internal training/validation split
                        internalTrainDate = data_filtered.Date(train_indices);
                        internalValidationDate = train_dates{j};
                        internalTrainIdx = ~strcmp(internalTrainDate, internalValidationDate);
                        internalValIdx = strcmp(internalTrainDate, internalValidationDate);

                        % Separate internal training and validation sets
                        X_internal_train = X_train(internalTrainIdx, :);
                        y_internal_train = y_train(internalTrainIdx);
                        X_internal_val = X_train(internalValIdx, :);
                        y_internal_val = y_train(internalValIdx);

                        % Normalize internal training and validation data separately
                        [X_internal_train_norm, mu_internal, sigma_internal] = zscore(X_internal_train);
                        X_internal_val_norm = bsxfun(@minus, X_internal_val, mu_internal);
                        X_internal_val_norm = bsxfun(@rdivide, X_internal_val_norm, sigma_internal);

                        % Train model on internal training data
                        t = templateTree('Reproducible', true, 'MaxNumSplits', maxNumSplits, 'NumVariablesToSample', numVarsToSample);
                        model = fitcensemble(X_internal_train_norm, y_internal_train, 'Method', 'Bag', 'NumLearningCycles', nTrees, 'Learners', t);

                        % Validate model on internal validation data
                         
                        [y_pred_val, scores] = predict(model, X_internal_val_norm);
                        [~, ~, ~, AUCValue] = perfcurve(y_internal_val, scores(:, 2), 1);
                        internalAUC(j) = AUCValue;
                        cm = confusionmat(y_internal_val, y_pred_val);
                        internalAccuracy(j) = sum(diag(cm)) / sum(cm(:));


                    end

                    meanInternalAUC = mean(internalAUC);
                    %accuracy = sum(diag(cm)) / sum(cm(:));


                    % Store accuracies for each model configuration
                    tempInternalFoldAccuracies(:, model_count) = internalAccuracy;
                    model_count = model_count + 1;

                    % Update best parameters if current model is better
                    if meanInternalAUC > bestInternalAUC
                        bestInternalAUC = meanInternalAUC;
                        bestNumTrees = nTrees;
                        bestMaxNumSplits = maxNumSplits;
                        bestNumVarsToSample = numVarsToSample;
                        bestModelIdx = model_count - 1;  % Store the index of the best model
                    end
                end
            end
        end

        internalFoldAccuracies{i} = tempInternalFoldAccuracies(:, bestModelIdx);

        % Store the best parameters for each date
        bestParams(i).Date = test_date;
        bestParams(i).NumTrees = bestNumTrees;
        bestParams(i).MaxNumSplits = bestMaxNumSplits;
        bestParams(i).NumVarsToSample = bestNumVarsToSample;
        bestParams(i).BestInternalAUC = bestInternalAUC;

        % Retrain using the best parameters on the full external training set
        t = templateTree('Reproducible', true, 'MaxNumSplits', bestMaxNumSplits, 'NumVariablesToSample', bestNumVarsToSample);
        model_external = fitcensemble(X_train_normalized, y_train, 'Method', 'Bag', 'NumLearningCycles', bestNumTrees, 'Learners', t);

        % Evaluate on the external test set
        X_test_normalized = bsxfun(@minus, X_test, mu);
        X_test_normalized = bsxfun(@rdivide, X_test_normalized, sigma);
        [y_test_pred, scores_test] = predict(model_external, X_test_normalized);

        % Calculate performance metrics
        [accuracy(i), precision(i), recall(i), F1_score(i), AUC(i), MCC(i), TSS(i), kappa(i), Xroc_cells{i}, Yroc_cells{i}, Xprec_cells{i}, Yprec_cells{i}] = ...
            calculatePerformanceMetrics(y_test, y_test_pred, scores_test(:, 2));
    end

    % Feature importance for the last trained model
    %importance_scores = predictorImportance(model_external);

    % Optional: Plot feature importance
    % figure;
    % bar(importance_scores);
    % xlabel('Feature Index');
    % ylabel('Importance Score');
    % title('Feature Importance Scores');
end

