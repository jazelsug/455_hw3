% Name: hw3.m
% Author: Jazel A. Suguitan
% Last Modified: Oct. 30, 2021

clc,clear
close all

% Q Learning (Off-Policy Control)

% ========================== TRAINING =========================

alpha = 0.8;    %initialize learning rate (WHAT TO SET???)
gamma = 0.2; %WHAT TO SET???
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
Q = randi([1,10], num_states, num_actions); %zeros(num_states, num_actions);
Q(25, :) = 0;
%s_ = cell(size(T), num_its);
%a_ = cell(size(T,1), num_its);
Q_eps = cell(num_eps, 1);
starts = randi([1,num_states], num_eps, num_its);   %create random start positions, store in num_eps x num_its matrix
%goals = randi([1,num_states], num_eps, num_its);    %create random goal positions
goal = 25;

rewards = [];
s_next_record = zeros(num_eps * num_its, 1);
endsofeps = zeros(num_eps, 1);

totalits = 0;

for episode = 1:num_eps
    %t = episode    %extra variable t to make Q equation look cleaner
    %s_t = 1;    %place robot in upper left cell of grid
    s_t = starts(episode, 1);
    %a_t = 3;    %arbitrary initial action
    for iteration = 1:num_its
        %k = iteration  % extra variable k to make Q equation look cleaner
        %find max reward in row of Q-table corresponding with current state
        totalits = totalits + 1;
        [maxReward, max_actions] = max(Q(s_t,:));
        
        %select random a_next if there are multiple maximums
        pos = length(max_actions);
        a_next = max_actions(pos);
        
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
        
        s_next_record(totalits) = s_next;
        
        %assign reward from new state after taken action
        if s_next == goal %goals(episode,iteration)
           %robot reached goal
           r = 100;
        elseif (s_next >= 1 && s_next <= grid_size) || (mod(s_next, grid_size) == 0) || (mod(s_next, grid_size) == 1)
            %robot now in border cell
            r = -1;
        else
            %all other actions
            r = 0;
        end
        
        %get max reward of new state from Q-table
        newMax = max(Q(s_next,:));
        
        %update Q table
        Q(s_t,a_next) = Q(s_t,a_next) + alpha * (r + gamma*newMax - Q(s_t,a_next));
        %FROM SLIDES: Q (s_{t}, a_{t})(k) = Q(s_{t}, a_{t})(k-1) + alpha [ r_{t+1} + gamma * Q(s_{t+1}, a_{t+1})(k-1)- Q(s_{t}, a_{t})(k-1)]
        
        %update current state variable
        s_t = s_next;
        
        %update reward array (for plot)
        rewards(totalits) = r;
        if (r == 100)
            iteration = num_its; %end the episode if terminal state was reached - DOES IT WORK??
            break
        end
    end
    Q_eps{episode} = Q;
    endsofeps(episode) = totalits;
end

Final_Q_Table = Q_eps{num_eps}

plot(rewards)
xlabel('Iterations');
ylabel('Reward');
for i=1:num_eps
    xline(endsofeps(i)); %vertical lines divide each episode
end