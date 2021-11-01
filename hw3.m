% Name: hw3.m
% Author: Jazel A. Suguitan
% Last Modified: Nov. 1, 2021

clc,clear
close all

% Q Learning (Off-Policy Control)

% ========================== TRAINING =========================

alpha = 0.95;
gamma = 0.05;
epsilon = 0.05;
grid_size = 5;
num_states = grid_size * grid_size;
S = 1:num_states
num_actions = 4;
A = 1:num_actions % 1-up, 2-down, 3-right, 4-left
num_eps = 6;
num_its = 180;
Q_eps = cell(num_eps, 1);   %store Q-tables for each episode
%starts = randi([1,num_states], num_eps, num_its);   %create random start positions, store in num_eps x num_its matrix
%goals = randi([1,num_states], num_eps, num_its);    %create random goal positions
start = 1;  %starting cell
goal = 25;  %terminal cell

Q = randi([1,5], num_states, num_actions); %initialize Q table with arbitrary values
Q(goal, :) = 0; %initialize Q values for terminal state = 0

rewards = [];   %store reward for each action
endsofeps = zeros(num_eps, 1);  %store which iterations mark ends of episodes
totalits = 0; %counter of total iterations
states = [];    %store states for each iteration
actions = []; %store actions taken at each iteration

for episode = 1:num_eps
    s_t = start;    %place robot in upper left cell of grid
    %s_t = starts(episode, 1);
    moves = [];
    for iteration = 1:num_its
        totalits = totalits + 1;    %increment total number of iterations

        states(totalits) = s_t; %store current state

        a_next = select_action(Q, s_t, epsilon, num_actions);   %choose action
                
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
        elseif ismember(s_next, moves)
            %robot revisited a cell it has already explored
            r = 0;
        else
            %all other actions
            r = 0.3;
        end
     
        moves(iteration) = s_next;  %keep track states for current episode only
        
        %get max reward of new state from Q-table
        newMax = max(Q(s_next,:));
        
        %update Q table
        Q(s_t,a_next) = Q(s_t,a_next) + alpha * (r + gamma*newMax - Q(s_t,a_next));
        %FROM SLIDES: Q (s_{t}, a_{t})(k) = Q(s_{t}, a_{t})(k-1) + alpha [ r_{t+1} + gamma * Q(s_{t+1}, a_{t+1})(k-1)- Q(s_{t}, a_{t})(k-1)]
        
        %update current state variable
        s_t = s_next;
        
        %update reward array (for plot)
        rewards(totalits) = r;
        
        if (r == 100) %goal has been reached -> end episode
            break
        end
    end
    Q_eps{episode} = Q; %store Q table for each episode
    endsofeps(episode) = totalits; %store iteration each episode ended on
end

% OUTPUT FINAL Q TABLE
Final_Q_Table = Q_eps{num_eps}

% PLOT REWARDS FOR ALL ITERATIONS
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

%plot for first/initial episode
%create grid
figure(2),hold on
for i = 1:nrow
    yy = y + (i-1)*height;
    for j = 1:ncol
        xx = x + (j-1)*width;
          %rectangle('position',[xx,yy,width,height],'facecolor',rand(3,1))
          r = rectangle('position',[xx,yy,width,height]);
          
          %make start cell green
          if mod(start, grid_size) == 0 && j == ncol && (nrow -(start/grid_size) + 1 == i)
              %start cell is a multiple of the grid_size
              r.FaceColor = 'green';
          elseif mod(start,grid_size) == j && (nrow - floor(start/grid_size) == i)
              %start cell is not a multiple of the grid_size
              r.FaceColor = 'green';
          end

        %make goal cell red
          if mod(goal, grid_size) == 0 && j == ncol && (nrow -(goal/grid_size) + 1 == i)
              %start cell is a multiple of the grid_size
              r.FaceColor = 'red';
          elseif mod(goal,grid_size) == j && (nrow - floor(goal/grid_size) == i)
              %start cell is not a multiple of the grid_size
              r.FaceColor = 'red';
          end
    end
end

for i = 1:endsofeps(1)
    state = states(i);
    action = actions(i);
    
    %calculate position of arrow
    if mod(state, grid_size) == 0
        x_value = grid_size - 0.5; %-0.5 to be in middle of cell
        y_value = grid_size - (state/grid_size) + 1 - 0.5; %-0.5 to be in middle of cell
    else
        x_value = mod(state, grid_size) - 0.5; %-0.5 to be in middle of cell
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

