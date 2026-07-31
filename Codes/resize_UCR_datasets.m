% Here we randomly change lengths of time series of some UCR datasets,
% in a scale of 20% around their initial fixed lengths.

% The datasets we process here are:
% Beef_TEST.txt
% CBF_TEST.txt
% CricketX_TEST.txt - CricketY_TEST.txt - CricketZ_TEST.txt
% DiatomSizeReduction_TEST.txt
% DistalPhalaxOutlineAgeGroup_TEST.txt
% FaceAll_TEST.txt
% FaceFour_TEST.txt
% FacesUCR_TEST.txt
% FiftyWords_TEST.txt
% Fish_TEST.txt
% Lightning7_TEST.txt
% MedicalImages_TEST.txt
% Plane_TEST.txt
% SwedishLeaf_TEST.txt
% Symbols_TEST.txt
% SyntheticControl_TEST.txt
% Trace_TEST.txt
% WordSynonyms_TEST.txt
% InsectEPGRegularTrain_TEST.txt
% InsectEPGSmallTrain_TEST.txt
% MelbournePedestrian_TEST.txt
% Rock_TEST.txt
% SmoothSubspace_TEST.txt

close all
clear
clc

% Read file
dataset_matrix = importdata("../../../../../zz Autres/Public datasets/Univariate2018_arff/Univariate_arff/Plane/Plane_TEST.txt");

% Convert matrix in cell
dataset_matrix_sorted = sortrows(dataset_matrix, 1); % sort time series by labels
labels = dataset_matrix_sorted(:,1); % stock labels
%labels(labels == -1) = 7;
dataset_matrix_sorted = dataset_matrix_sorted(:,2:end); % remove labels
dataset = mat2cell(dataset_matrix_sorted, ones(1, size(dataset_matrix_sorted, 1)), size(dataset_matrix_sorted, 2)); % convert rows in cells
dataset = cellfun(@(x) x(~isnan(x)), dataset, 'UniformOutput', false); % remove NaN for each row

% Define length scale
fixedLen = size(dataset_matrix_sorted, 2);
smallestLen = fixedLen - round(0.1*fixedLen);
longestLen = fixedLen + round(0.1*fixedLen);




newDataset = {};
for i = 1:length(dataset)
    % allow to randomly select a length around 20% of the fixed length
    longueur = randi([smallestLen, longestLen]);
    mask_longueur = linspace(1, fixedLen, longueur);
    
    % resize each time series of the dataset
    newPattern = [];
    newPattern = interp1(1:fixedLen, dataset{i}, mask_longueur, 'linear');
    newDataset{i} = newPattern;
end
newDataset{i+1} = labels;

save('Plane_varyLen.txt', "newDataset");







