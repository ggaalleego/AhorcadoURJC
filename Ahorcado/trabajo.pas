PROGRAM Ahorcado;
CONST
	 MAXJUGADORES = 15; {Número máximo de jugadores}
	 MAXLETRAS = 10; {Número de letras de la palabra}
	 MAXFALLOS = 3; {Número máximo de fallos}
	 MAXINTENTOS = MAXLETRAS + MAXFALLOS; {Número máximo de intentos}
	 MAXPALABRAS = 100; {Número máximo de palabras}
	 MAXPARTIDAS = 100; {Número máximo de partidas}
	 PUNTOS0FALLOS = 100; {Número de puntos sin fallos}
	 PUNTOS1FALLO = 75; {Número de puntos con un fallo}
	 PUNTOS2FALLOS = 50; {Número de puntos sin fallos}
TYPE
 {tipo Jugador}
	 tJugador = RECORD
		 nombre: string;
		 usuario: string;
		 puntos: integer;
	 END;
 {tipo lista de jugadores}
	 tIndiceJugadores = 1..MAXJUGADORES;
	 tListaJugadores = ARRAY [tIndiceJugadores] OF tJugador;

 {Array parcialmente lleno para jugadores}
	 tJugadores = RECORD
		 listaJugadores: tListaJugadores;
		 tope: integer;
	 END;
 {tipo para almacenar una palabra}
 	tPalabra = string[MAXLETRAS];
 {tipo lista de palabras}
	 tIndicePalabras = 1..MAXPALABRAS;
	 tListaPalabras = ARRAY [tIndicePalabras] OF tPalabra;
 {Array parcialmente lleno para palabras}
	 tPalabras = RECORD
		 listaPalabras: tListaPalabras;
		 tope: integer;
	 END;
 {tipo lista de intentos}
	 tIndiceIntentos = 1..MAXINTENTOS;
	 tListaIntentos = ARRAY [tIndiceIntentos] OF tPalabra;
 {Array parcialmente lleno para intentos}
	 tIntentos = RECORD
		 listaIntentos: tListaIntentos;
		 tope: integer;
	 END;
	 tPartida = RECORD
		 nombreUsuario : string; {nombre del usuario}
		 intentos: tIntentos;
	 END;
 {tipo lista de partidas}
	 tIndicePartidas = 1..MAXPARTIDAS;
	 tListaPartidas = ARRAY [tIndicePartidas] OF tPartida;
 {Array parcialmente lleno para partidas}
	 tPartidas = RECORD
		 listadoPartidas: tListaPartidas;
		 tope: integer;
	 END;
 {tipo archivos binarios}
	 tArchivoJugadores = FILE OF tJugador;
	 tArchivoPartidas = FILE OF tPartida;
PROCEDURE OrdenarJugadores(VAR list: tJugadores);
VAR
	i,j:integer;
	aux:tJugador;
BEGIN
	IF list.tope>0 THEN BEGIN
		{Bucle de ordenacion de jugadores por orden alfabetico segun su usuario}
		FOR i:=2 TO list.tope DO
			BEGIN
				j:= i-1;
				aux:=list.listaJugadores[i];
				WHILE (j>0)AND (list.listaJugadores[j].usuario>aux.usuario) DO BEGIN
					list.listaJugadores[j+1]:=list.listaJugadores[j];
					j:=j-1;
				END;
				list.listaJugadores[j+1]:= aux;
			END;
	END;
END;
PROCEDURE ListadoJugadores(list: tJugadores);
VAR
	i:integer;
BEGIN
	IF (list.tope > 0) THEN
		FOR i:=1 TO list.tope DO 
			writeln('Usuario: [',list.listaJugadores[i].usuario,'] con nombre de real: [',list.listaJugadores[i].nombre,'] y puntuacion [',list.listaJugadores[i].puntos,']')
	ELSE writeln('La lista esta vacia');
END;
FUNCTION ExisteJugador (player: string; list: tJugadores):boolean;
VAR
	i:integer;
