--LAURA LUZHEN RODRÍGUEZ MORÁN
USE SCOTT

--EJERCICIO 1
--Haz una función llamada DevolverCodDept que reciba el nombre de un departamento y devuelva su código.
CREATE FUNCTION dbo.DevolverCodDept(@nombre VARCHAR(14))
RETURNS INT 
AS
BEGIN
	DECLARE @codigo INT
	SELECT @codigo = (SELECT DEPTNO FROM DEPT WHERE DNAME = @nombre)
	RETURN @codigo
END
SELECT dbo.DevolverCodDept ('hola') AS 'Código'
GO

--EJERCICIO 2
--Realiza un procedimiento llamado HallarNumEmp que recibiendo un nombre de departamento, muestre en pantalla el número de empleados de dicho departamento. 
--Puedes utilizar la función creada en el ejercicio 1. Si el departamento no tiene empleados deberá mostrar un mensaje informando de ello. Si el departamento 
--no existe se tratará la excepción correspondiente.
CREATE OR ALTER PROCEDURE HallarNumEmp (@nombre VARCHAR(14))
AS
BEGIN
	DECLARE @numero INT, @count INT = 0
	SET @numero = dbo.DevolverCodDept (@nombre)

	IF @numero IS NULL
	BEGIN
		PRINT 'Algo salió mal...'
		RAISERROR('ERROR', 1, 1)
		RETURN
	END
	ELSE 
	BEGIN
		DECLARE cNumeroEmpleados CURSOR FOR SELECT * FROM EMP WHERE DEPTNO = @numero
		OPEN cNumeroEmpleados
		FETCH cNumeroEmpleados
		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			SET @count += 1
			FETCH cNumeroEmpleados
		END
	END
END
EXEC HallarNumEmp 'SALES'
GO

--EJERCICIO 3
--Realiza una función llamada CalcularCosteSalarial que reciba un nombre de departamento y devuelva la suma de los salarios y comisiones de los empleados de 
--dicho departamento. Trata las excepciones que consideres necesarias.
CREATE OR ALTER FUNCTION CalcularCosteSalarial (@departamento AS VARCHAR(14))
RETURNS MONEY
AS
BEGIN
	DECLARE @codDept INT, @total MONEY
	SET @codDept = dbo.DevolverCodDept(@departamento)

	IF @codDept IS NULL 
		RETURN NULL
		
	SELECT @total = SUM(ISNULL(SAL, 0) + ISNULL(COMM, 0)) FROM EMP WHERE DEPTNO = @codDept
	RETURN @total
END

SELECT dbo.CalcularCosteSalarial('ACCOUNTING')
GO

--EJERCICIO 4 
--Realiza un procedimiento MostrarCostesSalariales que muestre los nombres de todos los departamentos y el coste salarial de cada uno de ellos. Puedes usar la 
--función del ejercicio 3.
CREATE OR ALTER PROCEDURE MostrarCostesSalariales
AS
BEGIN
    DECLARE @NombreDept VARCHAR(14)
    DECLARE @Coste DECIMAL(7,2)

    DECLARE dept_cursor CURSOR FOR
        SELECT D.DNAME, SUM(E.SAL) FROM DEPT D 
		INNER JOIN EMP E ON D.DEPTNO = E.DEPTNO GROUP BY D.DNAME

    OPEN dept_cursor;
		FETCH NEXT FROM dept_cursor INTO @NombreDept, @Coste
		WHILE @@FETCH_STATUS = 0
		BEGIN
			PRINT 'Departamento: ' + @NombreDept + ' - Coste Salarial: ' + CAST(@Coste AS VARCHAR(14))

			FETCH NEXT FROM dept_cursor INTO @NombreDept, @Coste
		END
    CLOSE dept_cursor
    DEALLOCATE dept_cursor
END
EXEC MostrarCostesSalariales
GO


--EJERCICIO 5
--Realiza un procedimiento MostrarAbreviaturas que muestre las tres primeras letras del nombre de cada empleado.
CREATE OR ALTER PROCEDURE MostrarAbreviaturas
AS
BEGIN
SELECT LEFT(ENAME, 3) AS Nombre FROM EMP
END
EXEC MostrarAbreviaturas
GO

