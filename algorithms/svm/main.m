clear ; close all; clc

% Build libsvm library
cd './libsvm-3.22/matlab'
make octave
cd '../..'

% Add common functions to Octave search path
addpath('../common');

% Add libsvm to Octave search path
addpath('./libsvm-3.22/matlab');

fprintf('\nSVM iniciado!\n');

% Reading data
data = csvread('../../data/balanced_data.csv');

% Choosing k for k-fold cross validation
k = 10;

% Initializing accuracy, f_measure and MCC accumulators
measures = [0 0 0];

% Choosing C and gamma hyper parameters
C = 2^4.25;
gamma = 2^-7.25;

% Storing number of samples and attributes
sample_count = size(data, 1);
num_attributes = size(data, 2);

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

  % ------------------- NORMALIZATION BLOCK --------------------------
  [X_norm, avg, stddev] = normalizar(train_data(:, 1:num_attributes-1));
  X_norm_test = (test_data(:, 1:num_attributes-1) - repmat(avg, size(test_data, 1), 1)) ./ repmat(stddev, size(test_data, 1), 1);

  normalized_train_data = [X_norm train_data(:, num_attributes)];
  normalized_test_data = [X_norm_test test_data(:, num_attributes)];

  train_data = normalized_train_data;
  test_data = normalized_test_data;
  % -------------------------------------------------------------------
  % Getting the results for this step of the experiment
  [tp, fp, fn, tn] = svm(train_data, test_data, C, gamma);

  % Accumulate measures
  measures = measures + [accuracy(tp, fp, fn, tn) , f_measure(tp, fp, fn, tn), mcc(tp, fp, fn, tn)];
end

% Getting the measures' average
measures = measures / k * 100;

% Printing results
fprintf('-------Results-------\n');
fprintf('Accuracy: %f\n', measures(1));
fprintf('F-Measure: %f\n', measures(2));
fprintf('MCC: %f\n', measures(3));
fprintf('---------------------\n');
fprintf('\nSVM concluido!\n');