BEGIN
	ExisteJugador:= FALSE;
	{Busqueda de la existencia del jugador en la lista}
	IF list.tope<>0 THEN BEGIN
		i:= 1;
		WHILE (i<=list.tope) AND (NOT ExisteJugador) DO BEGIN
			ExisteJugador:= list.listaJugadores[i].usuario = player;
			i:= i +1;
		END;
	END;
END;

PROCEDURE DarAltaJugador(player: string; VAR list: tJugadores);
VAR
	i: integer;
	realName: string;
BEGIN
	IF (list.tope<MAXJUGADORES)THEN BEGIN
		list.tope:= list.tope +1;
		i:= list.tope;
		list.listaJugadores[i].usuario:= player;
		writeln('Inztroduzca su nombre real');
		readln(realName);
		list.listaJugadores[i].nombre:= realName;
		list.listaJugadores[i].puntos:= 0;
		writeln('Jugador dado de alta correctamente.');
	END
	ELSE writeln('Lo sentimos, la lista esta llena');
END;
PROCEDURE DarBajaJugador(player: string; VAR list: tJugadores);
VAR
	i,j: integer;
BEGIN
	IF ExisteJugador(player,list) THEN BEGIN
		{Busqueda del jugador con dicho nombre de usuario}
		i:= 0;
		REPEAT
			i:=i+1;
		UNTIL list.listaJugadores[i].usuario = player;
		{Eliminacion al jugador}
		FOR j:=i+1 TO list.tope DO BEGIN
			list.listaJugadores[j-1]:= list.listaJugadores[j];
		END;
		list.tope:= list.tope-1;
		writeln('El jugador ha sido dado de baja con exito');
	END
	ELSE writeln('El jugador no existe');
END;
FUNCTION ExistePalabra(wordle: tPalabra; list:tPalabras):boolean;
VAR
	i: integer;
BEGIN
	ExistePalabra:= FALSE;
	{Busqueda de la existencia de la palabra en la lista}
	IF (list.tope<>0) THEN BEGIN
		i:=1;
		WHILE (i<= list.tope) AND (NOT ExistePalabra) DO BEGIN
			ExistePalabra := wordle = list.listaPalabras[i];
			i:= i+1;
		END;
	END;
END;
PROCEDURE AltaPalabra(wordle: tPalabra; VAR list: tPalabras);
VAR
	i:integer;
BEGIN
	IF (NOT ExistePalabra(wordle,list)) AND (length(wordle)=10)  THEN BEGIN
		i:= list.tope+1;
		list.listaPalabras[i] := wordle;
		list.tope:= list.tope+1;
		writeln('La palabra ha sido anyadida');
	END
	ELSE IF (length(wordle)<>10) THEN writeln('Su palabra debe contener 10 letras')
	ELSE writeln('La palabra que ha introducido ya existe');
END;
PROCEDURE BajaPalabra(wordle: tPalabra; VAR list: tPalabras);
VAR
	i,j:integer;
BEGIN
	IF ExistePalabra(wordle,list) THEN BEGIN
		{Busqueda de dicha palabra en la lista}
		i:=0;
		REPEAT
			i:= i+1;
		UNTIL (list.listaPalabras[i]= wordle);
		{Bucle para eliminacion de dicha palabra}
		FOR j:= i+1 TO list.tope DO BEGIN
			list.listaPalabras[j-1]:= list.listaPalabras[j];
		END;
		list.tope:=list.tope-1;
		writeln('La palabra ha sido eliminada');
	END
	ELSE writeln('La palabra que ha introducido no existe');
END;
PROCEDURE MostrarListaPalabras(listWords: tPalabras);
VAR
	i: integer;
BEGIN
	writeln('Actualmente la lista contiene estas palabras: ');
	{Mostrado en pantalla del listado}
	FOR i:=1 TO listWords.tope DO 
		writeln('  ',listWords.listaPalabras[i]);
END;
PROCEDURE ModificarPalabra(wordle: tPalabra; VAR list: tPalabras);
VAR
	i:integer;
