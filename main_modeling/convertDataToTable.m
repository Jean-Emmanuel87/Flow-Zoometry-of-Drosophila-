function table_data = convertDataToTable(data)
    % Initialize variables to store phenotype, date, subfolder, h5_file, and features
    phenotype = data(:, 1);
    date = data(:, 2);
    subfolder = data(:, 3);
    h5_file = data(:, 4);
    features = vertcat(data{:, 5});

    % Define variable names for features
    variable_names = strcat('F', string(1:size(features, 2)));

    % Create tables
    phenotype_table = cell2table(phenotype, 'VariableNames', {'Phenotype'});
    date_table = cell2table(date, 'VariableNames', {'Date'});
    subfolder_table = cell2table(subfolder, 'VariableNames', {'Subfolder'});
    h5_file_table = cell2table(h5_file, 'VariableNames', {'H5_File'});
    features_table = array2table(features, 'VariableNames', variable_names);

    % Combine all tables
    table_data = [phenotype_table, date_table, subfolder_table, h5_file_table, features_table];
end