% -------------------------------------------------------------------------
% Zadatak 2.3: Određivanje pravca prispeća jednog izvora zračenja
% -------------------------------------------------------------------------

clear; clc; close all;

% Parametri iz teksta zadatka
f = 3e9;            % Radna učestanost (3 GHz)
c = 3e8;            % Brzina svetlosti (m/s)
lambda = c / f;     % Talasna dužina (0.1 m)
k = 2 * pi / lambda; % Talasni broj

M = 20;             % Broj antena u prijemnom nizu
d = 0.05;           % Razmak između antena (5 cm)[cite: 2]

% Pozicije antena u nizu simetrično postavljenih oko koordinatnog početka duž x-ose
% Za M = 20: -9.5*d, -8.5*d, ..., 9.5*d
j_indices = (1:M)';
x = (j_indices - (M + 1) / 2) * d;

% -------------------------------------------------------------------------
% 1. Učitavanje podataka iz LinArray1.ad1
% -------------------------------------------------------------------------
data = dlmread('LinArray1.ad1');

% Izrezi redove gde je pobudni port = 1, a prijemni portovi od 2 do M+1 (2 do 21)
% U datoteci: 2. kolona je pobuda, 3. kolona je prijem[cite: 1]
mask = (data(:, 2) == 1) & (data(:, 3) >= 2) & (data(:, 3) <= M + 1);
prijemni_podaci = data(mask, :);

% S_j1 parametri se nalaze u 4. (Re) i 5. (Im) koloni[cite: 1]
V = prijemni_podaci(:, 4) + 1i * prijemni_podaci(:, 5); % Vektor izmerenih napona (20x1)

% -------------------------------------------------------------------------
% 2. Formiranje ugaone promenljive i proračun S(phi)
% -------------------------------------------------------------------------
N = 360;
phi = linspace(0, 2*pi, N); % Definisana ugaona promenljiva prema zadatku[cite: 2]

S = zeros(1, N);

% Proračun funkcije S(phi) za svaku vrednost ugla
for n = 1:N
    % Steering vector a(phi) za linearni niz duž x-ose
    a = exp(1i * k * x * cos(phi(n)));

    % Skalarni proizvod izmerenog signala i steering vektora (skeniranje snopa)
    S(n) = sum(V .* conj(a));
end

% -------------------------------------------------------------------------
% 3. Prikaz rezultata
% -------------------------------------------------------------------------
figure;
plot(phi * 180 / pi, abs(S), 'LineWidth', 1.5); % Ugao u stepenima radi preglednosti[cite: 2]
grid on;
xlabel('\phi [^\circ]');
ylabel('|S(\phi)|');
title('Funkcija usmerenosti / Određivanje ugla prispeća (\phi)');

% Pronalaženje ugla na kojem je maksimum
[~, idx_max] = max(abs(S));
trazeni_ugao = phi(idx_max) * 180 / pi;
fprintf('Detektovani ugao prispeća iznosi: %.2f°\n', trazeni_ugao);
