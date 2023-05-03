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
%% Kalkış 5 grafik
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
ylabel("İvme [m/s^2]"); xlabel(["Zaman [s]"; "(a)"]);
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
ylabel("Akümülatör Basıncı [Bar]"); xlabel(["Zaman [s]"; "(d)"]);
hold on
% Direnç Kuvvetleri v. Zaman
yyaxis right
plot(t_k, dir_kuv_k(:,2),'--','LineWidth',2);
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
set(gca,'FontSize', 16)
ylabel("Araca Etki Eden Direnç Kuvvetleri [N]");
grid on
xl = xline(k_line,'-.r','LineWidth',2);
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
legend('Location','south')
legend('Akümülatör Basıncı','Direnç Kuvvetleri')
% Hız v. Zaman
nexttile
plot(t_k, hiz_k(:,2),'LineWidth',2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
set(gca,'FontSize', 16)
ylabel("Hız [m/s]"); xlabel(["Zaman [s]"; "(b)"]);
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
ylabel("Konum [m]"); xlabel(["Zaman [s]"; "(c)"]);
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
ylabel("Debi [L/dak]"); xlabel(["Zaman [s]"; "(e)"]);
xl = xline(k_line,'-.r','LineWidth',2);
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
grid on
%% Kalkış İvme, hız, konum v. zaman
figure
yyaxis left
plot(t_k, ivme_k(:,2),'-.b')
xlabel(["Zaman [s]"; "(d)"]);
hold on
plot(t_k, hiz_k(:,2),'--b')
set(gca,'YColor','b') 
yyaxis right
plot(t_k, konum_k(:,2));
grid on
xl = xline(k_line,'-.r',{'Akümülatörün','Boşaldığı An'});
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
legend('İvme [m/s^2]','Hız[m/s^]', 'Konum[m]')

%% Kalkış 3 Grafik
figure 
t = tiledlayout(3,2);
t.TileSpacing = 'loose';
t.Padding = 'tight';

% İvme, hız, konum v. zaman
nexttile([2 1])
yyaxis left
plot(t_k, ivme_k(:,2),'-.b','LineWidth',2)
xlabel(["Zaman [s]"; "(d)"],'fontweight','bold');
hold on
plot(t_k, hiz_k(:,2),'--b','LineWidth',2)
set(gca,'YColor','b')
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
yyaxis right
plot(t_k, konum_k(:,2),'LineWidth',2);
grid on
xl = xline(k_line,'-.r',{'Akümülatörün','Boşaldığı An'},'LineWidth',2);
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
legend('İvme [m/s^2]','Hız[m/s^]', 'Konum[m]')

% Akümülatör Basıncı, Direnç Kuvvetleri v. Zaman
nexttile([2 1])
yyaxis left
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
plot(t_k, aku_bas_k(:,2),'LineWidth',2)
ylabel("Akümülatör Basıncı [Bar]", 'FontWeight','bold'); xlabel(["Zaman [s]"; "(d)"],'LineWidth',2);
hold on
yyaxis right
plot(t_k, dir_kuv_k(:,2),'LineWidth',2);
ylabel("Araca Etki Eden Direnç Kuvvetleri [N]",'LineWidth',2);
grid on
xl = xline(k_line,'-.r',{'Akümülatörün','Boşaldığı An'});
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
legend('Akümülatör Basıncı','Direnç Kuvvetleri')

% Debi v. Zaman
nexttile([1 2])
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
plot(t_k, debi_k(:,2)*1000*60,'LineWidth',2)
ylabel("Debi [L/dak]",'LineWidth',2); xlabel(["Zaman [s]"; "(e)"]);
xl = xline(k_line,'-.r',{'Akümülatörün','Boşaldığı An'});
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
grid on

%% Kalkış 2 Grafik
figure 
t = tiledlayout(2,2);
t.TileSpacing = 'loose';
t.Padding = 'tight';

% İvme, hız, konum v. zaman
nexttile([2 1])
yyaxis left
set(gca,'YColor','b')
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
plot(t_k, ivme_k(:,2),'-.b','LineWidth',2)
xlabel(["Zaman [s]"; "(a)"],'fontweight','bold');
hold on
plot(t_k, hiz_k(:,2),'--b','LineWidth',2)
yyaxis right
plot(t_k, konum_k(:,2),'LineWidth',2);
grid on
xl = xline(k_line,'-.r',{'Akümülatörün','Boşaldığı An'},'LineWidth',2);
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
legend('İvme [m/s^2]','Hız[m/s^]', 'Konum[m]')

% Akümülatör Basıncı, Direnç Kuvvetleri v. Zaman
nexttile([2 1])
yyaxis left
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
set(gca,'YColor','b')
plot(t_k, aku_bas_k(:,2),'-.b','LineWidth',2)
hold on
plot(t_k, debi_k(:,2)*1000*60,'--b','LineWidth',2)
xlabel(["Zaman [s]"; "(b)"]);
yyaxis right
plot(t_k, dir_kuv_k(:,2),'LineWidth',2);
grid on
xl = xline(k_line,'-.r',{'Akümülatörün','Boşaldığı An'},'LineWidth',2);
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
legend('Akümülatör Basıncı[Bar]','Debi[L/Dak]','Direnç Kuvvetleri[N]')

%% Frenleme 5 Grafik
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
ylabel("İvme [m/s^2]"); xlabel(["Zaman [s]"; "(a)"]);
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
ylabel("Akümülatör Basıncı [Bar]"); xlabel(["Zaman [s]"; "(d)"]);
hold on
% Direnç Kuvvetleri v. Zaman
yyaxis right
plot(t_f, dir_kuv_f(:,2),'--','LineWidth',2);
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
set(gca,'FontSize', 16)
ylabel("Araca Etki Eden Direnç Kuvvetleri [N]");
grid on
xl = xline(f_line,'-.r','LineWidth',2);
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
legend('Location','North')
legend('Akümülatör Basıncı','Direnç Kuvvetleri')
% Hız v. Zaman
nexttile
plot(t_f, hiz_f(:,2),'LineWidth',2)
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
set(gca,'FontSize', 16)
ylabel("Hız [m/s]"); xlabel(["Zaman [s]"; "(b)"]);
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
ylabel("Konum [m]"); xlabel(["Zaman [s]"; "(c)"]);
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
ylabel("Debi [L/dak]"); xlabel(["Zaman [s]"; "(e)"]);
xl = xline(f_line,'-.r','LineWidth',2);
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
grid on
%% Frenleme 2 Grafik
figure 
t = tiledlayout(2,2);
t.TileSpacing = 'loose';
t.Padding = 'tight';

% İvme, hız, konum v. zaman
nexttile([2 1])
yyaxis left
set(gca,'YColor','b')
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
set(gca,'FontSize', 16)
plot(t_f, ivme_f(:,2),'-.b','LineWidth',2)
xlabel(["Zaman [s]"; "(a)"],'fontweight','bold');
hold on
plot(t_f, hiz_f(:,2),'--b','LineWidth',2)
yyaxis right
plot(t_f, konum_f(:,2),'LineWidth',2);
grid on
xl = xline(f_line,'-.r','LineWidth',2);
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
legend('İvme [m/s^2]','Hız[m/s^]', 'Konum[m]')

% Akümülatör Basıncı, Direnç Kuvvetleri v. Zaman
nexttile([2 1])
yyaxis left
set(gca,'FontWeight','bold')
set(gca,'LineWidth',2)
set(gca,'YColor','b')
set(gca,'FontSize', 16)
plot(t_f, aku_bas_f(:,2),'-.b','LineWidth',2)
hold on
plot(t_f, debi_f(:,2)*1000*60,'--b','LineWidth',2)
xlabel(["Zaman [s]"; "(b)"]);
yyaxis right
plot(t_f, dir_kuv_f(:,2),'LineWidth',2);
grid on
xl = xline(f_line,'-.r','LineWidth',2);
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
legend('Akümülatör Basıncı[Bar]','Debi[L/Dak]','Direnç Kuvvetleri[N]')