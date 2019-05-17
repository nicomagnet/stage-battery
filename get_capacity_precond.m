function [cap,Imax] = get_capacity_precond(name)
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

for i=0:max(T.('cycleNumber'))
    T_out=T(T.('cycleNumber') == i,:);
    T_out.('time_s')=(T_out.('time_s')-min(T_out.('time_s')));
    cap(i+1)=max(T_out.('QDischarge_mA_h'));
    Imax(i+1)=-min(T_out.('x_I__mA'));
end

end
