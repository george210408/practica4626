USE master;
GO

-- 1. Crear la base de datos HospitalDB
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'HospitalDB')
BEGIN
    DROP DATABASE HospitalDB;
END
GO

CREATE DATABASE HospitalDB;
GO

-- 2. Mostrar todas las bases de datos existentes
SELECT name AS BaseDeDatos, create_date AS FechaCreacion 
FROM sys.databases;
GO

-- 3. Seleccionar HospitalDB para trabajar
USE HospitalDB;
GO

-- 4 al 10. Creación inicial de tablas (Estructura base para aplicar restricciones luego)

CREATE TABLE Especialidades (
    id_especialidad INT IDENTITY(1,1),
    nombre VARCHAR(50)
);

CREATE TABLE Medicos (
    id_medico INT IDENTITY(1,1),
    nombre VARCHAR(50),
    correo VARCHAR(100),
    salario DECIMAL(10,2),
    id_especialidad INT
);

CREATE TABLE Pacientes (
    id_paciente INT IDENTITY(1,1),
    nombre VARCHAR(50),
    correo VARCHAR(100),
    edad INT,
    fecha_registro DATETIME
);

CREATE TABLE Citas (
    id_cita INT IDENTITY(1,1),
    id_paciente INT,
    id_medico INT,
    fecha_cita DATETIME
);

CREATE TABLE Habitaciones (
    id_habitacion INT IDENTITY(1,1),
    numero_habitacion VARCHAR(10),
    id_paciente INT
);

CREATE TABLE Tratamientos (
    id_tratamiento INT IDENTITY(1,1),
    descripcion VARCHAR(250),
    id_paciente INT,
    estado VARCHAR(20)
);

CREATE TABLE Medicamentos (
    id_medicamento INT IDENTITY(1,1),
    nombre_medicamento VARCHAR(100),
    id_tratamiento INT,
    fecha_vencimiento DATE
);
GO