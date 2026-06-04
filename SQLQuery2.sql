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

-- ============================================================================
-- MÓDULO V - INSERT (POBLADO DE DATOS)
-- ============================================================================

-- 1. Insertar 5 especialidades médicas
INSERT INTO Especialidades (nombre) VALUES 
('Cardiología'), ('Pediatría'), ('Medicina General'), ('Neurología'), ('Dermatología');

-- 2. Insertar 10 médicos
INSERT INTO Medicos (nombre, correo, salario, id_especialidad, experiencia, turno) VALUES
('Dr. Carlos Mendieta', 'carlos.m@hospital.com', 4500.00, 1, 10, 'Mañana'),
('Dra. Ana Gutiérrez', 'ana.g@hospital.com', 4200.00, 2, 8, 'Tarde'),
('Dr. Luis Ortega', 'luis.o@hospital.com', 3500.00, 3, 5, 'Mañana'),
('Dra. Sofia Rostran', 'sofia.r@hospital.com', 5000.00, 4, 12, 'Noche'),
('Dr. Roberto Blandón', 'roberto.b@hospital.com', 4000.00, 5, 7, 'Tarde'),
('Dra. Elena Espinoza', 'elena.e@hospital.com', 3600.00, 3, 4, 'Noche'),
('Dr. Sergio Torres', 'sergio.t@hospital.com', 4600.00, 1, 11, 'Tarde'),
('Dra. Lucia Méndez', 'lucia.m@hospital.com', 4300.00, 2, 9, 'Mañana'),
('Dr. Gabriel Núñez', 'gabriel.n@hospital.com', 5200.00, 4, 15, 'Mañana'),
('Dra. Vanesa Castillo', 'vanesa.c@hospital.com', 4100.00, 5, 6, 'Noche');

-- 3. Insertar 20 pacientes (Se incluyen variaciones solicitadas en el módulo V)
-- Nota: Usamos el formato explícito de campos requeridos
INSERT INTO Pacientes (nombre, correo, edad, fecha_registro, telefono, direccion, genero, tipo_sangre, fecha_nacimiento) VALUES
('Juan Pérez', 'juan.perez@mail.com', 34, '2026-01-10', '8888-1111', 'Managua, Colonial', 'M', 'O+', '1992-05-12'),
('María López', 'maria.lopez@mail.com', 28, '2026-02-15', '8888-2222', 'Masaya, Centro', 'F', 'A+', '1998-08-22'),
('Pedro Martínez', 'pedro.m@mail.com', 45, '2026-03-01', '8888-3333', 'Granada', 'M', 'B+', '1981-02-03'),
('Carmen Gómez', 'carmen.g@mail.com', 60, GETDATE(), '8888-4444', 'Leon, Subtiava', 'F', 'O-', '1966-11-30'),
('José Rodas', 'jose.rodas@mail.com', 12, GETDATE(), '8888-5555', 'Carazo', 'M', 'AB+', '2014-04-15'),
('Francisca Blandón', 'fran.b@mail.com', 19, GETDATE(), '8888-6666', 'Chandega', 'F', 'O+', '2007-01-12'),
('Arlen Silva', 'arlen.s@mail.com', 31, GETDATE(), '8888-7777', 'Estelí', 'F', 'A-', '1995-09-05'),
('Marcos Juárez', 'marcos.j@mail.com', 50, GETDATE(), '8888-8888', 'Matagalpa', 'M', 'O+', '1976-06-18'),
('Rebeca Tinoco', 'rebeca.t@mail.com', 23, GETDATE(), '8888-9999', 'Jinotega', 'F', 'B-', '2003-10-25'),
('Kevin Pastora', 'kevin.p@mail.com', 40, GETDATE(), '8888-0000', 'Managua, Altamira', 'M', 'O+', '1986-07-14'),
-- Pacientes adicionales para completar los 20 requeridos y pruebas de eliminaciones futuras
('Fabiola Ruiz', 'fabiola.r@mail.com', 25, GETDATE(), '7777-1111', 'Rivas', 'F', 'A+', '2001-03-03'),
('Hugo Sánchez', 'hugo.s@mail.com', 67, GETDATE(), '7777-2222', 'Boaco', 'M', 'O+', '1959-12-12'),
('Tatiana Solís', 'tatiana.s@mail.com', 29, GETDATE(), '7777-3333', 'Juigalpa', 'F', 'AB-', '1997-02-28'),
('Walter Meza', 'walter.m@mail.com', 55, GETDATE(), '7777-4444', 'Somoto', 'M', 'B+', '1971-05-19'),
('Ligia Flores', 'ligia.f@mail.com', 38, GETDATE(), '7777-5555', 'Ocotal', 'F', 'O+', '1988-04-04'),
('Ramiro Pastrán', 'ramiro.p@mail.com', 72, GETDATE(), '7777-6666', 'Bluefields', 'M', 'A+', '1954-08-09'),
('Sonia Benavidez', 'sonia.b@mail.com', 48, GETDATE(), '7777-7777', 'Bilwi', 'F', 'O-', '1978-01-20'),
('Tomas Jirón', 'tomas.j@mail.com', 33, GETDATE(), '7777-8888', 'San Carlos', 'M', 'O+', '1993-11-11'),
('Diana Lacayo', 'diana.l@mail.com', 22, GETDATE(), '7777-9999', 'Managua', 'F', 'B+', '2004-05-24'),
('Oscar Danilo', 'oscar.d@mail.com', 61, GETDATE(), '7777-0000', 'Masaya', 'M', 'O+', '1965-09-02');

