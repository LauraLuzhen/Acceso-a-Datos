-- Laura Luzhen Rodríguez Morán

CREATE DATABASE Juvenil
USE Juvenil

-- Tabla SOCIOS
CREATE TABLE SOCIOS (
    DNI VARCHAR(10) NOT NULL PRIMARY KEY,
    Nombre VARCHAR(20) NOT NULL,
    Direccion VARCHAR(20),
    Penalizaciones TINYINT DEFAULT 0  
);

-- Tabla LIBROS
CREATE TABLE LIBROS (
    RefLibro VARCHAR(10) NOT NULL PRIMARY KEY,
    Nombre VARCHAR(30) NOT NULL,
    Autor VARCHAR(20) NOT NULL,
    Genero VARCHAR(10),
    AñoPublicacion INT,      
    Editorial VARCHAR(10)
);

-- Tabla PRESTAMOS
CREATE TABLE PRESTAMOS (
    DNI VARCHAR(10) NOT NULL,
    RefLibro VARCHAR(10) NOT NULL,
    FechaPrestamo DATE NOT NULL,
    Duracion TINYINT DEFAULT 24, 
    CONSTRAINT PK_PRESTAMOS PRIMARY KEY (DNI, RefLibro, FechaPrestamo),
    CONSTRAINT FK_PRESTAMOS_SOCIOS FOREIGN KEY (DNI) REFERENCES SOCIOS(DNI),
    CONSTRAINT FK_PRESTAMOS_LIBROS FOREIGN KEY (RefLibro) REFERENCES LIBROS(RefLibro)
);

INSERT INTO socios VALUES ('111-A', 'David',   'Sevilla Este', 2);
INSERT INTO socios VALUES ('222-B', 'Mariano', 'Los Remedios', 3);

INSERT INTO socios (DNI, Nombre, Direccion)
VALUES ('333-C', 'Raul',    'Triana'      );

INSERT INTO socios (DNI, Nombre, Direccion)
VALUES ('444-D', 'Rocio',   'La Oliva'    );

INSERT INTO socios VALUES ('555-E', 'Marilo',  'Triana',       2);
INSERT INTO socios VALUES ('666-F', 'Benjamin','Montequinto',  5);

INSERT INTO socios (DNI, Nombre, Direccion)
VALUES ('777-G', 'Carlos',  'Los Remedios');

INSERT INTO socios VALUES ('888-H', 'Manolo',  'Montequinto',  2);


INSERT INTO libros
VALUES('E-1', 'El valor de educar', 'Savater',    'Ensayo', 1994, 'Alfaguara');
INSERT INTO libros
VALUES('N-1', 'El Quijote',         'Cervantes',  'Novela', 1602, 'Anagrama');
INSERT INTO libros
VALUES('E-2', 'La Republica',       'Plat�n',     'Ensayo', -230, 'Anagrama');
INSERT INTO libros
VALUES('N-2', 'Tombuctu',           'Auster',     'Novela', 1998, 'Planeta');
INSERT INTO libros
VALUES('N-3', 'Todos los nombres',  'Saramago',   'Novela', 1995, 'Planeta');
INSERT INTO libros
VALUES('E-3', 'Etica para Amador',  'Savater',    'Ensayo', 1991, 'Alfaguara');
INSERT INTO libros
VALUES('P-1', 'Rimas y Leyendas',   'Becquer',    'Poesia', 1837, 'Anagrama');
INSERT INTO libros
VALUES('P-2', 'Las flores del mal', 'Baudelaire', 'Poesia', 1853, 'Anagrama');
INSERT INTO libros
VALUES('P-3', 'El fulgor',          'Valente',    'Poesia', 1998, 'Alfaguara');
INSERT INTO libros
VALUES('N-4', 'Lolita',             'Nabokov',    'Novela', 1965, 'Planeta');
INSERT INTO libros
VALUES('C-1', 'En salvaje compa�ia','Rivas',      'Cuento', 2001, 'Alfaguara');


INSERT INTO prestamos VALUES('111-A','E-1', '17/12/00',24);
INSERT INTO prestamos VALUES('333-C','C-1', '15/12/01',48);
INSERT INTO prestamos VALUES('111-A','N-1', '17/12/01',24);
INSERT INTO prestamos VALUES('444-D','E-1', '17/12/01',48);
--INSERT INTO prestamos VALUES('111-A','C-2', '17/12/01',72);