BEGIN
	IF ExistePalabra(wordle,list) THEN BEGIN
		{Busca la palabra en la lista}
		i:=0;
		REPEAT
			i:= i+1;
		UNTIL (list.listaPalabras[i] = wordle);
		writeln('Introduzca la nueva palabra');
		REPEAT
			readln(wordle);
			IF ExistePalabra(wordle,list) THEN
			writeln('Esta palabra ya pertenece a la lista')
			ELSE IF length(wordle)<>10 THEN
			writeln('Su palabra debe tener exactamente 10 letras');
		UNTIL (length(wordle)= 10) AND (NOT ExistePalabra(wordle,list));
		list.listaPalabras[i]:=wordle;
		writeln('Su palabra ha sido modificada correctamente');
	END
	ELSE writeln('La palabra que desea modificar no existe');
END;
PROCEDURE HacerBackup(VAR filePlayers:tArchivoJugadores; listPlayers: tJugadores; VAR fileGames: tArchivoPartidas; listGames: tPartidas; VAR fileWords: text; listWords: tPalabras );
VAR
	i:integer;
BEGIN
	{Guardado Jugadores}
	rewrite(filePlayers);
	FOR i:=1 TO listPlayers.tope DO
		write(filePlayers,listPlayers.listaJugadores[i]);
	close(filePlayers);
	{Guardado Partidas}
	rewrite(fileGames);
	FOR i:=1 TO listGames.tope DO
		write(fileGames,listGames.listadoPartidas[i]);
	close(fileGames);
	{Guardado Palabras}
	rewrite(fileWords);
	FOR i:=1 TO listWords.tope DO 
		writeln(fileWords,listWords.listaPalabras[i]);
	close(fileWords);
	writeln('Los datos han sido guardados con exito.');
END;
PROCEDURE RestaurarBackup(VAR filePlayers:tArchivoJugadores; VAR listPlayers: tJugadores; VAR fileGames: tArchivoPartidas; VAR listGames: tPartidas; VAR fileWords: text; VAR listWords: tPalabras);
VAR
	i: integer;
BEGIN
	{Restaurado Jugadores}
	i:=1;
	WHILE NOT EOF(filePlayers) DO BEGIN
		read(filePlayers,listPlayers.listaJugadores[i]);
		i:=i+1;
	END;
	listPlayers.tope:=i-1;
	close(filePlayers);
	{Restaurado Partidas}
	i:=1;
	WHILE (NOT EOF(fileGames))DO BEGIN
		read(fileGames,listGames.listadoPartidas[i]);
		i:=i+1;
	END;
	listGames.tope:=i-1;
	close(fileGames);
	{Restaurado Palabras}
	reset(fileWords);
	i:=1;
	WHILE NOT EOF(fileWords) DO BEGIN
		readln(fileWords,listWords.listaPalabras[i]);
		i:=i+1;
	END;
	listWords.tope:=i-1;
	close(fileWords);
	writeln('Los datos se han restaurado con exito');	
END;
FUNCTION PerteneceLetra(letter:char; wordle:tPalabra):boolean;
VAR
	i:integer;
BEGIN
	PerteneceLetra:= FALSE;
	i:= 1;
	{Busqueda de la existencia de la letra en la palabra}
	WHILE (i<= MAXLETRAS) AND (NOT PerteneceLetra) DO BEGIN
		PerteneceLetra:= ord(letter) = ord(wordle[i]);
		i:=i+1;
	END;
END;
FUNCTION Puntuacion(failsNum:integer):integer;
BEGIN
	IF failsNum=0 THEN Puntuacion:= PUNTOS0FALLOS
	ELSE IF failsNum=1 THEN Puntuacion:= PUNTOS1FALLO
	ELSE IF failsNum=2 THEN Puntuacion:= PUNTOS2FALLOS;
