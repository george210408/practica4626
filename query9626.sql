-- 1. Crear una base de datos llamada EmpresaSQL
CREATE DATABASE EmpresaSQL;
GO

-- 2. Seleccionar la base de datos creada
USE EmpresaSQL;
-- 1. Crear una base de datos llamada EmpresaSQL
CREATE DATABASE EmpresaSQL;
GO

-- 2. Seleccionar la base de datos creada
USE EmpresaSQL;
GO

-- CREACIÓN DE ESQUEMAS LÓGICOS
CREATE SCHEMA rrhh;
GO
CREATE SCHEMA proyectos;
GO
CREATE SCHEMA ventas;
GO

-- 3. Crear una tabla llamada TDepartamento
CREATE TABLE rrhh.TDepartamento (
    nDepartamentoID INT IDENTITY(1,1) PRIMARY KEY,
    cNombreDepartamento VARCHAR(100) UNIQUE NOT NULL
);

-- 4. Crear una tabla llamada TCargo
CREATE TABLE rrhh.TCargo (
    nCargoID INT IDENTITY(1,1) PRIMARY KEY,
    cNombreCargo VARCHAR(100) UNIQUE NOT NULL
);

-- 5. Crear una tabla llamada TEmpleado (Con restricciones 6, 7, 8 y 9)
CREATE TABLE rrhh.TEmpleado (
    nEmpleadoID INT IDENTITY(1,1) PRIMARY KEY,
    cNIF VARCHAR(20) UNIQUE NOT NULL,
    cNombre VARCHAR(50) NOT NULL,
    cApellido VARCHAR(50) NOT NULL,
    nDepartamentoID INT,
    nCargoID INT,
    -- 7. Restricción DEFAULT para la fecha de contratación
    dFechaContratacion DATE DEFAULT GETDATE(),
    -- 6. Restricción CHECK para que el salario sea mayor que 300
    nSalario DECIMAL(10,2) CONSTRAINT CHK_Salario CHECK (nSalario > 300),
    
    -- 8. Llave foránea hacia rrhh.TDepartamento
    CONSTRAINT FK_Empleado_Departamento FOREIGN KEY (nDepartamentoID) 
        REFERENCES rrhh.TDepartamento(nDepartamentoID),
    -- 9. Llave foránea hacia rrhh.TCargo
    CONSTRAINT FK_Empleado_Cargo FOREIGN KEY (nCargoID) 
        REFERENCES rrhh.TCargo(nCargoID)
);

-- 10, 11, 12, 13, 14. Crear una tabla llamada TProyecto
CREATE TABLE proyectos.TProyecto (
    nProyectoID INT IDENTITY(1,1) PRIMARY KEY, -- 11. Autoincremental
    cNombreProyecto VARCHAR(100) NOT NULL,     -- 12. Obligatorio
    dFechaInicio DATE NOT NULL,                -- 13. Obligatorio
    dFechaFinalizacion DATE                    -- 14. Opcional
);

-- 15. Crear tabla intermedia TEmpleadoProyecto (Relación muchos a muchos entre esquemas)
CREATE TABLE proyectos.TEmpleadoProyecto (
    nEmpleadoID INT,
    nProyectoID INT,
    PRIMARY KEY (nEmpleadoID, nProyectoID),
    CONSTRAINT FK_EmpProj_Empleado FOREIGN KEY (nEmpleadoID) REFERENCES rrhh.TEmpleado(nEmpleadoID),
    CONSTRAINT FK_EmpProj_Proyecto FOREIGN KEY (nProyectoID) REFERENCES proyectos.TProyecto(nProyectoID)
);

-- 16. Agregar columna cEmail a TEmpleado
ALTER TABLE rrhh.TEmpleado ADD cEmail VARCHAR(100);

-- 17. Agregar columna cTelefono
ALTER TABLE rrhh.TEmpleado ADD cTelefono VARCHAR(15);

-- 18. Modificar longitud de cNombre a 100 caracteres
ALTER TABLE rrhh.TEmpleado ALTER COLUMN cNombre VARCHAR(100) NOT NULL;

-- 19. Modificar longitud de cApellido a 100 caracteres
ALTER TABLE rrhh.TEmpleado ALTER COLUMN cApellido VARCHAR(100) NOT NULL;

