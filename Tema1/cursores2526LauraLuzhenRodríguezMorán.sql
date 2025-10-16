--Laura Luzhen Rodríguez Morán

CREATE DATABASE cursores2526LauraLuzhenRodriguezMoran
USE cursores2526LauraLuzhenRodriguezMoran
GO

CREATE TABLE CLIENTES (
 IdCliente VARCHAR(10) PRIMARY KEY,
 Nombre VARCHAR(30) NOT NULL,
 Ciudad VARCHAR(20),
 PuntosFidelidad INT DEFAULT 0
);
CREATE TABLE PRODUCTOS (
 CodProducto VARCHAR(10)PRIMARY KEY,
 Nombre VARCHAR(30) NOT NULL,
 Categoria VARCHAR(20),
 Precio DECIMAL(8,2),
 Stock INT
);
CREATE TABLE COMPRAS (
 IdCliente VARCHAR(10) ,
 CodProducto VARCHAR(10),
 FechaCompra DATE NOT NULL,
 Cantidad INT DEFAULT 1,
 primary key (idCliente, CodProducto, FechaCompra),
 FOREIGN KEY (IdCliente) REFERENCES CLIENTES(IdCliente),
 FOREIGN KEY (CodProducto) REFERENCES PRODUCTOS(CodProducto)
);

INSERT INTO CLIENTES VALUES
('C01', 'Laura Pérez', 'Madrid', 150),
('C02', 'Juan Gómez', 'Barcelona', 80),
('C03', 'Ana López', 'Sevilla', 120),
('C04', 'Pedro Ruiz', 'Valencia', 60),
('C05', 'Marta Díaz', 'Bilbao', 40);
INSERT INTO PRODUCTOS VALUES
('P01', 'Camiseta Roja', 'Ropa', 19.99, 50),
('P02', 'Pantalón Jeans', 'Ropa', 39.99, 30),
('P03', 'Zapatillas Running', 'Calzado', 59.99, 20),
('P04', 'Sudadera Negra', 'Ropa', 29.99, 25),
('P05', 'Mochila Deportiva', 'Accesorios', 24.99, 15);
INSERT INTO COMPRAS VALUES
('C01', 'P01', '2024-10-01', 2),
('C02', 'P01', '2024-10-02', 1),
('C03', 'P02', '2024-10-03', 1),
('C04', 'P02', '2024-10-04', 3),
('C05', 'P03', '2024-10-05', 1),
('C01', 'P03', '2024-10-06', 2),
('C02', 'P03', '2024-10-07', 1),
('C03', 'P04', '2024-10-08', 1),
('C01', 'P05', '2024-10-09', 1);


--EXAMEN
--Creamos el procedimiento 
CREATE OR ALTER PROCEDURE ListadoTresMasVendidos 
AS
BEGIN
	--Declaramos las variables que vamos a necesitar para el primer cursor
	DECLARE @nombreprod VARCHAR(30), @numventas INT, @categoria VARCHAR(20), @codprod VARCHAR(10)
	--Declaramos las variables que vamos a necesitar para el segundo cursor
	DECLARE @idclient VARCHAR(10), @nombreclient VARCHAR(30), @fecha DATE

	--Excepciones: si la tabla productos está vacía lo indicamos y salimos
	IF NOT EXISTS (SELECT * FROM PRODUCTOS)
	BEGIN
		PRINT 'ERROR: La tabla productos está vacía'
		RETURN
	END

	--Excepciones: si la tabla clientes está vacía lo indicamos y salimos
	IF NOT EXISTS (SELECT * FROM CLIENTES)
	BEGIN
		PRINT 'ERROR: La tabla clientes está vacía'
		RETURN
	END

	--Excepciones: si la cantidad de productos es menor a 3 lo indicamos y salimos
	IF 3 > (SELECT COUNT(*) FROM COMPRAS)
	BEGIN
		PRINT 'ERROR: Hay menos de tres compras realizadas'
		RETURN
	END

	--Declaramos el primer cursor donde vamos a recorrer los 3 productos más vendidos
	DECLARE cproductos CURSOR FOR
	SELECT TOP 3 P.Nombre, COUNT(*) AS NumeroVentas, P.Categoria, P.CodProducto FROM PRODUCTOS AS P 
	JOIN COMPRAS AS C ON P.CodProducto = C.CodProducto
	GROUP BY P.Nombre, P.CodProducto, P.Categoria
	ORDER BY NumeroVentas DESC

	--Abrimos el cursor
	OPEN cproductos
	--Leemos el primer registro
	FETCH cproductos INTO @nombreprod, @numventas, @categoria, @codprod

	--Creamos un bucle para leer todos los registros
	WHILE @@FETCH_STATUS = 0
	BEGIN
		--Imprimimos cada producto con su información
		PRINT @nombreprod + '		' + CAST(@numventas AS VARCHAR(10)) + '		' + @categoria

		--Declaramos el segundo cursor donde vamos a recorrer todos los clientes que han comprado el producto
		DECLARE cclientes CURSOR FOR
		SELECT C.IdCliente, C.Nombre, CO.FechaCompra FROM CLIENTES AS C
		JOIN COMPRAS AS CO ON C.IdCliente = CO.IdCliente
		WHERE CO.CodProducto = @codprod

		--Abrimos el cursor
		OPEN cclientes
		--Leemos el primer registro
		FETCH cclientes INTO @idclient, @nombreclient, @fecha

		--Creamos un bucle para leer todos los registros
		WHILE @@FETCH_STATUS = 0
		BEGIN
			--Imprimimos cada cliente con su información
			PRINT '		' + @idclient + '		' + @nombreclient + '		' + CAST(@fecha AS VARCHAR(50))

			--Leemos el siguiente registro
			FETCH cclientes INTO @idclient, @nombreclient, @fecha
		END

		--Cerramos el cursor
		CLOSE cclientes
		--Eliminamos de memoria
		DEALLOCATE cclientes
		PRINT '	'

		--Leemos el siguiente registro
		FETCH cproductos INTO @nombreprod, @numventas, @categoria, @codprod
	END

	--Cerramos el cursor
	CLOSE cproductos
	--Eliminamos de memoria
	DEALLOCATE cproductos
END
EXEC ListadoTresMasVendidos

select * from PRODUCTOS
select * from COMPRAS
select * from CLIENTES