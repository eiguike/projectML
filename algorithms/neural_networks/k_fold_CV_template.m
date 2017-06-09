clc; clear; close all

dados = csvread('basefinal.csv');
k = 10;
acc = 0;
f_measure = 0;
mcc = 0;

num_amostras = size(dados, 1);
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