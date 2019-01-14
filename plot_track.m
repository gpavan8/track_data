clear
close all
clc

fileID = fopen('full_track2.LLH','r');
D = textscan(fileID,'%f/%f/%f %f:%f:%f %f %f %f %f %f %f %f %f %f %f %f %f %f','CollectOutput',1);
D = D{1,1};
D1 = D(1:210,:); D2 = D(255:660,:);
D = [D1;D2];

%% converting GPS data into meters with mean of the data as reference
pns = D(:,7:8)';     % until 210
center = [mean(pns(1,:)) mean(pns(2,:))];
[d,b0] = haversine(mean(pns(1,:)),mean(pns(2,:)),pns(1,1),pns(2,1));
y3 = zeros(1,size(pns,2));
x3 = zeros(1,size(pns,2));

y3(1) = d*cos(b0); x3(1) = d*sin(b0);
dandb = zeros(2,size(pns,2)-1);
for i = 1:size(pns,2)-1
    [dandb(1,i),dandb(2,i)] = haversine(pns(1,i),pns(2,i),pns(1,i+1),pns(2,i+1));
    y3(i+1) = y3(i)+dandb(1,i)*cos(dandb(2,i));
    x3(i+1) = x3(i)+dandb(1,i)*sin(dandb(2,i));
end

ovaldata_m = [x3;y3];

xx = smooth(ovaldata_m(1,:));
yy = smooth(ovaldata_m(2,:));

ovaldata_sm = [xx';yy'];
q = curvspace(ovaldata_sm',233);

% pt = interparc(400,x3,y3,'spline');
% q = curvspace(ovaldata_m',400);

figure
plot(D(:,8),D(:,7))
title('track data in terms of latitude and longitude')
xlabel('longitude')
ylabel('latitude')
hold on
scatter(center(2),center(1))
scatter(D(:,8),D(:,7))

figure
plot(x3,y3)
title('track data in meters with mean of data as reference')
xlabel('x(m)')
ylabel('y(m)')

figure
plot(xx,yy,'r*',q(:,1),q(:,2),'b-o')
%axis([-1.1 1.1 -1.1 1.1])
%axis equal
grid on
xlabel X
ylabel Y
title 'Points in blue are uniform in arclength around the circle'

q = q';
dists = zeros(1,size(q,2)-1);
for i=1:size(q,2)-1
    dists(1,i) = sqrt((q(1,i)-q(1,i+1))^2+(q(2,i)-q(2,i+1))^2);
end

figure
plot(dists)