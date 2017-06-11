% Clearing everything
clc; clear; close all

% Adding path for common functions
addpath('../common')

% Reading data
data = csvread('../../data/balanced_data.csv');

% Storing number of samples and attributes
sample_count = size(data, 1);
num_attributes = size(data, 2);

% Choosing k for k-fold cross validation
k = 2;

% Initializing accuracy, f_measure and MCC accumulators
measures = [0 0 0];

% Normalizing data
data = [normalizar(data(:, 1:num_attributes - 1)) data(:, num_attributes)];

% Getting the fold size for cross validation
fold_size = ceil(sample_count / k);

% Shuffling data
data = data(randperm(sample_count), :);

% For each cross validation iteration
for (i = 0 : k-1)

	% Getting the indexes for the start and end of the test fold
	start_idx = (i * fold_size) + 1;
	end_idx = min(start_idx + fold_size - 1, sample_count);

	% Getting the train and test sets from the original set
	train_data = [   (data((1 : (start_idx - 1)), :))   ;   (data((end_idx + 1) : sample_count, :))   ]; 
	test_data = data(start_idx:end_idx, :);

	% Getting the results for this step of the experiment
	[partial_acc, partial_f_measure, partial_mcc] = redes_neurais(train_data, test_data);
	
	% Accumulate measures
	measures = measures + [partial_acc, partial_f_measure, partial_mcc];
end

% Getting the measures' average
measures = measures / k * 100;

% Printing results
fprintf('\n\n-------Results-------\n');
fprintf('Accuracy: %f\n', measures(1));
fprintf('F-Measure: %f\n', measures(2));
fprintf('MCC: %f\n', measures(3));
