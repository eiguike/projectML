clc; clear; close all

dados = csvread('basefinal.csv');
k = 10;
acc = 0

num_amostras = size(dados, 1);
tam_particao = ceil(num_amostras / k);

dados = dados(randperm(num_amostras), :);

for (i = 0 : k-1)
	inicio = (i * tam_particao) + 1;
	fim = min(inicio + tam_particao - 1, num_amostras);

	train_data = [   (dados((1 : (inicio - 1)), :))   ;   (dados((fim + 1) : num_amostras, :))   ]; 
	test_data = dados(inicio:fim, :);

	acc = acc + some_algorithm(train_data, test_data)
end

acc = acc / 10