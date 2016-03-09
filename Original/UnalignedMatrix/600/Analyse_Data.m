%%Speed Calibration
rows = 1800;
TotalCells = 69;
centroid = zeros(rows,TotalCells*2);
for i = 1:TotalCells
    fileName = strcat('Data',num2str(i),'.csv');
    a = csvread(fileName, 0, 1, [0 1 rows-1 2]);
    for r = 1:rows
        centroid(r,(i-1)*2+1)=a(r,1);
        centroid(r,(i-1)*2+2)=a(r,2);
    end
end

distance = zeros(TotalCells,1);
for i = 1:TotalCells
    for r = 2:rows
        distance(i) = distance(i)+ sqrt((centroid(r,(i-1)*2+1)-centroid(r-1,(i-1)*2+1))^2+(centroid(r,(i-1)*2+2)- centroid(r-1,(i-1)*2+2))^2);
    end
end

distanceData = [mean(distance) std(distance)/sqrt(TotalCells)];




displacements = zeros(rows,69);
for i = 1:69
    for r = 2:rows
        displacements(r,i) = sqrt((centroid(r,(i-1)*2+1)-centroid(r-1,(i-1)*2+1))^2+(centroid(r,(i-1)*2+2)- centroid(r-1,(i-1)*2+2))^2);
    end
end

[p q] = hist(mean(displacements))

%% Calculate MSD
meanmsd_allcells = zeros(69,100);
for i = 1:69;
    msd = zeros(rows,100);
    for tau = 1:100
        for r = tau+1:rows
            displacements_x = centroid(r,(i-1)*2+1)-centroid(r-tau,(i-1)*2+1);
            displacements_y = centroid(r,(i-1)*2+1)-centroid(r-tau,(i-1)*2+1);
            norm = sqrt(displacements_x^2 + displacements_y^2)/tau;
            msd(1,r,tau)=norm;
        end
    end
    
    meanmsd = sum(msd);
    
    for k = 1:100
        meanmsd_allcells(i,k) = meanmsd(k)/(rows-k);
    end
end
image(meanmsd_allcells*180);


%% Auotocorelation
rows = 2000;
centroid = zeros(rows,69*2);
for i = 1:69
    fileName = strcat('polarity',num2str(i),'.csv');
    a = csvread(fileName, 0, 0, [0 0 rows-1 1]);
    for r = 1:rows
        centroid(r,(i-1)*2+1)=a(r,1);
        centroid(r,(i-1)*2+2)=a(r,2);
    end
end

%velocityDirection = zeros(rows,5);
meanCorelation = zeros(1,1000);
for i = 1:69;
    for tau = 1:1000
        totalCorelation = 0;
        count = 1;
        for r = tau+1:tau:rows
            displacements_x = (centroid(r,(i-1)*2+1)-centroid(r-tau,(i-1)*2+1));
            displacements_y = (centroid(r,(i-1)*2+1)-centroid(r-tau,(i-1)*2+1));
            norm = sqrt(displacements_x^2 + displacements_y^2);
            if(norm==0)
                velocityDirection(count,tau*2-1) = 0;
                velocityDirection(count,tau*2) = 0;
            else
                velocityDirection(count,tau*2-1) = displacements_x/norm;
                velocityDirection(count,tau*2) = displacements_y/norm;
            end
            
            %normAfterScaling = sqrt(velocityDirection(count,tau*2-1)^2+velocityDirection(count,tau*2)^2);
            if(r>(tau+1))
                totalCorelation = totalCorelation+ (velocityDirection(count,tau*2-1)*velocityDirection(count-1,tau*2-1))+(velocityDirection(count,tau*2)*velocityDirection(count-1,tau*2));
            end
            count = count+1;
        end
        meanCorelation(i,tau) = totalCorelation/(count-1);
    end
end
mean(meanCorelation)'

