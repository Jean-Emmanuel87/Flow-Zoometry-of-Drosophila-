function B = normalization_global(A)
epsilon = 0.000000001;
lmda = 1;
red=A;
s = 10;
    X = double(red);

    X_average = mean(X(:));
    X = X - X_average;

    % `su` is here the mean, instead of the sum
    contrast = sqrt(lmda + mean(X(:).^2));

    X = s * X ./ max([contrast, epsilon]);
%
%     figure
% histogram(X(:))
B = X;
end