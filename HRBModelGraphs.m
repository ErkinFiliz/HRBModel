close all

% Hidrolik rejeneretif frenleme sistemi modeli veri toplama ve işleme
% Erkin Filiz
% Son Güncelleme Tarihi: 06.04.2023

%% Modeli Açma ve Genel Parametreler
open_system('HRBModel.slx');

act_time_temp = 2; % Pompa veya Motorun Tam Deplasman Açıklığına Gelene Kadar Geçen Süre [s]
Simulink.data.evalinGlobal('HRBModel','act_time.Value = act_time_temp');

%% Kalkış İçin Parametreler ve Veri Toplama
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

%% Frenleme İçin Parametreler ve Veri Toplama
T_sim_temp = 10; % Simülasyon Süresi
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

%% Kalkış Grafikleri
% v. Zaman 
figure 
tiledlayout(3,1)
nexttile
% İvme v. Zaman
plot(t_k, ivme_k(:,2))
ylabel("İvme [m/s^2]"); xlabel("Zaman [s]"); %ylim([0 inf])
grid on
% Hız v. Zaman
nexttile
plot(t_k, hiz_k(:,2))
ylabel("Hız [m/s]"); xlabel("Zaman [s]");
grid on
% Konum v. Zaman
nexttile
plot(t_k, konum_k(:,2))
ylabel("Konum [m]"); xlabel("Zaman [s]");
grid on

% Akümülatör Basıncı v. Konum
figure
plot(konum_k(:,2), aku_bas_k(:,2));
ylabel("Akümülatör Basıncı [Bar]"); xlabel("Konum [m]");
grid on

% Direnç Kuvvetleri v. Zaman
figure
plot(t_k, dir_kuv_k(:,2));
ylabel("Araca Etki Eden Direnç Kuvvetleri [N]"); xlabel("Zaman [s]");
grid on

% Debi, Basınç v. Zaman
figure
tiledlayout(2,1)
% Basınç v. Zaman
nexttile
plot(t_k, aku_bas_k(:,2))
ylabel("Akümülatör Basıncı [Bar]"); xlabel("Zaman [s]");
grid on
% Debi v. Zaman
nexttile
plot(t_k, debi_k(:,2))
ylabel("Debi [m^3/s]"); xlabel("Zaman [s]");
grid on

%% Frenleme Grafikleri
% v. Zaman 
figure 
tiledlayout(3,1)
nexttile
% İvme v. Zaman
plot(t_f, ivme_f(:,2))
ylabel("İvme [m/s^2]"); xlabel("Zaman [s]");
grid on
% Hız v. Zaman
nexttile
plot(t_f, hiz_f(:,2))
ylabel("Hız [m/s]"); xlabel("Zaman [s]");
grid on
% Konum v. Zaman
nexttile
plot(t_f, konum_f(:,2))
ylabel("Konum [m]"); xlabel("Zaman [s]");
grid on

% Akümülatör Basıncı v. Konum
figure
plot(konum_f(:,2), aku_bas_f(:,2));
ylabel("Akümülatör Basıncı [Bar]"); xlabel("Konum [m]");
grid on

% Direnç Kuvvetleri v. Zaman
figure
plot(t_f, dir_kuv_f(:,2));
ylabel("Araca Etki Eden Direnç Kuvvetleri [N]"); xlabel("Zaman [s]");
grid on

% Debi, Basınç v. Zaman
figure
tiledlayout(2,1)
% Basınç v. Zaman
nexttile
plot(t_f, aku_bas_f(:,2))
ylabel("Akümülatör Basıncı [Bar]"); xlabel("Zaman [s]");
grid on
% Debi v. Zaman
nexttile
plot(t_f, debi_f(:,2))
ylabel("Debi [m^3/s]"); xlabel("Zaman [s]");
grid on

