program CodigoDisponibleParaElExamen;
uses GenericABB, GenericLinkedList;

const
  Filas = 12;
  Columnas = 10;
  CantListas = 5;
  DimensionFisica = 100;
  
type
  Matriz = array[1..Filas, 1..Columnas] of real;
  
  Lista = specialize LinkedList<integer>;
  VectorListas = array [1..CantListas] of Lista;
  
  Resumen = record
			identificador: integer; 
			cantidad: integer;
			end;
  ListaResumen = specialize LinkedList<Resumen>;
  
  VectorNumeros = array[1..DimensionFisica] of integer;
  
  ABBInteger = specialize ABB<integer>;
  
  NodoContador = record
				ocurrencias: integer;
				clave: integer;
				end;
  ABBContador = specialize ABB<NodoContador>;
  
  DatoDetalle = record
				detalle: real;
				end;
  ListaDeDatosDetalles = specialize LinkedList<DatoDetalle>;
  NodoConDetalles = record
					clave: integer;
					datoPrincipal: string;
					datos: ListaDeDatosDetalles;
					end;
  ABBDetalle = specialize ABB<NodoConDetalles>;
  DatosCompletos = record
					identificador: integer;
					dato: string;
					detalle: real;
					end;

procedure llenarMatriz(var m: Matriz);
var i, j: integer;
begin
for i:= 1 to filas do
  for j:= 1 to columnas do
     read(m[i,j]);
end;

procedure imprimirMatriz(m: Matriz);
var i, j: integer;
begin
for i:= 1 to filas do 
  begin
  for j:= 1 to columnas do
     write(m[j,i]:10:2);
  writeln;
  end;
end;

procedure buscaMinimo (var estantes: VectorListas; var min: integer);
var i, posmin: integer;
Begin
  min:= 9999;

  for i:= 1 to CantListas do
     if not(estantes[i].eol()) then
        if estantes[i].current() <= min then
         begin        
            min:= estantes[i].current();
            posmin:=i
         end;

  if min <> 9999 then
     estantes[posmin].next();
end;

procedure merge (estantes: VectorListas; var eNuevo: Lista);
var min: integer;
    i: integer;
Begin
  eNuevo:= Lista.create();
  for i:= 1 to CantListas do
    estantes[i].reset();
    
  buscaMinimo (estantes, min);
  while (min <> 9999) do
    begin
    eNuevo.add(min);
    buscaMinimo(estantes, min);
    end;
end; 

procedure mergeAcumulador (v: VectorListas; var listaUnica: ListaResumen);
var actual: Resumen; min: integer;
    i:integer;
begin
 listaUnica:= ListaResumen.create();
 for i:= 1 to CantListas do
    v[i].reset();
    
 buscaMinimo (v, min);
 while (min <> 9999) do
    begin
     actual.identificador:= min; 
     actual.cantidad:= 0;
     while (min = actual.identificador) do 
     begin
        actual.cantidad:= actual.cantidad + 1;
        buscaMinimo(v, min);
     end;
     listaUnica.add(actual);
    end;
end; 

function sumaTotal_recursiva_Vector(v: VectorNumeros; i: integer): real;
begin
if i > 1 then
	sumaTotal_recursiva_Vector:= sumaTotal_recursiva_Vector(v, i-1) + v[i]
else
  	sumaTotal_recursiva_Vector:= v[i];
end;


function sumaTotal_recursiva_lista(l: Lista): integer;
var res: integer;
begin 
if not l.eol() then  begin
  res:= l.current();
  sumaTotal_recursiva_lista:= res + sumaTotal_recursiva_lista(l.getSubList());
  end
else
  sumaTotal_recursiva_lista:= 0;
end;

function busquedaDicotomica(v: VectorNumeros; buscar, min, max: integer): integer;
var medio: integer;
begin
if min > max then
	busquedaDicotomica:= -1
else
  begin
  medio:= (max + min) div 2;
  if v[medio] = buscar then
    busquedaDicotomica:= medio
  else
    if v[medio] > buscar then
      busquedaDicotomica:= busquedaDicotomica(v, buscar, min, medio - 1)
    else
  	  busquedaDicotomica:= busquedaDicotomica(v, buscar, medio + 1, max);
  end;
end;

