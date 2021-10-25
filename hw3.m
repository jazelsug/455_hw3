% Name: hw3.m
% Author: Jazel A. Suguitan
% Last Modified: Oct. 24, 2021

clc,clear
close all

% Q Learning (Off-Policy Control)

% Create Q table

grid_size = 5;
num_states = grid_size * grid_size;
S = 1:num_states;
A = 1:4; % 1-up, 2-down, 3-right, 4-left
num_of_eps = 6;
num_of_its = 100;

for episode = 1:num_of_eps
    for iteration = 1:num_of_its
        %yolo!
        %Q (s_{t}, a_{t})(k) = Q(s_{t}, a_{t})(k-1) + alpha [ r_{t+1} + gamma * Q(s_{t+1}, a_{t+1})(k-1)- Q(s_{t}, a_{t})(k-1)]
    end
end