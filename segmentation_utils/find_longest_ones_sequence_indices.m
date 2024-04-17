function [max_start_index, max_end_index] = find_longest_ones_sequence_indices(binary_vector)
    % MATLAB implementation of finding the longest sequence of ones
    max_length = 0;
    current_length = 0;
    start_index = -1;
    max_start_index = -1;
    max_end_index = -1;
    for i = 1:length(binary_vector)
        bit = binary_vector(i);
        if bit == 1
            if current_length == 0
                start_index = i;
            end
            current_length = current_length + 1;
            if current_length > max_length
                max_length = current_length;
                max_start_index = start_index;
                max_end_index = i;
            end
        else
            current_length = 0;
        end
    end
    max_end_index = max_end_index; % End index is inclusive in MATLAB
end