% Base de conocimiento, Coloque aquí los predicados para representar el
% conocimiento

:- dynamic count/1.

count(0).

%Alimentos
fruta('manzana picada',52).
fruta('plátano picado',89).
fruta('papaya picada',45).
lacteo('vaso de leche entera',68).
cereal('pan de trigo integral',216).
ensalada('ensalada pepino',85).
bebida('jugo de naranja',45).



%Reglas

%Regla diagnostico
diagnostico(IMC,Sexo):- (
	Sexo == 1 -> (
		IMC < 17 -> 
		write('USTED PADECE DESNUTRICION');
		IMC >= 17,IMC < 20 -> 
		write('USTED ESTA BAJO DE PESO');
		IMC >= 20,IMC < 25 ->
		write('USTED ESTA NORMAL');
		IMC >= 25, IMC < 30 ->
		write('USTED TIENE LIGERO SOBREPESO');
		IMC >= 30, IMC < 40 ->
		write('USTED TIENE OBESIDAD SEVERA');
		write('USTED TIENEN OBESIDAD MÓRBIDA')
	);

	Sexo == 2 -> (
		IMC < 16 -> 
		write('USTED PADECE DESNUTRICION');
		IMC >= 16,IMC < 20 -> 
		write('USTED ESTA BAJO DE PESO');
		IMC >= 20,IMC < 24 ->
		write('USTED ESTA NORMAL');
		IMC >= 24, IMC < 29 ->
		write('USTED TIENE LIGERO SOBREPESO');
		IMC >= 29, IMC < 37 ->
		write('USTED TIENE OBESIDAD SEVERA');
		write('USTED TIENEN OBESIDAD MÓRBIDA')
	)
	
).

% El desayuno consta de fruta+lacteo+cereal
desayuno(LD, Tk):-fruta(F,Kf),lacteo(L,Kl), cereal(C,Kc),
                        Tk is Kf+Kl+Kc, LD = [F,L,C].

% El almuerzo consta de ensalada+bebida
almuerzo(LA,Tk):-ensalada(E,Ke),bebida(B,Kb), Tk = Ke+Kb, LA = [E,B].

% Regla que muestra la combinación de desayuno+almuerzo que
% esten en el rango de K mas/menos 10%
muestra_dietas(K):-desayuno(LD,Dk),almuerzo(LA,Ak),
                     Tk = Dk + Ak, Tk >= K*0.9, Tk =< K*1.1,
                     count(N), N1 is N+1,retract(count(N)),assert(count(N1)),
                     nl,format('MENÚ #~d (~d Kcal)',[N1,Tk]),
                     nl,write('Desayuno: '),write(LD),
                     nl,write('Almuerzo: '),write(LA),
                     nl,write('<<Press any key>>'),get_single_char(_),fail.

% Ciclo principal
main:-repeat,
      pinta_menu,
      read(Opcion),
      ( (Opcion=1,doImc,fail);
	(Opcion=2,doDieta,fail);
	(Opcion=3,write('Gracias por utilizar mi programa'))).

% Muestra el menú

pinta_menu:-nl,nl,
      writeln('===================================='),
      writeln('         DRA. MIKU HATSUNE'),
      writeln('          Médica Virtual'),
      writeln('   <<  Experta en Nutrición  >>'),
      writeln('===================================='),
      nl,writeln('       MENU PRINCIPAL'),
      nl,write('1 Calcular indice de masa corporal'),
      nl,write('2 Recomendar una dieta saludable'),
      nl,write('3 Salir'),
      nl,write('================================='),
      nl,write('Indique una opcion válida:').

% Regla para calcular IMC

doImc:-nl, write('================================='),nl,
       write('Elegiste: Calculo del Indice de Masa Corporal\n'),nl,
       write('Indique su peso en Kilogramos:'),read(Peso),
       write('Indique su estatura en Metros:'),read(Estatura),Estatura > 0,
       write('Indique su genero (1/Male, 2/Female):'),read(Sexo),
       IND is Peso/(Estatura*Estatura),
       nl,format('Su indice de masa corporal es: ~g',IND),get_single_char(_),
       get_single_char(_),
       nl, write('DIAGNOSTICO: '),diagnostico(IND,Sexo).
	   %(  (Sexo=1,IND<17,write('USTED PADECE DESNUTRICION!'));
	   %(Sexo=1,IND>=17,IND<20,write('USTED TIENE BAJO PESO!\n')) ).

% Regla para recomendar dietas

doDieta:-nl,writeln('Elegiste: Nutriologo Artificial'),
			retractall(count(_)),assert(count(0)),
			writeln('Recomendar dieta saludable'),
			write('Indique su genero (1/Male, 2/Female):'),read(Sexo),
			nl,write('Indique su peso en kilogramos'),read(Peso),
			nl,write('Indique su edad'),read(Edad),Edad > 0,
			(
				(Sexo == 1 ->
					GastoTempo is Peso * 24;
				Sexo == 2 -> 
					GastoTempo is Peso * 21.6;
				write('Problemas al elegir el sexo')
				)
			),
			(
				(Edad < 25 ->
					GastoKcal is GastoTempo + 300 ;
				Edad >= 25,Edad =< 45 ->
					GastoKcal is GastoTempo;
				Edad > 45 ->
					X is Edad - 45,
					Y is X/10,
					floor(Y,Z),
					GastoKcal is GastoTempo - (Z*100)
				)
			),
			write('El gasto calórico es: '), write(GastoKcal),
			muestra_dietas(500),
			muestra_dietas(GastoKcal).

