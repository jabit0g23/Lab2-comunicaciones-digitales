% -------------------------------------------
% Sección de parámetros modificables
% -------------------------------------------
num_bits = 1e4;           % Número de bits
SNR = 30;                 % Relación señal a ruido en dB
alpha = 1;              % Factor de roll-off del filtro (0, 0.25, 0.75, 1)
samples_per_symbol = 10;    % Muestras por símbolo
symbol_rate = 1e3;         % Tasa de símbolos (Hz)
EbN0_dB = 10;             % Relación Eb/N0 en dB
num_symbols_to_display = 2; % Número de símbolos a mostrar en el diagrama de ojo
% -------------------------------------------

% Calcular otros parámetros basados en los modificables
Fs = samples_per_symbol * symbol_rate;  % Frecuencia de muestreo (Hz)
T_symbol = 1 / symbol_rate;             % Duración del símbolo
num_samples_to_display = num_symbols_to_display * samples_per_symbol;

% Generar bits aleatorios
data = randi([0 1], 1, num_bits);  % Generar secuencia de bits binarios

% Generar la señal NRZ-L
nrz_signal = 2 * data - 1;        % Convertir a formato NRZ-L (-1 y 1)
nrz_signal_upsampled = upsample(nrz_signal, samples_per_symbol);  % Sobremuestrear

% Generar el filtro de coseno alzado basado en el parámetro alpha
rcos_filter = rcosdesign(alpha, 6, samples_per_symbol);

% Filtrar la señal NRZ-L
tx_signal = conv(nrz_signal_upsampled, rcos_filter, 'same');

% Añadir ruido AWGN a la señal transmitida
rx_signal = awgn(tx_signal, SNR, 'measured');

% Limitar el número de muestras a mostrar para el diagrama de ojo
max_samples = length(rx_signal);  % Número máximo de muestras disponible
num_samples = min(num_samples_to_display * 100, max_samples);  % Ajustar número de muestras

% Generar el diagrama de ojo
figure;
eyediagram(rx_signal(1:num_samples), num_samples_to_display);
title(['Diagrama de Ojo para \alpha = ', num2str(alpha)]);
xlabel('Tiempo (muestras)');
ylabel('Amplitud');
grid on;
