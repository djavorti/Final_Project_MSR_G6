% Define the joint variables
q1 = -1.0471976;
q2 = -0.8726646;
q3 = 0.68067841;
q4 = 0.01745329;
q5 = 1.76278254;
q6 = 2.12930169;

% Define the transformation matrices (you can copy the definitions from your code)
A0_1 = [cos(q1), 0, sin(q1), -180*cos(q1); 
        sin(q1), 0, -cos(q1), -180*sin(q1);
        0, 1, 0, 400;
        0, 0, 0, 1;
        ];
A1_2 = [sin(q2), cos(q2), 0, -600*sin(q2); 
        -cos(q2), sin(q2), 0, 600*cos(q2);
        0, 0, 1, 0;
        0, 0, 0, 1;
        ];
 
A2_3 = [sin(q3), cos(q3), 0, 120*sin(q3); 
        cos(q3), -sin(q3), 0, -120*cos(q3);
        0, 1, 0, 0;
        0, 0, 0, 1;
        ];
    
A3_4 = [cos(q4), 0, sin(q4), 0; 
        sin(q4), 0, -cos(q4), 0;
        0, 1, 0, 620;
        0, 0, 0, 1;
        ];
   
A4_5 = [cos(q5), 0, sin(q5), 0; 
        sin(q5), 0, -cos(q5), 0;
        0, 1, 0, 0;
        0, 0, 0, 1;
        ];
   
A5_6= [cos(q6), -sin(q6), 0, 0; 
        sin(q6), cos(q6), 0, 0;
        0, 0, 1, 200;
        0, 0, 0, 1;
        ];

% Calculate the composite transformation matrices
A2_0 = A0_1 * A1_2;
A3_0 = A2_0 * A2_3;
A4_0 = A3_0 * A3_4;
A5_0 = A4_0 * A4_5;
A6_0 = A5_0 * A5_6;

% Define the rotation matrices for each frame
R0 = A0_1(1:3, 1:3);
R1 = A2_0(1:3, 1:3);
R2 = A3_0(1:3, 1:3);
R3 = A4_0(1:3, 1:3);
R4 = A5_0(1:3, 1:3);
R5 = A6_0(1:3, 1:3);

% Calculate the positions of the joints (you need to extract the positions from the transformation matrices)
P0 = [0; 0; 0];
P1 = A0_1(1:3, 4);
P2 = A2_0(1:3, 4);
P3 = A3_0(1:3, 4);
P4 = A4_0(1:3, 4);
P5 = A5_0(1:3, 4);
P6 = A6_0(1:3, 4);

% Calculate the linear velocities for each joint
Jv = [cross([0; 0; 1], P6 - P0), cross(A0_1(1:3, 3), P6 - P1), ...
      cross(A2_0(1:3, 3), P6 - P2), cross(A3_0(1:3, 3), P6 - P3), ...
      cross(A4_0(1:3, 3), P6 - P4), cross(A5_0(1:3, 3), P6 - P5)];

% Calculate the angular velocities for each joint
Jw = [A0_1(1:3, 3), A2_0(1:3, 3), A3_0(1:3, 3), A4_0(1:3, 3), A5_0(1:3, 3), A6_0(1:3, 3)];

% Combine the linear and angular velocities to form the complete Jacobian
Jacobian = [Jv; Jw];

disp("Geometric Jacobian:");
disp(Jacobian);
