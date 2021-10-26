% Name: hw3.m
% Author: Jazel A. Suguitan
% Last Modified: Oct. 26, 2021

clc,clear
close all

% Q Learning (Off-Policy Control)

% Create Q table

alpha = 0.1;    %initialize learning rate (WHAT TO SET???)
gamma = 0.9; %
grid_size = 5;
%[X,Y] = meshgrid(grid_size);
grid = zeros(grid_size);
num_states = grid_size * grid_size;
S = 1:num_states;
num_actions = 4;
A = 1:num_actions; % 1-up, 2-down, 3-right, 4-left
num_eps = 6;
num_its = 100;
delta_t_update = 0.008;
T = 0:delta_t_update:7; % Set simulation time
Q = cell(num_states, num_actions);   % create initial Q-table  zeros(num_states, 4)
s_ = cell(size(T), num_its);
a_ = cell(size(T,1), num_its);

%Q (s_{0}, a_{0})(0) = zeros(num_states, num_actions);

for episode = 1:num_eps
    t = episode;    %extra variable t to make Q equation look cleaner
    s_{t} = 1;  %place robot in upper left cell of grid
    for iteration = 1:num_its
        k = iteration;  % extra variable k to make Q equation look cleaner
        if iteration == 1 %first iteration, Q table is empty
           
        end
        %Q (s_{t}, a_{t})(k) = Q(s_{t}, a_{t})(k-1) + alpha [ r_{t+1} + gamma * Q(s_{t+1}, a_{t+1})(k-1)- Q(s_{t}, a_{t})(k-1)]
    end
end