function [acc, f_m, mcc_] = redes_neurais(basetreino, baseteste)

Xtreino = basetreino(:, 1: size(basetreino, 2) - 1);
ytreino = basetreino(:, size(basetreino, 2));

Xteste = baseteste(:, 1: size(baseteste, 2) - 1);
yteste = baseteste(:, size(baseteste, 2));

m = size(Xtreino, 1);

input_layer_size  = size(Xtreino,2);  
hidden_layer_size = 5;   

init = 0.12;
Theta1_inicial = rand(hidden_layer_size, input_layer_size + 1) * 2 * init - init;
Theta2_inicial = rand(1, hidden_layer_size + 1) * 2 * init - init;

parametros_iniciais = [Theta1_inicial(:) ; Theta2_inicial(:)];

options = optimset('MaxIter', 50);
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
mcc_ = mcc(cm(1, 1), cm(1, 2), cm(2, 1), cm(2,2));

fprintf('TP = %f, FP = %f\n', cm(1, 1), cm(1, 2));
fprintf('FN = %f, TN = %f\n\n', cm(2, 1), cm(2, 2));
fprintf('Acuracia no conjunto de treinamento: %f\n', acc );
fprintf('F-medida no conjunto de treinamento: %f\n', f_m );
fprintf('MCC no conjunto de treinamento: %f\n\n', mcc_ );
