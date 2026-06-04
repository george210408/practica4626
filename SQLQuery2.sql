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



-- Primary Keys
ALTER TABLE Especialidades ADD CONSTRAINT PK_Especialidades PRIMARY KEY (id_especialidad);
ALTER TABLE Medicos ADD CONSTRAINT PK_Medicos PRIMARY KEY (id_medico);
ALTER TABLE Pacientes ADD CONSTRAINT PK_Pacientes PRIMARY KEY (id_paciente);
ALTER TABLE Citas ADD CONSTRAINT PK_Citas PRIMARY KEY (id_cita);
ALTER TABLE Habitaciones ADD CONSTRAINT PK_Habitaciones PRIMARY KEY (id_habitacion);
ALTER TABLE Tratamientos ADD CONSTRAINT PK_Tratamientos PRIMARY KEY (id_tratamiento);
ALTER TABLE Medicamentos ADD CONSTRAINT PK_Medicamentos PRIMARY KEY (id_medicamento);

-- Not Null
ALTER TABLE Pacientes ALTER COLUMN nombre VARCHAR(50) NOT NULL;
ALTER TABLE Medicos ALTER COLUMN nombre VARCHAR(50) NOT NULL;

-- Uniques
ALTER TABLE Pacientes ADD CONSTRAINT UQ_Pacientes_Correo UNIQUE (correo);
ALTER TABLE Medicos ADD CONSTRAINT UQ_Medicos_Correo UNIQUE (correo);

-- Checks
ALTER TABLE Pacientes ADD CONSTRAINT CK_Pacientes_Edad CHECK (edad >= 0);
ALTER TABLE Medicos ADD CONSTRAINT CK_Medicos_Salario CHECK (salario > 0);

-- Defaults
ALTER TABLE Pacientes ADD CONSTRAINT DF_Pacientes_FechaRegistro DEFAULT GETDATE() FOR fecha_registro;

-- Foreign Keys
ALTER TABLE Medicos ADD CONSTRAINT FK_Medicos_Especialidades 
    FOREIGN KEY (id_especialidad) REFERENCES Especialidades(id_especialidad);

ALTER TABLE Citas ADD CONSTRAINT FK_Citas_Pacientes 
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente);

ALTER TABLE Citas ADD CONSTRAINT FK_Citas_Medicos 
    FOREIGN KEY (id_medico) REFERENCES Medicos(id_medico);

ALTER TABLE Tratamientos ADD CONSTRAINT FK_Tratamientos_Pacientes 
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente);

ALTER TABLE Medicamentos ADD CONSTRAINT FK_Medicamentos_Tratamientos 
    FOREIGN KEY (id_tratamiento) REFERENCES Tratamientos(id_tratamiento);

ALTER TABLE Habitaciones ADD CONSTRAINT FK_Habitaciones_Pacientes 
    FOREIGN KEY (id_paciente) REFERENCES Pacientes(id_paciente);
GO

-- ============================================================================
-- MÓDULO III - MODIFICACIÓN DE ESTRUCTURAS (ALTER)
-- ============================================================================

-- Modificaciones en Pacientes
ALTER TABLE Pacientes ADD telefono VARCHAR(20);
ALTER TABLE Pacientes ADD direccion VARCHAR(100);
ALTER TABLE Pacientes ADD genero CHAR(1);
ALTER TABLE Pacientes ADD tipo_sangre VARCHAR(5);
ALTER TABLE Pacientes ADD fecha_nacimiento DATE;

ALTER TABLE Pacientes ALTER COLUMN nombre VARCHAR(150) NOT NULL;
ALTER TABLE Pacientes ALTER COLUMN direccion VARCHAR(250);

-- Modificaciones en Médicos
ALTER TABLE Medicos ADD experiencia INT;
ALTER TABLE Medicos ADD turno VARCHAR(20);
ALTER TABLE Medicos ADD observaciones VARCHAR(500);
ALTER TABLE Medicos DROP COLUMN observaciones; -- Se elimina según requerimiento de módulo III

-- Modificaciones en Citas
ALTER TABLE Citas ADD estado VARCHAR(20);
ALTER TABLE Citas ADD costo_consulta INT; -- Agregada inicialmente como INT
ALTER TABLE Citas ALTER COLUMN costo_consulta DECIMAL(10,2); -- Modificado tipo de dato

-- Modificaciones en Habitaciones
ALTER TABLE Habitaciones ADD disponibilidad BIT CONSTRAINT DF_Habitaciones_Disponibilidad DEFAULT 1;
GO

-- ============================================================================
-- MÓDULO IV - ELIMINACIÓN DE OBJETOS (DROP) DE PRUEBA
-- ============================================================================

-- 1. Eliminar una tabla temporal (creación y eliminación rápida)
CREATE TABLE #TemporalPrueba (id INT);
DROP TABLE #TemporalPrueba;

-- 2. Eliminar una restricción CHECK (creación y eliminación)
ALTER TABLE Pacientes ADD CONSTRAINT CK_Prueba_Borrar CHECK (edad < 150);
ALTER TABLE Pacientes DROP CONSTRAINT CK_Prueba_Borrar;

-- 3. Eliminar una restricción UNIQUE (creación y eliminación)
ALTER TABLE Pacientes ADD CONSTRAINT UQ_Prueba_Telefono UNIQUE (telefono);
ALTER TABLE Pacientes DROP CONSTRAINT UQ_Prueba_Telefono;

-- 4. Eliminar una columna (creación y eliminación)
ALTER TABLE Pacientes ADD columna_eliminar INT;
ALTER TABLE Pacientes DROP COLUMN columna_eliminar;

-- 5 y 9. Crear y eliminar tabla de pruebas / MedicamentosPrueba
CREATE TABLE MedicamentosPrueba (id INT);
DROP TABLE MedicamentosPrueba;

-- 6. Crear y eliminar tabla Auditoria
CREATE TABLE Auditoria (id_auditoria INT, fecha DATETIME);
DROP TABLE Auditoria;

-- 7. Crear y eliminar tabla Logs
CREATE TABLE Logs (id_log INT, mensaje VARCHAR(MAX));
DROP TABLE Logs;

-- 8. Eliminar una FOREIGN KEY (creación de una llave de prueba y su posterior eliminación)
ALTER TABLE Citas ADD id_prueba_fk INT;
ALTER TABLE Citas ADD CONSTRAINT FK_Prueba_Borrar FOREIGN KEY (id_prueba_fk) REFERENCES Pacientes(id_paciente);
ALTER TABLE Citas DROP CONSTRAINT FK_Prueba_Borrar;
ALTER TABLE Citas DROP COLUMN id_prueba_fk;

-- 10. Eliminar una base de datos de pruebas
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'DB_Pruebas_Borrar')
    DROP DATABASE DB_Pruebas_Borrar;
GO
-- Creamos una ficticia rápido y la borramos
CREATE DATABASE DB_Pruebas_Borrar;
GO
DROP DATABASE DB_Pruebas_Borrar;
GO