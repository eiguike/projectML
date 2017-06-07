function [acc, f_m, mcc_] = redes_neurais(basetreino, baseteste)

% clear ; close all; clc

% dados = csvread('basefinal.csv');

Xtreino = basetreino(:, 1: size(basetreino, 2) - 1);
% X = normalizar(X);
ytreino = basetreino(:, size(basetreino, 2));


Xteste = baseteste(:, 1: size(baseteste, 2) - 1);
% X = normalizar(X);
yteste = baseteste(:, size(baseteste, 2));

m = size(Xtreino, 1);

input_layer_size  = size(Xtreino,2);  
hidden_layer_size = 5;   

init = 0.13;
Theta1_inicial = rand(hidden_layer_size, input_layer_size + 1) * 2 * init - init;
Theta2_inicial = rand(1, hidden_layer_size + 1) * 2 * init - init;

parametros_iniciais = [Theta1_inicial(:) ; Theta2_inicial(:)];

options = optimset('MaxIter', 20);
lambda = 1;

funcaoCusto = @(p) rnaCusto(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   Xtreino, ytreino, lambda);

[rna_params, cost] = fmincg(funcaoCusto, parametros_iniciais, options);

Theta1 = reshape(rna_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(rna_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 1, (hidden_layer_size + 1));

pred = predicao(Theta1, Theta2, Xteste);

cm = confusionmat(yteste, pred);

acc = accuracy(cm(1, 1), cm(1, 2), cm(2, 1), cm(2,2));
f_m = f_measure(cm(1, 1), cm(1, 2), cm(2, 1), cm(2,2));
mcc_ = mcc(cm(1, 1), cm(1, 2), cm(2, 1), cm(2,2))

fprintf('\nAcuracia no conjunto de treinamento: %f\n', acc );
fprintf('\nF-medida no conjunto de treinamento: %f\n', f_m );
fprintf('\nMCC no conjunto de treinamento: %f\n', mcc_ );
