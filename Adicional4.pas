{Ejercicio 4. Una agencia de alquiler de autos a nivel nacional posee 10 sucursales. Cada
sucursal almacena la información de todos sus alquileres ordenada por marca y modelo. De
cada alquiler se conoce: código de sucursal, fecha de alquiler, patente, marca y modelo del
auto, cantidad de días del alquiler y precio por día. Cada sucursal puede tener distinto número
de alquileres.
1) Haga un módulo que procese la lista de alquileres que se dispone y que los almacene
agrupados por sucursal y ordenados por marca en una estructura de datos adecuada y
que la retorne.
2) Haga un módulo que reciba la estructura de datos devuelta por el módulo anterior y
retorne un resumen de alquileres para cada marca, registrando cantidad de alquileres y
precio total. Ordenada de manera descendente por cantidad de alquileres.
3) Haga un módulo que reciba la estructura de datos devuelta por el módulo
implementado en el punto 2 e imprima la marca con mayor cantidad de alquileres a
nivel nacional.
4) Haga un módulo que procese la lista de alquileres que se dispone, almacene en una
estructura de datos eficiente para la bú squeda de alquileres por patente y que la
retorne. Para cada patente se desea almacenar todos sus alquileres.
5) Haga un módulo que reciba la estructura de datos retornada en el punto 4, una
patente y una fecha y devuelva si ese auto se alquiló en la fecha recibida.
6) Haga un módulo que reciba la estructura de datos retornada en el punto 4 y una fecha
y devuelva la cantidad de alquileres que se realizaron en esa fecha.
7) Escriba un programa que invoque a los seis módulos implementados y compruebe el
correcto funcionamiento del mismo}
program Adicional4;
uses GenericABB, GenericLinkedList;

const
	CANTIDAD_PATENTES = 20;
	CANTIDAD_MARCAS = 10;

type
	Fecha = record
		dia, mes, anio: integer;
	end;
	Alquiler = record
		codigo_sucursal: integer;
		fecha_alquiler: Fecha;
		patente: string;
		marca: string;
		modelo: integer;
		dias_alquiler: integer;
		precio_por_dia: real;
	end;
	ListaAlquileres = specialize LinkedList<Alquiler>;
	vSucursales = array [1..10] of ListaAlquileres;
	MarcaResumen = record
		marca:string;
		cantidad_alquileres:integer;
		recaudacion:real;
	end;
	listaResumen= specialize LinkedList <MarcaResumen>;
	
	vehiculo = record
		patente:string;
		alquileres:ListaAlquileres;
	end;
	abbVehiculos = specialize abb <vehiculo>;

// Use esta función para obtener la lista de alquileres
procedure ObtenerAlquileres(var lista: ListaAlquileres);
var i, j, nValores: integer;
	alq: Alquiler;
	patentes: array [1..CANTIDAD_PATENTES] of string = ('A5', 'B8', 'C3', 'D1', 'E7', 'F9', 'G4', 'H6', 'I2', 'J8',
	                                              'K7', 'L2', 'M1', 'N8', 'O5', 'P0', 'Q3', 'R4', 'S1', 'T7');
	marcas_db: array [1..CANTIDAD_MARCAS] of string = ('Fiat', 'Audi', 'Ford', 'Renault', 'Volkswagen',
	                                              'Peugeot', 'Citroen', 'Nissan', 'Chevrolet', 'Toyota');
	modelos: array [1..CANTIDAD_PATENTES] of integer;
	marcas: array [1..CANTIDAD_PATENTES] of string;

begin
lista:= ListaAlquileres.create();

for i:= 1 to CANTIDAD_PATENTES do
	begin
	marcas[i]:= marcas_db[random(CANTIDAD_MARCAS) + 1];
	modelos[i]:= random(4) + 2020;
	end;
	
nValores:= random(1000) + 200;

