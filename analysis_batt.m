%% Analysis of batteries 
% LEPMI 
% Nicolas Magne
% 2019/02
% Type battery = ICR18650 MF1¨
% Capacity: 2150 mAh
% Standard Voltage: 3.65 V
% Max Discharge Current: 10 A

clc
clear
close all
%% Getting the values from the experiments Test 1 
% Parameters:
% Standard charge: @ C.C. 1075 [mA] (0.2C), C.V. 4.2 [V] cut off 50 [mA]
% Discharge:@ C.C. 0.2C, 0.3C, 0.7C, 1C, 2C, 3C, 4C Cut off 2.75 [V]
% Taking only one cycle of charge and discharge.
% All the information is get from the sofware Ec-lab Biologic. The data is
% save into form of tables.
T_0_2C = read_data_batt('test3.txt',5);
T_0_3C = read_data_batt('test1.txt',1);
T_0_7C = read_data_batt('test3.txt',1);
T_1C = read_data_batt('test5.txt',1);
T_2C = read_data_batt('test2.txt',1);
T_3C = read_data_batt('test3.txt',3);
T_4C = read_data_batt('test4.txt',1);
%% Plot the curves of Current and Battery Voltage vs Time
% Plot 2 experiment Ex. 0.3C and 2C
% 
% change the experiment to analyse
T=T_0_3C;
T1=T_2C;

total_t=seconds(max(T.('time_s')));
time_s=datenum(T.('time_s'));
time_s=(time_s.*(total_t*ones(length(time_s),1)))./(max(time_s)*...
    ones(length(time_s),1));
total_t1=seconds(max(T1.('time_s')));
time_s1=datenum(T1.('time_s'));
time_s1=(time_s1.*(total_t1*ones(length(time_s1),1)))./(max(time_s1)*...
    ones(length(time_s1),1));
figure (1),
subplot(2,1,1),
[hAx,hLine1,hLine2] = plotyy(time_s,T.('Ewe_V'),time_s,T.('x_I__mA'));
title('Experiment 1')
xlabel('Time [s]')
ylabel(hAx(1),'Voltage [V]') % left y-axis 
ylabel(hAx(2),'Current [mA]') % right y-axis
legend('Ewe_V','I_mA')
grid on
subplot(2,1,2),
[hAx,hLine1,hLine2] = plotyy(time_s1,T1.('Ewe_V'),time_s1,T1.('x_I__mA'));
title('Experiment 2')
xlabel('Time [s]')
ylabel(hAx(1),'Voltage [V]') % left y-axis 
ylabel(hAx(2),'Current [mA]') % right y-axis
legend('Ewe_V','I_mA')
grid on

%% Plot the Q discharge vs Voltage of all the experiment
figure (7),
plot(T_3C.('QDischarge_mA_h'),T_3C.('Ewe_V'),T_2C.('QDischarge_mA_h'),...
    T_2C.('Ewe_V'),T_0_7C.('QDischarge_mA_h'),T_0_7C.('Ewe_V'),...
    T_0_3C.('QDischarge_mA_h'),T_0_3C.('Ewe_V'),...
    T_0_2C.('QDischarge_mA_h'),T_0_2C.('Ewe_V'),...
    T_1C.('QDischarge_mA_h'),T_1C.('Ewe_V'),...
    T_4C.('QDischarge_mA_h'),T_4C.('Ewe_V'));
title('QDischarge vs V')
xlabel('QDischarge [mAh]')
ylabel('Voltage [V]') % left y-axis 
legend('T3C','T2C','T0.7C','T0.3C','T0.2C','T1C','T4C')
grid on
% Conclusion:
% The cut off voltage define is wrong because the value should be related
% with the drop voltage at the begining of the discharge.
% It is necessary to run again the experiments and calculate the offset 
% of the voltage in each C-rate

%% Calculating resistance
% V/I vs SOC
T=T_4C;
a=find(T.('QDischarge_mA_h'));
str=a(1);
figure (3),plot(T.('QDischarge_mA_h')(str:end),T.('Ewe_V')(str:end)./...
    (1.5*ones(length(T.('Ewe_V')(str:end)),1)))
title('Resistance vs QDischarge ')
xlabel('QDischarge [mAh]')
ylabel('Resistance [\Omega]') % left y-axis 
% Wrong method to calculate. It is needed to take into account the internal
% voltage source and compute the current and get the resistance.
% Pulse current is need it.
%% interpolation to get the same amoung of elements in the analysis 
% just a test of it
pt = interparc(10,T_3C.('QDischarge_mA_h'),T_3C.('Ewe_V'));
figure,plot(pt(:,1),pt(:,2))
%% Calculation of the offset voltage in the diferent C-rates
v(1) = offset_volt(T_0_2C,T_0_2C);
v(2) = offset_volt(T_0_2C,T_0_3C);                                                   
v(3) = offset_volt(T_0_2C,T_0_7C);
v(4) = offset_volt(T_0_2C,T_1C);
v(5) = offset_volt(T_0_2C,T_2C);
v(6) = offset_volt(T_0_2C,T_3C);
v(7) = offset_volt(T_0_2C,T_4C);
c_rate=[0.2,0.3,0.7,1,2,3,4];
% figure, plot(c_rate,v)
% Conclusion: The offset is linear at different C-rates
%%
p = polyfit(c_rate,v,1); 
f = polyval(p,c_rate); 
plot(c_rate,v,'o',c_rate,f,'-') 
legend('data','linear fit') 
