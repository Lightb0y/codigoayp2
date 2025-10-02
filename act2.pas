program PRandomGenerator;
uses UDateTime, URandomGenerator;

var 
  rg: RandomGenerator;  
  i: integer; 
  r: real; 
  s: string; 
  b: boolean;
  d1, d2, d: Date; 
  t1, t2, t: Time;

begin
  rg := RandomGenerator.create();   // ← ACÁ lo instanciamos

  i := rg.getInteger(200, 500);     // número entero al azar entre 200 y 500
  r := rg.getReal(1.2, 2.0);        // número real al azar
  b := rg.getBoolean();             // true o false al azar

  s := rg.getString(5);             // string de 5 letras al azar

  // Ejemplo con fechas
  d1 := Date.create(22, 9, 2021);   
  d2 := Date.create(4, 7, 2024);
  d := rg.getDate(d1, d2);          // fecha al azar entre d1 y d2

  // Ejemplo con horas
  t1 := Time.create(7, 0, 0);
  t2 := Time.create(21, 0, 0);
  t := rg.getTime(t1, t2);          // hora al azar entre t1 y t2

  // Ejemplo con etiquetas (strings precargados)
  rg.addLabel('rojo');
  rg.addLabel('azul');
  rg.addLabel('verde');

  s := rg.getLabel();               // devuelve una etiqueta al azar
  writeln(s);

  rg.clearLabels();                 // borra todas las etiquetas
end.
👉 Entonces:

Sí, el RandomGenerator también se instancia.

La diferencia con Date y Time es que RandomGenerator no almacena datos fijos, sino que su comportamiento es generar valores aleatorios cada vez que llamás a sus métodos.

¿Querés que te arme un ejemplo donde usemos los tres juntos (RandomGenerator para generar una fecha y hora al azar, y luego imprimirlas con toString())?





You said:
ACTIVIDAD 2: Crear el archivo Verdulería1.pas.
● Implemente un módulo CargarCarrito que simule la carga del carrito en
una verdulería. Use el objeto RandomGenerator para elegir al azar la
cantidad de productos a comprar, los productos a comprar y el peso de
cada producto. NOTA: cargue previamente el objeto
RandomGenerator con 10 productos típicos de una verdulería, usando
el método addLabel.
● Implemente un módulo que reciba la información generada en
CargarCarrito y la imprima por consola.
● Escriba un programa que invoque los métodos implementados y
pruebe el correcto funcionamiento del mismo.


ChatGPT said:

Thought for 16s
¡De una! Te dejo un Verdulería1.pas completo y simple usando POO + tu GenericLinkedList.
Genera un carrito al azar con RandomGenerator (cantidad de ítems, nombre del producto y peso) y luego lo imprime.

pascal
Copy code
program Verduleria1;

uses
  URandomGenerator, GenericLinkedList;

type
  TProducto = record
    nombre : string;
    pesoKg : real;
  end;

  // lista genérica de productos
  TListaProductos = specialize LinkedList<TProducto>;

procedure PrecargarProductos(rg: RandomGenerator);
begin
  // 10 productos típicos
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

// Crea N ítems (al azar) y los agrega a la lista.
// Para cada ítem: nombre al azar (entre las labels) y peso al azar.
procedure CargarCarrito(carrito: TListaProductos; rg: RandomGenerator);
var
  i, cant : integer;
  p       : TProducto;
begin
  // cantidad de productos a comprar (por ejemplo, entre 3 y 10)
  cant := rg.getInteger(3, 10);

  for i := 1 to cant do
  begin
    p.nombre := rg.getLabel();        // producto al azar (entre las 10 labels)
    p.pesoKg := rg.getReal(0.20, 3.50); // peso al azar en kg
    carrito.addLast(p);
  end;
end;

procedure ImprimirCarrito(carrito: TListaProductos);
var
  p : TProducto;
begin
  writeln('--- Carrito ---');
  carrito.reset;
  while not carrito.eol do
  begin
    p := carrito.current;
    writeln(p.nombre, ' - ', p.pesoKg:0:2, ' kg');
    carrito.next;
  end;
end;

var
  rg      : RandomGenerator;
  carrito : TListaProductos;

begin
  rg := RandomGenerator.create();
  PrecargarProductos(rg);

  carrito := TListaProductos.create();
  CargarCarrito(carrito, rg);
  ImprimirCarrito(carrito);
end.