INSERT INTO prestamos (DNI, RefLibro, FechaPrestamo) 
VALUES('777-G','N-1', '07/12/01');

INSERT INTO prestamos VALUES('111-A','N-1', '16/12/01',48);





-- EJERCICIOS BASE DE DATOS JUVENIL
-- EJERCICIO 1
CREATE OR ALTER PROCEDURE listadocuatromasprestados
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM LIBROS)
    BEGIN
        PRINT('No existe la tabla libros')
		RETURN
    END

    IF NOT EXISTS (SELECT * FROM SOCIOS)
    BEGIN
		PRINT('No existe la tabla socios')
		RETURN
    END

	IF (SELECT COUNT(DISTINCT RefLibro) FROM PRESTAMOS) < 4
    BEGIN
		PRINT('Hay menos de 4 libros prestados')
		RETURN
    END

	DECLARE @nombreLibro VARCHAR(10), @cantPrestados int, @generoLibro VARCHAR(10), @refLibro VARCHAR(10)

	DECLARE cuatromasprestados CURSOR FOR
	SELECT TOP 4 L.Nombre, COUNT(P.RefLibro) AS NumPrestamo, L.Genero, L.RefLibro
	FROM PRESTAMOS AS P
	JOIN LIBROS AS L ON P.RefLibro = L.RefLibro
	JOIN SOCIOS AS S ON P.DNI = S.DNI
	GROUP BY L.Nombre, L.Genero, L.RefLibro

	OPEN cuatromasprestados

	FETCH cuatromasprestados INTO @nombreLibro, @cantPrestados, @generoLibro, @refLibro

	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		PRINT @nombreLibro + '    ' + CAST(@cantPrestados AS VARCHAR(10)) + '    ' + @generoLibro

		DECLARE @dniSocio VARCHAR(10), @fechaPrestamo DATE

		DECLARE sociosPrestamo CURSOR FOR
		SELECT DNI, FechaPrestamo 
		FROM PRESTAMOS
		WHERE RefLibro = @refLibro
		ORDER BY FechaPrestamo

		OPEN sociosPrestamo

		FETCH sociosPrestamo INTO @dniSocio, @fechaPrestamo

		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			PRINT '    ' + @dniSocio + '    ' + CAST(@fechaPrestamo AS VARCHAR(10))
			FETCH sociosPrestamo INTO @dniSocio, @fechaPrestamo
		END

		CLOSE sociosPrestamo
		DEALLOCATE sociosPrestamo

		FETCH cuatromasprestados INTO @nombreLibro, @cantPrestados, @generoLibro, @refLibro
	END

	CLOSE cuatromasprestados
	DEALLOCATE cuatromasprestados
END
EXEC listadocuatromasprestados

-- EJERCICIO 2
CREATE DATABASE Estudiantes
USE Estudiantes
GO
-- ******** TABLAS ALUMNOS, ASIGNATURAS, NOTAS ***********

-- Eliminar tablas si existen (orden correcto por FK)
IF OBJECT_ID('NOTAS', 'U') IS NOT NULL DROP TABLE NOTAS;
IF OBJECT_ID('ASIGNATURAS', 'U') IS NOT NULL DROP TABLE ASIGNATURAS;
IF OBJECT_ID('ALUMNOS', 'U') IS NOT NULL DROP TABLE ALUMNOS;

-- Crear tabla ALUMNOS
CREATE TABLE ALUMNOS (
    DNI VARCHAR(10) NOT NULL PRIMARY KEY,
    APENOM VARCHAR(30),
    DIREC VARCHAR(30),
    POBLA VARCHAR(15),
    TELEF VARCHAR(10)
);

-- Crear tabla ASIGNATURAS
CREATE TABLE ASIGNATURAS (
    COD TINYINT NOT NULL PRIMARY KEY,
    NOMBRE VARCHAR(25)
);

