%KUKA kr5 - Gr�ficas y eso
% Posiciones iniciales y finales
q0 = [-1.04, -0.785, 0.471, 0.017, 1.88, 2.129]; %Lift Position 
qf = [2.04, -0.99, 0.855, 0.017, 1.69, 2.042]; %Red

% N�mero de puntos de interpolaci�n
num_puntos = 10;

% Grado del
% polinomio
grado = 5;

% Crear interpolantes polin�micos de quinto grado para cada articulaci�n
q_interp = zeros(6, num_puntos);
for i = 1:6
    coef = polyfit([0, 1], [q0(i), qf(i)], grado);  % Interpolaci�n polin�mica de quinto grado
    q_interp(i, :) = polyval(coef, linspace(0, 1, num_puntos));
end

% Gr�fico de las posiciones iniciales y finales
figure;
for i = 1:6
    subplot(3, 2, i);
    plot([0, 1], [q0(i), qf(i)], 'o', linspace(0, 1, num_puntos), q_interp(i, :), '-');
    title(['Articulaci�n ', num2str(i)]);
    xlabel('Tiempo (0 a 1)');
    ylabel('�ngulos');
    legend('Puntos Iniciales/Finales', 'Interpolaci�n Polin�mica de Quinto Grado');
end