END;
PROCEDURE Jugar(listWord: tPalabras; VAR player: tJugador; VAR listGame: tPartidas);
VAR
	wordle: tPalabra;
	randomNumber,failsNum,i,attempt: integer;
	letter: char;
	game: tPalabra;
BEGIN
	IF listWord.tope>0 THEN BEGIN
		randomize;
		randomNumber:= random(listWord.tope)+1;
		wordle:= listWord.listaPalabras[randomNumber];
		game:= '----------';
		failsNum:= 0;
		attempt:=0;
		writeln('Comienza el juego: ',game,' ',failsNum,' fallos');
		listGame.tope:=listGame.tope+1;
		REPEAT
			write('Introduce una letra: ');
			readln(letter);
			attempt:=attempt+1;
			listGame.listadoPartidas[listGame.tope].nombreUsuario:= player.usuario;
			listGame.listadoPartidas[listGame.tope].intentos.tope:= attempt;
			{Caso de la letra introducida pertenezca a la palabra}
			IF PerteneceLetra(letter,wordle) THEN BEGIN
				FOR i:= 1 TO MAXLETRAS DO BEGIN
					IF ord(letter) = ord(wordle[i]) THEN
						game[i]:= letter;
				END;
				listGame.listadoPartidas[listGame.tope].intentos.listaIntentos[attempt]:= game;
				writeln('ACIERTO: ',game);
			END
			{Caso de que la letra introducida no pertenezca a la palabra}
			ELSE BEGIN
				writeln('FALLO: ',game,' ',failsNum+1,' fallos');
				listGame.listadoPartidas[listGame.tope].intentos.listaIntentos[attempt]:= game;
				failsNum:=failsNum+1;
			END;
		UNTIL (failsNum = MAXFALLOS) OR (wordle = game) OR (attempt = MAXINTENTOS);
		{Caso que el jugador acierte la palabra}
		IF wordle=game THEN BEGIN
			writeln('GANASTE! La palabra era ',wordle,'. Has obtenido ', Puntuacion(failsNum),' puntos');
			player.puntos:= player.puntos + Puntuacion(failsNum);
		END
		{Caso que el jugador exceda el limite de intentos}
		ELSE IF attempt = MAXINTENTOS THEN writeln('Alcanzo el numero maximo de intentos')
		{Caso que el jugador alcance el maximo de errores}
		ELSE writeln('PERDISTE! La palabra era ',wordle,'. Has obtenido 0 puntos');
	END
	ELSE writeln('Lo sentimos, no hay palabras en el juego');
	readln;
END;
PROCEDURE VerRanking(list:tJugadores);
VAR
	i,j,top: integer;
	aux: tJugador;
BEGIN
	IF list.tope>0 THEN BEGIN
		{Bucle de ordenacion de jugadores de mayor a menor puntuacion}
		FOR i:=2 TO list.tope DO
			BEGIN
				j:= i-1;
				aux:=list.listaJugadores[i];
				WHILE (j>0)AND (list.listaJugadores[j].puntos<aux.puntos) DO BEGIN
					list.listaJugadores[j+1]:=list.listaJugadores[j];
					j:=j-1;
				END;
				list.listaJugadores[j+1]:= aux;
			END;
		top:= 0;
		{Muestra por pantalla de dichos jugadores}
		FOR i:= 1 TO list.tope DO 
			BEGIN
				top:=top+1;
				writeln('TOP ',top,': ',list.listaJugadores[i].usuario,' con puntuacion ',list.listaJugadores[i].puntos);
			END;
		
	END
	ELSE writeln('No hay ningun jugador registrado')
END;
FUNCTION HaJugado(user:string; listGames: tPartidas):boolean;
VAR
	i: integer;
BEGIN
	HaJugado := FALSE;
	{Busqueda de la existencia de partidas de un user en una lista}
	i:=1;
	WHILE (i<= listGames.tope) AND (NOT HaJugado) DO BEGIN
		HaJugado:= listGames.listadoPartidas[i].nombreUsuario = user;
		i:=i+1;
	END;
