function [distance,bearing] = haversine(lat1,lon1,lat2,lon2)
R = 6372800;         % Earth radius in meters

dlat = pi/180*(lat2-lat1);
dlon = pi/180*(lon2-lon1);
lat1 = pi/180*lat1;
lat2 = pi/180*lat2;

a = sin(dlat/2)^2+cos(lat1)*cos(lat2)*sin(dlon/2)^2;
c = 2*asin(sqrt(a));
distance = R*c;

y = sin(dlon)*cos(lat2);
x = cos(lat1)*sin(lat2)-sin(lat1)*cos(lat2)*cos(dlon);
bearing = atan2(y,x);

end