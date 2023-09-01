% Posiciones iniciales y finales (cuaterniones)
q0 = [-1.04, -0.785, 0.471, 0.017, 1.88, 2.129]; % Lift Position 
qf = [2.04, -0.99, 0.855, 0.017, 1.69, 2.042]; % Red

% Número de puntos de interpolación
num_puntos = 10;

% Crear interpolantes ScLERP para cada articulación
q_interp = zeros(6, num_puntos);
for i = 1:6
    interp_orientations = sclerp(q0(i), qf(i), linspace(0, 1, num_puntos));
    q_interp(i, :) = interp_orientations;
end

% Gráfico de las posiciones iniciales y finales
figure;
for i = 1:6
    subplot(3, 2, i);
    plot([0, 1], [q0(i), qf(i)], 'o', linspace(0, 1, num_puntos), q_interp(i, :), '-');
    title(['Articulación ', num2str(i)]);
    xlabel('Tiempo (0 a 1)');
    ylabel('Ángulos');
    legend('Puntos Iniciales/Finales', 'Interpolación ScLERP');
end

% Función de interpolación ScLERP
function interp_orientations = sclerp(q0, qf, t)
    omega = acos(dot(q0, qf));
    f = (sin((1 - t) * omega) / sin(omega)) * q0 + (sin(t * omega) / sin(omega)) * qf;
    interp_orientations = f;
end