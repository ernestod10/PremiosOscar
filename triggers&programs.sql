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
--------------------------------------------------------------------------------------------------------------------
create or replace function duplicado_postular_trigger() returns trigger as $postulacion_trigger$
    begin
        if (SELECT * FROM postulacion WHERE postulacion.pelicula_postulada_id_pelicula = NEW.pelicula_postulada_id_pelicula and
                                              postulacion.categoria_premio_id = NEW.categoria_premio_id)
               ||(SELECT * FROM postulacion WHERE postulacion.p_m_r_id_pelicula = NEW.pelicula_postulada_id_pelicula and
                                              postulacion.categoria_premio_id = NEW.categoria_premio_id)  then
            raise exception 'ya la pelicula en esa categoria esta postulada';
        end if;
    end;
    $$ language plpgsql;
Create  TRIGGER "duplicado_trigger" BEFORE INSERT ON "postulacion"
FOR EACH ROW
execute procedure duplicado_postular_trigger();
END;
--------------------------------------------------------------------------------------------------------------------
create or replace function postulacion_trigger() returns trigger as $$
    begin
       insert into votos_postular (anio, pelicula_postulada_id_pelicula, miembro_academia_id_miembro, miembro_academia_doc_identidad) VALUES 
                                                                                                                                          (new.anio_oscar,new.pelicula_postulada_id_pelicula,new.miembro_academia_id_maacc,new.miembro_academia_doc_identidad);
    end;
    $$ language plpgsql;
Create  TRIGGER "postulacion_trigger" after INSERT ON "postulacion"
FOR EACH ROW
execute procedure postulacion();
END;


create or replace function verificar_categoria() returns trigger as $vpTrigger$
    declare
        duplicado boolean;
        id_categoria integer;

    begin
        for id_categoria in (select a_c.categoria_premio_id from a_c where miembro_academia_id_miembro = New.miembro_academia_id_maacc) loop
            if (select id from postulacion where (pelicula_postulada_id_pelicula = new.pelicula_postulada_id_pelicula or (p_m_r_id_pelicula = new.p_m_r_id_pelicula and  p_m_r_doc_identidad = new.p_m_r_doc_identidad) )and id_categoria = new.categoria_premio_id ) then
            duplicado = true;
            end if;

            end loop;


        if (duplicado) then
            raise exception 'ya esta pelicula esta postulada para esta categoria';
        end if;
    end;
    $vpTrigger$ language plpgsql;
Create  TRIGGER "postulacion_duplicado_trigger" BEFORE INSERT or update ON "postulacion"
FOR EACH ROW
execute procedure verificar_categoria();
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
        if (id_cat ==16) then --se cambia luego por el id de mejor pelicula
        limite=10;
            else
            limite =5;
        end if;
        For id_post in (select p.id from postulacion p inner join votos v on p.id = v.postulacion_id where  post_categoria_premio_id = id_cat and v.tipo = ('n') and p.anio_oscar = year
                                          group by p.id
                                          order by count(v.postulacion_id)
                                          desc limit limite)
            LOOP
            insert into nominacion (ganador, post_categoria_premio_id, postulacion_id_miembroaacc, postulacion_id, postulacion_año_oscar, postulacion_doc_identidad)

            VALUES (FALSE, id_cat,(select miembro_academia_id_maacc from postulacion where postulacion.id = id_post),id_post,year,(select miembro_academia_doc_identidad from postulacion where postulacion.id = id_post));
            update pelicula_postulada  set total_nominaciones = total_nominaciones+1 where id_pelicula = (select pelicula_postulada_id_pelicula from postulacion where id = id_post);
        END LOOP;
    END LOOP;
    END;
$$
language plpgsql;
--cuenta los votos de nominados y hace update al ganador

Create or replace PROCEDURE votos_ganador (year Integer )
AS $$
    DECLARE
    id_nom Integer;
    id_cat integer;

    BEGIN
    FOR id_cat in (select id from categoria_premio where nivel = 2)LOOP
        For id_nom in (select n.id from nominacion n inner join votos v on n.id = v.nominacion_id where  post_categoria_premio_id = id_cat and v.tipo = ('g') and n.postulacion_año_oscar = year
                                          group by n.id
                                          order by count(v.nominacion_id)
                                          desc limit 1)
            LOOP
            update nominacion set ganador = True where id = id_nom;
            update pelicula_postulada  set total_premios = total_premios+1 where id_pelicula = (select pelicula_postulada_id_pelicula from postulacion where id = (select postulacion_id from nominacion  ) ) or id_pelicula =(select p_m_r_id_pelicula from postulacion);
        END LOOP;
    END LOOP;
    END;
$$
language plpgsql;





-- Vistas
-- create vew for pelicula_postulada joined with votos_postular



--Roles (seguridad)
--cuenta de administrador





--Cuentas de usuario final
Create role Miembro_Academia;
grant Miembro_Academia select on pelicula_postulada;
grant Miembro_Academia insert on pelicula_postulada;
grant Miembro_Academia select on postulacion;
grant Miembro_Academia select on nominacion;
grant miembro_academia insert on votos;
grant miembro_academia insert on postulacion;

create role Administrador_academia;
grant Administrador_academia execute on votos_nominacion;
grant Administrador_academia execute on votos_ganador;





--Inserts