-- 20. Agregar columna cDireccion
ALTER TABLE rrhh.TEmpleado ADD cDireccion VARCHAR(200);

-- 21. Agregar columna nEdad
ALTER TABLE rrhh.TEmpleado ADD nEdad INT;

-- 22. Crear restricción CHECK para edades entre 18 y 65 años
ALTER TABLE rrhh.TEmpleado ADD CONSTRAINT CHK_Edad CHECK (nEdad BETWEEN 18 AND 65);

-- 23. Agregar restricción UNIQUE al correo electrónico
ALTER TABLE rrhh.TEmpleado ADD CONSTRAINT UQ_Email UNIQUE (cEmail);

-- 24. Agregar columna bActivo tipo BIT con valor por defecto 1
ALTER TABLE rrhh.TEmpleado ADD bActivo BIT DEFAULT 1 WITH VALUES; 

-- 25. Eliminar la columna cDireccion
ALTER TABLE rrhh.TEmpleado DROP COLUMN cDireccion;

-- 26. Cambiar el tipo de dato de teléfono a VARCHAR(20)
ALTER TABLE rrhh.TEmpleado ALTER COLUMN cTelefono VARCHAR(20);

-- 27. Agregar columna cGenero
ALTER TABLE rrhh.TEmpleado ADD cGenero CHAR(1);

-- 28. Agregar restricción CHECK para que el género solo permita M o F
ALTER TABLE rrhh.TEmpleado ADD CONSTRAINT CHK_Genero CHECK (cGenero IN ('M', 'F'));

-- 29. Agregar columna dFechaNacimiento
ALTER TABLE rrhh.TEmpleado ADD dFechaNacimiento DATE;

-- 30. Crear una nueva tabla llamada TSucursal (la asignaremos a rrhh)
CREATE TABLE rrhh.TSucursal (
    nSucursalID INT IDENTITY(1,1) PRIMARY KEY,
    cNombreSucursal VARCHAR(100) NOT NULL,
    cUbicacion VARCHAR(150)
);

-- 31. Insertar 5 departamentos diferentes
INSERT INTO rrhh.TDepartamento (cNombreDepartamento) VALUES 
('Tecnología'), ('Recursos Humanos'), ('Finanzas'), ('Ventas'), ('Marketing');

-- 32. Insertar 5 cargos diferentes
INSERT INTO rrhh.TCargo (cNombreCargo) VALUES 
('Desarrollador'), ('Analista de RRHH'), ('Contador'), ('Asesor Comercial'), ('Gerente');

-- 33. Insertar 10 empleados
INSERT INTO rrhh.TEmpleado (cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, nEdad, cGenero, cEmail, cTelefono) VALUES
('11111111A', 'Juan', 'Pérez', 1, 1, 1200.00, 30, 'M', 'juan.perez@empresa.com', '555-0011'),
('22222222B', 'Ana', 'Gómez', 2, 2, 950.00, 28, 'F', 'ana.gomez@empresa.com', '555-0022'),
('33333333C', 'Carlos', 'Rodríguez', 3, 3, 1100.00, 45, 'M', 'carlos.rod@empresa.com', '555-0033'),
('44444444D', 'María', 'López', 4, 4, 850.00, 24, 'F', 'maria.lopez@empresa.com', '555-0044'),
('55555555E', 'Luis', 'García', 1, 1, 1300.00, 35, 'M', 'luis.garcia@empresa.com', '555-0055'),
('66666666F', 'Laura', 'Martínez', 5, 5, 2000.00, 40, 'F', 'laura.mar@empresa.com', '555-0066'),
('77777777G', 'Pedro', 'González', 1, 1, 1250.00, 32, 'M', 'pedro.gonz@empresa.com', '555-0077'),
('88888888H', 'Sofía', 'Castro', 3, 3, 400.00, 22, 'F', 'sofia.castro@empresa.com', '555-0088'),
('99999999I', 'Diego', 'Sánchez', 4, 4, 450.00, 29, 'M', 'diego.san@empresa.com', '555-0089'),
('00000000J', 'Elena', 'Ruiz', 2, 2, 900.00, 50, 'F', 'elena.ruiz@empresa.com', '555-0090');

-- 34. Insertar 3 proyectos
INSERT INTO proyectos.TProyecto (cNombreProyecto, dFechaInicio, dFechaFinalizacion) VALUES
('Migración Cloud', '2026-01-15', '2026-08-30'),
('Reclutamiento 2026', '2026-02-01', NULL),
('Auditoría Anual', '2026-03-01', '2026-06-15');

