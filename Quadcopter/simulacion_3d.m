clear; clc;

L_w=0.470; %distancia del contrapeso al eje de elevacion
L_a=0.660; %distancia del eje de rotacion al extremo de las helices
L_h=0.178; %distancia del eje pitch a un motor.

Elevacion = 0;
Pitch = 0;
Traslacion = 0;
i=1;

for Traslacion = 0:20:360
    for Elevacion = -40:20:100

Elevacion_nueva = Elevacion*(pi/180);
Pitch_nuevo = 0;
Traslacion_nueva = Traslacion*(pi/180);

%Matrices de coordenadas cartesianas de los cuerpos en movimiento.
HTM_BASE_TO_TRAVEL = [cos(Traslacion_nueva) sin(Traslacion_nueva) 0 0; %de la base al eje de traslacion
                     -sin(Traslacion_nueva) cos(Traslacion_nueva) 0 0;
                      0 0 1 0;
                      0 0 0 1];

HTM_TRAVEL_TO_CW = [1 0 0 0;                                           %del eje de traslacion al contrapeso
                    0 cos(Elevacion_nueva) -sin(Elevacion_nueva) -cos(Elevacion_nueva)*L_w;
                    0 sin(Elevacion_nueva) cos(Elevacion_nueva) -sin(Elevacion_nueva)*L_w;
                    0 0 0 1];

HTM_TRAVEL_TO_HB  = [1 0 0 0;                                           %del eje de traslacion al centro de las helices
                     0 cos(Elevacion_nueva) -sin(Elevacion_nueva) cos(Elevacion_nueva)*L_a;
                     0 sin(Elevacion_nueva) cos(Elevacion_nueva) sin(Elevacion_nueva)*L_a;
                     0 0 0 1];
                 
HTM_HB_TO_FM = [cos(Pitch_nuevo) 0 -sin(Pitch_nuevo) cos(Pitch_nuevo)*L_h;  %del centro de las helices al motor de enfrente
                0 1 0 0;
                sin(Pitch_nuevo) 0 cos(Pitch_nuevo) sin(Pitch_nuevo)*L_h;
                0 0 0 1];
            
HTM_HB_TO_BM = [cos(Pitch_nuevo) 0 -sin(Pitch_nuevo) -cos(Pitch_nuevo)*L_h; %del centro de las helices al motor de atras
              0 1 0 0;
              sin(Pitch_nuevo) 0 cos(Pitch_nuevo) -sin(Pitch_nuevo)*L_h;
              0 0 0 1];
          
HTM_BASE_TO_CW = HTM_BASE_TO_TRAVEL*HTM_TRAVEL_TO_CW;     %de la base al contrapeso

HTM_BASE_TO_HB = HTM_BASE_TO_TRAVEL*HTM_TRAVEL_TO_HB;     %de la base al centro de las helices

HTM_BASE_TO_FM = HTM_BASE_TO_HB* HTM_HB_TO_FM;            %de la base al motor frontal

HTM_BASE_TO_BM = HTM_BASE_TO_HB* HTM_HB_TO_BM;            %de la base al motor de atras

hold off
plot3([0 HTM_BASE_TO_TRAVEL(1,4)], [0 HTM_BASE_TO_TRAVEL(2,4)], [-1 HTM_BASE_TO_TRAVEL(3,4)],'Color', [0.6 0.6 0.6], 'LineWidth', 3); %eje de base del bicoptero
hold on

plot3([HTM_BASE_TO_CW(1,4),HTM_BASE_TO_HB(1,4)], [HTM_BASE_TO_CW(2,4),HTM_BASE_TO_HB(2,4)], [HTM_BASE_TO_CW(3,4),HTM_BASE_TO_HB(3,4)], 'k', 'LineWidth', 3); %cuerpo del bicoptero
    
plot3([HTM_BASE_TO_HB(1,4),HTM_BASE_TO_FM(1,4)],[HTM_BASE_TO_HB(2,4),HTM_BASE_TO_FM(2,4)],[HTM_BASE_TO_HB(3,4),HTM_BASE_TO_FM(3,4)], 'k', 'LineWidth', 3); %helice derecha
plot3([HTM_BASE_TO_HB(1,4),HTM_BASE_TO_BM(1,4)],[HTM_BASE_TO_HB(2,4),HTM_BASE_TO_BM(2,4)],[HTM_BASE_TO_HB(3,4),HTM_BASE_TO_BM(3,4)], 'k', 'LineWidth', 3); %helice izquierda

%tres ejes (x,y,z) para reescalar lo ya graficado
plot3([-1,1],[-1,-1],[-1,-1], 'k', 'LineWidth', 1);
plot3([-1,-1],[-1,1],[-1,-1], 'k', 'LineWidth', 1);
plot3([-1,-1],[-1,-1],[-1, 1], 'k', 'LineWidth', 1);

%se guardan las trayectorias de las posiciones de los motores
i=i+1;
Xb(i)=HTM_BASE_TO_FM(1,4);
Yb(i)=HTM_BASE_TO_FM(2,4);
Zb(i)=HTM_BASE_TO_FM(3,4);
Xf(i)=HTM_BASE_TO_BM(1,4);
Yf(i)=HTM_BASE_TO_BM(2,4);
Zf(i)=HTM_BASE_TO_BM(3,4);

%graficamos dichos vectores guardados
plot3(Xb,Yb,Zb,':b');
plot3(Xf,Yf,Zf,':r');

axis equal;


pause(0.002);

    end
end
