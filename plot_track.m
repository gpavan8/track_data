clear
close all
clc

fileID = fopen('full_track2.LLH','r');
D = textscan(fileID,'%f/%f/%f %f:%f:%f %f %f %f %f %f %f %f %f %f %f %f %f %f','CollectOutput',1);
D = D{1,1};

figure
plot(D(:,8),D(:,7))
title('track data in terms of latitude and longitude')
xlabel('latitude')
ylabel('longitude')

%% converting GPS data into meters with mean of the data as reference
pns = D(:,7:8)';
center = [mean(pns(1,:)) mean(pns(2,:))];
[d,b0] = haversine(mean(pns(1,:)),mean(pns(2,:)),pns(1,1),pns(2,1));
x3 = zeros(1,size(pns,2));
y3 = zeros(1,size(pns,2));

x3(1) = d*cos(b0); y3(1) = d*sin(b0);
dandb = zeros(2,size(pns,2)-1);
for i = 1:size(pns,2)-1
    [dandb(1,i),dandb(2,i)] = haversine(pns(1,i),pns(2,i),pns(1,i+1),pns(2,i+1));
    x3(i+1) = x3(i)+dandb(1,i)*cos(dandb(2,i));
    y3(i+1) = y3(i)+dandb(1,i)*sin(dandb(2,i));
end

ovaldata_m = [x3;y3];

figure
plot(y3,x3)
title('track data in meters with mean of data as reference')
xlabel('x(m)')
ylabel('y(m)')
