function [C, gamma, metrics] = grid_search(data, C_range, gamma_range, C_step, gamma_step, type, PCA)
  % Choosing k for k-fold cross validation
  k = 5;

  % Initializing PCA K value
  PCA_K = 1;

  % Selecting desired variance keep for PCA
  desired_variance = 0.98;

  % Storing number of samples and attributes
  sample_count = size(data, 1);
  num_attributes = size(data, 2);

  % Getting the fold size for cross validation
  fold_size = ceil(sample_count / k);

  % Shuffling data
  data = data(randperm(sample_count), :);
  fprintf('Grid Search iniciado!\n');

  % Initialize Grid Search variables
  C = gamma = metrics = 0;

  grid = [];
  save('-text', strcat(type, '_grid.mat'), 'grid');
  C_current = C_range(1);
  while (C_current <= C_range(2))
    gamma_current = gamma_range(1);
    while (gamma_current <= gamma_range(2))
      % Initializing accuracy, f_measure and MCC accumulators
      acc_sum = 0;
      % Initialize metric variables
      tp =  fp =  fn =  tn = 0;
      tp_sum =  fp_sum =  fn_sum =  tn_sum = 0;
      % For each cross validation iteration
      fprintf('======================\n');
      fprintf('Iniciando K-fold cross-validation\n');
      fprintf('Parametros:\n');
      fprintf('C: %.5f. Gamma: %.15f.\n', C_current, gamma_current);
      fprintf('----------------------\n');

      for (i = 0 : k-1)
        fprintf('Fold de numero: %d\n', i + 1);
      	% Getting the indexes for the start and end of the test fold
      	start_idx = (i * fold_size) + 1;
      	end_idx = min(start_idx + fold_size - 1, sample_count);

      	% Getting the train and test sets from the original set
      	train_data = [(data((1:(start_idx - 1)), :)); (data((end_idx + 1):sample_count, :))];
      	test_data = data(start_idx:end_idx, :);

      	% ------------------- NORMALIZATION BLOCK --------------------------
      	[X_norm, avg, stddev] = normalizar(train_data(:, 1:num_attributes-1));
      	X_norm_test = (test_data(:, 1:num_attributes-1) - repmat(avg, size(test_data, 1), 1)) ./ repmat(stddev, size(test_data, 1), 1);

      	normalized_train_data = [X_norm train_data(:, num_attributes)];
      	normalized_test_data = [X_norm_test test_data(:, num_attributes)];

      	train_data = normalized_train_data;
      	test_data = normalized_test_data;
      	% -------------------------------------------------------------------

        % ---------------------- PCA BLOCK ---------------------------------
        if (PCA == true)
          X_train = train_data(:, 1:num_attributes-1);
          Y_train = train_data(:, num_attributes);

          X_test = test_data(:, 1:num_attributes-1);
          Y_test = test_data(:, num_attributes);

          [U, S] = pca(X_train);
          diagonal = diag(S);

          for (count = 1:num_attributes-1)
            K = num_attributes - count;
            if ((sum(diagonal(1:K) / sum(diagonal))) > desired_variance)
              PCA_K = K;
            end
          end

          fprintf('Chosen K for PCA: %d\n', PCA_K)

          Z_train = projetarDados(X_train, U, PCA_K);
          Z_test = projetarDados(X_test, U, PCA_K);

          train_data = [Z_train Y_train];
          test_data = [Z_test Y_test];
        end
        % ------------------------------------------------------------------

      	% Getting the results for this step of the experiment
      	[tp, fp, fn, tn] = svm(train_data, test_data, C_current, gamma_current);
        tp_sum += tp;
        fp_sum += fp;
        tn_sum += tn;
        fn_sum += fn;

        fprintf('tp: %d | fn: %d\n', tp, fn);
        fprintf('fp: %d | tn: %d\n', fp, tn);

        fprintf('Fold Accuracy: %f\n', accuracy(tp, fp, fn, tn));
        fprintf('----------------------\n');

      	% Accumulate measures
      	acc_sum += accuracy(tp, fp, fn, tn);
      end

      acc_sum = acc_sum / k;
      grid(end+1,:) = [C_current gamma_current tp_sum fp_sum tn_sum fn_sum acc_sum];
      save('-text', strcat(type, '_grid.mat'), 'grid');
      gamma_current *= gamma_step;
    endwhile
    C_current *= C_step;
  endwhile

  % Return variables
  [max_values inds] = max(grid);
  C = grid(inds(7), 1);
  gamma = grid(inds(7), 2);
  metrics = grid(inds(7), 3:7);

  % Print best grid params and results
  fprintf(cstrcat('The ', type, ' grid has finished!'));
  fprintf('-------Results-------\n');
  fprintf('C: %f ', C);
  fprintf('gamma: %f\n', gamma);
  fprintf('Accuracy: %f\n', grid(inds(7), 7));
  fprintf('---------------------\n');
end
