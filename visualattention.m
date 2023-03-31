% ATTENTION: Project 2

cue_position = zeros(2,1); trials = 4; 
valid_time = zeros(640,1); invalid_time = zeros(640,1);
one_hundred_time = zeros(640,1); three_hundred_time = zeros(640,1);
hor_dist = zeros(640,1); vert_dist = zeros(640,1);
val_counter = 1; inval_counter = 1;
delay_counter = 1; delay_counter2 = 1;

% Define random locations on grid
all_trials = zeros(4,64);
for i=1:4
    all_trials(1,(16*(i-1)+1):16*i)=i;
end
all_trials(2,:) = repmat([1 1 1 1 2 2 2 2 3 3 3 3 4 4 4 4], 1, 4);
all_trials(3,:) = repmat([1 1 2 2], 1, 16);
all_trials(4,:) = repmat([1 2], 1, 32);

% Experiment Set-up
for i = 1:trials
     % randomize what type of trial/condition it will be
       trial_rand = randperm(64);
    for j = 1:64
           x = all_trials(: , trial_rand(j));
           cue_position(1) = 4*(x(1)-1);
           cue_position(2) = 4*(x(2)-1);
           
           % randomly assign valid/invalid trial
           if(x(3) == 1)
               validity = 'v';
           else
               validity = 'i';
           end
           % randomly assign delay
           if(x(4) == 1)
               delay = 0.1; % 100ms delay
           else
               delay = 0.3; % 300ms delay
           end
       [target_box_x, target_box_y] = celldraw(validity, delay, cue_position);
       tic; pause;
       temp_t = toc;
       refresh; 
       if(x(3) == 1)
           valid_time(val_counter) = temp_t;
           val_counter = val_counter + 1;
       else
           invalid_time(inval_counter) = temp_t;
           hor_dist(inval_counter) = abs(target_box_x - cue_position(1));
           vert_dist(inval_counter) = abs(target_box_y - cue_position(2));
           inval_counter = inval_counter + 1;
       end
       if(x(4) == 1)
       one_hundred_time(delay_counter) = temp_t;
       delay_counter = delay_counter + 1;
       else
       three_hundred_time(delay_counter2) = temp_t;
       delay_counter2 = delay_counter2 + 1;
       end       
    end
end

% Filtering out outlier points
valid_time2 = []; invalid_time2 = [];
hor_dist2 = []; vert_dist2 = [];
one_hundred_time2 = []; three_hundred_time2 = [];

for i = 1:length(valid_time)
    if(valid_time(i) > 0.1 && valid_time(i) < 2)
       valid_time2 = [valid_time2,valid_time(i)];
    end
    if(invalid_time(i) > 0.1 && invalid_time(i) < 2)
        invalid_time2 = [invalid_time2,invalid_time(i)];
        hor_dist2 = [hor_dist2,hor_dist(i)];
        vert_dist2 = [vert_dist2,vert_dist(i)];
    end
    if(one_hundred_time(i) > 0.1 && one_hundred_time(i) < 2)
        one_hundred_time2 = [one_hundred_time2,one_hundred_time(i)];
    end
    if(three_hundred_time(i) > 0.1 && three_hundred_time(i) < 2)
        three_hundred_time2 = [three_hundred_time2,three_hundred_time(i)];
    end
end

% Time vs Horizontal Distance
mean_hor_dist0 = []; mean_hor_dist1 = [];
mean_hor_dist2 = []; mean_hor_dist3 = [];

for i = 1:length(hor_dist2)
    if (hor_dist2(i) == 0)
        mean_hor_dist0 = [mean_hor_dist0, invalid_time2(i)];
    elseif (hor_dist2(i) == 4)
        mean_hor_dist1 = [mean_hor_dist1, invalid_time2(i)];
    elseif (hor_dist2(i) == 8)
        mean_hor_dist2 = [mean_hor_dist2, invalid_time2(i)];
    else
        mean_hor_dist3 = [mean_hor_dist3, invalid_time2(i)];
    end
end

mean_hor_dist0 = mean(mean_hor_dist0);
mean_hor_dist1 = mean(mean_hor_dist1);
mean_hor_dist2 = mean(mean_hor_dist2);
mean_hor_dist3 = mean(mean_hor_dist3);

% Time vs Vertical Distance
mean_vert_dist0 = []; mean_vert_dist1 = [];
mean_vert_dist2 = []; mean_vert_dist3 = [];

for i = 1:length(vert_dist2)
    if (vert_dist2(i) == 0)
        mean_vert_dist0 = [mean_vert_dist0,invalid_time2(i)];
    elseif (vert_dist2(i) == 4)
        mean_vert_dist1 = [mean_vert_dist1,invalid_time2(i)];
    elseif (vert_dist2(i) == 8)
        mean_vert_dist2 = [mean_vert_dist2,invalid_time2(i)];
    else
        mean_vert_dist3=[mean_vert_dist3, invalid_time2(i)];
    end
end

mean_vert_dist0 = mean(mean_vert_dist0);
mean_vert_dist1 = mean(mean_vert_dist1);
mean_vert_dist2 = mean(mean_vert_dist2);
mean_vert_dist3 = mean(mean_vert_dist3);

% Plot Distances vs Reaction Times: 
% horizontal, vertical & both cases
x=[0, 1, 2, 3]; figure; 
plot(x, [mean_hor_dist0, mean_hor_dist1, mean_hor_dist2, mean_hor_dist3], 'b');
hold on;
plot(x, [mean_vert_dist0, mean_vert_dist1, mean_vert_dist2, mean_vert_dist3], 'r');
hold on;
plot(x, [sqrt(mean_hor_dist0^2 + mean_vert_dist0^2), sqrt(mean_hor_dist1^2 + mean_vert_dist1^2),...
    sqrt(mean_hor_dist2^2 + mean_vert_dist2^2), sqrt(mean_hor_dist3^2 + mean_vert_dist3^2)], 'm');
legend('Horizontal', 'Vertical', 'Total');
xlabel('Distance'); ylabel('Reaction Time (s)');
title('Distance vs Reaction Time Plot');

% function that draws the cue/target inside each of the 16 possible cells
function [target_box_x, target_box_y] = celldraw(validity, delay, cue_position)

text(8,8,'+', 'FontSize', 30);
xlim([0 16]); ylim([0 16]);
n = randperm(4); m = randperm(4);
cue_box_x = cue_position(1);
cue_box_y = cue_position(2);

if(strcmp(validity, 'v'))
    target_box_x = cue_box_x;
    target_box_y = cue_box_y;
else
    a =4*(n(1)-1); b = 4*(m(1)-1);
    if((a == cue_position(1)) && (b == cue_position(2)))
        target_box_x = 4*(n(2)-1);
        target_box_y = 4*(m(2)-1);
    else
        target_box_x = a;
        target_box_y = b;
    end
end
 %cue_fig = rectangle('Position', [cue_box_x, cue_box_y, 4, 4]);
 %set(cue_fig, 'FaceColor', 'g');
text(cue_box_x, cue_box_y, 'O','FontSize',30,'Color', 'r');
text(8,8,'+', 'FontSize', 30);
pause(0.05); clf; 
xlim([0 16]); ylim([0 16]);
pause(delay);
 %target_fig = rectangle('Position', [2, 10, 4, 4]);
 %set(target_fig, 'FaceColor', 'r');
text(target_box_x, target_box_y, 'X', 'FontSize', 30, 'Color','r');
text(8,8,'+', 'FontSize', 30);

end


 
        