-- Crear tabla NOTAS
CREATE TABLE NOTAS (
    DNI VARCHAR(10) NOT NULL,
    COD TINYINT NOT NULL,
    NOTA TINYINT,
    CONSTRAINT FK_NOTAS_ALUMNOS FOREIGN KEY (DNI) REFERENCES ALUMNOS(DNI),
    CONSTRAINT FK_NOTAS_ASIGNATURAS FOREIGN KEY (COD) REFERENCES ASIGNATURAS(COD),
    CONSTRAINT PK_NOTAS PRIMARY KEY (DNI, COD)
);

-- Insertar asignaturas
INSERT INTO ASIGNATURAS VALUES (1,'Prog. Leng. Estr.');
INSERT INTO ASIGNATURAS VALUES (2,'Sist. Informáticos');
INSERT INTO ASIGNATURAS VALUES (3,'Análisis');
INSERT INTO ASIGNATURAS VALUES (4,'FOL');
INSERT INTO ASIGNATURAS VALUES (5,'RET');
INSERT INTO ASIGNATURAS VALUES (6,'Entornos Gráficos');
INSERT INTO ASIGNATURAS VALUES (7,'Aplic. Entornos 4ªGen');

-- Insertar alumnos
INSERT INTO ALUMNOS VALUES ('12344345','Alcalde García, Elena', 'C/Las Matas, 24','Madrid','917766545');
INSERT INTO ALUMNOS VALUES ('4448242','Cerrato Vela, Luis', 'C/Mina 28 - 3A', 'Madrid','916566545');
INSERT INTO ALUMNOS VALUES ('56882942','Díaz Fernández, María', 'C/Luis Vives 25', 'Móstoles','915577545');

-- Insertar notas
INSERT INTO NOTAS VALUES('12344345', 1,6);
INSERT INTO NOTAS VALUES('12344345', 2,5);
INSERT INTO NOTAS VALUES('12344345', 3,6);

INSERT INTO NOTAS VALUES('4448242', 4,6);
INSERT INTO NOTAS VALUES('4448242', 5,8);
INSERT INTO NOTAS VALUES('4448242', 6,4);
INSERT INTO NOTAS VALUES('4448242', 7,5);

INSERT INTO NOTAS VALUES('56882942', 5,7);
INSERT INTO NOTAS VALUES('56882942', 6,8);
INSERT INTO NOTAS VALUES('56882942', 7,9);

-- EJERCICIO 2
CREATE OR ALTER PROCEDURE dbo.notasasignaturas @asig VARCHAR(20)
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM ASIGNATURAS WHERE NOMBRE = @asig)
    BEGIN
        PRINT('No existe la asignatura')
		RETURN
    END

	IF NOT EXISTS (SELECT ALU.APENOM, N.NOTA FROM NOTAS AS N
	INNER JOIN ASIGNATURAS AS ASI ON N.COD = ASI.COD
	INNER JOIN ALUMNOS AS ALU ON N.DNI = ALU.DNI
	WHERE ASI.NOMBRE = @asig)
	BEGIN
		PRINT('No hay alumnos en esta asignatura')
		RETURN
	END

	DECLARE @nombrealum VARCHAR(20), @nota int
	DECLARE @suspensos int = 0, @aprobados int = 0, @notables int = 0, @sobresalientes int = 0
	DECLARE @alummayor VARCHAR(20), @alummenor VARCHAR(20), @notaanterior int = 0, @notamayor int = -1, @notamenor int = 11

	DECLARE listado CURSOR FOR
	SELECT ALU.APENOM, N.NOTA FROM NOTAS AS N
	INNER JOIN ASIGNATURAS AS ASI ON N.COD = ASI.COD
	INNER JOIN ALUMNOS AS ALU ON N.DNI = ALU.DNI
	WHERE ASI.NOMBRE = @asig

	OPEN listado

	FETCH listado INTO @nombrealum, @nota

	WHILE (@@FETCH_STATUS = 0 )
	BEGIN
		PRINT @nombrealum + '   NOTA: ' + CAST(@nota AS VARCHAR(5))

		IF @nota < 5
			SET @suspensos = @suspensos + 1
		ELSE
			SET @aprobados = @aprobados + 1
		
		IF @nota >= 5 AND @nota <= 8
			SET @notables = @notables + 1
		ELSE IF @nota = 9 or @nota = 10
			SET @sobresalientes = @sobresalientes + 1

		IF @nota > @notamayor
		BEGIN
			SET @notamayor = @nota
			SET @alummayor = @nombrealum
		END

		IF @nota < @notamenor
		BEGIN
			SET @notamenor = @nota
			SET @alummenor = @nombrealum
		END

		FETCH listado INTO @nombrealum, @nota
	END

	CLOSE listado
	DEALLOCATE listado

	PRINT 'Suspensos: ' + CAST(@suspensos AS VARCHAR(5))
	PRINT 'Aprobados: ' + CAST(@aprobados AS VARCHAR(5))
	PRINT 'Notables: ' + CAST(@notables AS VARCHAR(5))
	PRINT 'Sobresalientes: ' + CAST(@sobresalientes AS VARCHAR(5))
	PRINT 'Alumno con mayor nota: ' + @alummayor
	PRINT 'Alumno con menor nota: ' + @alummenor