-- 35. Asignar empleados a proyectos
INSERT INTO proyectos.TEmpleadoProyecto (nEmpleadoID, nProyectoID) VALUES
(1, 1), (5, 1), (7, 1), (2, 2), (10, 2), (3, 3);

-- 36. Insertar un empleado utilizando el valor por defecto de fecha
INSERT INTO rrhh.TEmpleado (cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, nEdad, cGenero, cEmail)
VALUES ('12345678X', 'Miguel', 'Torres', 1, 1, 1400.00, 33, 'M', 'miguel.torres@empresa.com');

-- 37. Insertar un empleado con correo electrónico
INSERT INTO rrhh.TEmpleado (cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, nEdad, cGenero, cEmail)
VALUES ('87654321Y', 'Carmen', 'Ortiz', 4, 4, 880.00, 27, 'F', 'carmen.ortiz@empresa.com');

-- 38. Insertar un empleado sin indicar estado activo
INSERT INTO rrhh.TEmpleado (cNIF, cNombre, cApellido, nDepartamentoID, nCargoID, nSalario, nEdad, cGenero, cEmail)
VALUES ('54321678Z', 'Jorge', 'Giménez', 1, 1, 1150.00, 31, 'M', 'jorge.gim@empresa.com');

-- 39. Insertar registros usando múltiples VALUES
INSERT INTO rrhh.TDepartamento (cNombreDepartamento) VALUES 
('Logística'), ('Calidad'), ('Soporte Técnico');

-- 40. Intentar insertar un salario negativo y analizar el error
INSERT INTO rrhh.TEmpleado (cNIF, cNombre, cApellido, nSalario) VALUES ('00000000X', 'Error', 'Test', -100);
-- ANÁLISIS: Rompe la restricción 'CHK_Salario' del esquema 'rrhh'.

-- 41. Incrementar en 10% el salario de todos los empleados
UPDATE rrhh.TEmpleado SET nSalario = nSalario * 1.10;

-- 42. Incrementar en 20% el salario de los empleados de un departamento específico (Ej: Departamento 1)
UPDATE rrhh.TEmpleado SET nSalario = nSalario * 1.20 WHERE nDepartamentoID = 1;

-- 43. Actualizar el correo electrónico de un empleado
UPDATE rrhh.TEmpleado SET cEmail = 'juan.perez.nuevo@empresa.com' WHERE cNIF = '11111111A';

-- 44. Modificar el cargo de un empleado
UPDATE rrhh.TEmpleado SET nCargoID = 5 WHERE nEmpleadoID = 1;

-- 45. Cambiar el departamento de dos empleados
UPDATE rrhh.TEmpleado SET nDepartamentoID = 3 WHERE nEmpleadoID IN (2, 4);

-- 46. Marcar como inactivos a los empleados con salario inferior a 500
UPDATE rrhh.TEmpleado SET bActivo = 0 WHERE nSalario < 500;

-- 47. Actualizar la fecha de finalización de un proyecto
UPDATE proyectos.TProyecto SET dFechaFinalizacion = '2026-12-31' WHERE nProyectoID = 2;

-- 48. Asignar un nuevo proyecto a un empleado
INSERT INTO proyectos.TEmpleadoProyecto (nEmpleadoID, nProyectoID) VALUES (1, 2);

-- 49. Eliminar un empleado específico mediante su NIF
DELETE FROM proyectos.TEmpleadoProyecto WHERE nEmpleadoID = (SELECT nEmpleadoID FROM rrhh.TEmpleado WHERE cNIF = '54321678Z');
DELETE FROM rrhh.TEmpleado WHERE cNIF = '54321678Z';

-- 50. Eliminar todos los empleados inactivos
DELETE FROM proyectos.TEmpleadoProyecto WHERE nEmpleadoID IN (SELECT nEmpleadoID FROM rrhh.TEmpleado WHERE bActivo = 0);
DELETE FROM rrhh.TEmpleado WHERE bActivo = 0;

-- 51. Eliminar un proyecto específico
DELETE FROM proyectos.TEmpleadoProyecto WHERE nProyectoID = 3;
DELETE FROM proyectos.TProyecto WHERE nProyectoID = 3;

