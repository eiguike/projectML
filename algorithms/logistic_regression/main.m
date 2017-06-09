% Machine Learning Project
% Logistic Regression

% loading database %
X = csvread("../../data/balanced_data.csv");

function acc = accuracy(tp, fp, fn, tn)
  acc = (tp + tn) / (tp + fp + fn + tn);
  fprintf('acc: %f\n', acc);
end

function f_m = f_measure(tp, fp, fn, tn)
  prec = tp / (tp + fp);
  rec = tp / (tp + fn);
  f_m = 2 * ((prec * rec) / (prec + rec));
  fprintf('f_m: %f\n', f_m);
end

function mcc = mcc(tp, fp, fn, tn)
  mcc =  ((tp * tn) - (fp * fn)) / sqrt((tp + fp) * (tp + fn) * (tn + fp) * (tn + fn)); 
  fprintf('mcc: %f\n', mcc);
end

function [X_norm, mu, sigma] = normalizar(X)
  [m,n] = size(X); % m = qtde de objetos e n = qtde de atributos por objeto
  X_norm = zeros(m,n); % inicializa X_norm
  mu = 0; % inicializa media
  sigma = 1; % inicializa desvio padrao
  X_norm = X;
  mu = mean(X);
  sigma = std(X);
  X_norm = X_norm - mu;
  X_norm = X_norm ./sigma;
end

function [J, grad] = funcaoCusto(theta, X, y)
m = length(y); % numero de exemplos de treinamento
J = 0;
grad = zeros(size(theta));
hyp = sigmoid(X*theta);
J = (-y' * log(hyp) - (1 - y)' * log(1-hyp))/m;
grad = (X' *(hyp - y))./m;
end

function p = predicao(theta, X)
m = size(X, 1); % Numero de examplos de treinamento
p = zeros(m, 1);
p = (sigmoid(theta' * X') >= 0.5)';
end

function g = sigmoid(z)
g = zeros(size(z));
g = 1 ./ (1 + e .^ -z);
end

function p = predicao(theta, X)
m = size(X, 1); % Numero de examplos de treinamento
p = zeros(m, 1);
p = (sigmoid(theta' * X') >= 0.5)';
end

fprintf('Regressão Logística iniciado!\n');

[X_norm, mu, sigma] = normalizar(X);
X_norm(:,end) = X(:,end);

k = 10;
acc = 0
tp =  fp =  fn =  tn =  mcc_local = f_m = acc = 0;
tp_acumulator =  fp_acumulator =  fn_acumulator =  tn_acumulator =  mcc_local = f_m = acc = 0;

num_amostras = size(X, 1);
tam_particao = ceil(num_amostras / k);

X = X_norm(randperm(num_amostras), :);

for (i = 0 : k-1)
	inicio = (i * tam_particao) + 1;
	fim = min(inicio + tam_particao - 1, num_amostras);

	train_data = [   (X((1 : (inicio - 1)), :))   ;   (X((fim + 1) : num_amostras, :))   ];
	test_data = X(inicio:fim, :);

  [m,n] = size(train_data);
  %X = [ones(m,1), X];
  theta_inicial = zeros(n,1);
  %theta_inicial = zeros(n+1,1);

  test_data_Y = test_data(:,end);

  [custo, grad] = funcaoCusto(theta_inicial, train_data, train_data(:,end));
  opcoes = optimset('GradObj', 'on', 'MaxIter', 10000);
  [theta, custo] = fminunc(@(t)(funcaoCusto(t, train_data, train_data(:,end))), theta_inicial, opcoes);

  p = predicao(theta, test_data);

  tp = sum(((p == 0)+1) == (test_data_Y == 1));
  fp = sum(((p == 0)+1) == (test_data_Y == 0));
  tn = sum(((p == 1)+1) == (test_data_Y == 0));
  fn = sum(((p == 1)+1) == (test_data_Y == 1));


  fprintf('tp: %d\n', tp);
  fprintf('fp: %d\n', fp);
  fprintf('tn: %d\n', tn);
  fprintf('fn: %d\n', fn);

  tp_acumulator = tp + tp_acumulator;
  fp_acumulator = fp + fp_acumulator;
  tn_acumulator = tn + tn_acumulator;
  fn_acumulator = fn + fn_acumulator;

  mcc(tp, fp, fn, tn);
  f_measure(tp, fp, fn, tn);
  accuracy(tp, fp, fn, tn);
  fprintf('=====================\n');
end

acc = accuracy(tp_acumulator, fp_acumulator, fn_acumulator, tn_acumulator);
mcc_local = mcc(tp_acumulator, fp_acumulator, fn_acumulator, tn_acumulator);
f_m = f_measure(tp_acumulator, fp_acumulator, fn_acumulator, tn_acumulator);

fprintf('tp_total: %d\n', tp_acumulator);
fprintf('fp_total: %d\n', fp_acumulator);
fprintf('tn_total: %d\n', tn_acumulator);
fprintf('fn_total: %d\n', fn_acumulator);

fprintf('mcc_total: %f\n', mcc_local);
fprintf('acc_total: %f\n', acc * 100);
fprintf('f_m_total: %f\n', f_m * 100);
fprintf('Regressão Logística concluído!\n');
