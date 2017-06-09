% Machine Learning Project
% kNN

% loading database %
X = csvread("../result/bank_cleaned_preprocessed.csv");
K = 3

num_amostras = size(X, 1);
num_colunas = size(X, 2);

X = sortrows(X, num_colunas);
qtdpos = sum(X(:,num_colunas));

X = [X(1:2*qtdpos, :); X(num_amostras - qtdpos + 1: num_amostras, :)];
num_amostras = size(X, 1);

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

function D = distancia(x, X)
  c = 3;
  [m,n] = size(X);
  D = zeros(m,1);
  for i = 1:m
    D(i) = sqrt(sum( (x - X(i)) .^ 2)); % euclidean distance
    %D(i) = sum( sign((x - X(i))) .* (x - X(i)) ); % manhattan
    %D(i) = (sum( (sign((x - X(i))) .* (x - X(i))).^c ))^(1/c); % Minkowski
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
    %[D, indices] =sort(D);
    %D = horzcat(D, indices);

    D = horzcat(D, train_data_Y);
    D = horzcat(D, (1:size(D,1))');
    D = sortrows(D,[1]);

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

  fprintf('tp: %d\n', tp);
  fprintf('fp: %d\n', fp);
  fprintf('tn: %d\n', tn);
  fprintf('fn: %d\n', fn);
end


% getting the final results %
Y = X(:,end);

% loading tests %
%X_test = csvread("../input/bank.csv");

fprintf('kNN iniciado!\n');
tp =  fp =  fn =  tn =  mcc_local = f_m = acc = 0;

[X_norm, mu, sigma] = normalizar(X);
X_norm(:,end) = Y;

k = 10;
acc = 0

num_amostras = size(X, 1);
tam_particao = ceil(num_amostras / k);

X = X_norm(randperm(num_amostras), :);

for (i = 0 : k-1)
	inicio = (i * tam_particao) + 1;
	fim = min(inicio + tam_particao - 1, num_amostras);

	train_data = [   (X((1 : (inicio - 1)), :))   ;   (X((fim + 1) : num_amostras, :))   ];
	test_data = X(inicio:fim, :);

	[tp, fp, fn, tn] = knn(test_data, train_data, K);
  mcc_local = mcc_local + mcc(tp, fp, fn, tn);
  f_m = f_m + f_measure(tp, fp, fn, tn);
  acc = acc + accuracy(tp, fp, fn, tn);
end

acc = acc / k;
mcc_local = mcc_local / k;
f_m = f_m / k;
fprintf('mcc_total: %f\n', mcc_local * 100);
fprintf('acc_total: %f\n', acc * 100);
fprintf('f_m_total: %f\n', f_m * 100);
fprintf('kNN concluído!\n');
