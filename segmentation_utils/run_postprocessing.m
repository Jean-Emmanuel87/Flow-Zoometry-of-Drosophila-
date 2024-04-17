function [K8, K9] = run_postprocessing(K5, K4, numFiles)
    % run_postprocessing : Conducts postprocessing on the provided data.
    %
    % Inputs:
    %   K5 - The data to be processed by first_segment_filter.
    %   K4 - The data to be processed by second_label_filtering.
    %   numFiles - The number of files or data points to process.
    %
    % Outputs:
    %   K8 - The output from first_segment_filter.
    %   K9 - The output from second_label_filtering.

    disp('Postprocessing in progress...');

    % First stage of postprocessing
    K8 = first_segment_filter(K5, numFiles);

    % Second stage of postprocessing
    K9 = second_label_filtering(K8, K4, numFiles);

    disp('Postprocessing complete.');
end