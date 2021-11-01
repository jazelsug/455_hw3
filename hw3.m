% Name: hw3.m
% Author: Jazel A. Suguitan
% Last Modified: Oct. 30, 2021

clc,clear
close all

% Q Learning (Off-Policy Control)

% ========================== TRAINING =========================

alpha = 0.95;    %initialize learning rate (WHAT TO SET???)
gamma = 0.05; %WHAT TO SET???
epsilon = 0.05;
grid_size = 5;
%[X,Y] = meshgrid(grid_size);
grid = zeros(grid_size);
num_states = grid_size * grid_size;
S = 1:num_states
num_actions = 4;
A = 1:num_actions % 1-up, 2-down, 3-right, 4-left
num_eps = 6;
num_its = 180;
%Q = cell(num_states, num_actions);   % create initial Q-table  zeros(num_states, 4)
Q = randi([1,5], num_states, num_actions); %zeros(num_states, num_actions);
Q(25, :) = 0;
%s_ = cell(size(T), num_its);
%a_ = cell(size(T,1), num_its);
Q_eps = cell(num_eps, 1);
%starts = randi([1,num_states], num_eps, num_its);   %create random start positions, store in num_eps x num_its matrix
%goals = randi([1,num_states], num_eps, num_its);    %create random goal positions
goal = 25;

rewards = [];   %store reward for each action
endsofeps = zeros(num_eps, 1);  %store which iterations mark ends of episodes
totalits = 0; %counter of total iterations
states = [];    %store states for each iteration
actions = []; %store actions taken at each iteration

for episode = 1:num_eps
    s_t = 1;    %place robot in upper left cell of grid
    %s_t = starts(episode, 1);
    %a_t = 3;    %arbitrary initial action
    moves = [];
    for iteration = 1:num_its
        %find max reward in row of Q-table corresponding with current state
        totalits = totalits + 1;
%         [maxReward, max_actions] = max(Q(s_t,:));
%         
%         %select random a_next if there are multiple maximums
%         pos = length(max_actions);
%         a_next = max_actions(pos);

        states(totalits) = s_t; %store current state

        a_next = select_action(Q, s_t, epsilon, num_actions);
        
        
        actions(totalits) = a_next;   %store action taken at current state
        
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
        if s_next == goal %goals(episode,iteration)
           %robot reached goal
           r = 100;
        elseif (s_next >= 1 && s_next <= grid_size) || (mod(s_next, grid_size) == 0) || (mod(s_next, grid_size) == 1)
            %robot now in border cell
            r = -1;
        else
            %all other actions
            if ismember(s_next, moves)
                r = 0;
            else
                r = 0.3;
            end
        end
        
%         if iteration > 2
%             if s_next == moves(iteration-2)%ismember(s_next, moves)
%                 %new state had already been visited in this episode
%                 r = r - 0.5;
%             end
%         elseif iteration == 2
%             if s_next == 1
%                 r = r - 0.5;
%             end
%         end
%         
        moves(iteration) = s_next;
        
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

figure(1), plot(rewards)
xlabel('Iterations');
ylabel('Reward');
for i=1:num_eps
    xline(endsofeps(i)); %vertical lines divide each episode
end

% ========================== ACTION SELECTION PLOTS =========================
x = 0;  %value that x-axis starts at
y = 0;  %value that y-axis starts at
width = 1;  %width of cell
height = 1; %height of cell
nrow = grid_size;
ncol = grid_size;
figure(2),hold on
for i = 1:nrow
    yy = y + (i-1)*height;
    for j = 1:ncol
        xx = x + (j-1)*width;
          %rectangle('position',[xx,yy,width,height],'facecolor',rand(3,1))
          rectangle('position',[xx,yy,width,height])
    end
end

%plot for first/initial episode
for i = 1:endsofeps(1)
    state = states(i);
    action = actions(i);
    
    %calculate position of arrow
    x_value = mod(state, grid_size) + 0.5; %+0.5 to be in middle of cell
    if mod(state, grid_size) == 0
        y_value = grid_size - (state/grid_size) + 1 - 0.5; %-0.5 to be in middle of cell
    else
        y_value = grid_size - floor(state/grid_size) - 0.5; %-0.5 to be in middle of cell
    end
    
    %draw arrow
    if action == 1 %up
        quiver(x_value, y_value, 0, 0.3, 'b', 'LineWidth', 1.5);
    elseif action == 2 %down
        quiver(x_value, y_value, 0, -0.3, 'b', 'LineWidth', 1.5);
    elseif action == 3 %right
        quiver(x_value, y_value, 0.3, 0, 'b', 'LineWidth', 1.5);
    else %left
        quiver(x_value, y_value, -0.3, 0, 'b', 'LineWidth', 1.5);
    end
end

% ========================== TASK =========================

s_t = 1;
goal = 25;

task_steps = [];

for t=1:num_its
    [maxReward, max_actions] = max(Q(s_t,:));

    %select random a_next if there are multiple maximums
    pos = length(max_actions);
    a_next = max_actions(pos);

    %take action
    if a_next == 1  %up
        s_next = s_t - grid_size;
    elseif a_next == 2  %down
        s_next = s_t + grid_size;
    elseif a_next == 3 %right
        s_next = s_t + 1;
    else   %left
        s_next = s_t - 1;
    end

    %update current state variable
    s_t = s_next;
    task_steps(t) = s_t;

    %update reward array (for plot)
    if (s_t == 25)
        break
    end
end

function a = select_action(Q, S, epsilon, num_actions)
    n = randi([0,1]);
    if n < epsilon
        a = randi([1,num_actions]);
    else
        [maxReward, max_actions] = max(Q(S,:));
        a = max_actions(1);
    end
end