%% MPD
rows = 1800;
centroid = zeros(rows,69*2);
for i = 1:69
    fileName = strcat('polarity',num2str(i),'.csv');
    a = csvread(fileName, 0, 0, [0 0 rows-1 1]);
    maxPathDistance(i) = 0;
    for r = 1:rows
        centroid(r,(i-1)*2+1)=a(r,1);
        centroid(r,(i-1)*2+2)=a(r,2);
        if(r>1)
            latestDistance(i) = (centroid(r,(i-1)*2+1) - centroid(1,(i-1)*2+1))^2+(centroid(r,(i-1)*2+2) - centroid(1,(i-1)*2+2))^2;
            if(latestDistance(i) > maxPathDistance(i))
                maxPathDistance(i) = latestDistance(i);
            end
        end
    end
end

%[sqrt(maxPathDistance') sqrt(latestDistance')]
[mean(sqrt(maxPathDistance')) mean(sqrt(maxPathDistance'))/sqrt(69)]

%% Angle of migration
rows = 2000;
centroid = zeros(rows,69*2);
for i = 1:69
    fileName = strcat('polarity',num2str(i),'.csv');
    a = csvread(fileName, 0, 0, [0 0 rows-1 1]);
    for r = 1:rows
        centroid(r,(i-1)*2+1)=a(r,1);
        centroid(r,(i-1)*2+2)=a(r,2);
    end
end

%velocityDirection = zeros(rows,5);
meanCorelation = zeros(1,1000);
for i = 1:69;
    for tau = 50
        totalCorelation = 0;
        count = 0;
        for r = tau+1:tau:rows
            count = count+1;
            displacements_x = (centroid(r,(i-1)*2+1)-centroid(r-tau,(i-1)*2+1));
            displacements_y = (centroid(r,(i-1)*2+1)-centroid(r-tau,(i-1)*2+1));
            norm = sqrt(displacements_x^2 + displacements_y^2);
            if(norm==0)
                velocityDirection(count,tau*2-1) = 0;
                velocityDirection(count,tau*2) = 0;
            else
                velocityDirection(count,i*2-1) = displacements_x/norm;
                velocityDirection(count,i*2) = displacements_y/norm;
            end
        end
    end
end

%% Distance and displace and then directional persistence
rows = 1800;
centroid = zeros(rows,69*2);
for i = 1:69
    fileName = strcat('polarity',num2str(i),'.csv');
    a = csvread(fileName, 0, 0, [0 0 rows-1 1]);
    for r = 1:rows
        centroid(r,(i-1)*2+1)=a(r,1);
        centroid(r,(i-1)*2+2)=a(r,2);
    end
end

displacements = zeros(69,1);
distance = zeros(69,1);
persistence = zeros(69,1);
for i = 1:69
    for r = 2:rows
        distance(i) = distance(i)+ sqrt((centroid(r,(i-1)*2+1)-centroid(r-1,(i-1)*2+1))^2+(centroid(r,(i-1)*2+2)- centroid(r-1,(i-1)*2+2))^2);
    end
end

distanceData = [mean(distance)/10 std(distance)/sqrt(69)];

for i = 1:69
        displacements(i) = sqrt((centroid(1800,(i-1)*2+1)-centroid(1,(i-1)*2+1))^2+(centroid(1800,(i-1)*2+2)- centroid(1,(i-1)*2+2))^2);
end

displacementsData = [mean(displacements)/10 std(displacements)/sqrt(69)];

for i = 1:69
        persistence(i) = displacements(i)/distance(i);
end

persistenceData = [mean(persistence) std(persistence)/sqrt(69)];

data = [distanceData; displacementsData; persistenceData];

%% For Temporal MMP Dynamics
rows = 1800;
data = zeros(18,1);
a = csvread('MMP.csv');
for i = 100:100:1800
data(i/100) = sum(a(i-99:i,2));
end
data

%% For Temporal FiberDeg dynamics
rows = 1800;
data = zeros(18,1);
a = csvread('FiberDegraded.csv');
for i = 100:100:1800
data(i/100) = sum(a(i-99:i,2));
end
data