END
EXEC dbo.notasasignaturas 'FOL'

-- EJERCICIO 3
CREATE DATABASE Productos
USE Productos
GO

-- Eliminar tablas si existen
IF OBJECT_ID('dbo.ventas', 'U') IS NOT NULL DROP TABLE dbo.ventas;
IF OBJECT_ID('dbo.productos', 'U') IS NOT NULL DROP TABLE dbo.productos;
GO

-- Crear tabla PRODUCTOS
CREATE TABLE dbo.productos
(
    CodProducto      VARCHAR(10)  NOT NULL CONSTRAINT PK_productos PRIMARY KEY,
    Nombre           VARCHAR(20)  NOT NULL,
    LineaProducto    VARCHAR(10),
    PrecioUnitario   DECIMAL(10,2),
    Stock            INT
);
GO

-- Crear tabla VENTAS
CREATE TABLE dbo.ventas
(
    CodVenta          VARCHAR(10)  NOT NULL CONSTRAINT PK_ventas PRIMARY KEY,
    CodProducto       VARCHAR(10)  NOT NULL,
    FechaVenta        DATE,
    UnidadesVendidas  INT,
    CONSTRAINT FK_ventas_productos FOREIGN KEY (CodProducto)
        REFERENCES dbo.productos(CodProducto)
);
GO

-- Insertar datos en PRODUCTOS
INSERT INTO dbo.productos VALUES 
('1','Procesador P133', 'Proc',15000,20),
('2','Placa base VX',   'PB',  18000,15),
('3','Simm EDO 16Mb',   'Memo', 7000,30),
('4','Disco SCSI 4Gb',  'Disc',38000, 5),
('5','Procesador K6-2', 'Proc',18500,10),
('6','Disco IDE 2.5Gb', 'Disc',20000,25),
('7','Procesador MMX',  'Proc',15000, 5),
('8','Placa Base Atlas','PB',  12000, 3),
('9','DIMM SDRAM 32Mb', 'Memo',17000,12);
GO

-- Insertar datos en VENTAS (usando formato de fecha ISO: YYYY-MM-DD)
INSERT INTO dbo.ventas VALUES
('V1', '2', '1997-09-22',2),
('V2', '4', '1997-09-22',1),
('V3', '6', '1997-09-23',3),
('V4', '5', '1997-09-26',5),
('V5', '9', '1997-09-28',3),
('V6', '4', '1997-09-28',1),
('V7', '6', '1997-10-02',2),
('V8', '6', '1997-10-02',1),
('V9', '2', '1997-10-04',4),
('V10','9', '1997-10-04',4),
('V11','6', '1997-10-05',2),
('V12','7', '1997-10-07',1),
('V13','4', '1997-10-10',3),
('V14','4', '1997-10-16',2),
('V15','3', '1997-10-18',3),
('V16','4', '1997-10-18',5),
('V17','6', '1997-10-22',2),
('V18','6', '1997-11-02',2),
('V19','2', '1997-11-04',3),
('V20','9', '1997-12-04',3);
GO