// Generamos N alquileres y los almacenamos en la lista
for i:= 1 to nValores do
	begin
	alq.codigo_sucursal:= random(10) + 1;
	alq.fecha_alquiler.anio:= random(5) + 2020;
	alq.fecha_alquiler.mes:= random(12) + 1;
	alq.fecha_alquiler.dia:= random(28) + 1;
	j:= random(CANTIDAD_PATENTES) + 1;
	alq.patente:= patentes[j];
	alq.marca:= marcas[j];
	alq.modelo:= modelos[j];;
	alq.dias_alquiler:= random(15) + 4;
	alq.precio_por_dia:= random(15) + 70;
		
	lista.add(alq);
	end;
end;
//---------inciso1 -----------------------------------------------
procedure insertarOrdenado(var ls:ListaAlquileres, a:alquiler);
var
insertado:boolean;
begin
insertado:= false;
 ls.reset();
  if ls.eol() then
   ls.add(a);
   else
    begin
	  ls.reset();
	  while not ls.eol() and not insertado do begin
		if ls.current().marca > a.marca then
		 begin
		  ls.insertCurrent(a);
		  insertado:= true;
		 end
		else 
		  ls.next();
	  end;
	  if not insertado then // es importante porque si entra una marca nueva pero la lista no esta vacia entonces aca se agrega al final
	    ls.add(a);
	end;
end;
procedure almacenarenvector (l:ListaAlquileres,v:vSucursales);
var 
 a:alquiler;
begin
  l.reset();
  while not l.eol() do
  begin
	insertarOrdenado(v[l.current().codigo_sucursal] , l.current());
	l.next();
  end;
end;

//--------------------------------------------------------
//---------inciso 2-----------------------------------------------     //????? revisar
procedure insertarOrdenadoPorCantidad(var lr: listaResumen; mr: MarcaResumen);
var insertado: boolean;
begin
  insertado := false;
  if lr.isEmpty() then
    lr.add(mr)
  else
  begin
    lr.reset();
    while not lr.eol() and not insertado do
    begin
      if lr.current().cantidad_alquileres < mr.cantidad_alquileres then
      begin
        lr.insertCurrent(mr);
        insertado := true;
      end
      else
        lr.next();
    end;
    if not insertado then
      lr.add(mr);
  end;
end;

 procedure cargarListaResumen(v:vSucursales ; var lr:listaResumen);
 var
 i:integer;marcaactual:string;cant:integer; mr:MarcaResumen; recaudacion:real;
 begin
   lr.reset();
   for i:=1 to 10 do 
   begin
	v[i].reset();
	while not v[i].eol() do
	 begin
	    marcaactual:= v[i].current().marca;
		cant:=0;
		recaudacion:=0;
	    while marcaactual = v[i].current().marca do
		begin
		  cant:= cant + 1;
		  recaudacion:= recaudacion + (v[i].current().precio_por_dia * v[i].current().dias_alquiler);
		  v[i].next();
		end;
		mr.marca:= marcaactual;
		mr.cantidad_alquileres:=cant;
		mr.recaudacion:= recaudacion;
		insertarOrdenadoPorCantidad(lr, mr);
	 end;
   end;
 end;


//--------------------------------------------------------
//----------inciso 3----------------------------------------------
procedure imprimirMaxAlquileres(lr:listaResumen);
begin
  lr.reset();
  if not lr.eol();
   writeln(lr.current().marca,' es la marca con mayor cantidad de alquileres realizados.');
end;
//--------------------------------------------------------

//-------inciso 4-----------------------------------------


procedure agregarAlquilerPorPatente(a: abbVehiculos; alq: Alquiler);
var n: vehiculo;
begin
	if a.isEmpty() then
	begin
		n.patente := alq.patente;
		n.alquileres := ListaAlquileres.create();
		n.alquileres.add(alq);
		a.insertCurrent(n);
	end
	else
		if a.current().patente = alq.patente then
			begin
			a.current().alquileres.add(alq);
			end
		else
			if alq.patente < a.current().patente then
				agregarAlquilerPorPatente(a.getLeftChild(), alq)
			else
				agregarAlquilerPorPatente(a.getRightChild(), alq);
end;

procedure cargararbol(l: ListaAlquileres; var a: abbVehiculos);
begin
	l.reset();
	while not l.eol() do
	begin
		agregarAlquilerPorPatente(a, l.current());
		l.next();
	end;