-- 52. Eliminar las asignaciones de un empleado en la tabla TEmpleadoProyecto
DELETE FROM proyectos.TEmpleadoProyecto WHERE nEmpleadoID = 1;

-- 53. Eliminar un departamento que no tenga empleados asociados
DELETE FROM rrhh.TDepartamento 
WHERE nDepartamentoID NOT IN (SELECT DISTINCT nDepartamentoID FROM rrhh.TEmpleado WHERE nDepartamentoID IS NOT NULL);

-- 54. Mostrar todos los empleados ordenados por apellido
SELECT * FROM rrhh.TEmpleado ORDER BY cApellido ASC;

-- 55. Mostrar empleados con salario mayor a 1,000
SELECT * FROM rrhh.TEmpleado WHERE nSalario > 1000;

-- 56. Mostrar empleados activos
SELECT * FROM rrhh.TEmpleado WHERE bActivo = 1;

-- 57. Mostrar empleados contratados durante el año actual
SELECT * FROM rrhh.TEmpleado WHERE YEAR(dFechaContratacion) = YEAR(GETDATE());

-- 58. Mostrar empleados y el nombre de su departamento
SELECT E.cNombre, E.cApellido, D.cNombreDepartamento 
FROM rrhh.TEmpleado E
INNER JOIN rrhh.TDepartamento D ON E.nDepartamentoID = D.nDepartamentoID;

-- 59. Mostrar empleados y el nombre de su cargo
SELECT E.cNombre, E.cApellido, C.cNombreCargo 
FROM rrhh.TEmpleado E
INNER JOIN rrhh.TCargo C ON E.nCargoID = C.nCargoID;

-- 60. Mostrar empleados asignados a proyectos
SELECT E.cNombre, E.cApellido, P.cNombreProyecto 
FROM rrhh.TEmpleado E
INNER JOIN proyectos.TEmpleadoProyecto EP ON E.nEmpleadoID = EP.nEmpleadoID
INNER JOIN proyectos.TProyecto P ON EP.nProyectoID = P.nProyectoID;

-- 61. Mostrar cantidad de empleados por departamento
SELECT D.cNombreDepartamento, COUNT(E.nEmpleadoID) AS TotalEmpleados
FROM rrhh.TDepartamento D
LEFT JOIN rrhh.TEmpleado E ON D.nDepartamentoID = E.nDepartamentoID
GROUP BY D.cNombreDepartamento;

-- 62. Mostrar salario promedio por departamento
SELECT D.cNombreDepartamento, AVG(E.nSalario) AS SalarioPromedio
FROM rrhh.TDepartamento D
INNER JOIN rrhh.TEmpleado E ON D.nDepartamentoID = E.nDepartamentoID
GROUP BY D.cNombreDepartamento;

-- 63. Mostrar salario máximo y mínimo por departamento
SELECT D.cNombreDepartamento, MAX(E.nSalario) AS SalarioMaximo, MIN(E.nSalario) AS SalarioMinimo
FROM rrhh.TDepartamento D
INNER JOIN rrhh.TEmpleado E ON D.nDepartamentoID = E.nDepartamentoID
GROUP BY D.cNombreDepartamento;

-- 64. Mostrar los proyectos con más de dos empleados asignados
SELECT P.cNombreProyecto, COUNT(EP.nEmpleadoID) AS NumEmpleados
FROM proyectos.TProyecto P
INNER JOIN proyectos.TEmpleadoProyecto EP ON P.nProyectoID = EP.nProyectoID
GROUP BY P.cNombreProyecto
HAVING COUNT(EP.nEmpleadoID) > 2;

-- 65. Mostrar empleados cuyo apellido inicia con "G"
SELECT * FROM rrhh.TEmpleado WHERE cApellido LIKE 'G%';

-- 66. Mostrar empleados ordenados por salario descendente
SELECT * FROM rrhh.TEmpleado ORDER BY nSalario DESC;

-- 67. Mostrar los tres salarios más altos
SELECT TOP 3 nSalario, cNombre, cApellido FROM rrhh.TEmpleado ORDER BY nSalario DESC;

-- 68. Mostrar empleados con edad entre 25 and 40 años
SELECT * FROM rrhh.TEmpleado WHERE nEdad BETWEEN 25 AND 40;