procedure agregarNodoEnArbol(a: ABBInteger; i: integer);
	begin
	if a.isEmpty() then
		a.insertCurrent(i)
	else
	if i < a.current() then
		agregarNodoEnArbol(a.getLeftChild(), i)
	else
		agregarNodoEnArbol(a.getRightChild(), i);
	end;

function buscarUnElementoEnArbol(a: ABBInteger; i: integer): boolean;
	begin
	if a.isEmpty() then
		buscarUnElementoEnArbol:= false
	else
	if a.current() = i then
		buscarUnElementoEnArbol:= true
	else
	if i < a.current() then
	   buscarUnElementoEnArbol:= buscarUnElementoEnArbol(a.getLeftChild(), i)
	else
	   buscarUnElementoEnArbol:= buscarUnElementoEnArbol(a.getRightChild(), i);
	end;

function contarElementosDeArbol(a: ABBInteger): integer;
	begin
	if a.isEmpty() then
		contarElementosDeArbol:= 0
	else
	    begin
		contarElementosDeArbol:= contarElementosDeArbol(a.getLeftChild()) + contarElementosDeArbol(a.getRightChild()) + 1;
	    end
	end;

procedure imprimirInOrden(a: ABBInteger);
begin
if not a.isEmpty() then
	begin
	imprimirInOrden(a.getLeftChild());
	writeln(a.current());
	imprimirInOrden(a.getRightChild());
	end;
end;

function minimoDeArbol(a: ABBInteger): integer;
begin
if a.hasLeftChild() then
	minimoDeArbol:= minimoDeArbol(a.getLeftChild())
else
	minimoDeArbol:= a.current();
end;

procedure imprimirMenoresEnArbol(a: ABBInteger; valor: integer);
begin
if not a.isEmpty() then
	begin
	if (a.current() <= valor) then
		begin
		imprimirMenoresEnArbol(a.getLeftChild(), valor);
		writeln(a.current);
		imprimirMenoresEnArbol(a.getRightChild(), valor);
		end
	else
		imprimirMenoresEnArbol(a.getLeftChild(), valor);
	end;
end;

procedure imprimirAcotadoDeArbol(a: ABBInteger; valorMin, valorMax: integer);
begin
if not a.isEmpty() then
	begin
	if (a.current() >= valorMin) and (a.current() <= valorMax) then
		begin
		imprimirAcotadoDeArbol(a.getLeftChild(), valorMin, valorMax);
		writeln(a.current);
		imprimirAcotadoDeArbol(a.getRightChild(), valorMin, valorMax);
		end
	else
		if (a.current() <= valorMin) then
			imprimirAcotadoDeArbol(a.getRightChild(), valorMin, valorMax)
		else
			imprimirAcotadoDeArbol(a.getLeftChild(), valorMin, valorMax);
	end;
end;

procedure agregarNodoAlArbolContando(a: ABBContador; num: integer);
  var n: NodoContador;
	begin
	if a.isEmpty() then    
		begin
		n.ocurrencias:= 1;    
		n.clave:= num;
		a.insertCurrent(n);
		end
	else
		if a.current().clave = num then  begin
			n:= a.current();
			n.ocurrencias:= n.ocurrencias + 1;
			a.setCurrent(n);
			end
		else
			if num < a.current().clave then
				agregarNodoAlArbolContando(a.getLeftChild(), num)
			else
				agregarNodoAlArbolContando(a.getRightChild(), num);
	end;

  procedure agregarNodoAlArbolConDetalle(a: ABBDetalle; dc: DatosCompletos);
  var n: NodoConDetalles;    
	  dd: DatoDetalle;
	begin
	if a.isEmpty() then    
		begin
	    n.datos:= ListaDeDatosDetalles.create();
	    dd.detalle:= dc.detalle;
		n.datos.add(dd);
		n.clave:= dc.identificador;
		n.datoPrincipal:= dc.dato; 

	    a.insertCurrent(n);
	    end
	else
	if a.current().clave = dc.identificador then  
		begin
		dd.detalle:= dc.detalle;
		a.current().datos.add(dd);
		end
	else
		if dc.identificador < a.current().clave then
			agregarNodoAlArbolConDetalle(a.getLeftChild(), dc)
		else
			agregarNodoAlArbolConDetalle(a.getRightChild(), dc);
end;


begin
end.
