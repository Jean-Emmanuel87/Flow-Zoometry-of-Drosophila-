function [K,K1,K2,K3,K4,K5] = variable_initalization(filteredFileNames)

k1 = 0;
numFiles = length(filteredFileNames);
K  ={};
K1 = {};
K2 = {};
K3 = {};
K4 = {};
K5 = {};

% Predefine K cell arrays to store results
K = cell(1, numFiles);
K1 = cell(1, numFiles);
K5 = cell(1, numFiles);
K3 = cell(1, numFiles);
K4 = cell(1, numFiles);
end