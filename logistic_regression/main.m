% Machine Learning Project
% Logistic Regression

% loading database %
X = csvread("../result/bank_cleaned_preprocessed.csv");

% getting the final results %
%Y = X(:,end);

% removing final results from database %
%X = X(:,1:(end-1));

% loading tests %
%X_test = csvread("../input/bank.csv");

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


[X_norm, mu, sigma] = normalizar(X);

k = 10;
acc = 0

num_amostras = size(X, 1);
tam_particao = ceil(num_amostras / k);

X = X(randperm(num_amostras), :);

for (i = 0 : k-1)
	inicio = (i * tam_particao) + 1;
	fim = min(inicio + tam_particao - 1, num_amostras);

	train_data = [   (X((1 : (inicio - 1)), :))   ;   (X((fim + 1) : num_amostras, :))   ];
	test_data = X(inicio:fim, :);

  [m,n] = size(train_data);
  %X = [ones(m,1), X];
  theta_inicial = zeros(n,1);
  %theta_inicial = zeros(n+1,1);

  [custo, grad] = funcaoCusto(theta_inicial, train_data, train_data(:,end));
  opcoes = optimset('GradObj', 'on', 'MaxIter', 10000);
  [theta, custo] = fminunc(@(t)(funcaoCusto(t, train_data, train_data(:,end))), theta_inicial, opcoes);

  p = predicao(theta, test_data);

  acc = acc + mean(double(p == test_data(:,end)));
end

acc = acc / k;
fprintf('Acuracia na base de treinamento: %f\n', acc * 100);
pause