END;
PROCEDURE VerDetallePartidas(user:string; listGames: tPartidas);
VAR
	i,j,games:integer;
BEGIN
	IF HaJugado(user,listGames) THEN BEGIN
		games:=0;
		{Bucle de bsuqueda de un user en una lista}
		FOR i:= 1 TO listGames.tope DO BEGIN
			{Mostrado en pantalla de las partidas de dicho user}
			IF (listGames.listadoPartidas[i].nombreUsuario = user) THEN BEGIN
				games:= games +1;
				writeln('PARTIDA ',games,':');
				FOR j:=1 TO listGames.listadoPartidas[i].intentos.tope DO BEGIN
					writeln('  INTENTO ',j,': ',listGames.listadoPartidas[i].intentos.listaIntentos[j]);
				END;
			END;
		END;
	END
	ELSE writeln('Todavia no ha jugado ninguna partida');
END;
PROCEDURE DarBajaPartidas(user:string; VAR listGames: tPartidas);
VAR
	i,j:integer;
BEGIN
	WHILE HaJugado(user,listGames) DO BEGIN
		{Busqueda del jugador en la lista}
		i:=0;
		REPEAT
			i:=i+1;
		UNTIL listGames.listadoPartidas[i].nombreUsuario = user;
		{Eliminacion de las partidas de dicho jugador}
		FOR j:=i+1 TO listGames.tope DO BEGIN
			listGames.listadoPartidas[j-1]:= listGames.listadoPartidas[j];
		END;
		listGames.tope:= listGames.tope-1;
	END;
END;
VAR
	palabra: tPalabra;
	listaPartidas: tPartidas;
	listaPalabras: tPalabras;
	listaJugadores: tJugadores;
	jugador: tJugador;
	archivoJugadores: tArchivoJugadores;
	archivoPartidas: tArchivoPartidas;
	archivoPalabras: text;
	contador:integer;
	opcion,opcionAdministrador,opcionJugador: char;
	usuario,pregunta:string;
	existeArchivoJugadores,existeArchivoPartidas: boolean;