-- 4. Insertar 15 citas (Citas con fecha actual, pasadas y futuras para pruebas)
INSERT INTO Citas (id_paciente, id_medico, fecha_cita, estado, costo_consulta) VALUES
(1, 1, GETDATE(), 'Completada', 50.00),                       -- Fecha Actual
(2, 2, GETDATE(), 'Completada', 40.00),                       -- Fecha Actual
(3, 3, DATEADD(DAY, 5, GETDATE()), 'Programada', 30.00),      -- Futura
(4, 4, DATEADD(DAY, 10, GETDATE()), 'Programada', 60.00),     -- Futura
(5, 5, DATEADD(DAY, 2, GETDATE()), 'Programada', 45.00),      -- Futura
(6, 6, DATEADD(DAY, -1, GETDATE()), 'Cancelada', 30.00),      -- Cancelada (Para borrar luego)
(7, 7, DATEADD(DAY, 3, GETDATE()), 'Programada', 50.00),
(8, 8, DATEADD(DAY, 6, GETDATE()), 'Programada', 40.00),
(9, 9, DATEADD(DAY, -2, GETDATE()), 'Cancelada', 60.00),      -- Cancelada (Para borrar luego)
(10, 10, DATEADD(DAY, 1, GETDATE()), 'Programada', 45.00),
(1, 2, DATEADD(DAY, 12, GETDATE()), 'Programada', 40.00),
(2, 4, DATEADD(DAY, 15, GETDATE()), 'Programada', 60.00),
(3, 1, GETDATE(), 'Programada', 50.00),                       -- Fecha Actual
(4, 7, DATEADD(DAY, 20, GETDATE()), 'Programada', 50.00),
(5, 10, DATEADD(DAY, -5, GETDATE()), 'No Asistió', 45.00);

-- 5. Insertar 10 habitaciones (Mezcla de disponibles = 1 y ocupadas = 0)
INSERT INTO Habitaciones (numero_habitacion, id_paciente, disponibilidad) VALUES
('101A', 1, 0), -- Ocupada
('101B', NULL, 1), -- Disponible
('102A', 2, 0), -- Ocupada
('102B', NULL, 1), -- Disponible
('201A', 3, 0), -- Ocupada
('201B', NULL, 1), -- Disponible
('202A', NULL, 1), -- Disponible
('202B', NULL, 1), -- Disponible
('301A', NULL, 1), -- Disponible
('302A', NULL, 1); -- Disponible