-- 69. Mostrar cantidad total de empleados activos
SELECT COUNT(*) AS TotalActivos FROM rrhh.TEmpleado WHERE bActivo = 1;

-- 70. Mostrar el total de proyectos registrados
SELECT COUNT(*) AS TotalProyectos FROM proyectos.TProyecto;

-- 71. Eliminar la restricción CHECK de edad
ALTER TABLE rrhh.TEmpleado DROP CONSTRAINT CHK_Edad;

-- 72. Eliminar la restricción UNIQUE del correo
ALTER TABLE rrhh.TEmpleado DROP CONSTRAINT UQ_Email;

-- 73. Agregar nuevamente ambas restricciones
ALTER TABLE rrhh.TEmpleado ADD CONSTRAINT CHK_Edad CHECK (nEdad BETWEEN 18 AND 65);
ALTER TABLE rrhh.TEmpleado ADD CONSTRAINT UQ_Email UNIQUE (cEmail);

-- ELIMINACIÓN PROPAGADA RESPETANDO ESQUEMAS
-- 74. Eliminar la tabla TEmpleadoProyecto
DROP TABLE proyectos.TEmpleadoProyecto;

-- 75. Eliminar la tabla TProyecto
DROP TABLE proyectos.TProyecto;

-- 76. Eliminar la tabla TEmpleado
DROP TABLE rrhh.TEmpleado;

-- 77. Eliminar la tabla TCargo
DROP TABLE rrhh.TCargo;

-- 78. Eliminar la tabla TDepartamento
DROP TABLE rrhh.TDepartamento;

-- 79. Eliminar la tabla TSucursal
DROP TABLE rrhh.TSucursal;

-- 80. Eliminar la base de datos EmpresaSQL
USE master;
GO
DROP DATABASE EmpresaSQL;
GO

-- 81. Crear una tabla TCliente en el esquema ventas
CREATE TABLE ventas.TCliente (
    nClienteID INT IDENTITY(1,1) PRIMARY KEY,
    cDocumento VARCHAR(20) UNIQUE NOT NULL,
    cNombre VARCHAR(100) NOT NULL,
    cApellido VARCHAR(100) NOT NULL,
    cEmail VARCHAR(100) UNIQUE,
    cTelefono VARCHAR(20),
    dFechaRegistro DATE DEFAULT GETDATE(),
    nEdad INT CHECK (nEdad >= 18),
    bEstado BIT DEFAULT 1
);

-- 82. Crear una tabla TVenta relacionada en el esquema ventas
CREATE TABLE ventas.TVenta (
    nVentaID INT IDENTITY(1,1) PRIMARY KEY,
    nClienteID INT NOT NULL,
    dFechaVenta DATETIME DEFAULT GETDATE(),
    nMontoTotal DECIMAL(10,2) CHECK (nMontoTotal > 0),
    cMetodoPago VARCHAR(30) CHECK (cMetodoPago IN ('Efectivo', 'Tarjeta', 'Transferencia')),
    CONSTRAINT FK_Venta_Cliente FOREIGN KEY (nClienteID) REFERENCES ventas.TCliente(nClienteID)
);

-- 83. Registrar 20 clientes
INSERT INTO ventas.TCliente (cDocumento, cNombre, cApellido, cEmail, nEdad) VALUES
('ID01', 'Carlos', 'Meza', 'carlos@mail.com', 25), ('ID02', 'Maria', 'Solis', 'maria@mail.com', 30),
('ID03', 'Jorge', 'Luna', 'jorge@mail.com', 40), ('ID04', 'Rosa', 'Diaz', 'rosa@mail.com', 22),
('ID05', 'Luis', 'Paz', 'luis@mail.com', 35), ('ID06', 'Elena', 'Rios', 'elena@mail.com', 28),
('ID07', 'Pedro', 'Soto', 'pedro@mail.com', 50), ('ID08', 'Lucia', 'Cruz', 'lucia@mail.com', 45),
('ID09', 'Andres', 'Gomez', 'andres@mail.com', 19), ('ID10', 'Sofia', 'Vega', 'sofia@mail.com', 31),
('ID11', 'Mario', 'Silva', 'mario@mail.com', 26), ('ID12', 'Laura', 'Ferrer', 'laura@mail.com', 34),
('ID13', 'Diego', 'Mendoza', 'diego@mail.com', 23), ('ID14', 'Paula', 'Campos', 'paula@mail.com', 38),
('ID15', 'Raul', 'Ortega', 'raul@mail.com', 42), ('ID16', 'Natalia', 'Fuentes', 'natalia@mail.com', 27),
('ID17', 'Javier', 'Delgado', 'javier@mail.com', 48), ('ID18', 'Irene', 'Castillo', 'irene@mail.com', 29),
('ID19', 'Tomas', 'Pardo', 'tomas@mail.com', 55), ('ID20', 'Sara', 'Guzman', 'sara@mail.com', 33);