BEGIN {programa principal}
	writeln('********************************************');
	writeln(' 	Ignacio   Gallego   Torres      ');
	writeln('********************************************');
	assign(archivoJugadores,'jugadores.dat');
	assign(archivoPartidas,'partidas.dat');
	assign(archivoPalabras,'palabras.txt');
	listaJugadores.tope:=0;
	listaPalabras.tope:=0;
	listaPartidas.tope:= 0;
	{$I-}
	reset(archivoPartidas);
	{$I+}
	existeArchivoPartidas:= (IOResult = 0);
	{$I-}
	reset(archivoJugadores);
	{$I+}
	existeArchivoJugadores:= (IOResult= 0);
	REPEAT
		writeln;
		writeln('****************  MENU  *******************');
		writeln('a) Administrador');
		writeln('b) Jugador');
		writeln('c) Terminar');
		readln(opcion);
		CASE opcion OF
			'a','A':
			BEGIN
				REPEAT
					writeln('********** MENU ADMINISTRADOR **********');
					writeln('a) Listado de jugadores');
					writeln('b) Dar de baja un jugador');
					writeln('c) Alta palabra');
					writeln('d) Baja palabra');
					writeln('e) Modificar palabra');
					writeln('f) Hacer backup');
					writeln('g) Restaurar backup');
					writeln('h) Regresar al menu');
					readln(opcionAdministrador);
					CASE opcionAdministrador OF
						'a','A':
							BEGIN
								OrdenarJugadores(listaJugadores);
								ListadoJugadores(listaJugadores);
								readln;
							END;
						'b','B':
							BEGIN
								IF listaJugadores.tope>0 THEN BEGIN
									writeln('Introduzca el nombre de usuario que desea dar de baja');
									readln(usuario);
									DarBajaPartidas(usuario,listaPartidas);
									DarBajaJugador(usuario,listaJugadores);
								END
								ELSE writeln('Actualmente no hay ningun usuario dado de alta');
								readln;
							END;
						'c','C':
							BEGIN
								IF listaPalabras.tope< MAXPALABRAS THEN BEGIN
									writeln('Introduzca la palabra que desee anyadir');
									REPEAT
										readln(palabra);		
										AltaPalabra(palabra,listaPalabras);
									UNTIL ExistePalabra(palabra,listaPalabras);
								END
								ELSE writeln('Lo sentimos, se ha alcanzado el numero maximo de palabras'); 
								readln;
							END;
						'd','D':       
							BEGIN
								IF listaPalabras.tope>0 THEN BEGIN
									writeln('Introduzca la palabra que desea eliminar');
									readln(palabra);
									BajaPalabra(palabra,listaPalabras);
								END
								ELSE writeln('Actualmente no hay palabras en el juego');
								readln;
							END;
						'e','E': 
							BEGIN
								IF listaPalabras.tope>0 THEN BEGIN
									MostrarListaPalabras(listaPalabras);
									writeln('Introduzca la palabra que desea modificar');
									readln(palabra);
									ModificarPalabra(palabra,listaPalabras);									
								END
								ELSE writeln('Actualmente no hay palabras en el juego');
								readln;
							END;	
						'f','F':
							BEGIN	
								HacerBackup(archivoJugadores,listaJugadores,archivoPartidas,listaPartidas,archivoPalabras,listaPalabras);		
							END;
						'g','G':
							BEGIN
								IF (existeArchivoJugadores OR existeArchivoPartidas) THEN BEGIN
									writeln('Si restaura datos, los datos actuales seran eliminados si no han sido guardados. ¿Esta seguro que desea restauralos?  (si/no)');
									readln(pregunta);
									CASE pregunta OF
										'Si','si','SI': RestaurarBackup(archivoJugadores,listaJugadores,archivoPartidas,listaPartidas,archivoPalabras,listaPalabras);											
									END;
								END
								ELSE writeln('Actualmente no existe ninguno archivo con datos que restaurar');
							END;
					END;
				UNTIL opcionAdministrador = 'h';
			END;
			'b','B':
			BEGIN
				writeln('************ MENU JUGADOR **************');
				REPEAT
					writeln('Introduzca su nombre de usuario');
					readln(usuario);
					opcionJugador := '*';
					IF ExisteJugador(usuario,listaJugadores) THEN BEGIN
						contador:= 0;
						REPEAT
							contador:=contador+1
						UNTIL	(usuario = (listaJugadores.listaJugadores[contador].usuario));	
						jugador:=listaJugadores.listaJugadores[contador];
						REPEAT
							writeln('a) Jugar partida');
							writeln('b) Ver ranking');
							writeln('c) Ver el detalle de las partidas');
							writeln('d) Regresar al menu');
							readln(opcionJugador);
							CASE opcionJugador OF
								'a','A':
								BEGIN
									IF listaPartidas.tope < MAXPARTIDAS THEN BEGIN
										Jugar(listaPalabras,jugador,listaPartidas);
										listaJugadores.listaJugadores[contador]:=jugador;
									END
									ELSE writeln('Se ha alcanzado el numero maximo de partidas.');
								END;
								'b','B':
								BEGIN
									VerRanking(listaJugadores);
									readln;
								END;
								'c','C':
								BEGIN
									VerDetallePartidas(usuario,listaPartidas);
									readln;
								END;
							END;
						UNTIL opcionJugador = 'd';
					END
					ELSE IF (NOT ExisteJugador(usuario,listaJugadores)) AND (listaJugadores.tope<MAXJUGADORES) THEN BEGIN
						writeln('Vamos a proceder a darle de alta como nuevo jugador.');
						DarAltaJugador(usuario,listaJugadores);
					END
					ELSE
						BEGIN
							writeln('Lo sentimos, se ha alcanzado el numero maximo de usuarios dados de alta.');
							opcionJugador := 'd';
						END;
				UNTIL opcionJugador = 'd';	
			END;
		END;
	UNTIL opcion = 'c';
END.
