function [X_normalized, mu, sigma] = normalize_features(X)
    % Calculate the mean and standard deviation for each feature
    mu = mean(X, 1);
    sigma = std(X, 0, 1);

    % Normalize the features using z-score normalization
    X_normalized = (X - mu) ./ sigma;
end