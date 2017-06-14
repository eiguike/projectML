function [tp, fp, fn, tn] = redes_neurais(basetreino, baseteste, chosen_lambda, num_internal_nodes)

Xtreino = basetreino(:, 1: size(basetreino, 2) - 1);
ytreino = basetreino(:, size(basetreino, 2));

Xteste = baseteste(:, 1: size(baseteste, 2) - 1);
yteste = baseteste(:, size(baseteste, 2));

m = size(Xtreino, 1);

input_layer_size  = size(Xtreino,2);  
hidden_layer_size = fix(num_internal_nodes);   

init = 0.12;
Theta1_inicial = rand(hidden_layer_size, input_layer_size + 1) * 2 * init - init;
Theta2_inicial = rand(1, hidden_layer_size + 1) * 2 * init - init;

parametros_iniciais = [Theta1_inicial(:) ; Theta2_inicial(:)];

options = optimset('MaxIter', 75);
lambda = fix(chosen_lambda);

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

tp = sum(((pred == 0)+1) == (yteste == 1));
fp = sum(((pred == 0)+1) == (yteste == 0));
tn = sum(((pred == 1)+1) == (yteste == 0));
fn = sum(((pred == 1)+1) == (yteste == 1));

