-- creamos una base de datos
drop schema  biblioteca;

create schema biblioteca;  


-- usamos una base de datos especifica llamada biblioteca
use biblioteca;

-- creamos las tablas que contendra la base de datos

create table biblioteca.generos
(
idgenero int auto_increment primary key,
nombre varchar (255) not null
);

create table autores
(
idautor int auto_increment primary key,
nombre varchar (255),
apellido varchar (255),
nacionalidad varchar (255)
);
create table clientes
(
idcliente int auto_increment primary key,
nombre varchar (255),
apellido varchar (255),
nacionalidad varchar (255)
);

create table libros
(
idlibros int auto_increment primary key not null,
nombre varchar (255)not null,
cantidad int,
precio int not null,
idgenero int,
idautor int,
foreign key (idgenero) references generos(idgenero) ,
foreign key (idautor) references autores(idautor) 
);

-- EJEMPLO ON DELETE RESTRICT
-- EJEMPLO ON DELETE NO ACTION

 create table prestamos
 (
id int auto_increment primary key not null,
fecha_prestamo date not null,
fecha_devolucion date,
idlibros int ,
idcliente int ,
foreign key (idcliente)  references clientes(idcliente) ,
foreign key (idlibros) references libros(idlibros));
 
-- insertamos datos a todas las tablas PRIMERO DEBEMOS INSERTAR DATOS EN LAS TABLAS PRINCIPALES/FUERTES

insert into  generos (idgenero, nombre) values
(1, 'Economia'),
(2, 'Novela'),
(3, 'Policial'),
(4, 'Infantil'),
(5, 'Programacion');

insert into generos values (8);
select * from generos;



insert into autores (idautor, nombre, apellido, nacionalidad) values
(1, 'Robert', 'kiyosaki', 'estadounidense'),
(2, 'Andrea','Milano', 'argentina'),
(3, 'Arthur','Conan','britanico'),
(4,'Michael','Ende','aleman'),
(5,'Bill','Gates','estadounidense');

INSERT INTO biblioteca.clientes (idcliente, nombre, apellido, nacionalidad) VALUES
 ('1', 'Raquel', 'Lopez', 'argentina'),
 ('2', 'Esteban', 'Lo Presti', 'argentino'),
 ('3', 'Camila', 'Rodriguez', 'colombiana'),
 ('4', 'Rosa', 'Martinez', 'peruana'),
 ('5', 'Leonel', 'Dominguez', 'chileno');

insert into libros (idlibros,nombre,cantidad,precio,idgenero,idautor) values
(1,'El flujo del dinero',20,2000,1,1),
(2,'Hasta que te vuelva a ver',45,1500,2,2),
(3,'Estudio de escarlata',50,1800,3,3),
(4,'Historia interminable',28,2400,4,4),
(5,'Tecnologias de la informacion',3000,30,5,5);

insert into prestamos (id,fecha_prestamo, fecha_devolucion,idlibros,idcliente) values
(1,'2012/07/23','2012/08/23',3,1),
(2,'2013/06/2','2013/07/2',1,2),
(3,'2013/08/8','2013/09/8',5,4),
(4, '2013/06/2','2013/06/2',2,3),
(5, '2013/03/1','2013/06/2',4,5);




UPDATE libros set    
nombre='En busca de la verdad'
where idlibros='2';
 
UPDATE libros set
cantidad=40
where idlibros=4;
       
UPDATE generos set
nombre='Robotica'
where idgenero=5;

select * from autores;  
   
UPDATE autores set
apellido='Fernadez'
where idautor=2;
       
-- eliminamos registros especificos
delete from biblioteca.autores
 where idautor=1;

delete from biblioteca.autores
 where idautor=5;



 -- SUBCONSULTAS INSERT INTO:
select * from libros;
INSERT INTO libros (idlibros,nombre,cantidad,precio,idgenero,idautor)VALUES
(NULL,  'Las leyes del poder', '32',1500, (SELECT idgenero FROM generos
WHERE nombre='novela'),(SELECT idautor from autores where nombre= 'robert')
);

SELECT idgenero FROM generos
WHERE nombre='novela';
select * from autores;

INSERT INTO prestamos (id,fecha_prestamo,fecha_devolucion,idlibros,idcliente) VALUES
(NULL,'2022/02/02','2022/02/09',(select idlibros from libros where nombre='Las leyes del poder'),2);
select * from prestamos;

-- SUBCONSULTAS UPDATE:
select * from autores;
UPDATE autores
SET apellido ='Rodriguez'
WHERE idautor = (SELECT idautor FROM libros  WHERE idlibros=4);
select * from libros;

select * from generos;
UPDATE generos
SET nombre ='Entretenimiento'
WHERE idgenero = (SELECT idgenero FROM libros  WHERE idlibros=4);

update prestamos
set fecha_devolucion= '2022/04/02'
where idcliente= (select idcliente from clientes where nombre='leonel');
select * from libros;





-- SUBCONSULTA DELETE :
DELETE FROM libros
WHERE idlibros = (SELECT idlibros FROM prestamos WHERE idlibros=1);



-----------------------------------------------------------------------------------
#TRIGGERS


#Borramos la tabla si es que existe
DROP TABLE IF EXISTS auditoriaClientes;

# creamos la tabla de auditoria
CREATE TABLE auditoriaClientes
(
id_auditoria_clientes INT PRIMARY KEY AUTO_INCREMENT,
idcliente INT NOT NULL,
nombre varchar(255),
apellido varchar(255),
nacionalidad varchar(255),
usuario VARCHAR (255),
fecha_hora DATETIME,
tipo_mov varchar(255) 
);

