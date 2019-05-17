function [T_out] = read_data_batt(name,cyclenumber)
% read_data_batt: read data and filter specific cycle
% usage: name = define the file to read (string)
% usage: cyclenumber = in xhich cycle is the information (int)
% output: T_out = table filter
% Also fix the data to double and fix the date

T = readtable(name,...
    'Delimiter','\t' ,'ReadVariableNames',true);
T.('time_s')=datetime(T.('time_s'),'InputFormat','MM/dd/yy H:m:s,SSS','Format','dd-MMM-yyyy HH:mm:ss:SSS');
for i=find(strcmpi(T.Properties.VariableNames,'time_s')):length(T.Properties.VariableNames)
    if iscellstr((T.(T.Properties.VariableNames{i})))
       T.(T.Properties.VariableNames{i})=str2num(char(strrep(T.(T.Properties.VariableNames{i}),',','.')'));
    end
end
T_out=T(T.('cycleNumber') ==cyclenumber,:);
T_out.('time_s')=(T_out.('time_s')-min(T_out.('time_s')));
end
