CREATE TABLE clientes (
  id_cliente SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  telefono VARCHAR(15) NOT NULL,
  email VARCHAR(100) UNIQUE
);
CREATE TABLE menu (
  id_platillo SERIAL PRIMARY KEY,
  nom_plato VARCHAR(100) NOT NULL,
  precio NUMERIC(10,2) NOT NULL,
  descripcion TEXT
);
CREATE TABLE mesa (
  nmesa INTEGER PRIMARY KEY,
  disponibilidad VARCHAR(20) NOT NULL,
  lugares INTEGER NOT NULL
);
CREATE TABLE empleados (
  id_empleado SERIAL PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  correo VARCHAR(100) NOT NULL UNIQUE,
  puesto VARCHAR(50) NOT NULL
);
CREATE TABLE reservacion (
  id_reservacion SERIAL PRIMARY KEY,
  nmesa INTEGER NOT NULL REFERENCES mesa(nmesa),
  id_cliente INTEGER NOT NULL REFERENCES clientes(id_cliente),
  fecha TIMESTAMP NOT NULL
);
CREATE TABLE pedidos (
  id_pedido SERIAL PRIMARY KEY,
  id_cliente INTEGER NOT NULL REFERENCES clientes(id_cliente),
  id_empleado INTEGER NOT NULL REFERENCES empleados(id_empleado),
  nmesa INTEGER NOT NULL REFERENCES mesa(nmesa),
  fecha TIMESTAMP NOT NULL,
  estado VARCHAR(20) NOT NULL
);
CREATE TABLE detalle_pedidos (
  id_pedido INTEGER NOT NULL REFERENCES pedidos(id_pedido),
  id_platillo INTEGER NOT NULL REFERENCES menu(id_platillo),
  cantidad INTEGER NOT NULL,
  subtotal NUMERIC(10,2) NOT NULL,
  PRIMARY KEY (id_pedido, id_platillo)
);
CREATE TABLE pagos (
  folio SERIAL PRIMARY KEY,
  id_pedido INTEGER NOT NULL UNIQUE REFERENCES pedidos(id_pedido),
  monto NUMERIC(10,2) NOT NULL,
  fecha TIMESTAMP NOT NULL,
  fpago VARCHAR(30) NOT NULL,
  factura VARCHAR(50)
);