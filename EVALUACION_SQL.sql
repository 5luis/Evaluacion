-------SQL Y BASE DE DATOS------------------------------

Pregunta 1
CONDUCTOR

*clave_conductor Number
 Nombre String
 Apellidos String
 Fecha_nacimiento String
 Direccion String

CARRO
*clave_carro Number
 potencia   Number
 peso        Number
 velocidad   String

 ESCUDERIAS
*clave_escuderia Number  
*clave_conductor  Number
*clave_carro   Number
 nombre Strin


Pregunta 2
1) Obtener los alumnos ordenados por fecha de nacimiento de los más jóvenes a los más viejos.
SELECT nombre,fecha_nacimiento from alumnos order by fecha_nacimiento desc;
2) Obtener las materias que pertenezcan al área “Español”.
SELECT nombre from materias where area = 'ESPAÑOL';
3)Obtener la boleta del alumno con matrícula “A09998”. 
La boleta deberá tener el nombre completo (nombre y apellidos) del alumno, 
la clave y nombre de la materia, así como la calificación obtenida. 
No importa que el nombre del alumno se repita en cada registro. 
El ordenamiento deberá ser por nombre de materia.

SELECT  Alumnos.matricula
		,Alumnos.nombre
		,Alumnos.apellidos
		,Materias.clavemateria
		,Materias.nombre
		,Calificaciones.calificacion
		FROM Calificaciones 
		inner join Materias
		on Calificaciones.clave_materia = Materias.clave_materia
		inner join Alumnos  
		on  Calificaciones.matricula = Alumnos.matricula
		where Calificaciones.matricula = 'A09998' order by Materias.nombre;

4)Obtener el listado de alumnos inscritos. 
Por inscritos se entiende que cuentan con al menos una materia inscrita.
SELECT DISTINCT NOMBRE FROM ALUMNOS 

-----------------------------------------------------------------------------------------
a)Crear el registro del alumno Pedro Pérez, con fecha de nacimiento el 10 de octubre de 2001. 
  Su matrícula será “A09999”
INSERT INTO Alumnos values('A09999','PEDRO','PEREZ','10-10-2001');
b)Crear el registro de la materia “Introducción a la Programación”,
 del área “Computación”. Su clave será: “TI0001”.
INSERT INTO Materias values('TI0001','Introduccion a la programacion','Computacion');
c)Inscribir a Pedro en Introducción a la Programación con calificación de 88.
INSERT INTO Calificaciones values('A09999','TI0001','88');
d)Actualizar la calificación de Pedro a 92.
UPDATE Calificaciones SET calificacion = 92 where matricula='A09999';
e)Eliminar el registro de Pedro de la clase de Programación Avanzada.
DELETE FROM Calificaciones where clavemateria ='PA0001' AND matricula = 'A09999';


--- PROGRAMACION PL/SQL --

-- Pregunta 1
 Diseñe un procedimiento que reciba como entrada la clave de persona y la clave del puesto y actualice el puesto actual de la persona por el nuevo. 

DELIMITER $$ 
DROP PROCEDURE IF EXISTS `P_ActualizarPuesto`$$  
CREATE PROCEDURE `P_ActualizarPuesto` (IN clave_puesto INT,IN clave_personal INT) 
BEGIN 
update Personal set clave_puesto = clave_puesto where clave_personal = clave_personal; 
	END $$ 
DELIMITER ;
-- Pregunta 2
 Diseñe una función que reciba como entrada la clave de la persona y regrese como salida el sueldo actual de la persona.

DELIMITER $$
DROP FUNCTION IF EXISTS `F_Sueldo` $$
CREATE FUNCTION `F_Sueldo`(clave_personal int) returnS int(20)
DETERMINISTIC
BEGIN
  DECLARE sueldo int(20);
  SET sueldo = (SELECT  puesto.sueldo
		FROM Personal 
		inner join Puesto
		on Personal.clave_puesto = Puesto.clave_puesto
		where Personal.clave_personal = clave_personal order by  Puesto.clave_puesto desc  limit 1);
RETURN sueldo;
END $$
DELIMITER ;

-- Pregunta 3
Diseñe una función que genere una nueva persona. 
Deberá de recibir como entrada el nombre, apellido y fecha de nacimiento de la persona. 
Como salida deberá regresar la clave de la persona generada.
Las claves nuevas se deberán obtener buscando la máxima clave de persona existente y sumando uno.

DELIMITER $$
DROP FUNCTION IF EXISTS `F_insertarPersonal` $$
CREATE FUNCTION `F_insertarPersonal`(nombre varchar(50),
	    						   Apellidos varchar(50),
	    						   Fecha_nacimiento varchar(12)
	    						   ) RETURNS INT(11)
DETERMINISTIC
BEGIN
  DECLARE id INT;

  INSERT INTO Personal VALUES (NULL, nombre, Apellidos, Fecha_nacimiento,0);
  SET id = (SELECT LAST_INSERT_ID());
  RETURN id;
END $$
DELIMITER ;
