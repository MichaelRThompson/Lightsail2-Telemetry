[tel_file, path] = uigetfile('*.txt', 'MultiSelect', 'on');

datet_vec = cell(length(tel_file), 1);
tp_vec = cell(length(tel_file), 3);

for i = 1:length(tel_file)
    
    fid = fopen([path, tel_file{1,i}], 'r');
    
    for j = 1:11
        fgets(fid);
    end
    line = fgets(fid);
    if line(1) == 'O'
        date_str = line(18:end);

        datet_vec{i, 1} = datetime(date_str, 'InputFormat', 'MMM  d HH:m:ss yyyy');

        for j = 1:316
            fgets(fid);
        end

        tpx = fgets(fid);
        tp_vec{i, 1} = str2double(tpx(38:42));

        tpy = fgets(fid);
        tp_vec{i, 2} = str2double(tpy(38:42));

        tpz = fgets(fid);
        tp_vec{i, 3} = str2double(tpz(38:42));
    end
    
    fclose(fid);
end

%% Plotting Torquer Powers

figure
for i = 1:length(tel_file)
    hold on
    scatter(datet_vec{i,1}, tp_vec{i,1}, '.', 'k')
end
hold off
xlabel('Date')
ylabel('X Torquer Power [mW]')

figure
for i = 1:length(tel_file)
    hold on
    scatter(datet_vec{i,1}, tp_vec{i,2}, '.', 'k')
end
hold off
xlabel('Date')
ylabel('Y Torquer Power [mW]')

figure
for i = 1:length(tel_file)
    hold on
    scatter(datet_vec{i,1}, tp_vec{i,3}, '.', 'k')
end
hold off
xlabel('Date')
ylabel('Z Torquer Power [mW]')

figure
for i = 1:length(tel_file)
    hold on
    scatter(datet_vec{i,1}, tp_vec{i,1} + tp_vec{i,2} + tp_vec{i,3}, '.', 'k')
end
hold off
xlabel('Date')
ylabel('Total Torquer Power [mW]')