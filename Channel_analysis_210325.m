clc
clear
close all

%%%%
% Sensitivity 
% Large numbers = More sensitive 
% If channels are being missed raise numbers, if too many are being found raise numbers. 


% This number is dividided by the maximum absolute vertically summed heigtht to determine a
% threshold value to identify the start or end of a channel
S1 = 3;
S2 = 3;

% This number is dividided by the gradient maximum absolute vertically summed heigtht to determine a
% threshold value to identify the start or end of a channel
S3 = 1000;
S4 = 1000;
%%%%

%%%%
% Manual_Zero
% 
manual_zero = 0;
%%%%%


load('Heightsample01.mat')
% figure

[A,B] = size(Height);

binary = zeros(A,B);

minus_drift = detrend_2d_updated210311(Height);
%removes linear drift
% figure
% surf(minus_drift)
% title('not zeroed')
% shading interp
% figure

Gausian_filter_applied = imgaussfilt(minus_drift,20,'Filtersize',41);
% Apply Guasian filter to drift corrected image
% surf(Gausian_filter_applied)
% shading interp

min_quarters = zeros(4,1);
Q1 = Gausian_filter_applied(1:B/2,1:A/2);
min_quarters(1) = min(min(Q1));
Q2 = Gausian_filter_applied(B/2:end,1:A/2);
min_quarters(2) = min(min(Q2));
Q3 = Gausian_filter_applied(1:B/2,A/2:end);
min_quarters(3) = min(min(Q3));
Q4 = Gausian_filter_applied(B/2:end,A/2:end);
min_quarters(4) = min(min(Q4));

zero_point = mean(min_quarters);

user_input = 0;
% splits filtered image into 4 quadrants and finds the minimum value in
% each, then uses the mean value of these as the zero point
additional_zero = 0;
while user_input==0
   minus_drift = minus_drift + -zero_point + manual_zero + additional_zero;
    
    %Plots 3d plot from side view to see if zeroing has worked
subplot(3,1,1)
%surf(minus_drift)
plot(minus_drift(:,round(B/4)))
title('Line 1/4')
% shading interp
% view(87,0)
subplot(3,1,2)
%surf(minus_drift)
plot(minus_drift(:,round(B/2)))
title('Line 1/2')
% shading interp
% view(90,0)
subplot(3,1,3)
%surf(minus_drift)
plot(minus_drift(:,round(B/1.3333)))
title('Line 3/4')
% shading interp
% view(93,0) 
    
    
user_input = input('Did the auto zero work?\n','s');

if user_input == 'y' | user_input == 'Y' |user_input == 'yes' | user_input == 'Yes' | user_input == 1
    user_input = 1;
    
elseif user_input == 'n' | user_input == 'N' |user_input == 'no' | user_input == 'No' | user_input == 0
    user_input = 0;
    
    additional_zero = input('Input new offset\n');
    close
else
    fprintf('not a valid responce\n\n')
    user_input = 0;
end
end









thresh = mean(mean(minus_drift));

for i = 1:A
    for j = 1:B
        if minus_drift(i,j) >thresh
            binary(i,j) = 1;
        end
    end
end
 %threshold - besed on  mean height      




%figure
% surf(minus_drift)
% shading interp
%imshow(binary)

BW = edge(binary,'canny');


[H,T,R] = hough(BW,'RhoResolution',30,'Theta',-90:0.5:89);

% Uncomment to plot hough matrix

% figure
% subplot(2,1,1);
% imshow(minus_drift);
% title('gantrycrane.png');
% subplot(2,1,2);
% imshow(imadjust(rescale(H)),'XData',T,'YData',R,...
%       'InitialMagnification','fit');
% title('Hough transform of gantrycrane.png');
% xlabel('\theta'), ylabel('\rho');
% axis on, axis normal, hold on;
% colormap(gca,hot);

V = H == max(max(H));
[V1,thets] = find(V);
% finds angle
angle = T(thets(1));


% Rotates image
I = imrotate(minus_drift,angle);

 figure
 surf(I)
 shading interp
 title('Flattened and Rotated')
 view(0,90)
 zlim([-2,6])
