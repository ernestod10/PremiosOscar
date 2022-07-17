create or replace function votos_postular_fn() returns trigger as $vpTrigger$
    begin
        if (SELECT COUNT(*) FROM votos_postular WHERE miembro_academia_id_miembro = NEW.miembro_academia_id_miembro) > 1 then
            raise exception 'un miembro de academia no puede postular mas de 2 veces';
        end if;
    end;
    $vpTrigger$ language plpgsql;


Create  TRIGGER "VP_trigger" BEFORE INSERT ON "votos_postular"
FOR EACH ROW
execute procedure votos_postular_fn();
END;

create or replace function duplicado_postular() returns trigger as $postulacion_trigger$
    begin
        if (SELECT * FROM postulacion WHERE postulacion.pelicula_postulada_id_pelicula = NEW.pelicula_postulada_id_pelicula and
                                              postulacion.categoria_premio_id = NEW.categoria_premio_id)
               ||(SELECT * FROM postulacion WHERE postulacion.p_m_r_id_pelicula = NEW.pelicula_postulada_id_pelicula and
                                              postulacion.categoria_premio_id = NEW.categoria_premio_id)  then
            raise exception 'ya la pelicula en esa categoria esta postulada';
        end if;
    end;
    $postulacion_trigger$ language plpgsql;


Create  TRIGGER "postulacion_trigger" BEFORE INSERT ON "postulacion"
FOR EACH ROW
execute procedure duplicado_postular();
END;



--cuenta los votos de postulacion e inserta en nominados

Create or replace PROCEDURE votos_nominacion (year Integer )
AS $$
    DECLARE
    id_post Integer;
    id_cat integer;
    limite integer;
    BEGIN
    FOR id_cat in (select id from categoria_premio where nivel = 2)LOOP
        if (id_cat ==5) then --se cambia luego por el id de mejor pelicula
        limite=10;
            else
            limite =5;
        end if;
        For id_post in (select p.id from postulacion p inner join votos v on p.id = v.postulacion_id where  post_categoria_premio_id = id_cat and v.tipo = ('n') and p.año_oscar = year
                                          group by p.id
                                          order by count(v.postulacion_id)
                                          desc limit limite)
            LOOP
            insert into nominacion (ganador, postulacion_id_pelicula, post_categoria_premio_id, postulacion_id, postulacion_año_oscar)
            VALUES (FALSE,(select pelicula_postulada_id_pelicula from postulacion where id = id_post), id_cat,id_post,year);



        END LOOP;
    END LOOP;
    END;
$$
language plpgsql;

--cuenta los votos de nominados y hace update al ganador

Create or replace PROCEDURE votos_ganador (year Integer )
AS $$
    DECLARE
    id_post Integer;
    id_cat integer;

    BEGIN
    FOR id_cat in (select id from categoria_premio where nivel = 2)LOOP
        For id_post in (select n.postulacion_id from nominacion n inner join votos v on n.id = v.postulacion_id where  post_categoria_premio_id = id_cat and v.tipo = ('g') and n.postulacion_año_oscar = year
                                          group by n.id
                                          order by count(v.postulacion_id)
                                          desc limit 1)
            LOOP
            update nominacion set ganador = True where postulacion_id = id_post;



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