close all
clc

% Ajustes de simulación
f1   = 500;  % Frecuencia de prueba 1
f2   = 5000; % Frecuencia de prueba 2
fc   = 1e3;  % Frecuencia de corte del filtro
fs   = 50e3; % Frecuencia de muestreo
L    = 1000; % Longitud de simulación
NFFT = 1024; % Cantidad de puntos para los gráficos en frecuencia
simulation_type = 0;
% Definición de punto fijo
NB_I       = 12;   % Cantidad de bits de la entrada 
NBF_I      = 11;   % Parte fraccional de la entrada

NB_COEFFS  = 12;   % Cantidad de bits de los coeficientes
NBF_COEFFS = 11;   % Parte fraccional de los coeficientes

NB_PP      = 12; % Cantidad de bits de producto parcial
NBF_PP     = 11; % Parte fraccional del producto parcial

NB_ACCUM   = 12+5; % Cantidad de bits del acumulador
NBF_ACCUM  = 11; % Parte fraccional del acumulador

NB_O       = 12;   % Cantidad de bits de la salida 
NBF_O      = 11;   % Parte fraccional de la salida

NTAPS      = 32;   % Cantidad de taps

% Cálculo de coeficientes
b = fir1(NTAPS-1,fc/(fs/2),'low'); % fir1(Orden del filtro, frecuencia digital (0 a 1), tipo de respuesta)

% Ploteo de la respuesta en frecuencia
B = fft(b,NFFT); % FFT de NFFT puntos
plot((0:NFFT/2-1)/NFFT*fs, 20*log10(abs(B(1:NFFT/2)))) % eje x: frecuencias analógicas, eje y: respuesta en dB

% Cuantización de los coeficientes
bfx=fi(b,1,NB_COEFFS,NBF_COEFFS);

% Ploteo de la respuesta en frecuencia cuantizada
Bfx=fft(bfx.double,NFFT);                   % Obtengo transformada de Fourier
hold all;                                   % Habilito escritura de múltiples gráficos en la misma figura
plot((0:NFFT/2-1)/NFFT*fs, 20*log10(abs(Bfx(1:NFFT/2)))) % Grafico respuesta en frecuencia
grid on                                     % Habilita la grilla
legend('Punto flotante','Punto fijo')       % Escribe leyendas en el gráfico
title('Respuesta en frecuencia del filtro') % Escribe título del gráfico
ylabel('Magnitud [dB]');                    % Nombre del eje de abscisas
xlabel('Frecuencia [Hz]');                  % Nombre del eje de ordenadas

% Escritura de archivo de coeficientes
fid=fopen('coeffs.vhd','w+');               % Abre archivo .vhd
vhd_start={                                 % Líneas de encabezado
    'library ieee;',
    'use ieee.std_logic_1164.all;',
    'entity coeffs is',
    ['port( b : out std_logic_vector(' num2str(NTAPS*NB_COEFFS-1) ' downto 0));'],
    'end entity;',
    'architecture behavioral of coeffs is',
    'begin'};

vhd_end={                                   % Líneas de fin
    'end architecture behavioral;'};

for i=1:length(vhd_start)                   % Imprime encabezado
    fprintf(fid,[vhd_start{i} '\n']);
end

for i=1:NTAPS                               % Imprime coeficientes
    tmp=bfx(i);
    fprintf(fid,[ '"' tmp.bin '",\n']);
end

for i=1:length(vhd_end)                     % Imprime fin
    fprintf(fid,[vhd_end{i} '\n']);
end
fclose(fid)                                 % Cierra archivo



% Generación de señal de prueba
if (simulation_type==0) % 0 para probar el filtrado, 1 para estimar snr
  a = sin(2*pi* round(f1/fs*NFFT)/NFFT * (0:L-1)) + sin(2*pi* round(f2/fs*NFFT)/NFFT * (0:L-1)); % Se redondea la frecuencia para no tener leakage en la representación espectral
else 
  a = sin(2*pi* round(f1/fs*NFFT)/NFFT * (0:L-1));
end

a = a /max(a) * (1-2*2^-NBF_I); % Normalización de la señal de entrada

% Modelo del filtro en punto flotante
pp = zeros(1,length(b));
y  = zeros(1,length(a));



% Modelo del filtro en punto fijo
% Definición de aritmética interna del filtro
%Opciones posibles de redondeo: floor(truncado), nearest(redondeo), ceil, round
%Opciones posibles de ajuste de rango: wrap(recorte/overflow), saturate(saturación)
ppfx        = fi(pp                ,1,NB_PP,NBF_PP      ,'RoundMode','floor','OverflowMode','wrap'); 
accumfx     = fi(0                 ,1,NB_ACCUM,NBF_ACCUM,'RoundMode','floor','OverflowMode','wrap'); 
yfx         = fi(zeros(1,length(a)),1,NB_O,NBF_O        ,'RoundMode','floor','OverflowMode','wrap');
afx         = fi(a                 ,1,NB_I,NBF_I);

% convolucion entrada con el filtro
y=conv(afx.double,bfx.double)
%ploteo entrada
figure();
plot(afx.double)
legend('Señal de entrada')
title('Entrada del filtro')
ylabel('Amplitud');
xlabel('Muestras');

% Dibujo ambas respuestas en el tiempo
figure();
plot(y)
legend('Señal de salida')
title('Salida del filtro')
ylabel('Amplitud');
xlabel('Muestras');

% Dibujo ambas respuestas en frecuencia
figure();
Y=fft(y,NFFT);
plot((0:NFFT/2-1)/NFFT*fs, 20*log10(abs(Y(1:NFFT/2))))
hold all
legend('Punto fijo')
title('Salida del filtro en el dominio de la frecuencia')
ylabel('Magnitud [dB]');
xlabel('Frecuencia [Hz]');


%Genero vectores de entrada para el testbench
fid=fopen('x.txt','w+');
for i=1:length(yfx)
    tmp=afx(i);
    fprintf(fid,[tmp.bin '\n']);
end
fclose(fid)

%Lectura salida generada por el filtro implementado en vhdl
fid=fopen('output.txt','r');
data= fscanf(fid,'%f')
fclose(fid)

figure();
plot(data)
legend('Señal de salida')
title('Salida del filtro implementado en vhdl')
ylabel('Amplitud');
xlabel('Muestras');

figure();
DATA=fft(data,NFFT);
plot((0:NFFT/2-1)/NFFT*fs, 20*log10(abs(DATA(1:NFFT/2))))
hold all
legend('Punto fijo')
title('Salida del filtro implementado en el dominio de la frecuencia')
ylabel('Magnitud [dB]');
xlabel('Frecuencia [Hz]');


