--trigger where votos_postular_id can't repeat more than 3 times 
Create or replace TRIGGER "votos_postular_trigger" BEFORE INSERT ON "votos_postular"
FOR EACH ROW
BEGIN
    SELECT raise_application_error('22023', 'un miembro de academia no puede postular a mas de 2 peliculas')
    WHERE NEW.votos_postular_id_voto_postulado IS NOT NULL AND
    (SELECT COUNT(*) FROM votos_postular WHERE miembro_academia_id_miembro = NEW.miembro_academia_id_miembro) > 1;
END;

Create or replace TRIGGER "votos_nominar_trigger" BEFORE INSERT ON "votos"
FOR EACH ROW
BEGIN
    SELECT raise_application_error('22023', 'un miembro de academia no puede postular a mas de 2 peliculas')
    WHERE NEW.votos_postular_id_voto_postulado IS NOT NULL AND
    (SELECT COUNT(*) FROM Votos WHERE miembro_academia_id_miembro = NEW.miembro_academia_id_miembro) > 1 and ;
END;

Create or replace TRIGGER "votos_ganador_trigger" BEFORE INSERT ON "votos"
FOR EACH ROW
BEGIN
    SELECT raise_application_error('22023', 'un miembro de academia no puede postular a mas de 2 peliculas')
    WHERE NEW.votos_postular_id_voto_postulado IS NOT NULL AND
    (SELECT COUNT(*) FROM Votos WHERE miembro_academia_id_miembro = NEW.miembro_academia_id_miembro) > 1 AND;
END;

--trigger where votos_postular_id can't repeat more than 3 times 


-- Procedures

--counts the number of times pelicula_postulada_id_pelicula repeats from votos_postular and inserts the top 35 into postulacion
Create or replace PROCEDURE contar_nominacion (year Integer )
    BEGIN
        DECLARE votos_postular_id_pelicula_count INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_2 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_3 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_4 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_5 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_6 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_7 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_8 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_9 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_10 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_11 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_12 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_13 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_14 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_15 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_16 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_17 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_18 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_19 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_20 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_21 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_22 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_23 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_24 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_25 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_26 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_27 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_28 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_29 INTEGER;
        DECLARE votos_postular_id_pelicula_count_temp_30 INTEGER;
            
END


        


        





-- Vistas
-- create vew for pelicula_postulada joined with votos_postular
CREATE VIEW pelicula_postulada_votos_postular AS




--Roles (seguridad)

Create role Miembro_Academia;
grant Miembro_Academia select on pelicula_postulada_votos_postular;






--Inserts