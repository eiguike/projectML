function acc = redes_neurais(basetreino, baseteste)

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

options = optimset('MaxIter', 5);
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

acc = mean(double(pred == yteste)) * 100;
fprintf('\nAcuracia no conjunto de treinamento: %f\n', acc );