-- 6. Insertar 10 tratamientos (Activos e Inactivos/Finalizados)
INSERT INTO Tratamientos (descripcion, id_paciente, estado) VALUES
('Tratamiento Hipertensión Crónica', 1, 'Activo'),
('Control de Fiebre Infantil', 5, 'Finalizado'),
('Rehabilitación Post-Infarto', 3, 'Activo'),
('Terapia Migraña Severa', 4, 'Activo'),
('Tratamiento Dermatitis Atópica', 2, 'Finalizado'),
('Seguimiento Diabetes Tipo II', 8, 'Activo'),
('Control de Asma Tratamiento Inicial', 6, 'Activo'),
('Recuperación Quirúrgica Rodilla', 10, 'Finalizado'),
('Terapia Antidepresiva Evaluativa', 7, 'Activo'),
('Tratamiento de Gastritis Aguda', 9, 'Finalizado');

-- 7. Insertar 20 medicamentos
INSERT INTO Medicamentos (nombre_medicamento, id_tratamiento, fecha_vencimiento) VALUES
('Enalapril 20mg', 1, '2028-12-31'),
('Amoxicilina 500mg', 2, '2027-05-15'),
('Aspirina 100mg', 3, '2029-01-01'),
('Sumatriptán 50mg', 4, '2027-09-20'),
('Betametasona Crema', 5, '2026-11-18'),
('Metformina 850mg', 6, '2028-06-14'),
('Salbutamol Inhalador', 7, '2027-03-22'),
('Ibuprofeno 400mg', 8, '2024-05-10'), -- Ya Vencido (Para borrar luego)
('Sertralina 50mg', 9, '2028-02-28'),
('Omeprazol 20mg', 10, '2025-12-01'), -- Ya Vencido (Para borrar luego)
('Losartán 50mg', 1, '2028-10-30'),
('Paracetamol 500mg', 2, '2027-08-12'),
('Clopidogrel 75mg', 3, '2028-04-11'),
('Propranolol 40mg', 4, '2027-07-19'),
('Hidrocortisona Crema', 5, '2026-10-05'),
('Glibenclamida 5mg', 6, '2028-01-15'),
('Bromuro de Ipratropio', 7, '2027-11-21'),
('Acetaminofén IV', 8, '2024-01-01'),    -- Ya Vencido (Para borrar luego)
('Clonazepam 2mg', 9, '2028-09-09'),
('Pantoprazol 40mg', 10, '2025-06-15'); -- Ya Vencido (Para borrar luego)
GO

-- ============================================================================
-- MÓDULO VI - UPDATE (ACTUALIZACIONES)
-- ============================================================================

-- 1. Actualizar teléfono de un paciente
UPDATE Pacientes SET telefono = '8999-5555' WHERE id_paciente = 1;

-- 2. Actualizar dirección de un paciente
UPDATE Pacientes SET direccion = 'Managua, Bello Horizonte' WHERE id_paciente = 2;

-- 3. Actualizar salario de un médico
UPDATE Medicos SET salario = 4800.00 WHERE id_medico = 1;

-- 4. Actualizar turno de un médico
UPDATE Medicos SET turno = 'Noche' WHERE id_medico = 3;

-- 5. Cambiar estado de una cita
UPDATE Citas SET estado = 'Completada' WHERE id_cita = 3;

-- 6. Actualizar costo de consulta
UPDATE Citas SET costo_consulta = 55.00 WHERE id_cita = 1;

-- 7. Actualizar nombre de especialidad
UPDATE Especialidades SET nombre = 'Cardiología Avanzada' WHERE id_especialidad = 1;

-- 8. Actualizar disponibilidad de habitación
UPDATE Habitaciones SET disponibilidad = 0, id_paciente = 4 WHERE numero_habitacion = '101B';

-- 9. Actualizar tratamiento activo
UPDATE Tratamientos SET descripcion = 'Tratamiento Hipertensión Crónica y Dieta' WHERE id_tratamiento = 1;

-- 10. Actualizar medicamento
UPDATE Medicamentos SET nombre_medicamento = 'Enalapril Maleato 20mg' WHERE id_medicamento = 1;

-- 11. Actualizar correo de paciente
UPDATE Pacientes SET correo = 'juan.perez.nuevo@mail.com' WHERE id_paciente = 1;

-- 12. Actualizar correo de médico
UPDATE Medicos SET correo = 'carlos.mendieta@hospital.com' WHERE id_medico = 1;

-- 13. Actualizar fecha de cita
UPDATE Citas SET fecha_cita = DATEADD(DAY, 1, fecha_cita) WHERE id_cita = 4;