#eliminamos el trigger si existe
DROP TRIGGER IF EXISTS auditoria_insercion_cliente;

#creamos un trigger
CREATE TRIGGER auditoria_insercion_cliente
AFTER INSERT ON clientes 
FOR EACH ROW
INSERT INTO auditoriaClientes VALUES 
(DEFAULT, new.idcliente, new.nombre, new.apellido, new.nacionalidad, USER(), NOW(),'se inserto un nuevo cliente');

#Insertamos en la tabla de clientes un nuevo registro
INSERT INTO biblioteca.clientes VALUES (DEFAULT, 'Manuel', 'Gonzales','argentino');

#consultamos la tabla auditoriaClientes
SELECT * FROM auditoriaClientes;

SELECT * FROM clientes;



#eliminamos el trigger si existe
DROP TRIGGER IF EXISTS auditoria_eliminacion_cliente;

#creamos un trigger
CREATE TRIGGER auditoria_eliminacion_cliente
BEFORE DELETE ON clientes 
FOR EACH ROW
INSERT INTO auditoriaClientes VALUES 
(DEFAULT, OLD.idcliente, OLD.nombre, OLD.apellido, OLD.nacionalidad, USER(), NOW(),'se elimina un cliente');

#Eliminamos en la tabla de clientes un registro
DELETE FROM clientes WHERE idcliente=6;

#consultamos la tabla auditoriaClientes
SELECT * FROM auditoriaClientes;
#consultamos la tabla clientes
SELECT * FROM clientes;


------------------------------------------------------




DROP TABLE IF EXISTS auditoriaLibros;

#creamos la tabla de auditoria
CREATE TABLE auditoriaLibros(
id_log INT PRIMARY KEY AUTO_INCREMENT,
id_libros INT NOT NULL,
VIEJOnombre varchar (255),
VIEJAcantidad int,
VIEJOprecio int,
idgenero int ,
idautor int ,
usuario VARCHAR (60),
fecha_hora DATETIME,
tipo_mov varchar (255),
nuevonombre varchar (255),
NuevaCantidad int,
NuevoPrecio int
);
DROP TRIGGER IF EXISTS  auditoria_mod_libro;
CREATE TRIGGER auditoria_mod_libro
AFTER UPDATE ON libros
FOR EACH ROW
INSERT INTO auditoriaLibros VALUES 
(DEFAULT,old.idlibros,old.nombre,old.cantidad,old.precio,old.idgenero,old.idautor,USER(), NOW(),'se modifica un libro',new.nombre,new.Cantidad,new.Precio);


#Modificamos  en la tabla de libros una cantidad
UPDATE libros SET nombre='cultura',cantidad=70,precio=3000 WHERE idlibros=2;

#consultamos la tabla auditoriaLibros
SELECT * FROM auditoriaLibros;
#consultamos la tabla libros
SELECT * FROM libros;



use biblioteca;


delimiter $$
create definer=`root`@`localhost`
FUNCTION f_NombreCompletoCliente (param_idcliente INT) 
RETURNS CHAR (50)
DETERMINISTIC
BEGIN
DECLARE var char(50);
SET var =(select concat(nombre,' ',apellido)  from clientes where idcliente = param_idcliente) ;
return var;

END$$

SELECT f_NombreCompletoCliente(2) AS NombreCompleto;


--  Cuenta los prestamos de cada cliente, ingresando el ID.
Delimiter &
create FUNCTION F_cant_prestamoslibros (param_idlibros int) 
returns int
deterministic
begin 

return (select count(*) FROM prestamos where idlibros = param_idlibros);

end&
Delimiter ;
select F_cant_prestamoslibros(4);



-------------------- sp ----------------------------------------------


DELIMITER $$
CREATE PROCEDURE `Ordenar libros por campo`(IN campo VARCHAR(255), IN tipo_ordenamiento ENUM('ASC','DESC'))
BEGIN 
IF campo <> '' THEN
SET @ordenar = CONCAT(' ORDER BY ', campo);
ELSE
SET @ordenar = '';
END IF;
IF tipo_ordenamiento <> '' THEN
SET @tipo = CONCAT(' ', tipo_ordenamiento);
else 
SET @tipo = '';
END IF;
SET @clausula = CONCAT('SELECT idlibros,nombre,cantidad, precio,idgenero,idautor FROM biblioteca.libros',@ordenar, @tipo);
PREPARE ejecutarSQL FROM @clausula;
EXECUTE ejecutarSQL;
deallocate prepare ejecutarSQL;
END;
$$

-- sp ordenar
DELIMITER //
CREATE PROCEDURE SP_Ordenar(IN Tabla VARCHAR(255), IN columna VARCHAR(255), IN orden VARCHAR(255))
BEGIN
SET @s = CONCAT('SELECT * FROM ',Tabla,' ORDER BY ', columna,' ',orden);
    PREPARE stmt1 FROM @s;
EXECUTE stmt1 ;
    DEALLOCATE PREPARE stmt1;
END //
DELIMITER ;

-- Para poder utilizar la tabla es necesario definir que tabla se quiere ordenar, la columna a partir de la cual ordenar y la forma (Ascendente o descendente).
--  Luego se realiza el llamado al Procedure.
SET @Tabla = 'autores';
SET @columna = 'nombre';
SET @orden = 'asc';

CALL SP_Ordenar(@Tabla, @columna, @orden);


