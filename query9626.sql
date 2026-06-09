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