-- 14. Actualizar experiencia del médico
UPDATE Medicos SET experiencia = 11 WHERE id_medico = 1;

-- 15. Actualizar tipo de sangre
UPDATE Pacientes SET tipo_sangre = 'O-' WHERE id_paciente = 2;
GO

-- ============================================================================
-- MÓDULO VII - DELETE (ELIMINACIÓN DE REGISTROS)
-- ============================================================================

-- Nota: Para respetar la integridad referencial (Foreign Keys), se borran primero 
-- las dependencias de los registros específicos que se van a eliminar.

-- 1. Eliminar un paciente específico (id_paciente = 20, no tiene dependencias críticas creadas)
DELETE FROM Pacientes WHERE id_paciente = 20;

-- 2. Eliminar una cita específica
DELETE FROM Citas WHERE id_cita = 15;

-- 3. Eliminar un medicamento
DELETE FROM Medicamentos WHERE id_medicamento = 11;

-- 4. Eliminar una habitación
DELETE FROM Habitaciones WHERE id_habitacion = 10;

-- 5. Eliminar un tratamiento específico (id_tratamiento = 10 tiene medicamentos vencidos, los borramos primero)
DELETE FROM Medicamentos WHERE id_tratamiento = 10;
DELETE FROM Tratamientos WHERE id_tratamiento = 10;

-- 6. Eliminar citas canceladas
DELETE FROM Citas WHERE estado = 'Cancelada';

-- 7. Eliminar pacientes sin citas (Aquellos que no tengan registros en la tabla Citas)
DELETE FROM Habitaciones WHERE id_paciente IN (SELECT id_paciente FROM Pacientes WHERE id_paciente NOT IN (SELECT id_paciente FROM Citas));
DELETE FROM Medicamentos WHERE id_tratamiento IN (SELECT id_tratamiento FROM Tratamientos WHERE id_paciente NOT IN (SELECT id_paciente FROM Citas));
DELETE FROM Tratamientos WHERE id_paciente NOT IN (SELECT id_paciente FROM Citas);
DELETE FROM Pacientes WHERE id_paciente NOT IN (SELECT id_paciente FROM Citas);

-- 8. Eliminar habitaciones vacías (disponibles)
DELETE FROM Habitaciones WHERE disponibilidad = 1;

-- 9. Eliminar medicamentos vencidos (A la fecha actual del sistema)
DELETE FROM Medicamentos WHERE fecha_vencimiento < GETDATE();

-- 10. Eliminar registros de prueba (Ejemplo de purga conceptual en cascada si existieran remanentes)
-- (Ya se ejecutó arriba al limpiar pacientes sin citas y cascadas controladas).
GO

-- ============================================================================
-- MÓDULO VIII - CONSULTAS SELECT
-- ============================================================================

-- 1. Mostrar todos los pacientes
SELECT * FROM Pacientes;

-- 2. Mostrar todos los médicos
SELECT * FROM Medicos;

-- 3. Mostrar todas las especialidades
SELECT * FROM Especialidades;

-- 4. Mostrar todas las citas
SELECT * FROM Citas;

-- 5. Mostrar pacientes ordenados por apellido (Asumiendo primer orden jerárquico por nombre/campo actual)
SELECT * FROM Pacientes 
ORDER BY nombre ASC;

-- 6. Mostrar médicos ordenados por salario (De mayor a menor)
SELECT * FROM Medicos 
ORDER BY salario DESC;

-- 7. Mostrar citas del día actual
SELECT * FROM Citas 
WHERE CAST(fecha_cita AS DATE) = CAST(GETDATE() AS DATE);

-- 8. Mostrar habitaciones disponibles (Dado que borramos las disponibles en el Módulo VII, esta consulta devolverá vacío o las remanentes)
SELECT * FROM Habitaciones 
WHERE disponibilidad = 1;

-- 9. Mostrar cantidad de pacientes registrados
SELECT COUNT(*) AS TotalPacientes 
FROM Pacientes;

-- 10. Mostrar cantidad de citas por médico
SELECT M.nombre AS Medico, COUNT(C.id_cita) AS CantidadCitas
FROM Medicos M
LEFT JOIN Citas C ON M.id_medico = C.id_medico
GROUP BY M.nombre;
GO