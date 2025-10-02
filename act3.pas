program Verduleria2;

uses
  URandomGenerator, UDateTime, UBalanza, GenericLinkedList;

type
  TProducto = record
    nombre : string;
    pesoKg : real;
  end;

  TListaProductos = specialize LinkedList<TProducto>;

  TTicket = record
    fecha   : Date;
    hora    : Time;
    cliente : string;
    total   : real;
    productos : TListaProductos; // referencia al carrito generado
  end;

procedure PrecargarProductos(rg: RandomGenerator);
begin
  rg.addLabel('manzana');
  rg.addLabel('banana');
  rg.addLabel('naranja');
  rg.addLabel('pera');
  rg.addLabel('tomate');
  rg.addLabel('papas');
  rg.addLabel('cebolla');
  rg.addLabel('zanahoria');
  rg.addLabel('lechuga');
  rg.addLabel('morron');
end;

// ACTIVIDAD 2 (reusada)
procedure CargarCarrito(carrito: TListaProductos; rg: RandomGenerator);
var
  i, cant : integer;
  p       : TProducto;
begin
  cant := rg.getInteger(3, 10);        // cantidad de ítems al azar
  for i := 1 to cant do
  begin
    p.nombre := rg.getLabel();         // producto al azar
    p.pesoKg := rg.getReal(0.20, 3.50);// peso en kg al azar
    carrito.addLast(p);
  end;
end;

// ACTIVIDAD 3: pesar todo y generar ticket
function GenerarTicket(carrito: TListaProductos; rg: RandomGenerator): TTicket;
var
  b       : Balanza;
  p       : TProducto;
  precioK : real;
  dMin,dMax: Date;
  tMin,tMax: Time;
  tk      : TTicket;
begin
  // 1) Total a pagar con Balanza
  b := Balanza.create();
  b.limpiar();

  carrito.reset;
  while not carrito.eol do
  begin
    p := carrito.current;

    // precio por kilo al azar (ajustá rangos a gusto)
    precioK := rg.getReal(500.0, 2500.0);  // $/kg entre 500 y 2500
    b.setPrecioPorKilo(precioK);
    b.pesar(p.pesoKg);  // suma precioK * peso al total interno de la balanza

    carrito.next;
  end;

  // 2) Fecha y hora aleatoria en septiembre 2024
  dMin := Date.create(1, 9, 2024);
  dMax := Date.create(30, 9, 2024);
  tMin := Time.create(0, 0, 0);
  tMax := Time.create(23, 59, 59);

  // 3) Armar ticket
  tk.fecha   := rg.getDate(dMin, dMax);
  tk.hora    := rg.getTime(tMin, tMax);
  tk.cliente := rg.getString(8);        // nombre ficticio simple
  tk.total   := b.getTotalAPagar();
  tk.productos := carrito;

  GenerarTicket := tk;
end;

procedure ImprimirTicket(const tk: TTicket);
var
  p : TProducto;
begin
  writeln('================= TICKET =================');
  writeln('Fecha: ', tk.fecha.toString(), '  Hora: ', tk.hora.toString());
  writeln('Cliente: ', tk.cliente);
  writeln('------------------------------------------');
  writeln('Detalle de productos:');
  tk.productos.reset;
  while not tk.productos.eol do
  begin
    p := tk.productos.current;
    writeln(' - ', p.nombre, '  ', p.pesoKg:0:2, ' kg');
    tk.productos.next;
  end;
  writeln('------------------------------------------');
  writeln('TOTAL A PAGAR: $', tk.total:0:2);
  writeln('==========================================');
end;

var
  rg      : RandomGenerator;
  carrito : TListaProductos;
  ticket  : TTicket;

begin
  rg := RandomGenerator.create();
  PrecargarProductos(rg);

  carrito := TListaProductos.create();
  CargarCarrito(carrito, rg);

  ticket := GenerarTicket(carrito, rg);
  ImprimirTicket(ticket);
end.