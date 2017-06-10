%##KNN##%

% carregando base de dados %
X = csvread("../../data/balanced_data.csv");

% variância permitida (PCA) %
variancia = 0.98;

% armazenando classes de saída %
Y = X(:,end);

fprintf('kNN iniciado!\n');

% inicializando variáveis %
tp =  fp =  fn =  tn =  mcc_local = f_m = acc = 0;
tp_acumulator =  fp_acumulator =  fn_acumulator =  tn_acumulator =  mcc_local = f_m = acc = 0;

% normalizando base de dados %
[X_norm, mu, sigma] = normalizar(X);

% k-cross-validation %
k = 10;

[num_amostras, num_atributos] = size(X);
tam_particao = ceil(num_amostras / k);

X = X_norm(randperm(num_amostras), :);

% aplicando pca %
[U,S] = pca(X);

% escolhendo nova dimensionalidade %
for (dim=1 : num_atributos)
  diagonal = diag(S);
  aux = sum(diagonal(1:dim,:))/sum(diagonal);
  if aux >= variancia
    fprintf('Dimensão: %d\n',dim);
    break
  end
endfor

% dados na nova dimensionalidade %
Z = projetarDados(X_norm, U, dim);
X = Z';
X = horzcat(X,Y);

for (i = 0 : k-1)
	inicio = (i * tam_particao) + 1;
	fim = min(inicio + tam_particao - 1, num_amostras);

	train_data = [   (X((1 : (inicio - 1)), :))   ;   (X((fim + 1) : num_amostras, :))   ];
	test_data = X(inicio:fim, :);

	[tp, fp, fn, tn] = knn(test_data, train_data, K);

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
fprintf('=====================\n');
fprintf('tp_total: %d\n', tp_acumulator);
fprintf('fp_total: %d\n', fp_acumulator);
fprintf('tn_total: %d\n', tn_acumulator);
fprintf('fn_total: %d\n', fn_acumulator);

fprintf('mcc_total: %f\n', mcc_local);
fprintf('acc_total: %f\n', acc * 100);
fprintf('f_m_total: %f\n', f_m * 100);
fprintf('kNN concluído!\n');
