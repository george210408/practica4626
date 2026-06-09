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