BEGIN TRANSACTION T1
-- EJERCICIO 3
-- Apartado A sin trigger
CREATE OR ALTER PROCEDURE actualizacionstock
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM ventas)
	BEGIN
		PRINT 'La tabla ventas está vacía'
		RETURN
	END

	IF NOT EXISTS (SELECT * FROM productos)
	BEGIN
		PRINT 'La tabla productos está vacía'
		RETURN
	END

	DECLARE @codprod VARCHAR(10), @unidades int
	DECLARE @stockact int

	DECLARE actualizacion CURSOR FOR
	SELECT V.CodProducto, V.UnidadesVendidas FROM ventas AS V

	OPEN actualizacion
	FETCH actualizacion INTO @codprod, @unidades

	WHILE (@@FETCH_STATUS = 0)
	BEGIN

		SELECT @stockact = CAST(Stock AS int) FROM productos WHERE CodProducto = @codprod
		
		SET @stockact = @stockact - @unidades

		IF (@stockact >= 0)
		BEGIN
			UPDATE productos SET Stock = CAST(@stockact AS VARCHAR(10))  WHERE CodProducto = @codprod
		END
		ELSE
		BEGIN
			PRINT 'El producto ' + CAST(@codprod AS VARCHAR(10)) + ' se ha quedado sin stock'
		END

		FETCH actualizacion INTO @codprod, @unidades
	END

	CLOSE actualizacion
	DEALLOCATE actualizacion
END
ROLLBACK
--COMMIT TRANSACTION T1

EXEC actualizacionstock



-- Apartado A con trigger
BEGIN TRANSACTION controlotodo
CREATE OR ALTER TRIGGER controlstock
ON ventas
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @stock INT, @verificarstock INT
	DECLARE @codprod INT, @unidades INT, @codventa VARCHAR(10), @fecha DATE

	SELECT @codprod = i.CodProducto, @unidades = i.UnidadesVendidas, @codventa = i.CodVenta, @fecha = i.FechaVenta FROM inserted AS i
	SELECT @stock = Stock FROM productos WHERE CodProducto = @codprod

	IF @codventa IN (SELECT CodVenta FROM ventas)
	BEGIN 
		SET @verificarstock = @stock + @unidades
		UPDATE productos SET Stock = @verificarstock WHERE CodProducto = @codprod
		DELETE FROM ventas WHERE CodVenta = @codventa
	END
	ELSE 
	BEGIN
		SET @verificarstock = @stock - @unidades
		IF @verificarstock < 0
		BEGIN
			PRINT 'No queda stock suficiente del producto ' + CAST(@codprod AS VARCHAR(10))
		END
		ELSE
		BEGIN
			INSERT INTO dbo.ventas VALUES (@codventa, @codprod, @fecha, @unidades)
			UPDATE productos SET Stock = @verificarstock WHERE CodProducto = @codprod
		END
	END
END
ROLLBACK
COMMIT TRANSACTION controlotodo

INSERT INTO dbo.ventas VALUES ('V42', '2', '1997-09-22',10)
SELECT * FROM productos
SELECT * FROM ventas

-- Apartado B
CREATE OR ALTER PROCEDURE imprimirventas
AS
BEGIN
	DECLARE @linea VARCHAR(10), @importetotal DECIMAL(10,2)
	DECLARE @prod VARCHAR(10), @unidades int, @importeprod DECIMAL(10,2)

	DECLARE recorrerlinea CURSOR FOR
	SELECT DISTINCT LineaProducto FROM productos

	OPEN recorrerlinea
	FETCH recorrerlinea INTO @linea

	WHILE (@@FETCH_STATUS =0)
	BEGIN
		SET @importetotal = 0
		PRINT 'Linea Producto: ' + @linea

		DECLARE recorrerproducto CURSOR FOR
		SELECT Nombre, Stock, PrecioUnitario FROM productos WHERE LineaProducto = @linea

		OPEN recorrerproducto
		FETCH recorrerproducto INTO @prod, @unidades, @importeprod

		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			PRINT '		' + @prod + '		' + CAST(@unidades AS VARCHAR(10)) + '		' + CAST(@importeprod AS VARCHAR(10))

			SET @importetotal = @importetotal + @importeprod

			FETCH recorrerproducto INTO @prod, @unidades, @importeprod
		END

		CLOSE recorrerproducto
		DEALLOCATE recorrerproducto

		PRINT 'Importe total ' + @linea + ': ' + CAST(@importetotal AS VARCHAR(10))

		FETCH recorrerlinea INTO @linea
	END

	CLOSE recorrerlinea
	DEALLOCATE recorrerlinea
END

EXEC imprimirventas


select * from ventas
select * from productos