--EJERCICIO 6  
--Realiza un procedimiento MostrarMasAntiguos que muestre el nombre del empleado más antiguo de cada departamento junto con el nombre del departamento. 
--Trata las excepciones que consideres necesarias.
CREATE OR ALTER PROCEDURE MostrarMasAntiguos
AS
BEGIN
	DECLARE @numero INT, @nombre VARCHAR(14), @empleado VARCHAR(14)

	DECLARE CogerAntiguo CURSOR FOR
		SELECT DEPTNO, DNAME FROM DEPT
	
	OPEN CogerMasAntiguo
		FETCH NEXT FROM CogerMasAntiguo INTO @numero, @nombre

		WHILE @@FETCH_STATUS = 0
		BEGIN
			SELECT TOP 1 @empleado = ENAME FROM EMP WHERE DEPTNO = @numero ORDER BY HIREDATE
			PRINT('Departamento: ' + @nombre + '-  Empleado: ' + @empleado)
			FETCH NEXT FROM CogerMasAntiguo INTO @numero, @nombre
		END
	CLOSE CogerMasAntiguo
	DEALLOCATE CogerMasAntiguo
END
EXEC dbo.MostrarMasAntiguos
GO

--EJERCICIO 7 
--Realiza un procedimiento MostrarJefes que reciba el nombre de un departamento y muestre los nombres de los empleados de ese departamento que son jefes 
--de otros empleados.Trata las excepciones que consideres necesarias.
CREATE OR ALTER PROCEDURE MostrarJefes
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @nombre VARCHAR(14), @numero INT, @numeroEmp INT, @nombreEmp VARCHAR(14)

    DECLARE Departamento CURSOR FOR
        SELECT DEPTNO, DNAME FROM DEPT

    OPEN Departamento
    FETCH NEXT FROM CursorDept INTO @numero, @nombre

    WHILE @@FETCH_STATUS = 0
    BEGIN
       DECLARE Jefes CURSOR FOR
            SELECT E.EMPNO, E.ENAME
            FROM EMP E
            WHERE E.DEPTNO = @numero
              AND E.EMPNO IN (SELECT DISTINCT MGR FROM EMP WHERE MGR IS NOT NULL)

        OPEN Jefes
        FETCH NEXT FROM Jefes INTO @numeroEmp, @nombreEmp

        WHILE @@FETCH_STATUS = 0
        BEGIN
            PRINT 'Departamento: ' + @nombre + ' - Jefe: ' + @nombreEmp
            FETCH NEXT FROM Jefes INTO @numeroEmp, @nombreEmp
        END

        CLOSE Jefes
        DEALLOCATE Jefes

        FETCH NEXT FROM Departamento INTO @numero, @nombre
    END

    CLOSE Departamento
    DEALLOCATE Departamento
END
EXEC MostrarJefes
GO

--EJERCICIO 8
--Realiza un procedimiento MostrarMejoresVendedores que muestre los nombres de los dos vendedores con más comisiones. Trata las excepciones que consideres necesarias.
CREATE OR ALTER PROCEDURE MostrarMejoresVendedores
AS
BEGIN
	SELECT TOP 2 * FROM EMP ORDER BY COMM DESC
END
EXEC MostrarMejoresVendedores
GO

--EJERCICIO 10
--Realiza un procedimiento RecortarSueldos que recorte el   sueldo un 20% a los empleados cuyo nombre empiece por la  letra que recibe como parámetro.
--Trata las excepciones  que consideres necesarias
CREATE OR ALTER PROCEDURE RecortarSueldos(@letra CHAR)
AS
BEGIN
	UPDATE EMP SET SAL -= ISNULL(SAL, 0) * 0.2
	WHERE @letra = LEFT(ENAME,1)
	UPDATE EMP SET SAL = SAL - SAL
END
EXEC RecortarSueldos 'A'
GO

--EJERCICIO 11 
--Realiza un procedimiento BorrarBecarios que borre a los dos empleados más nuevos de cada departamento. Trata las excepciones que consideres necesarias.
CREATE OR ALTER PROCEDURE BorrarBecarios 
AS 
BEGIN
	DECLARE @numero INT, @nombre VARCHAR(14), @empleado VARCHAR(14)

	DECLARE MasAntiguo CURSOR
	FOR SELECT DEPTNO, DNAME FROM DEPT
	OPEN MasAntiguo
		FETCH NEXT FROM MasAntiguo INTO @numero, @nombre
		WHILE @@FETCH_STATUS = 0
		BEGIN 
			SELECT TOP 1 @empleado = ENAME FROM EMP WHERE DEPTNO = @numero ORDER BY HIREDATE
			PRINT('Departamento: ' + @nombre + '-  Empleado: ' + @empleado)
		FETCH NEXT FROM MasAntiguo INTO @numero, @nombre
	END
	CLOSE MasAntiguo
	DEALLOCATE MasAntiguo
END
EXEC BorrarBecarios
GO