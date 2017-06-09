clc; clear; close all

dados = csvread('basefinal.csv');
num_amostras = size(dados, 1);
num_colunas = size(dados, 2);

dados = sortrows(dados, num_colunas);
qtdpos = sum(dados(:,num_colunas));

dados = [dados(1:qtdpos, :); dados(num_amostras - qtdpos + 1: num_amostras, :)];
num_amostras = size(dados, 1);

k = 5;
acc = 0;
f_measure = 0;
mcc = 0;

dados = [normalizar(dados(:, 1:num_colunas - 1)) dados(:, num_colunas)];


tam_particao = ceil(num_amostras / k);

dados = dados(randperm(num_amostras), :);

for (i = 0 : k-1)
	inicio = (i * tam_particao) + 1;
	fim = min(inicio + tam_particao - 1, num_amostras);

	train_data = [   (dados((1 : (inicio - 1)), :))   ;   (dados((fim + 1) : num_amostras, :))   ]; 
	test_data = dados(inicio:fim, :);

	[acc_parcial, f_measure_parcial, mcc_parcial] = redes_neurais(train_data, test_data);
	
	acc = acc + acc_parcial;
	f_measure = f_measure + f_measure_parcial;
	mcc = mcc + mcc_parcial;


end

acc = acc / k
f_measure = f_measure / k
mcc = mcc / k

fprintf('\n----------------\nAcuracia FINAL no experimento: %f\n', acc );
fprintf('\nF-medida FINAL no experimento: %f\n', f_measure );
fprintf('\nMCC FINAL no experimento: %f\n', mcc );
