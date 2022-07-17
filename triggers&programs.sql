create or replace function votos_postular_fn() returns trigger as $vpTrigger$
    begin
        if (SELECT COUNT(*) FROM votos_postular WHERE miembro_academia_id_miembro = NEW.miembro_academia_id_miembro) > 2 then
            raise exception 'un miembro de academia no puede postular mas de 3 peliculas';
        end if;
    end;



    $vpTrigger$ language plpgsql;


Create  TRIGGER "VP_trigger" BEFORE INSERT ON "votos_postular"
FOR EACH ROW
execute procedure votos_postular_fn();
END;




Create or replace PROCEDURE contar_nominacion (year Integer )
AS $$
    DECLARE
    id_post Integer;
    id_cat integer;
    BEGIN
    FOR id_cat in (select id from categoria_premio where nivel = 2)LOOP
        For id_post in (select p.id from postulacion p inner join votos v on p.id = v.postulacion_id where  post_categoria_premio_id = id_cat
                                          group by p.id
                                          order by count(v.postulacion_id)
                                          desc limit 10) LOOP
        insert into nominacion (id, ganador, postulacion_id_pelicula, post_categoria_premio_id, postulacion_id_miembroaacc, postulacion_id, postulacion_año_oscar, postulacion_doc_identidad1)
        VALUES (1,false,(select pelicula_postulada_id_pelicula from postulacion where id = id_post),id_cat,(select miembro_academia_id_maacc from postulacion where id = id_post),id_post, year,(select miembro_academia_doc_identidad from postulacion where id = id_post));
        END LOOP;
    END LOOP;
    END;
$$
language plpgsql;






-- Vistas
-- create vew for pelicula_postulada joined with votos_postular
CREATE VIEW pelicula_postulada_votos_postular AS




--Roles (seguridad)

Create role Miembro_Academia;
grant Miembro_Academia select on pelicula_postulada_votos_postular;






--Inserts