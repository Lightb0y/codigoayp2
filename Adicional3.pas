{Ejercicio 3. Un teatro posee una sala con 80 filas y 100 butacas en cada fila. Se desea procesar
las entradas vendidas durante todo un mes con el objetivo de obtener la ubicación (fila y
butaca) más vendida. De cada venta se lee la fecha, nombre de la obra y ubicación (fila y
butaca) y DNI del espectador.
1) Haga un módulo que procese la lista de ventas que se dispone y las almacene en una
estructura de datos conveniente para resolver el objetivo y retorne dicha estructura de
datos.
2) Haga un módulo recursivo que reciba la estructura de datos retornada en el punto 1 y
devuelva la ubicación más vendida.
3) Haga un módulo que reciba la estructura de datos retornada en el punto 1 y devuelva
la cantidad de ubicaciones que no tienen entradas vendidas.
4) Haga un módulo que procese la lista de ventas que se dispone, las almacene en una
estructura de datos y que la retorne. Dicha estructura debe permitir la búsqueda
eficiente por nombre de obra. Para cada obra se desea almacenar todas las entradas
vendidas (fecha, ubicación y DNI del comprador).
5) Haga un módulo que reciba la estructura de datos retornada en el punto 4 y un DNI y
que devuelva la cantidad de veces que asistió el espectador con dicho DNI. Nota: un
espectador pudo haber asistido más de una vez a la misma obra.
6) Haga un módulo que reciba la estructura de datos retornada en el punto 4 y dos DNI, e
imprima las fechas de las obras de todos los espectadores cuyo DNI se encuentra entre
los dos DNIs recibidos.
7) Haga un módulo que reciba el nombre de una obra y que devuelva la cantidad de
espectadores (cero si nadie fue a verla).
8) Escriba un programa que invoque a los siete módulos implementados y compruebe el
correcto funcionamiento del mismo.}

program Adicional3;
uses SysUtils, GenericABB, GenericLinkedList;

const
	CANTIDAD_FILAS = 80;
	CANTIDAD_BUTACAS = 100;
	CANTIDAD_OBRAS = 20;

type 	
	EntradaVendida = record
		fecha: string;
		nombre_obra: string;
		fila, butaca: integer;
		dni_espectador: integer;
	end;
	ListaEntradasVendidas = specialize LinkedList<EntradaVendida>;
	
	 Asiento = record
	 	fila,butaca:integer;
		entradasv: ListaEntradasVendidas;
		end;
    matriz = array[1..80,1..100] of Asiento; 
  
  entrada= record
   fecha:string;
   fila,butaca:integer;
   dni_espectador:integer;
   end;
    Obra= record
    nombre_obra:string;
    entradas:ListaEntradasPorObra; 
    end;
  abbobras = specialize abb <obra>;
  ListaEntradasPorObra = specialize LinkedList <entrada>;
// Use esta función para obtener la lista de entradas vendidas
procedure ObtenerEntradasVendidas(var lista: ListaEntradasVendidas);
var i, nValores, dia: integer;
	sdia: string;
	enVen: EntradaVendida;
	obras: array [1..CANTIDAD_OBRAS] of string = ('Romeo y Julieta', 'Hamlet', 'Don Juan Tenorio', 'El fantasma de la opera', 'La Celestina',
	                                              'Casa de muñecas', 'Un tranvia llamado deseo', 'La gaviota', 'Bodas de sangre', 'Las troyanas',
	                                              'Guillermo Tell', 'Antigona', 'Los miserables', 'La divina comedia', 'La casa de Bernarda Alba',
	                                              'Fuente Ovejuna', 'Las aves', 'El burlador de Sevilla', 'Tres sombreros de copa', 'La venganza de Don Mendo');

begin
lista:= ListaEntradasVendidas.create();

nValores:= random(1000) + 200;

