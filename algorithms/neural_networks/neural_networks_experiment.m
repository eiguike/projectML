% Clearing everything
clc; clear; close all

% Adding path for common functions
addpath('../common')

% result_file = fopen('results.txt', 'w');

% Reading data
data = csvread('../../data/balanced_data.csv');

% Storing number of samples and attributes
sample_count = size(data, 1);
num_attributes = size(data, 2);

% Choosing k for k-fold cross validation
k = 5;

% Initializing accuracy, f_measure and MCC accumulators
measures = [0 0 0];

% Initializing PCA K value
PCA_K = 1;

% Selecting desired variance keep for PCA
desired_variance = 0.95;

% % Normalizing data
% data = [normalizar(data(:, 1:num_attributes - 1)) data(:, num_attributes)];

% Getting the fold size for cross validation
fold_size = ceil(sample_count / k);

% Shuffling data
data = data(randperm(sample_count), :);

lambdas = [0.01 0.05 0.1 0.25 0.5 0.75 1 2];
internal_nodes = [3:25];

for (lambda_idx = 1: size(lambdas, 2))
	for (nodes_idx = 1: size(internal_nodes, 2))
		lambda = lambdas(lambda_idx);
		num_nodes = internal_nodes(nodes_idx);

		result_file_name = strcat('nodes_', num2str(num_nodes), '_lambda_', num2str(lambda), '.txt');
		result_file = fopen(result_file_name, 'w');

		% For each cross validation iteration
			measures = [0 0 0];
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

				% % ---------------------- PCA BLOCK ---------------------------------
				% X_train = train_data(:, 1:num_attributes-1);
				% Y_train = train_data(:, num_attributes);

				% X_test = test_data(:, 1:num_attributes-1);
				% Y_test = test_data(:, num_attributes);

				% [U, S] = pca(X_train);
				% diagonal = diag(S);

				% for (count = 1:num_attributes-1)
				% 	K = num_attributes - count;
				% 	if ((sum(diagonal(1:K) / sum(diagonal))) > desired_variance)
				% 		PCA_K = K;
				% 	end
				% end

				% fprintf('Chosen K for PCA: %d\n', PCA_K)

				% Z_train = projetarDados(X_train, U, PCA_K);
				% Z_test = projetarDados(X_test, U, PCA_K);

				% train_data = [Z_train Y_train];
				% test_data = [Z_test Y_test];
				% ------------------------------------------------------------------

				% Getting the results for this step of the experiment
				
				[tp, fp, fn, tn] = redes_neurais(train_data, test_data, lambda, num_nodes);
				
				% Accumulate measures
				measures = measures + [accuracy(tp, fp, fn, tn) , f_measure(tp, fp, fn, tn), mcc(tp, fp, fn, tn)];
			end
			% Getting the measures' average
			measures = measures / k * 100;

		% Printing results
		fprintf('Results for %d internal nodes and lambda = %.2f\n', num_nodes, lambda);
		fprintf('Accuracy: %f\n', measures(1));
		fprintf('F-Measure: %f\n', measures(2));
		fprintf('MCC: %f\n', measures(3));
		fprintf('------------------------------\n');

		fprintf(result_file, 'Results for %d internal nodes and lambda = %.2f\n', num_nodes, lambda);
		fprintf(result_file, 'Accuracy: %f\n', measures(1));
		fprintf(result_file, 'F-Measure: %f\n', measures(2));
		fprintf(result_file, 'MCC: %f\n', measures(3));
		fprintf(result_file, '------------------------------\n');

		fclose(result_file);
	end
end