end;
//--------------------------------------------------------
//--------INCISO 5------------------------------------------------
function encontrefecha(la:ListaAlquileres,bfecha:fecha):boolean;
var
falquileract:fecha;
begin
 encontrefecha:=false;
  la.reset();
  while not la.eol()do
   begin
    falquileract:=la.current().fecha_alquiler;
	if (falquileract.dia = bfecha.dia )and (falquileract.mes=bfecha.mes) and (falquileract.anio = bfecha.anio)then
	   encontrefecha:=true;
    la.next();
   end;
end;

function sealquilo(a:abbVehiculos;bpatente:string;bfecha:fecha):boolean;  //con este recorro eficientemente el arbol buscando la patente y llamo a encontrefecha cuando la encuentre
                                                                         //para recorrer la lista interna
begin   
 sealquilo:= false;                                                              
 if not a.isEmpty() then
    begin
	    if a.current().patente = bpatente then
			if encontrefecha(a.current().alquileres,bfecha)then
				sealquilo:=true;
	    else
		   if (bpatente < a.current().patente) then
		     sealquilo:= sealquilo(a.getLeftChild(), bpatente, bfecha)
		   else
		     sealquilo:= sealquilo(a.getRightChild(), bpatente, bfecha);
	end; 
end;                                                                     

//--------------------------------------------------------
//-----Inciso 6---------------------------------------------------
function encontrefechayacum(la:ListaAlquileres; bfecha:fecha ):integer;
var
falquileract:fecha; cant:integer;
begin
 cant:=0;
  la.reset();
  while not la.eol()do
   begin
    falquileract:=la.current().fecha_alquiler;
	if (falquileract.dia = bfecha.dia )and (falquileract.mes=bfecha.mes) and (falquileract.anio = bfecha.anio)then
	 begin
	   cant:= cant+ 1;
	  end;
    la.next();
   end;
   encontrefechayacum:= cant;
end;
function alquileresEnFecha(a:abbVehiculos,bfecha:fecha):integer;
begin
 if a.isEmpty() then
	alquileresEnFecha:=0
 else
	alquileresEnFecha:=
	  encontrefechayacum(a.current().alquileres, bfecha)
	  + alquileresEnFecha(a.getLeftChild(), bfecha)
	  + alquileresEnFecha(a.getRightChild(), bfecha);
end;
//--------------------------------------------------------

var 
l: ListaAlquileres; v:vSucursales; i:integer;
lr:ListaAlquileres;arbol:abbVehiculos;
bpatente:string; bfecha:fecha;

begin
randomize;

writeln('Obteniendo lista');
ObtenerAlquileres(l);

l.reset();
while not l.eol do
  begin
  if l.current.patente = 'S1' then begin
  writeln(l.current.codigo_sucursal);
	writeln(l.current.fecha_alquiler.anio);
	writeln(l.current.fecha_alquiler.mes);
	writeln(l.current.fecha_alquiler.dia);
	writeln(l.current.patente);
	writeln(l.current.marca);
	writeln(l.current.modelo);
	writeln(l.current.dias_alquiler);
	writeln(l.current.precio_por_dia);
	
  writeln('-----------------');end;
  l.next;
  end;
  //inciso 1
for i:=1 to 10 do
 begin
   v[i]:=ListaAlquileres.create();
   
 end;
 
 almacenarenvector(l,v);
 //inciso2
  lr:= listaResumen.create();
  cargarListaResumen(v,lr);
  //inciso 3
  imprimirMaxAlquileres(lr);
  //inciso 4
  cargararbol(l,arbol)
  //inciso 5
  writeln('Ingresa una patente');
  readln(bpatente);
  writeln('ingresa una fecha (Dia , mes , anio)');
  read(bfecha.dia);
  read(bfecha.mes);
  read(bfecha.anio);
  if sealquilo(arbol,bfecha,bpatente) then
  writeln('Esa patente fue efectivamente ALQUILADA en esa fecha');
  else
  writeln('La patente no fue alquilada en esa fecha');
  //inciso 6
  writeln('Pero en esa fecha se alquilaron  ',alquileresEnFecha(arbol,bfecha),' autos');

end.
