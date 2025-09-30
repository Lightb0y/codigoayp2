{Ejercicio 2. Un mayorista almacena los registros anuales de las ventas de sus clientes, por
sucursal, y de cada una de sus 9 sucursales (cuyos códigos van de 101 a 109). De cada registro
anual se conoce: código de cliente, año, código de sucursal y monto total anual gastado.
1) Haga un módulo que procese la lista de registros anuales que se dispone y que cargue
en un árbol los registros ordenados por código de cliente.
2) Haga un módulo que reciba el árbol y que contabilice en una matriz el monto total
gastado por todos los clientes para cada sucursal (101..109) y para el período
2020..2024.
3) Haga un módulo recursivo que reciba la matriz y un código de sucursal y que devuelva
el año con mayor facturación, junto con el monto facturado.
4) Haga un módulo que reciba la matriz y retorne en un vector los años y monto
facturado con mayor facturación de cada una de las sucursales. Nota: este módulo
debe invocar el módulo implementado en el punto 3.
5) Haga un módulo que reciba el vector y lo imprima ordenado de menor a mayor por
monto facturado. Nota: preste atención qué pasa con los códigos de sucursal al
ordenar el vector.
6) Haga un módulo que reciba el árbol y un código de cliente y que devuelva la cantidad
de registros en los que aparece.
7) Haga un módulo que reciba el árbol y dos códigos de clientes e imprima toda la
información de los registros anuales para todos los clientes cuyo código de cliente se
encuentre entre los dos códigos recibidos.
8) Escriba un programa que invoque a los siete módulos implementados y compruebe el
correcto funcionamiento del mismo}
program Adicional2;
uses GenericABB, GenericLinkedList;

const
	CANTIDAD_SUCURSALES = 9;

type 	
	RegistroAnual = record
		codigo_sucursal: integer;
		anio: integer;
		codigo_cliente: integer;
		monto_total: real;
	end;
	ListaRegistrosAnuales = specialize LinkedList<RegistroAnual>;
	abbregistros= specialize abb <RegistroAnual>;
	matriz =array [101..109,2020..2024]of real;
	
	RegistroMax = record
		aniomaximo:integer;
		montomaximo:real;
	end;
	VectorMaximos = array[101..109] of RegistroMax;
// Use esta función para obtener la lista de registros anuales
procedure ObtenerRegistrosAnuales(var lista: ListaRegistrosAnuales);
var i, finalizados: integer;
	regan: RegistroAnual;
	anios: array [101..(CANTIDAD_SUCURSALES+100)] of integer;

begin
lista:= ListaRegistrosAnuales.create();

for i := 101 to CANTIDAD_SUCURSALES+100 do
	begin
	anios[i]:= 2000 + random(5);
	end;

// Generamos N registros anuales
finalizados:= 0;
while finalizados < CANTIDAD_SUCURSALES do
	begin
	regan.codigo_sucursal:= random(CANTIDAD_SUCURSALES) + 101;

	if anios[regan.codigo_sucursal] < 2025 then
		begin
		regan.anio:= anios[regan.codigo_sucursal];
		anios[regan.codigo_sucursal]:= anios[regan.codigo_sucursal] + 1;
		if anios[regan.codigo_sucursal] = 2025 then
			finalizados:= finalizados + 1;
		
		regan.codigo_cliente:= random(50) + 2500;
		regan.monto_total:= random(10000) + 1000;
				
		lista.add(regan);
		end;
	end;
end;
//--(inciso1)------------------------------------------------------
procedure AgregarRegistroAnual(a:abbregistros; r:registroAnual);
begin
	if a.isEmpty() then
		a.insertCurrent(r)
	else
	if r.codigo_cliente < a.current().codigo_cliente then
		AgregarRegistroAnual(a.getLeftChild(), r)
	else
		AgregarRegistroAnual(a.getRightChild(), r);
end;

procedure cargararbol(a:abbregistros; l:listaregistrosanuales);
begin
	l.reset();
	while not l.eol() do
	 begin
		agregarRegistroAnual(a,l.current());
		l.next();
	 end;
end;
//------(inciso2)-----------------------------------------------
procedure llenarMatrizR(a:abbregistros; var m:matriz);

begin
if not a.isEmpty() then
begin
 llenarMatrizR(a.getLeftChild(), m);
 m[a.current().codigo_sucursal,a.current().anio]:= (m[a.current().codigo_sucursal,a.current().anio])+(a.current().monto_total);
 llenarMatrizR(a.getRightChild(), m);
end;
end;
//-(inciso3)----------------------------------------------------
procedure hallaraniomax(m:matriz;var aniomax:integer;var montomax:real;i,j:integer);
begin                        
	if 	(j<=2024) then
	   if m[i,j]> montomax then
	      begin
			montomax:= m[i,j];
			aniomax:= j;
	      end;
	   hallaraniomax(m,aniomax,montomax,i,j+1);	
end;

//------(inciso 4-----------------------------------------------
procedure cargarvector(m:matriz; var v:vectormaximos);
var
 i,j ,aniomax:integer;
 montomax:real;
