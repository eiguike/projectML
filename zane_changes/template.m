clc; clear; close all

dados = csvread('basefinal.csv');

k = 10;

num_amostras = size(dados, 1);
tam_particao = ceil(num_amostras / k);

dados = dados(randperm(num_amostras), :);

for (i = 0 : k-1)
	inicio = (i * tam_particao) + 1;
	fim = min(inicio + tam_particao - 1, num_amostras);

	test_data = dados(inicio:fim, :);
	train_data = [   (dados((1 : (inicio - 1)), :))   ;   (dados((fim + 1) : num_amostras, :))   ]; 
end