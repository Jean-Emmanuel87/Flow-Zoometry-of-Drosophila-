function [accuracy, precision, recall, F1, AUC, MCC, TSS, kappa, Xroc, Yroc, Xpre, Ypre] = calculatePerformanceMetrics(y_true, y_pred, scores)
    % Compute confusion matrix
    cm = confusionmat(y_true, y_pred);

    % Compute basic metrics
    accuracy = sum(diag(cm)) / sum(cm(:));
    precision = cm(2, 2) / sum(cm(:, 2));
    recall = cm(2, 2) / sum(cm(2, :));
    F1 = 2 * (precision * recall) / (precision + recall);

    % Compute AUC
    [Xroc, Yroc, ~, AUC] = perfcurve(y_true, scores, true);

    % Compute MCC
    TP = cm(2, 2);
    TN = cm(1, 1);
    FP = cm(1, 2);
    FN = cm(2, 1);
    MCC = (TP * TN - FP * FN) / sqrt((TP + FP) * (TP + FN) * (TN + FP) * (TN + FN));

    % Compute TSS
    sensitivity = TP / (TP + FN);
    specificity = TN / (TN + FP);
    TSS = sensitivity + specificity - 1;

    % Compute Cohen's kappa
    total = sum(cm(:));
    pe = ((sum(cm(1, :)) * sum(cm(:, 1))) + (sum(cm(2, :)) * sum(cm(:, 2)))) / total^2;
    po = sum(diag(cm)) / total;
    kappa = (po - pe) / (1 - pe);

    % Compute precision-recall curve
    [Xpre, Ypre] = perfcurve(y_true, scores, true, 'xCrit', 'reca', 'yCrit', 'prec');
end