begin
  j:=2020;
      for i:=101 to 109 do begin
        aniomax:=0;
		montomax:=0;
		hallaraniomax(m,aniomax,montomax,i,j);
		v[i].aniomaximo := aniomax;
		v[i].montomaximo := montomax;
		end;
end;

//------(inciso 5)-----------------------------------------------
procedure ordenarVectorPorMonto(var v: VectorMaximos);
var
  i, j, min: integer;
  aux: RegistroMax;
begin
  for i := 101 to 108 do
  begin
    min := i;  // Asumimos que el elemento en posición i es el mínimo
    for j := i + 1 to 109 do
      if v[j].montomaximo < v[min].montomaximo then
        min := j;  // Encontramos un elemento menor
    
    // Si encontramos un elemento menor, lo intercambiamos
    if min <> i then
    begin
      aux := v[i];
      v[i] := v[min];
      v[min] := aux;
    end;
  end;
end;

procedure imprimirVectorOrdenado(v: VectorMaximos);
var
  i: integer;
begin
  writeln('Vector ordenado de menor a mayor por monto facturado:');
  writeln('Sucursal | Año | Monto');
  writeln('---------|-----|--------');
  for i := 101 to 109 do
    writeln('   ', i, '    | ', v[i].aniomaximo, ' | $', v[i].montomaximo:0:2);
end;

//-----inciso 6------------------------------------------------
	function cantocurrencias(a:abbregistros; bcodigocli:integer):integer;
	begin
		if a.isEmpty() then
			cantocurrencias := 0
		else
		begin
			cantocurrencias := 0;
			if bcodigocli <= a.current().codigo_cliente then
				cantocurrencias := cantocurrencias + cantocurrencias(a.getLeftChild(), bcodigocli);
			if bcodigocli = a.current().codigo_cliente then
				cantocurrencias := cantocurrencias + 1;
			if bcodigocli >= a.current().codigo_cliente then
				cantocurrencias := cantocurrencias + cantocurrencias(a.getRightChild(), bcodigocli);
		end;
	end;

//--------------Inciso 7-----------------------------
procedure imprimirRegistro(r:registroAnual);
	begin
	  writeln(r.codigo_sucursal);
	  writeln(r.anio);
	  writeln(r.codigo_cliente);
	  writeln(r.monto_total);
	end;
procedure imprimirAcotadoDeArbol(a: abbregistros; codigobot, codigotop: integer);
begin
if not a.isEmpty() then
	begin
	if (a.current().codigo_cliente >= codigobot) and (a.current().codigo_cliente <= codigotop) then
		begin
		imprimirAcotadoDeArbol(a.getLeftChild(), codigobot, codigotop);
		imprimirRegistro(a.current());
		imprimirAcotadoDeArbol(a.getRightChild(), codigobot, codigotop);
		end
	else
		if (a.current().codigo_cliente <= codigobot) then
			imprimirAcotadoDeArbol(a.getRightChild(), codigobot, codigotop)
		else
			imprimirAcotadoDeArbol(a.getLeftChild(), codigobot, codigotop);
	end;
end;
//----------------------------------------------------

var 
l: ListaRegistrosAnuales; arbol:abbregistros; m:matriz;
i,j:integer;
aniomax:integer;
montomax:real;
vmax:vectorMaximos;
bcodigocli:integer; 
codigobot,codigotop:integer;
begin
randomize;

writeln('Obteniendo lista');
ObtenerRegistrosAnuales(l);
//inciso1
arbol:= abbregistros.create();
cargararbol(arbol,l);
writeln('Arbol cargado');
//inciso2
//inicializo matriz
for i:=101 to 109 do
	for j:=2020 to 2024 do
		m[i,j]:= 0;
llenarMatrizR(arbol,m);
//inciso3
 aniomax:=0; montomax:=0;
 
 for i:=101 to 109 do begin
		j:=2020;
		hallaraniomax(m,aniomax,montomax,i,j);
		writeln('fila recorrida');
         end;
 writeln('El anio de mayor facturacion fue : ',aniomax,' , con una facturacion de: $',montomax);
//inciso 4 
//inicializo vector de maximos 
for i:=101 to 109 do
  begin
	vmax[i].aniomaximo:= 0;
	vmax[i].montomaximo:= 0; 
  end;
cargarvector(m,vmax);

//inciso 5
writeln('Ordenando vector por monto facturado...');
ordenarVectorPorMonto(vmax);
imprimirVectorOrdenado(vmax);
//inciso 6   debo recorrerr completo el arbol y acumular ocurrencias de bcodigocli
writeln('ingresa un codigo_cliente y te digo en la cantidad de registros que aparece');
readln(bcodigocli);
writeln('el codigo de cliente ingresado aparece ', cantocurrencias(arbol,bcodigocli), ' veces');
//inciso 7
 writeln('ingresa dos codigos y imprimo los registros de cada cliente entre esos dos codigos de clientes');
 readln(codigobot);
 readln(codigotop);
 writeln('/-/-/-/-/AHORA IMPRIMO ACOTADO-/-/-/-/-/-/-/-');
 imprimirAcotadoDeArbol(arbol,codigobot,codigotop);
end.
