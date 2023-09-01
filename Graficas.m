%KUKA kr5 - Gráficas y eso
% Posiciones iniciales y finales
q0 = [-1.04, -0.785, 0.471, 0.017, 1.88, 2.129]; %Lift Position 
qf = [2.04, -0.99, 0.855, 0.017, 1.69, 2.042]; %Red

% Número de puntos de interpolación
num_puntos = 10;

% Grado del
% polinomio
grado = 5;

% Crear interpolantes polinómicos de quinto grado para cada articulación
q_interp = zeros(6, num_puntos);
for i = 1:6
    coef = polyfit([0, 1], [q0(i), qf(i)], grado);  % Interpolación polinómica de quinto grado
    q_interp(i, :) = polyval(coef, linspace(0, 1, num_puntos));
end

% Gráfico de las posiciones iniciales y finales
figure;
for i = 1:6
    subplot(3, 2, i);
    plot([0, 1], [q0(i), qf(i)], 'o', linspace(0, 1, num_puntos), q_interp(i, :), '-');
    title(['Articulación ', num2str(i)]);
    xlabel('Tiempo (0 a 1)');
    ylabel('Ángulos');
    legend('Puntos Iniciales/Finales', 'Interpolación Polinómica de Quinto Grado');
end