%plot for final episode
%create grid
figure(3), hold on
for i = 1:nrow
    yy = y + (i-1)*height;
    for j = 1:ncol
        xx = x + (j-1)*width;
          %rectangle('position',[xx,yy,width,height],'facecolor',rand(3,1))
          r = rectangle('position',[xx,yy,width,height]);
          
          %make start cell green
          if mod(start, grid_size) == 0 && j == ncol && (nrow -(start/grid_size) + 1 == i)
              %start cell is a multiple of the grid_size
              r.FaceColor = 'green';
          elseif mod(start,grid_size) == j && (nrow - floor(start/grid_size) == i)
              %start cell is not a multiple of the grid_size
              r.FaceColor = 'green';
          end

        %make goal cell red
          if mod(goal, grid_size) == 0 && j == ncol && (nrow -(goal/grid_size) + 1 == i)
              %start cell is a multiple of the grid_size
              r.FaceColor = 'red';
          elseif mod(goal,grid_size) == j && (nrow - floor(goal/grid_size) == i)
              %start cell is not a multiple of the grid_size
              r.FaceColor = 'red';
          end
    end
end

for i = endsofeps(num_eps-1)+1:endsofeps(num_eps)
    state = states(i);
    action = actions(i);
    
    %calculate position of arrow
    if mod(state, grid_size) == 0
        x_value = grid_size - 0.5; %-0.5 to be in middle of cell
        y_value = grid_size - (state/grid_size) + 1 - 0.5; %-0.5 to be in middle of cell
    else
        x_value = mod(state, grid_size) - 0.5; %-0.5 to be in middle of cell
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

% s_t = 1;
% goal = 25;
% 
% task_states = [];    %store states for each iteration
% task_actions = []; %store actions taken at each iteration
% 
% for t=1:num_its
%     task_states(t) = s_t;
%     
%     a_next = select_action(Q, s_t, epsilon, num_actions);   %choose action
%     
%     task_actions(t) = a_next;
% 
%     %take action
%     if a_next == 1  %up
%         s_next = s_t - grid_size;
%     elseif a_next == 2  %down
%         s_next = s_t + grid_size;
%     elseif a_next == 3 %right
%         s_next = s_t + 1;
%     else   %left
%         s_next = s_t - 1;
%     end
% 
%     %update current state variable
%     s_t = s_next;
% 
%     %update reward array (for plot)
%     if (s_t == goal)
%         break
%     end
% end
% 
% task_its = t;
% 
% %plot for task
% %create grid
% figure(4), hold on
% for i = 1:nrow
%     yy = y + (i-1)*height;
%     for j = 1:ncol
%         xx = x + (j-1)*width;
%           %rectangle('position',[xx,yy,width,height],'facecolor',rand(3,1))
%           r = rectangle('position',[xx,yy,width,height]);
%           
%           %make start cell green
%           if mod(start, grid_size) == 0 && j == ncol && (nrow -(start/grid_size) + 1 == i)
%               %start cell is a multiple of the grid_size
%               r.FaceColor = 'green';
%           elseif mod(start,grid_size) == j && (nrow - floor(start/grid_size) == i)
%               %start cell is not a multiple of the grid_size
%               r.FaceColor = 'green';
%           end
% 
%         %make goal cell red
%           if mod(goal, grid_size) == 0 && j == ncol && (nrow -(goal/grid_size) + 1 == i)
%               %start cell is a multiple of the grid_size
%               r.FaceColor = 'red';
%           elseif mod(goal,grid_size) == j && (nrow - floor(goal/grid_size) == i)
%               %start cell is not a multiple of the grid_size
%               r.FaceColor = 'red';
%           end
%     end
% end
% 
% for i = 1:task_its
%     state = task_states(i);
%     action = task_actions(i);
%     
%     %calculate position of arrow
%     if mod(state, grid_size) == 0
%         x_value = grid_size - 0.5; %-0.5 to be in middle of cell
%         y_value = grid_size - (state/grid_size) + 1 - 0.5; %-0.5 to be in middle of cell
%     else
%         x_value = mod(state, grid_size) - 0.5; %-0.5 to be in middle of cell
%         y_value = grid_size - floor(state/grid_size) - 0.5; %-0.5 to be in middle of cell
%     end
%     
%     %draw arrow
%     if action == 1 %up
%         quiver(x_value, y_value, 0, 0.3, 'b', 'LineWidth', 1.5);
%     elseif action == 2 %down
%         quiver(x_value, y_value, 0, -0.3, 'b', 'LineWidth', 1.5);
%     elseif action == 3 %right
%         quiver(x_value, y_value, 0.3, 0, 'b', 'LineWidth', 1.5);
%     else %left
%         quiver(x_value, y_value, -0.3, 0, 'b', 'LineWidth', 1.5);
%     end
% end


function a = select_action(Q, S, epsilon, num_actions)
    n = randi([0,1]);
    if n < epsilon
        a = randi([1,num_actions]);
    else
        [maxReward, max_actions] = max(Q(S,:));
        a = max_actions(1);
    end
end