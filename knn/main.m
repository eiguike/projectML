% Machine Learning Project
% kNN

% loading database %
X = csvread("../result/bank_cleaned_preprocessed.csv");
K = 3

% getting the final results %
Y = X(:,end);

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

function D = distancia(x, X)
  [m,n] = size(X);
  D = zeros(m,1);
  for i = 1:m
    D(i) = sqrt(sum( (x .- X(i)) .^ 2));
  endfor
end

function [tp, fp, fn, tn] = knn(test_data, train_data, K)

  % getting final results %
  test_data_Y = test_data(:,end);
  train_data_Y = train_data(:,end);

  % removing final results %
  train_data = train_data(:,1:(end-1));
  test_data = test_data(:,1:(end-1));

  [m, n] = size(test_data_Y);

  Y_out = zeros(m, 1);

  ind_viz = ones(K,1);  % Inicializa indices (linhas) em train_data das K amostras mais

  for i=1:m
    D = distancia(test_data(i,:), train_data);
    D = horzcat(D, train_data_Y);
    D = horzcat(D, (1:size(D,1))');
    D = sortrows(D);

    indices = D(:,end);
    classes = D(:,end-1);

    ind_viz = indices(1:K);
    viz_classes = classes(1:K);

    if sum(viz_classes) <= (K / 2)
        Y_out(i) = 0;
    else
        Y_out(i) = 1;
    endif
  endfor

  tp = sum(((Y_out == 0)+1) == (test_data_Y == 1));
  fp = sum(((Y_out == 0)+1) == (test_data_Y == 0));
  tn = sum(((Y_out == 1)+1) == (test_data_Y == 0));
  fn = sum(((Y_out == 1)+1) == (test_data_Y == 1));

  Y_out
  test_data_Y
  fprintf('tp: %d\n', tp);
  fprintf('fp: %d\n', fp);
  fprintf('tn: %d\n', tn);
  fprintf('fn: %d\n', fn);
  fprintf('acc: %f\n', (tp+tn)/(tp+fp+tn+fn));
  acc = mean(double(Y_out == test_data_Y));
end

fprintf('kNN iniciado!\n');

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

	acc = acc + knn(test_data, train_data, 5);
end

acc = acc / k;
fprintf('Acuracia na base de treinamento: %f\n', acc * 100);
fprintf('kNN concluído!\n');
