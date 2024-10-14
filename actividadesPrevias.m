% Parámetros
B = 1; % Ancho de banda absoluto (puedes modificarlo)
f0 = B/2; % Ancho de banda de 6 dB
t = linspace(0, 10, 1000); % Valores de tiempo (solo para t >= 0)
f = linspace(-2*B, 2*B, 1000); % Valores de frecuencia para la gráfica de frecuencia
roll_off_factors = [0, 0.25, 0.75, 1]; % Factores de roll-off

% Graficar la respuesta al impulso
figure;
for i = 1:length(roll_off_factors)
    alpha = roll_off_factors(i);
    fDelta = alpha * f0;
    
    % Ecuación 14 - Respuesta al impulso
    he_t = 2*f0 * (sin(2*pi*f0*t) ./ (2*pi*f0*t)) .* (cos(2*pi*fDelta*t) ./ (1 - (4*fDelta*t).^2));
    
    subplot(2,2,i);
    plot(t, he_t);
    title(['Respuesta al impulso, \alpha = ', num2str(alpha)]);
    xlabel('Tiempo (t)');
    ylabel('h_e(t)');
    grid on;
end

% Graficar la respuesta en frecuencia
figure;
for i = 1:length(roll_off_factors)
    alpha = roll_off_factors(i);
    fDelta = alpha * f0;
    
    % Ecuación 10 - Respuesta en frecuencia
    He_f = zeros(size(f));
    f1 = f0 - fDelta;
    for j = 1:length(f)
        if abs(f(j)) < f1
            He_f(j) = 1;
        elseif abs(f(j)) >= f1 && abs(f(j)) <= B
            He_f(j) = 0.5 * (1 + cos(pi*(abs(f(j))-f1)/(2*fDelta)));
        else
            He_f(j) = 0;
        end
    end
    
    subplot(2,2,i);
    plot(f, He_f);
    title(['Respuesta en frecuencia, \alpha = ', num2str(alpha)]);
    xlabel('Frecuencia (f)');
    ylabel('H_e(f)');
    grid on;
end
