% Importar las bibliotecas
addpath('path/to/roboticstoolbox');  % Ajusta la ruta a la ubicación de la Robotics Toolbox

% Crear los enlaces (articulaciones) del robot KUKA KR5
L(1) = Revolute('d', 0.4, 'a', 0, 'alpha', pi/2, 'qlim', [-pi, pi]);
L(2) = Revolute('d', 0, 'a', 0.6, 'alpha', 0, 'qlim', [-pi, pi]);
L(3) = Revolute('d', 0, 'a', 0.17, 'alpha', pi/2, 'qlim', [-pi, pi]);
L(4) = Revolute('d', 0.62, 'a', 0, 'alpha', pi/2, 'qlim', [-pi, pi]);
L(5) = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'qlim', [-pi, pi]);
L(6) = Revolute('d', 0.2, 'a', 0, 'alpha', 0, 'qlim', [-pi, pi]);

% Crear el robot KUKA KR5 con los enlaces definidos
robot = SerialLink(L, 'name', 'KUKA KR5');

% Definir el tiempo y la frecuencia de muestreo
t = linspace(0, 10, 100);  % Tiempo de 0 a 10 segundos
dt = t(2) - t(1);  % Frecuencia de muestreo

% Configuraciones iniciales y finales
q0 = [-1.04, -0.785, 0.471, 0.017, 1.88, 2.129]; %Lift Position 
qf = [2.04, -0.99, 0.855, 0.017, 1.69, 2.042]; %Red

% Interpolación polinómica de quinto orden para las configuraciones iniciales y finales
num_puntos = length(t);
q_traj = zeros(num_puntos, 6);
for i = 1:6
    coef = polyfit([0, 1], [q0(i), qf(i)], 5);  % Interpolación polinómica de quinto orden
    q_traj(:, i) = polyval(coef, linspace(0, 1, num_puntos));
end

% Calcular velocidades y aceleraciones numéricamente
qdot_traj = diff(q_traj) / dt;
qdotdot_traj = diff(qdot_traj) / dt;

% Calcular la trayectoria cinemática directa (poses del efector final)
poses_traj = robot.fkine(q_traj);

% Extraer las posiciones (translaciones) de las poses
positions = poses_traj.transl;

% Colores para las líneas de los eslabones en las gráficas
colors = lines(6);  % 6 colores distintos

% Graficar las trayectorias y configuraciones angulares
figure;

% Gráfico de Trayectoria Cinemática Directa
subplot(3, 2, 1);
robot.plot(q_traj, 'trail', 'r');
title('Direct Kinematic Trajectory');

% Gráfico de Configuraciones Angulares
subplot(3, 2, 2);
plot(t, q_traj);
title('Angular Configurations');
xlabel('Time (s)');
ylabel('Angles');
legend('q1', 'q2', 'q3', 'q4', 'q5', 'q6', 'Location', 'Best');

% Gráfico de Velocidades Angulares
subplot(3, 2, 3);
plot(t(1:end-1), qdot_traj);
title('Angular Velocities');
xlabel('Time (s)');
ylabel('Velocities');
legend('q1dot', 'q2dot', 'q3dot', 'q4dot', 'q5dot', 'q6dot', 'Location', 'Best');

% Gráfico de Aceleraciones Angulares
subplot(3, 2, 4);
plot(t(1:end-2), qdotdot_traj);
title('Angular Accelerations');
xlabel('Time (s)');
ylabel('Accelerations');
legend('q1ddot', 'q2ddot', 'q3ddot', 'q4ddot', 'q5ddot', 'q6ddot', 'Location', 'Best');

% Gráfico de Posiciones del Efector Final
subplot(3, 2, [5, 6]);
plot3(positions(:, 1), positions(:, 2), positions(:, 3), 'r', 'LineWidth', 2);
grid on;
xlabel('X');
ylabel('Y');
zlabel('Z');
title('End Effector Trajectory');
