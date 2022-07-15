
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




-- Procedures

--counts the number of times pelicula_postulada_id_pelicula repeats from votos_postular and inserts the top 35 into postulacion
Create or replace PROCEDURE contar_nominacion (year Integer )
AS $$
    DECLARE
        pelicula_postulada_id_pelicula Integer;
        votos_postular_id_voto_postulado Integer;
        votos_postular_id_voto_postulado_count Integer;
        votos_postular_id_voto_postulado_count_max Integer;

    BEGIN
        FOR pelicula_postulada_id_pelicula IN (SELECT pelicula_postulada_id_pelicula FROM pelicula_postulada) LOOP
            votos_postular_id_voto_postulado_count_max := 0;
            FOR votos_postular_id_voto_postulado IN (SELECT votos_postular_id_voto_postulado FROM votos_postular WHERE pelicula_postulada_id_pelicula = pelicula_postulada_id_pelicula) LOOP
                votos_postular_id_voto_postulado_count := (SELECT COUNT(*) FROM votos_postular WHERE votos_postular_id_voto_postulado = votos_postular_id_voto_postulado);
                IF votos_postular_id_voto_postulado_count > votos_postular_id_voto_postulado_count_max THEN
                    votos_postular_id_voto_postulado_count_max := votos_postular_id_voto_postulado_count;
                END IF;
            END LOOP;
            INSERT INTO postulacion (pelicula_postulada_id_pelicula, votos_postular_id_voto_postulado_count) VALUES (pelicula_postulada_id_pelicula, votos_postular_id_voto_postulado_count_max);
        END LOOP;
    END;

-- counts the top 



-- Vistas
-- create vew for pelicula_postulada joined with votos_postular
CREATE VIEW pelicula_postulada_votos_postular AS




--Roles (seguridad)

Create role Miembro_Academia;
grant Miembro_Academia select on pelicula_postulada_votos_postular;






--Inserts