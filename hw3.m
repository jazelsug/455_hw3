% Name: hw3.m
% Author: Jazel A. Suguitan
% Last Modified: Oct. 27, 2021

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
%T = 0:delta_t_update:7; % Set simulation time
%Q = cell(num_states, num_actions);   % create initial Q-table  zeros(num_states, 4)
Q = zeros(num_states, num_actions);
%s_ = cell(size(T), num_its);
%a_ = cell(size(T,1), num_its);
Q_eps = cell(num_eps, 1);
goals = randi([2,num_states], num_eps, num_its);    %create random goal positions, store in num_eps x num_its matrix

for episode = 1:num_eps
    %t = episode;    %extra variable t to make Q equation look cleaner
    %s_{t} = 1;  %place robot in upper left cell of grid
    s_t = 1;    %place robot in upper left cell of grid
    for iteration = 1:num_its
        %k = iteration;  % extra variable k to make Q equation look cleaner
        %find max reward in row of Q-table corresponding with current state
        [maxReward, a_next] = max(Q(s_t));
        
        %take action
        if a_next == 1  %up
            if s_t >= 1 && s_t <= grid_size %robot is currently in top row of grid
                %do not move out of grid. do nothing
                s_next = s_t;
            else %robot is able to move up
                s_next = s_t - grid_size;
            end
        elseif a_next == 2  %down
            if s_t <= num_states && s_t > num_states - grid_size %robot is currently in bottom row of grid
                %do not move out of grid. do nothing
                s_next = s_t;
            else %robot is able to move down
                s_next = s_t + grid_size;
            end
        elseif a_next == 3 %right
            if mod(s_t, grid_size) == 0 %robot is currently in rightmost column of grid
                %do not move out of grid. do nothing
                s_next = s_t;
            else %robot is able to move right
                s_next = s_t + 1;
            end
        else   %left
            if mod(s_t, grid_size) == 1 %robot is currently in leftmost column of grid
                %do not move out of grid. do nothing
                s_next = s_t;
            else % robot is able to move left
                s_next = s_t - 1;
            end
        end
        
        %assign reward from new state after taken action
        
        
        %Q = Q + alpha * ();
        %FROM SLIDES: Q (s_{t}, a_{t})(k) = Q(s_{t}, a_{t})(k-1) + alpha [ r_{t+1} + gamma * Q(s_{t+1}, a_{t+1})(k-1)- Q(s_{t}, a_{t})(k-1)]
    end
    Q_eps{episode} = Q;
end