-- 84. Registrar ventas
INSERT INTO ventas.TVenta (nClienteID, dFechaVenta, nMontoTotal, cMetodoPago) VALUES
(1, '2026-01-10', 150.00, 'Tarjeta'), (1, '2026-01-15', 50.00, 'Efectivo'),
(2, '2026-01-20', 300.00, 'Transferencia'), (3, '2026-02-05', 450.00, 'Tarjeta'),
(4, '2026-02-12', 80.00, 'Efectivo'), (5, '2026-02-25', 500.00, 'Transferencia'),
(6, '2026-03-02', 120.00, 'Tarjeta'), (7, '2026-03-10', 250.00, 'Efectivo'),
(8, '2026-03-15', 95.00, 'Tarjeta'), (9, '2026-04-01', 60.00, 'Efectivo'),
(10, '2026-04-05', 700.00, 'Transferencia'), (11, '2026-04-12', 110.00, 'Tarjeta'),
(12, '2026-04-18', 180.00, 'Efectivo'), (13, '2026-05-02', 220.00, 'Transferencia'),
(14, '2026-05-09', 310.00, 'Tarjeta'), (15, '2026-05-14', 415.00, 'Efectivo'),
(1, '2026-05-20', 90.00, 'Tarjeta'), (2, '2026-06-01', 130.00, 'Efectivo'),
(3, '2026-06-04', 550.00, 'Transferencia'), (4, '2026-06-05', 25.00, 'Efectivo');

-- 85. Actualizar precios o montos de ventas según una condición
UPDATE ventas.TVenta SET nMontoTotal = nMontoTotal * 1.05 WHERE cMetodoPago = 'Tarjeta';

-- 86. Eliminar clientes sin ventas
DELETE FROM ventas.TCliente WHERE nClienteID NOT IN (SELECT DISTINCT nClienteID FROM ventas.TVenta);

-- 87. Consultar los 5 clientes con mayores compras
SELECT TOP 5 C.nClienteID, C.cNombre, C.cApellido, SUM(V.nMontoTotal) AS TotalComprado
FROM ventas.TCliente C
INNER JOIN ventas.TVenta V ON C.nClienteID = V.nClienteID
GROUP BY C.nClienteID, C.cNombre, C.cApellido
ORDER BY TotalComprado DESC;

-- 88. Consultar ventas por mes
SELECT MONTH(dFechaVenta) AS Mes, YEAR(dFechaVenta) AS Anio, COUNT(*) AS TotalVentas, SUM(nMontoTotal) AS Facturacion
FROM ventas.TVenta
GROUP BY YEAR(dFechaVenta), MONTH(dFechaVenta)
ORDER BY Anio, Mes;

-- 89. Consultar promedio de ventas por cliente
SELECT C.cNombre, C.cApellido, AVG(V.nMontoTotal) AS PromedioVenta
FROM ventas.TCliente C
INNER JOIN ventas.TVenta V ON C.nClienteID = V.nClienteID
GROUP BY C.nClienteID, C.cNombre, C.cApellido;

-- 90. Reporte consolidado uniendo 3 tablas (Esquemas cruzados: rrhh, ventas)
-- Ejemplo práctico: Mostrar qué cliente compró, qué empleado de "Ventas" tiene su mismo apellido (Coincidencia familiar/comercial conceptual)
SELECT C.cNombre AS ClienteNombre, C.cApellido AS ClienteApellido, 
       V.nMontoTotal, V.dFechaVenta,
       E.cNombre AS AtendidoPorSemejanza
FROM ventas.TCliente C
INNER JOIN ventas.TVenta V ON C.nClienteID = V.nClienteID
LEFT JOIN rrhh.TEmpleado E ON C.cApellido = E.cApellido;