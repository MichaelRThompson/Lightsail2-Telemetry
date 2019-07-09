clear
close all

[tel_file, path] = uigetfile('*.txt', 'MultiSelect', 'on');

datet_vec = cell(length(tel_file), 1);
gyro_vec = cell(length(tel_file), 3);

for i = 1:length(tel_file)
    
    fid = fopen([path, tel_file{1,i}], 'r');
    
    for j = 1:11
        fgets(fid);
    end
    line = fgets(fid);
    if line(1) == 'O'

        for j = 1:295
            fgets(fid);
        end

        gyrox = fgets(fid);
        gyro_vec{i, 1} = str2double(gyrox(38:45));

        gyroy = fgets(fid);
        gyro_vec{i, 2} = str2double(gyroy(38:45));

        gyroz = fgets(fid);
        gyro_vec{i, 3} = str2double(gyroz(38:45));
        
        for j = 1:133
            fgets(fid);
        end
        
        line = fgets(fid);
        date_str = line(6:15);
        datet_vec{i, 1} = datetime(str2double(date_str), 'ConvertFrom', 'posixtime');
        if datet_vec{i, 1} < datetime(2018, 1, 1)
            datet_vec{i, 1} = datet_vec{i, 1} + seconds(300000000);
        end
        
    else
        for j = 1:293
            fgets(fid);
        end
        
        gyrox = fgets(fid);
        gyro_vec{i, 1} = str2double(gyrox(38:45));

        gyroy = fgets(fid);
        gyro_vec{i, 2} = str2double(gyroy(38:45));

        gyroz = fgets(fid);
        gyro_vec{i, 3} = str2double(gyroz(38:45));
        
        for j = 1:133
            fgets(fid);
        end
        
        line = fgets(fid);
        date_str = line(6:15);
        datet_vec{i, 1} = datetime(str2double(date_str), 'ConvertFrom', 'posixtime');
        if datet_vec{i, 1} < datetime(2018, 1, 1)
            datet_vec{i, 1} = datet_vec{i, 1} + seconds(300000000);
        end
    end
    
    fclose(fid);
end

%% Plotting Spin Rates

figure
for i = 1:length(tel_file)
    hold on
    scatter(datet_vec{i,1}, gyro_vec{i,1}, '.', 'k')
end
hold off
title('X Rotation Rate')
xlabel('Date')
ylabel('X Rotation Rate [deg/s]')

figure
for i = 1:length(tel_file)
    hold on
    scatter(datet_vec{i,1}, gyro_vec{i,2}, '.', 'k')
end
hold off
title('Y Rotation Rate')
xlabel('Date')
ylabel('Y Rotation Rate [deg/s]')

figure
for i = 1:length(tel_file)
    hold on
    scatter(datet_vec{i,1}, gyro_vec{i,3}, '.', 'k')
end
hold off
title('Z Rotation Rate')
xlabel('Date')
ylabel('Z Rotation Rate [deg/s]')

figure
for i = 1:length(tel_file)
    hold on
    scatter(datet_vec{i,1}, sqrt(gyro_vec{i,1}^2 + gyro_vec{i,2}^2 + gyro_vec{i,3}^2), '.', 'k')
end
hold off
xlabel('Date')
ylabel('Rotation Rate Magnitude [deg/s]')