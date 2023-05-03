close all

% Hydraulic Regeneretive Braking Simulation Data & Results
% Erkin Filiz
% Revised: 03.05.2023

%% Model and Parameters
open_system('HRBModel.slx');

act_time_temp = 2; % Pompa veya Motorun Tam Deplasman Açıklığına Gelene Kadar Geçen Süre [s]
Simulink.data.evalinGlobal('HRBModel','act_time.Value = act_time_temp');

%% Acceleration Simulation Parameters
T_sim_temp = 25; % Simülasyon Süresi
Simulink.data.evalinGlobal('HRBModel','T_sim.Value = T_sim_temp');
set_param('HRBModel/M_P', 'sw', '1') % Pompa ve Motor Arasında seçim. Motor:1 Pompa:0
P1_temp = 395; % Akümülatörün Simülasyon Başındaki Basıncı (Şarj Durumu) [Bar]
Simulink.data.evalinGlobal('HRBModel','P1.Value = P1_temp');
ilk_hiz_temp = 0; % Aracın Simülasyon Başındaki Hızı [m/s]
Simulink.data.evalinGlobal('HRBModel','ilk_hiz.Value = ilk_hiz_temp');
out = sim('HRBModel.slx');
t_k = out.tout; % Kalkış Simülasyonu Zaman Arrayi
ivme_k = out.Acceleration;
hiz_k = out.Velocity;
konum_k = out.Displacement;
aku_bas_k = out.AccPressure;
dir_kuv_k = out.ResForce;
debi_k = out.flowrt;

%% Braking Simulation Parameters
T_sim_temp = 7; % Simülasyon Süresi
Simulink.data.evalinGlobal('HRBModel','T_sim.Value = T_sim_temp');
set_param('HRBModel/M_P', 'sw', '0') % Pompa ve Motor Arasında seçim. Motor:1 Pompa:0
P1_temp = 60; % Akümülatörün Simülasyon Başındaki Basıncı (Şarj Durumu) [Bar]
Simulink.data.evalinGlobal('HRBModel','P1.Value = P1_temp');
ilk_hiz_temp = 15; % Aracın Simülasyon Başındaki Hızı [m/s]
Simulink.data.evalinGlobal('HRBModel','ilk_hiz.Value = ilk_hiz_temp');
out = sim('HRBModel.slx');
t_f = out.tout; % Frenleme Simülasyonu Zaman Arrayi
ivme_f = out.Acceleration;
hiz_f = out.Velocity;
konum_f = out.Displacement;
aku_bas_f = out.AccPressure;
dir_kuv_f = out.ResForce;
debi_f = out.flowrt;

%% Acceleration Graphs
e_aku = find(aku_bas_k(:,2) <= 50); % Akümülatörün boşaldığı noktanın tespiti
k_line = t_k(e_aku(1)); % Akümülatörün boşaldığı zaman
figure 
t = tiledlayout(3,2);
t.TileSpacing = 'loose';
t.Padding = 'tight';
nexttile
% İvme v. Zaman
plot(t_k, ivme_k(:,2),'LineWidth',2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
set(gca,'FontSize', 16)
ylabel("Acceleration [m/s^2]"); xlabel(["Time [s]"; "(a)"]);
xl = xline(k_line,'-.r','LineWidth',2);
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
grid on
% Akümülatör Basıncı v. Zaman
nexttile([2 1])
plot(t_k, aku_bas_k(:,2),'LineWidth',2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
set(gca,'FontSize', 16)
ylabel("Accumulator Pressure [Bar]"); xlabel(["Time [s]"; "(d)"]);
hold on
% Direnç Kuvvetleri v. Zaman
yyaxis right
plot(t_k, dir_kuv_k(:,2),'--','LineWidth',2);
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
set(gca,'FontSize', 16)
ylabel("Resistive Forces [N]");
grid on
xl = xline(k_line,'-.r','LineWidth',2);
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
legend('Location','south')
legend('Accumulator Pressure','Resistive Forces')
% Hız v. Zaman
nexttile
plot(t_k, hiz_k(:,2),'LineWidth',2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
set(gca,'FontSize', 16)
ylabel("Velocity [m/s]"); xlabel(["Time [s]"; "(b)"]);
xl = xline(k_line,'-.r','LineWidth',2);
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
grid on
% Konum v. Zaman
nexttile
plot(t_k, konum_k(:,2),'LineWidth',2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
set(gca,'FontSize', 16)
ylabel("Position [m]"); xlabel(["Time [s]"; "(c)"]);
xl = xline(k_line,'-.r','LineWidth',2);
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
grid on
% Debi v. Zaman
nexttile
plot(t_k, debi_k(:,2)*1000*60,'LineWidth',2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
set(gca,'FontSize', 16)
ylabel("Flow Rate [L/min]"); xlabel(["Time[s]"; "(e)"]);
xl = xline(k_line,'-.r','LineWidth',2);
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
grid on

%% Braking Graphs
d_aku = find(aku_bas_f(:,2) > 399); % Akümülatörün dolduğu noktanın tespiti
f_line = t_f(d_aku(1)); % Akümülatörün dolduğu zaman
figure 
t = tiledlayout(3,2);
t.TileSpacing = 'loose';
t.Padding = 'tight';
nexttile
% İvme v. Zaman
plot(t_f, ivme_f(:,2),'LineWidth',2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
set(gca,'FontSize', 16)
ylabel("Acceleration [m/s^2]"); xlabel(["Time [s]"; "(a)"]);
xl = xline(f_line,'-.r','LineWidth',2);
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
grid on
% Akümülatör Basıncı v. Zaman
nexttile([2 1])
plot(t_f, aku_bas_f(:,2),'LineWidth',2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
set(gca,'FontSize', 16)
ylabel("Accumulator Pressure [Bar]"); xlabel(["Time [s]"; "(d)"]);
hold on
% Direnç Kuvvetleri v. Zaman
yyaxis right
plot(t_f, dir_kuv_f(:,2),'--','LineWidth',2);
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
set(gca,'FontSize', 16)
ylabel("Resistive Forces [N]");
grid on
xl = xline(f_line,'-.r','LineWidth',2);
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
legend('Location','North')
legend('Accumulator Pressure','Resistive Forces')
% Hız v. Zaman
nexttile
plot(t_f, hiz_f(:,2),'LineWidth',2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
set(gca,'FontSize', 16)
ylabel("Velocity [m/s]"); xlabel(["Time [s]"; "(b)"]);
xl = xline(f_line,'-.r','LineWidth',2);
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
grid on
% Konum v. Zaman
nexttile
plot(t_f, konum_f(:,2),'LineWidth',2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
set(gca,'FontSize', 16)
ylabel("Position [m]"); xlabel(["Time [s]"; "(c)"]);
xl = xline(f_line,'-.r','LineWidth',2);
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
grid on
% Debi v. Zaman
nexttile
plot(t_f, debi_f(:,2)*1000*60,'LineWidth',2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
set(gca,'FontSize', 16)
ylabel("Flow Rate [L/min]"); xlabel(["Time [s]"; "(e)"]);
xl = xline(f_line,'-.r','LineWidth',2);
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
grid on