// Generamos N ventas de entradas y las almacenamos en la lista
for i:= 1 to nValores do
	begin
	dia:= random(30)+1;
	sdia:= IntToStr(dia);
	if dia < 10 then
		sdia:= '0' + sdia;
	enVen.fecha:= '2023-09-' + sdia;
		
	enVen.nombre_obra:= obras[random(CANTIDAD_OBRAS) + 1];
		
	enVen.fila:= random(CANTIDAD_FILAS) + 1;
	enVen.butaca:= random(CANTIDAD_BUTACAS) + 1;
	enVen.dni_espectador:= random(20000) + 300;

	lista.add(enVen);
	end;
end;
//------------INCISO 1--------------------------------------------
 procedure cargarmatriz(var m:matriz ; l:ListaEntradasVendidas);
 var
  i,j :integer;
  a:asiento;
  begin
  // Primero inicializamos toda la matriz con asientos vacíos
  for i:=1 to CANTIDAD_FILAS do
   for j:=1 to CANTIDAD_BUTACAS do
     begin
       a.fila:=i;
       a.butaca:=j;
       a.entradasv:=ListaEntradasVendidas.create();
       m[i,j]:=a;
     end;
  
  // Luego recorremos la lista de entradas y las agregamos a los asientos correspondientes
  l.reset();
  while not l.eol() do
    begin
      m[l.current().fila, l.current().butaca].entradasv.add(l.current());
      l.next();
    end;
  end;
  
 

//-----------INCISO 2---------------------------------------------
{Haga un módulo recursivo que reciba la estructura de datos retornada en el punto 1 y
devuelva la ubicación más vendida.}

function cantentradas(lb:ListaEntradasVendidas):integer;
var
acum:integer;
begin
  lb.reset();
  acum:=0;
  while not lb.eol() do 
  begin
    acum:= acum+1;
    lb.next();
  end;
  cantentradas:= acum;
end;

function calcularmax(m:matriz; i,j:integer; var filamax,butacamax:integer):integer;
var
  cantActual, maxResto: integer;
begin
  // Caso base: hemos procesado toda la matriz
  if (i > CANTIDAD_FILAS) then
  begin
    calcularmax := 0;  // "No hay más asientos, el máximo de una matriz vacía es 0"
    filamax := 0;      // Coordenadas inválidas
    butacamax := 0;
  end
  else if (j > CANTIDAD_BUTACAS) then
    // Fin de fila, continuar con la siguiente
    calcularmax := calcularmax(m, i+1, 1, filamax, butacamax)
  else
  begin
    // Procesar asiento actual
    cantActual := cantentradas(m[i,j].entradasv);
    
    // Obtener máximo del resto de la matriz
    maxResto := calcularmax(m, i, j+1, filamax, butacamax);  /// ACA es donde se pausan las llamadas recursivas y esperan que le pasen el maximo entre lo que queda
     
    // Comparar y retornar el mayor
    if cantActual > maxResto then
    begin
      filamax := i;
      butacamax := j;
      calcularmax := cantActual;
    end
    else
      calcularmax := maxResto;
  end;
end;
  

//--------------------------------------------------------
//-----------INCISO 3---------------------------------------------
{Haga un módulo que reciba la estructura de datos retornada en el punto 1 y devuelva
la cantidad de ubicaciones que no tienen entradas vendidas.}
 function asiento_sinventa(m:matriz,i,j:integer):integer;
 begin
   // Caso base: si llegamos al final de la matriz
   if (i > CANTIDAD_FILAS) then
     asiento_sinventa := 0
   else if (j > CANTIDAD_BUTACAS) then
     // Pasamos a la siguiente fila
     asiento_sinventa := asiento_sinventa(m, i+1, 1)
   else
   begin
     // Verificamos si el asiento actual tiene entradas vendidas
     m[i,j].entradasv.reset();
     if m[i,j].entradasv.eol() then
       // Asiento sin ventas - contamos 1 y continuamos
       asiento_sinventa := 1 + asiento_sinventa(m, i, j+1)
     else
       // Asiento con ventas - no contamos y continuamos
       asiento_sinventa := asiento_sinventa(m, i, j+1);
   end;
 end;

