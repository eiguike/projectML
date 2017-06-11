clear ; close all; clc

% Build libsvm library
cd './libsvm-3.22/matlab'
make octave
cd '../..'

% Add common functions to Octave search path
addpath('../common');

% Add libsvm to Octave search path
addpath('./libsvm-3.22/matlab');

fprintf('SVM iniciado!\n');

% Load data, save labels and normalize features
fprintf('Carregando dados...\n');
data = csvread('../../data/balanced_data.csv');
labels = data(:,end);
[X_norm, mu, sigma] = normalizar(data);
X_norm(:,end) = labels;

% Set number of folds and initialize metric variables
k = 10;
acc = f_m = mcc_ = 0;
tp =  fp =  fn =  tn = 0;
tp_sum =  fp_sum =  fn_sum =  tn_sum = 0;

% Fetch number of observations and initialize partition variables
num_amostras = size(data, 1);
tam_particao = ceil(num_amostras / k);

data = X_norm(randperm(num_amostras), :);

% Cross validation iteration
fprintf('Iniciando K-fold cross-validation\n');
for (i = 0 : k-1)
  fprintf('=====================\n');
  fprintf('Fold de numero: %d\n', i + 1);
	inicio = (i * tam_particao) + 1;
	fim = min(inicio + tam_particao - 1, num_amostras);

	train_data = [(data((1:(inicio - 1)), :));(data((fim + 1) : num_amostras, :))];
	test_data = data(inicio:fim, :);

	[tp, fp, fn, tn] = svm(train_data, test_data);

  fprintf('tp: %d | fn: %d\n', tp, fn);
  fprintf('fp: %d | tn: %d\n', fp, tn);

  tp_sum += tp;
  fp_sum += fp;
  tn_sum += tn;
  fn_sum += fn;

  mcc(tp, fp, fn, tn);
  f_measure(tp, fp, fn, tn);
  accuracy(tp, fp, fn, tn);
  fprintf('=====================\n');
end

acc = accuracy(tp_sum, fp_sum, fn_sum, tn_sum);
mcc_ = mcc(tp_sum, fp_sum, fn_sum, tn_sum);
f_m = f_measure(tp_sum, fp_sum, fn_sum, tn_sum);

fprintf('=====================\n');
fprintf('SVM resultados finais:\n');
fprintf('tp: %d | fn: %d\n', tp_sum, fn_sum);
fprintf('fp: %d | tn: %d\n', fp_sum, tn_sum);

fprintf('mcc: %f\n', mcc_);
fprintf('acc: %f\n', acc * 100);
fprintf('f_m: %f\n', f_m * 100);

fprintf('\nSVM concluido!\n');
