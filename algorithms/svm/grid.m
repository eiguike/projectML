% Clearing everything
clc; clear; close all

% Build libsvm library
cd './libsvm-3.22/matlab'
make octave
cd '../..'

% Add common functions to Octave search path
addpath('../common');

% Add libsvm to Octave search path
addpath('./libsvm-3.22/matlab');

% Reading data
data = csvread('../../data/balanced_data.csv');

% Grid Search ranges and steps for each parameter
C_range = [2^13 2^15];
gamma_range = [2^-13 2^1];
C_step = gamma_step = 2^2;

% Execute Coarse Grid Search without PCA
[C gamma metrics] = grid_search(data, C_range, gamma_range, C_step, gamma_step, 'Coarse', false);

% Execute Coarse Grid Search with PCA
[C gamma metrics] = grid_search(data, C_range, gamma_range, C_step, gamma_step, 'Coarse', true);

% Once we have executed the Coarse grid searches we can select the ranges
% of C and gamma that yielded the best results and perform Fine grid searches
C_range = [2^1 2^5];
gamma_range = [2^-9 2^-5];
C_step = gamma_step = 2^.25;

% Execute Fine Grid Search without PCA
[C gamma metrics] = grid_search(data, C_range, gamma_range, C_step, gamma_step, 'Fine', false);

% Execute Fine Grid Search with PCA
[C gamma metrics] = grid_search(data, C_range, gamma_range, C_step, gamma_step, 'Fine', true);