//--------------------------------------------------------
//-----------INCISO 4---------------------------------------------
{ Haga un módulo que procese la lista de ventas que se dispone, las almacene en una
estructura de datos y que la retorne. Dicha estructura debe permitir la búsqueda
eficiente por nombre de obra. Para cada obra se desea almacenar todas las entradas
vendidas (fecha, ubicación y DNI del comprador).}
  procedure agregarNodoAlArbolConDetalle(a:abbobras; dc:EntradaVendida );   // dc  es el registro entrante (el que viene de la lista) 
  var 
    n:obra;    //el registro del nodo
	  dd: entrada;  // el registro chiquitito
	begin
	if a.isEmpty() then    
		begin
	    n.entradas:= ListaEntradasPorObra.create();
	    dd.fecha:= dc.fecha;
      dd.fila:=dc.fila;
      dd.butaca:= dc.butaca;
      dd.dni_espectador:=dc.dni_espectador;
		n.entradas.add(dd);
		n.nombre_obra:= dc.nombre_obra;
		//n.datoPrincipal:= dc.dato; 

	    a.insertCurrent(n);
	    end
	else
	if a.current().nombre_obra = dc.nombre_obra then  
		begin
	    dd.fecha:= dc.fecha;
      dd.fila:=dc.fila;
      dd.butaca:= dc.butaca;
      dd.dni_espectador:=dc.dni_espectador;
		a.current().entradas.add(dd);
		end
	else
		if dc.nombre_obra < a.current().nombre_obra then
			agregarNodoAlArbolConDetalle(a.getLeftChild(), dc)
		else
			agregarNodoAlArbolConDetalle(a.getRightChild(), dc);
end;

procedure cargararbol(var a:abbobras,l:ListaEntradasVendidas);
 begin
  l.reset();
  while not l.eol()do begin
    agregarNodoAlArbolConDetalle(a,l.current());
    l.next();
  end;
 end;

//--------------------------------------------------------
//--------INCISO 5------------------------------------------------
{Haga un módulo que reciba la estructura de datos retornada en el punto 4 y un DNI y
que devuelva la cantidad de veces que asistió el espectador con dicho DNI. Nota: un
espectador pudo haber asistido más de una vez a la misma obra.}

function cantasistencias(a:abbobras,dni:integer):integer;
var
 contador:integer;
 e:entrada;
begin
   if a.isEmpty()then
    cantasistencias:=0;
   else  
    begin
    contador:=0; //entradas del nodo actual
    a.current().entradas.reset();
    while not a.current.entradas.eol() do
    begin
      e:= a.current().entradas.current();
      if e.dni_espectador = dni then 
        contador:= contador +1 ; 
      a.current().entradas.next();
    end;
  
    cantasistencias:= contador+ cantasistencias(a.getLeftChild,dni) + cantasistencias(a.getRightChild,dni);
   end;   
end;



//--------------------------------------------------------
//-----INCISO 6---------------------------------------------------
{Haga un módulo que reciba la estructura de datos retornada en el punto 4 y dos DNI, e
imprima las fechas de las obras de todos los espectadores cuyo DNI se encuentra entre
los dos DNIs recibidos}
//--------------------------------------------------------
//------INCISO 7--------------------------------------------------
{Haga un módulo que reciba el nombre de una obra y que devuelva la cantidad de
espectadores (cero si nadie fue a verla).}
//--------------------------------------------------------


var l: ListaEntradasVendidas; m:matriz;
 i,j,filamax,butacamax,maxentradas:integer;
 arbol:abbobras;
 dni:integer;
begin
randomize;

writeln('Obteniendo lista');
ObtenerEntradasVendidas(l);
//inciso 1
cargarmatriz(m,l);
//inciso 2
i:=1;j:=1;
maxentradas := calcularmax(m,i,j,filamax,butacamax);
writeln('La ubicacion mas vendida es fila ',filamax,' butaca ',butacamax,' con ',maxentradas,' entradas');
//inciso 3
writeln('Hay ',asiento_sinventa(m,i,j),' asientos sin entradas vendidas ');
//inciso4
arbol:= abbobras.create();
cargararbol(arbol,l);
//inciso5
writeln('INCISO 5: Ingresa un dni para buscarlo en el arbol y te digo la cantidad de asistencias de ese espectador');
readln(dni);
writeln('dni ',dni,',',cantasistencias(arbol,dni),' asistencias ');
end.