%  AAA = input('all good')
 
 [A2,B2] = size(I);
 for i = 1:A2
    probe(i) =  sum(I(1:end,i));
 end
 % Sum collumns to find channels
 
 dprobe = diff(probe);
 plot(dprobe)
 hold on
 plot(probe)
 legend('Differentiated','Vertically averaged')
 cou = 0;
 up =0;
 for i = 1:length(probe)-1
     if up ==0
    if (probe(i)) > max(probe)/S1 & dprobe(i) > max(dprobe)/S3
        up = 1;
        cou = cou +1;
        index_up(cou,:) = i;
    end
     elseif up ==1
         if probe(i) < max(probe)/S2 & dprobe(i) < min(dprobe)/S4
        up = 0;
%         cou = cou +1;
        index_down(cou,:) = i;
    end
     end
 end
 % Identifies x axis position of begining and end of channel

  for i = 1:min([length(index_up),length(index_down)])
     
     x_position(i) = round((index_up(i)+index_down(i))/2);
     
  end
 user_input = 0;
 x_position = x_position(2:end);
  while user_input == 0
  
  
 % x position of channels
 rotated_BW = imrotate(binary,angle);
 marked_channels_vert = rotated_BW;
 for i = 1:length(x_position)
    marked_channels_vert(:,x_position(i)-3:x_position(i)+3) = 2;
 end
%  figure
%  imshow(rotated_BW)
%   figure
%  mesh(marked_channels_vert)
% %   axis([0 1000 -0.001 110 0 110])    
%  view(0,90)
 number_horiz_marks = 5;
 marked_channels_horiz = marked_channels_vert;
 index_horiz_mark = round((B / number_horiz_marks) * [1:number_horiz_marks]);
 
 for i = 1:number_horiz_marks
%      index_horiz_mark = round((B / number_horiz_marks) * i);
    marked_channels_horiz(index_horiz_mark(i) - 3:index_horiz_mark(i) + 3,:) = 2;
 end
   figure
 mesh(marked_channels_horiz)
%   axis([0 1000 -0.001 110 0 110])    
 view(0,90)
% Mark points of interest
while 1==1
user_input = input('Did the channel identification work?\n','s');

if user_input == 'y' | user_input == 'Y' |user_input == 'yes' | user_input == 'Yes' | user_input == 1
    user_input = 1;
    break
elseif user_input == 'n' | user_input == 'N' |user_input == 'no' | user_input == 'No' | user_input == 0
    user_input = 0
    fprintf('current x position\n')
    x_position
    x_position = input('new x posit\n must be in square brackets\n');
    break
else
    fprintf('y/n\n')
    
end
end




  end

for i = 1:length(x_position)
    for j = 1:length(index_horiz_mark)
        
         depth_at_POI(j,i) = I(index_horiz_mark(j),x_position(i));
        
    end
end
% Find depth at POI
ave_separation_half = round(mean(diff(x_position))/2);

for i = 1:length(x_position)
    for  j = 1:length(index_horiz_mark)
        left_limit = max([x_position(i)-ave_separation_half,1]);
        right_limit = min([x_position(i) + ave_separation_half,A,B]);
        line_of_interest = I(index_horiz_mark(j) , left_limit : right_limit);
        Smoothed_LOI = smooth(line_of_interest,round(length(line_of_interest)/7));
%        figure
%        plot(Smoothed_LOI)
%       hold on
%        plot(line_of_interest)
       halfway = (max(Smoothed_LOI) - min(Smoothed_LOI))/2 + min(Smoothed_LOI);
     
       bin_2 = line_of_interest > halfway;
       Max_of_chan(j,i) = max(line_of_interest);
       width_channel(j,i) = sum(bin_2);
    end
end
             
mag_fact = 1;
Aspect_ratio = Max_of_chan(:)./width_channel(:);

mean_AR = mean(Aspect_ratio)
std_AR = std(Aspect_ratio)



%  for i = 1:min([length(index_up),length(index_down)])
%      figure
%      plot(I(:,(round((index_up(i)+index_down(i))/2))))
%      title(sprintf('peak %i',i))
%  end
 % plots centerline of all ridges
 

 
 
