function [accuracy, precision, recall, F1_score, AUC, MCC, TSS, kappa, Conf] = initializeMetrics(num_dates)
    % initializeMetrics Initializes performance metrics arrays for evaluation.
    %
    % This function initializes arrays to store various performance metrics for each
    % fold in a cross-validation process. The metrics include accuracy, precision,
    % recall, F1 score, Area Under Curve (AUC), Matthews Correlation Coefficient (MCC),
    % True Skill Statistic (TSS), Cohen's kappa, and the confusion matrix (Conf).
    %
    % Inputs:
    %   num_dates - The number of folds or unique dates in the cross-validation process.
    %
    % Outputs:
    %   accuracy - An array to store accuracy values for each fold.
    %   precision - An array to store precision values for each fold.
    %   recall - An array to store recall values for each fold.
    %   F1_score - An array to store F1 score values for each fold.
    %   AUC - An array to store AUC values for each fold.
    %   MCC - An array to store MCC values for each fold.
    %   TSS - An array to store TSS values for each fold. 
    %   kappa - An array to store Cohen's kappa values for each fold.
    %   Conf - A 3D array to store the confusion matrix for each fold (2x2 matrices).

    accuracy = zeros(num_dates, 1);
    precision = zeros(num_dates, 1);
    recall = zeros(num_dates, 1);
    F1_score = zeros(num_dates, 1);
    AUC = zeros(num_dates, 1);
    MCC = zeros(num_dates, 1);
    TSS = zeros(num_dates, 1);
    kappa = zeros(num_dates, 1);
    Conf = zeros(2, 2, num_dates);  % Assuming binary classification
end