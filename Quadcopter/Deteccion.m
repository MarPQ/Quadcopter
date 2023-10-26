            %--------Universidad De Guadalajara--------%
%--------Centro Universitario De Ciencias Exactas E Ingenierias--------%
              %--------Sistemas Inteligentes 1--------%
         %--------Pacheco Quintero Marco Antonio--------%  

clear all; close all; clc;         

imagen = imread('Imagen2.jpg');            %Cargamos imagenes.
plantilla = imread('Plantilla.jpg');

imagen_gris = rgb2gray(imagen);             %Convertimos imagenes a escala de grises.
plantilla_gris = rgb2gray(plantilla);

[H,W] = size(imagen_gris);                  %Obtenemos las dimensiones de las imagenes.
[h,w] = size(plantilla_gris);

% Limites inferiores y superiores 
xl = [1 1]';
xu = [W-w H-h]'; 

F = 0.6;                 %Factor de amplificacion
CR = 0.9;                %Constante de recombinacion
 
G = 100;                %Iteraciones o generaciones que tendra el algoritmo
N = 100;                %Poblacion de particulas
D = 2;                  %Dimension del problema
 
x = zeros(D,N);          %Vector donde inicializaremos a nuestra poblacion.
fitness = zeros(1,N);    %Vector donde guardaremos la evaluacion (NCC) de cada individuo.
plot_fit = zeros(1,G);  
 for i = 1:N 
     x(1,i) = randi([xl(1) xu(1)]);                                %Inicializamos aleatoriamente con enteros dentro del rango.
     x(2,i) = randi([xl(2) xu(2)]); 
     fitness(i) = NCC(imagen_gris,plantilla_gris,x(1,i),x(2,i));    %Evaluamos y guardamos para cada miembro.  
 end
 
 for t = 1:G
     for i = 1:N
        y = randperm(N);               %Generamos un vector con los indices de los individuos permutados
        y2 = y(y~=i);                  %Excluimos el indice del individuo actual.
         
        v = x(:,y2(1)) + F.*(x(:,y2(2)) - x(:,y2(3)));         %Creamos un vector mutado para cada individuo
        
        u = zeros(D,1);                                        %Creamos un vector de prueba
        
        for j = 1:D
            
            r = rand;
            
            if r <= CR                                        %Comparamos CR con un numero aleatorio si este ultimo es
                u(j) = v(j);                                  %menor a CR guardamos en la posicion de u lo que se encuentra en la de v
            else                                              %de no ser asi se guardara lo de x, es decir al final no habra cambio.
                u(j) = x(j,i);
            end  
            
        end
        
        for k = 1:D
           if xl(k) < u(k) && u(k) < xu(k)                   %Si el individuo no excede el espacio de trabajo permanece.
               u(k) = u(k);
           else
               u(k) = randi([xl(k) xu(k)]);                  %En caso de excederlo se recalcula al individuo.
           end      
        end
        
        u = round(u);                                          %Redondeamos u en caso de que no aplique la penalizacion para asegurar enteros.
        
        fitness_u = NCC(imagen_gris,plantilla_gris,u(1),u(2));  %Evaluamos la funcion en u.
        
        if fitness_u > fitness(i)                             %Finalmente realizamos la operacion de seleccion, si la evaluacion de la funcion 
            x(:,i) = u;                                       %en u es mayor que la evalucion en x (fitness), u pasara a sustituir el actual en x,
            fitness(i) = fitness_u;                           %y la misma actualizacion ocurrira para fitness con fitness_u
        end      
     end
[plot_fit(t),~] = max(fitness); 
 end
 
[~,ig] = max(fitness);     %Obtenemos el maximo del vector fitness                      

pixel = x(:,ig);           %El mejor miembro sera la coordenada donde se encuentra la plantilla.

figure(1)
hold on
imshow(imagen)             %Mostramos la imagen.
line([pixel(1) pixel(1)+w], [pixel(2) pixel(2)],'Color','g','LineWidth',3);    %Señalamos el contorno donde se encontro la plantilla
line([pixel(1) pixel(1)], [pixel(2) pixel(2)+h],'Color','g','LineWidth',3);
line([pixel(1)+w pixel(1)+w], [pixel(2) pixel(2)+h],'Color','g','LineWidth',3);
line([pixel(1) pixel(1)+w], [pixel(2)+h pixel(2)+h],'Color','g','LineWidth',3);

% figure(2)
% grid on
% hold on
% plot(plot_fit);             %Resulta una grafica de iteraciones contra la evaluacion en la funcion objetivo, de esta manera obtenemos
% xlabel('iteraciones');      %informacion como por ejemplo: cuantas iteraciones le tomo al algoritmo encontrar el minimo global, si hubo
% ylabel('f(x,y)');           %estancamiento en minimos locales y en cuantas iteraciones se corrijio.