%% Makale Grafikleri
% Kalkış
e_aku = find(aku_bas_k(:,2) <= 50); % Akümülatörün boşaldığı noktanın tespiti
k_line = t_k(e_aku(1)); % Akümülatörün boşaldığı zaman
figure 
t = tiledlayout(3,2);
t.TileSpacing = 'compact';
t.Padding = 'tight';
nexttile
% İvme v. Zaman
plot(t_k, ivme_k(:,2))
ylabel("İvme [m/s^2]"); xlabel(["Zaman [s]"; "(a)"]);
xl = xline(k_line,'-.r',{'Akümülatörün','Boşaldığı An'});
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
grid on
% Akümülatör Basıncı v. Zaman
nexttile([2 1])
plot(t_k, aku_bas_k(:,2))
ylabel("Akümülatör Basıncı [Bar]"); xlabel(["Zaman [s]"; "(d)"]);
xl = xline(k_line,'-.r',{'Akümülatörün','Boşaldığı An'});
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
hold on
% Direnç Kuvvetleri v. Zaman
yyaxis right
plot(t_k, dir_kuv_k(:,2));
ylabel("Araca Etki Eden Direnç Kuvvetleri [N]");
grid on
legend('Akümülatör Basıncı','Direnç Kuvvetleri')
% Hız v. Zaman
nexttile
plot(t_k, hiz_k(:,2))
ylabel("Hız [m/s]"); xlabel(["Zaman [s]"; "(b)"]);
xl = xline(k_line,'-.r',{'Akümülatörün','Boşaldığı An'});
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
grid on
% Konum v. Zaman
nexttile
plot(t_k, konum_k(:,2))
ylabel("Konum [m]"); xlabel(["Zaman [s]"; "(c)"]);
xl = xline(k_line,'-.r',{'Akümülatörün','Boşaldığı An'});
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
grid on
% Debi v. Zaman
nexttile
plot(t_k, debi_k(:,2)*1000*60)
ylabel("Debi [L/dak]"); xlabel(["Zaman [s]"; "(e)"]);
xl = xline(k_line,'-.r',{'Akümülatörün','Boşaldığı An'});
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
grid on

% Frenleme
d_aku = find(aku_bas_f(:,2) > 399); % Akümülatörün dolduğu noktanın tespiti
f_line = t_f(d_aku(1)); % Akümülatörün dolduğu zaman
figure 
t = tiledlayout(3,2);
t.TileSpacing = 'compact';
t.Padding = 'tight';
nexttile
% İvme v. Zaman
plot(t_f, ivme_f(:,2))
ylabel("İvme [m/s^2]"); xlabel(["Zaman [s]"; "(a)"]);
xl = xline(f_line,'-.r',{'Akümülatörün Maksimum','Basınca Ulaştığı An'});
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
grid on
% Akümülatör Basıncı v. Zaman
nexttile([2 1])
plot(t_f, aku_bas_f(:,2))
ylabel("Akümülatör Basıncı [Bar]"); xlabel(["Zaman [s]"; "(d)"]);
xl = xline(f_line,'-.r',{'Akümülatörün Maksimum','Basınca Ulaştığı An'});
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
hold on
% Direnç Kuvvetleri v. Zaman
yyaxis right
plot(t_f, dir_kuv_f(:,2));
ylabel("Araca Etki Eden Direnç Kuvvetleri [N]");
grid on
legend('Akümülatör Basıncı','Direnç Kuvvetleri')
% Hız v. Zaman
nexttile
plot(t_f, hiz_f(:,2))
ylabel("Hız [m/s]"); xlabel(["Zaman [s]"; "(b)"]);
xl = xline(f_line,'-.r',{'Akümülatörün Maksimum','Basınca Ulaştığı An'});
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
grid on
% Konum v. Zaman
nexttile
plot(t_f, konum_f(:,2))
ylabel("Konum [m]"); xlabel(["Zaman [s]"; "(c)"]);
xl = xline(f_line,'-.r',{'Akümülatörün Maksimum','Basınca Ulaştığı An'});
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
grid on
% Debi v. Zaman
nexttile
plot(t_f, debi_f(:,2)*1000*60)
ylabel("Debi [L/dak]"); xlabel(["Zaman [s]"; "(e)"]);
xl = xline(f_line,'-.r',{'Akümülatörün Maksimum','Basınca Ulaştığı An'});
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
grid on
