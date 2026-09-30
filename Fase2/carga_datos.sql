-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.clientes (
  id_cliente integer NOT NULL DEFAULT nextval('clientes_id_cliente_seq'::regclass),
  nombre character varying NOT NULL,
  telefono character varying NOT NULL,
  email character varying UNIQUE,
  CONSTRAINT clientes_pkey PRIMARY KEY (id_cliente)
);
CREATE TABLE public.menu (
  id_platillo integer NOT NULL DEFAULT nextval('menu_id_platillo_seq'::regclass),
  nom_plato character varying NOT NULL,
  precio numeric NOT NULL CHECK (precio > 0::numeric),
  descripcion text,
  CONSTRAINT menu_pkey PRIMARY KEY (id_platillo)
);
CREATE TABLE public.mesa (
  nmesa integer NOT NULL,
  disponibilidad character varying NOT NULL,
  lugares integer NOT NULL,
  CONSTRAINT mesa_pkey PRIMARY KEY (nmesa)
);
CREATE TABLE public.empleados (
  id_empleado integer NOT NULL DEFAULT nextval('empleados_id_empleado_seq'::regclass),
  nombre character varying NOT NULL,
  correo character varying NOT NULL UNIQUE,
  puesto character varying NOT NULL,
  CONSTRAINT empleados_pkey PRIMARY KEY (id_empleado)
);
CREATE TABLE public.reservacion (
  id_reservacion integer NOT NULL DEFAULT nextval('reservacion_id_reservacion_seq'::regclass),
  nmesa integer NOT NULL,
  id_cliente integer NOT NULL,
  fecha timestamp without time zone NOT NULL,
  CONSTRAINT reservacion_pkey PRIMARY KEY (id_reservacion),
  CONSTRAINT reservacion_nmesa_fkey FOREIGN KEY (nmesa) REFERENCES public.mesa(nmesa),
  CONSTRAINT reservacion_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.clientes(id_cliente)
);
CREATE TABLE public.pedidos (
  id_pedido integer NOT NULL DEFAULT nextval('pedidos_id_pedido_seq'::regclass),
  id_cliente integer NOT NULL,
  id_empleado integer NOT NULL,
  nmesa integer NOT NULL,
  fecha timestamp without time zone NOT NULL,
  estado character varying NOT NULL,
  CONSTRAINT pedidos_pkey PRIMARY KEY (id_pedido),
  CONSTRAINT pedidos_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.clientes(id_cliente),
  CONSTRAINT pedidos_id_empleado_fkey FOREIGN KEY (id_empleado) REFERENCES public.empleados(id_empleado),
  CONSTRAINT pedidos_nmesa_fkey FOREIGN KEY (nmesa) REFERENCES public.mesa(nmesa)
);
CREATE TABLE public.detalle_pedidos (
  id_pedido integer NOT NULL,
  id_platillo integer NOT NULL,
  cantidad integer NOT NULL,
  subtotal numeric NOT NULL,
  CONSTRAINT detalle_pedidos_pkey PRIMARY KEY (id_pedido, id_platillo),
  CONSTRAINT detalle_pedidos_id_pedido_fkey FOREIGN KEY (id_pedido) REFERENCES public.pedidos(id_pedido),
  CONSTRAINT detalle_pedidos_id_platillo_fkey FOREIGN KEY (id_platillo) REFERENCES public.menu(id_platillo)
);
CREATE TABLE public.pagos (
  folio integer NOT NULL DEFAULT nextval('pagos_folio_seq'::regclass),
  id_pedido integer NOT NULL UNIQUE,
  monto numeric NOT NULL,
  fecha timestamp without time zone NOT NULL,
  fpago character varying NOT NULL,
  factura character varying,
  CONSTRAINT pagos_pkey PRIMARY KEY (folio),
  CONSTRAINT pagos_id_pedido_fkey FOREIGN KEY (id_pedido) REFERENCES public.pedidos(id_pedido)
);