clear
close all

[tel_file, path] = uigetfile('*.txt', 'MultiSelect', 'on');

datet_vec = cell(length(tel_file), 1);
gyro_vec = cell(length(tel_file), 3);

for i = 1:length(tel_file)
    
    fid = fopen([path, tel_file{1,i}], 'r');
    
    while ~feof(fid)
        line = fgets(fid);
        if length(line) > 3
            if line(1:4) == '290:'
                gyro_vec{i, 1} = str2double(line(38:45));
            end
            if line(1:4) == '291:'
                gyro_vec{i, 2} = str2double(line(38:45));
            end
            if line(1:4) == '292:'
                gyro_vec{i, 3} = str2double(line(38:45));
            end
            if line(1:3) == 'tim'
                date_str = line(6:15);
                datet_vec{i, 1} = datetime(str2double(date_str), 'ConvertFrom', 'posixtime');
            end
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

Ixx = (1/12)*5*(.113^2 + .34^2);
Iyy = (1/12)*5*(.113^2 + .34^2);
Izz = (1/12)*5*(.113^2 + .113^2);

figure
for i = 1:length(tel_file)
    Kx = 0.5*Ixx*(gyro_vec{i,1}*pi/180)^2;
    Ky = 0.5*Iyy*(gyro_vec{i,2}*pi/180)^2;
    Kz = 0.5*Izz*(gyro_vec{i,3}*pi/180)^2;
    
    hold on
    scatter(datet_vec{i,1}, Kx + Ky + Kz, '.', 'k')
end
hold off
title('Rotational Energy')
xlabel('Date')
ylabel('Rotational Energy (J)')