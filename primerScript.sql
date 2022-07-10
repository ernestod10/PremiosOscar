-- Tipo OO
CREATE TYPE hist_premios AS (
fechai	TIMESTAMP(0),
fechaf	TIMESTAMP(0),
nombre	VARCHAR(28),
cant_nominaciones  INTEGER
);

CREATE TYPE hist_donacion AS (
ano	INTEGER,
porcentaje	INTEGER,
monto	INTEGER
);



-- Main Script
CREATE TABLE a_c (
    categoria_premio_id             INTEGER NOT NULL, 
    miembro_academia_id_miembro     INTEGER NOT NULL,
    miembro_academia_doc_id         INTEGER NOT NULL
);

ALTER TABLE a_c
    ADD CONSTRAINT a_c_pk PRIMARY KEY ( categoria_premio_id,
                                        miembro_academia_id_miembroaacc,
                                        miembro_academia_doc_identidad );

CREATE TABLE categoria_premio (
    id                  INTEGER NOT NULL,
    nombre              VARCHAR(28) NOT NULL,
    nivel               INTEGER NOT NULL,
    rama                VARCHAR(28),
    descripcion         VARCHAR(28) NOT NULL,
    hist_premio         VARCHAR(28)
    ,
    categoria_premio_id INTEGER NOT NULL
);

ALTER TABLE categoria_premio ADD CONSTRAINT categoria_premio_pk PRIMARY KEY ( id );


CREATE TABLE ceremonia (
    año                   INTEGER NOT NULL,
    numero_edicion        INTEGER NOT NULL,
    fecha                 TIMESTAMP(0) NOT NULL,
    descripcion           VARCHAR(28),
    lugar                 VARCHAR(28) NOT NULL,
    persona_doc_identidad INTEGER NOT NULL,
    historico_premio	  hist_premio[]
);

ALTER TABLE ceremonia ADD CONSTRAINT ceremonia_pk PRIMARY KEY ( año );


CREATE TABLE critica (
    id       INTEGER NOT NULL,
    año      INTEGER NOT NULL,
    texto    VARCHAR(28) NOT NULL,
    negativa CHAR(1) NOT NULL
);

ALTER TABLE critica ADD CONSTRAINT critica_pk PRIMARY KEY ( id );


CREATE TABLE donacion_organizacion (
    id            INTEGER NOT NULL,
    nombre        VARCHAR(28) NOT NULL,
    mision        VARCHAR(28) NOT NULL,
    historico_donacion hist_donacion[]

);

ALTER TABLE donacion_organizacion ADD CONSTRAINT donacion_organizacion_pk PRIMARY KEY ( id );


CREATE TABLE miembro_academia (
    id_miembroaacc        INTEGER NOT NULL,
    fecha_i               TIMESTAMP(0) NOT NULL,
    fecha_f               TIMESTAMP(0),
    vitalicio             CHAR(1) NOT NULL,
    areas                 unknown 
,
    persona_doc_identidad INTEGER NOT NULL
);


CREATE UNIQUE INDEX miembro_academia__idx ON
    miembro_academia (
        persona_doc_identidad
    ASC );

ALTER TABLE miembro_academia ADD CONSTRAINT miembro_academia_pk PRIMARY KEY ( id_miembroaacc,
                                                                              persona_doc_identidad );


CREATE TABLE nominacion (
    id                              INTEGER NOT NULL,
    ganador                         CHAR(1) NOT NULL,
    postulacion_id_pelicula         INTEGER NOT NULL, 

    post_categoria_premio_id        INTEGER NOT NULL,
    postulacion_id_miembroaacc      INTEGER NOT NULL,
    postulacion_id                  INTEGER NOT NULL,
    postulacion_año_oscar           unknown 
,
    postulacion_doc_identidad1      INTEGER NOT NULL
);

ALTER TABLE nominacion
    ADD CONSTRAINT nominacion_pk PRIMARY KEY ( id,
                                               postulacion_id_pelicula,
                                               postulacion_categoria_premio_id,
                                               postulacion_id_miembroaacc,
                                               postulacion_id,
                                               postulacion_año_oscar,
                                               postulacion_doc_identidad1 );


CREATE TABLE p_m_r (
    pelicula_postulada_id_pelicula INTEGER NOT NULL,
    persona_doc_identidad          INTEGER NOT NULL,
    rol_id                         INTEGER NOT NULL,
    cancion_titulo                 unknown 


);

ALTER TABLE p_m_r
    ADD CONSTRAINT p_m_r_pk PRIMARY KEY ( pelicula_postulada_id_pelicula,
                                          persona_doc_identidad,
                                          rol_id );


CREATE TABLE pelicula_postulada (
    id_pelicula      INTEGER NOT NULL,
    nombre           VARCHAR(32) NOT NULL,
    titulo_original  VARCHAR(32) NOT NULL,
    sinopsis         TEXT NOT NULLL,
    año              INTEGER NOT NULL,
    genero           TEXT ARRAY[4],
    pais             TEXT ARRAY[4],
    distribuidor     TEXT ARRAY[4],
    duracion_min     INTEGER NOT NULL,
    censura          VARCHAR(28) NOT NULL,
    fecha_estreno_la TIMESTAMP(0) NOT NULL,
    total_nominaciones INTEGER,
    total_Premios    INTEGER	 
);

ALTER TABLE pelicula_postulada ADD CONSTRAINT pelicula_postulada_pk PRIMARY KEY ( id_pelicula );


CREATE TABLE persona (
    doc_identidad        INTEGER NOT NULL,
    nombre               VARCHAR(28) NOT NULL,
    fecha_nacimiento     INTEGER NOT NULL,
    apellido             VARCHAR(28) NOT NULL,
    2Nombre            CHAR(1),
    2Apellido          VARCHAR(28),
    fecha_defuncion      unknown ,
    fecha_inicio_carrera unknown 

);

ALTER TABLE persona ADD CONSTRAINT persona_pk PRIMARY KEY ( doc_identidad );


CREATE TABLE postulacion (
    id                              INTEGER NOT NULL,
    año_oscar                       unknown 
,
    pelicula_postulada_id_pelicula  INTEGER NOT NULL,
    categoria_premio_id             INTEGER NOT NULL, 

    miembro_academia_id_miembroa    INTEGER NOT NULL,
    p_m_r_id_pelicula               INTEGER NOT NULL,
    p_m_r_doc_identidad             INTEGER NOT NULL,
    p_m_r_rol_id                    INTEGER NOT NULL,
    miembro_academia_doc_identidad  INTEGER NOT NULL
);

ALTER TABLE postulacion
    ADD CONSTRAINT postulacion_pk PRIMARY KEY ( pelicula_postulada_id_pelicula,
                                                categoria_premio_id,
                                                miembro_academia_id_miembroaacc,
                                                miembro_academia_doc_identidad,
                                                id,
                                                año_oscar );


CREATE TABLE presentador (
    ceremonia_año         INTEGER NOT NULL,
    categoria_premio_id   INTEGER NOT NULL,
    persona_doc_identidad INTEGER NOT NULL
);

ALTER TABLE presentador
    ADD CONSTRAINT presentador_pk PRIMARY KEY ( ceremonia_año,
                                                categoria_premio_id,
                                                persona_doc_identidad );


CREATE TABLE rol (
    id          INTEGER NOT NULL,
    nombre      VARCHAR(28) NOT NULL,
    descripcion VARCHAR(28) NOT NULL
);

ALTER TABLE rol ADD CONSTRAINT rol_pk PRIMARY KEY ( id );


CREATE TABLE votos (
    id                                         INTEGER NOT NULL,
    fecha_hora                                 TIMESTAMP(0) NOT NULL,
    tipo                                       VARCHAR(1) NOT NULL,

    miembro_academia_id_miembro                INTEGER NOT NULL,
    nominacion_id                              INTEGER NOT NULL, 

    nominacion_post_id_pelicula                INTEGER NOT NULL, 
    nom_post_cat_premio_id                     INTEGER NOT NULL, 
    nominacion_postulacion_id_miemb            INTEGER NOT NULL,
    nominacion_postulacion_id                  INTEGER NOT NULL, 
    nominacion_postulacion_año_oscar           unknown 
,
    postulacion_id_pelicula                    INTEGER NOT NULL, 

    post_categoria_premio_id                   INTEGER NOT NULL,
    postulacion_id_miembroaacc                 INTEGER NOT NULL,
    postulacion_id                             INTEGER NOT NULL,
    postulacion_año_oscar                      unknown 
,
    postulacion_doc_identidad1                 INTEGER NOT NULL, 
    nom_post_doc_identidad1                    INTEGER NOT NULL,
    miembro_academia_doc_identidad             INTEGER NOT NULL
);

ALTER TABLE votos
    ADD CONSTRAINT votos_pk PRIMARY KEY ( miembro_academia_id_miembroaacc,
                                          id,
                                          nominacion_id,
                                          nominacion_postulacion_id_pelicula,
                                          nominacion_postulacion_categoria_premio_id,
                                          nominacion_postulacion_id_miembroaacc,
                                          nominacion_postulacion_id,
                                          nominacion_postulacion_año_oscar,
                                          nominacion_postulacion_doc_identidad1,
                                          postulacion_id_pelicula,
                                          postulacion_categoria_premio_id,
                                          postulacion_id_miembroaacc,
                                          postulacion_id,
                                          postulacion_año_oscar,
                                          postulacion_doc_identidad1 );


CREATE TABLE votos_postular (
    año                             VARCHAR(28) NOT NULL,
    pelicula_postulada_id_pelicula  INTEGER NOT NULL, 
    miembro_academia_id_miembro     INTEGER NOT NULL,
    miembro_academia_doc_identidad  INTEGER NOT NULL
);

ALTER TABLE votos_postular
    ADD CONSTRAINT votos_postular_pk PRIMARY KEY ( año,
                                                   pelicula_postulada_id_pelicula,
                                                   miembro_academia_id_miembroaacc,
                                                   miembro_academia_doc_identidad );

ALTER TABLE a_c
    ADD CONSTRAINT a_c_categoria_premio_fk FOREIGN KEY ( categoria_premio_id )
        REFERENCES categoria_premio ( id );

ALTER TABLE a_c
    ADD CONSTRAINT a_c_miembro_academia_fk FOREIGN KEY ( miembro_academia_id_miembroaacc,
                                                         miembro_academia_doc_identidad )
        REFERENCES miembro_academia ( id_miembroaacc,
                                      persona_doc_identidad );


ALTER TABLE categoria_premio
    ADD CONSTRAINT cat_premiofk FOREIGN KEY ( categoria_premio_id )
        REFERENCES categoria_premio ( id );

ALTER TABLE ceremonia
    ADD CONSTRAINT ceremonia_persona_fk FOREIGN KEY ( persona_doc_identidad )
        REFERENCES persona ( doc_identidad );

ALTER TABLE miembro_academia
    ADD CONSTRAINT miembro_academia_persona_fk FOREIGN KEY ( persona_doc_identidad )
        REFERENCES persona ( doc_identidad );

ALTER TABLE nominacion
    ADD CONSTRAINT nominacion_postulacion_fk FOREIGN KEY ( postulacion_id_pelicula,
                                                           postulacion_categoria_premio_id,
                                                           postulacion_id_miembroaacc,
                                                           postulacion_doc_identidad1,
                                                           postulacion_id,
                                                           postulacion_año_oscar )
        REFERENCES postulacion ( pelicula_postulada_id_pelicula,
                                 categoria_premio_id,
                                 miembro_academia_id_miembroaacc,
                                 miembro_academia_doc_identidad,
                                 id,
                                 año_oscar );

ALTER TABLE p_m_r
    ADD CONSTRAINT p_m_r_pelicula_postulada_fk FOREIGN KEY ( pelicula_postulada_id_pelicula )
        REFERENCES pelicula_postulada ( id_pelicula );

ALTER TABLE p_m_r
    ADD CONSTRAINT p_m_r_persona_fk FOREIGN KEY ( persona_doc_identidad )
        REFERENCES persona ( doc_identidad );

ALTER TABLE p_m_r
    ADD CONSTRAINT p_m_r_rol_fk FOREIGN KEY ( rol_id )
        REFERENCES rol ( id );

ALTER TABLE postulacion
    ADD CONSTRAINT post_categoria_premio_fk FOREIGN KEY ( categoria_premio_id )
        REFERENCES categoria_premio ( id );

ALTER TABLE postulacion
    ADD CONSTRAINT post_miembro_academia_fk FOREIGN KEY ( miembro_academia_id_miembroaacc,
                                                                 miembro_academia_doc_identidad )
        REFERENCES miembro_academia ( id_miembroaacc,
                                      persona_doc_identidad );

ALTER TABLE postulacion
    ADD CONSTRAINT postulacion_p_m_r_fk FOREIGN KEY ( p_m_r_id_pelicula,
                                                      p_m_r_doc_identidad,
                                                      p_m_r_rol_id )
        REFERENCES p_m_r ( pelicula_postulada_id_pelicula,
                           persona_doc_identidad,
                           rol_id );


ALTER TABLE postulacion
    ADD CONSTRAINT post_pelicula_postulada_fk FOREIGN KEY ( pelicula_postulada_id_pelicula )
        REFERENCES pelicula_postulada ( id_pelicula );

ALTER TABLE presentador
    ADD CONSTRAINT presentador_cat_premio_fk FOREIGN KEY ( categoria_premio_id )
        REFERENCES categoria_premio ( id );

ALTER TABLE presentador
    ADD CONSTRAINT presentador_ceremonia_fk FOREIGN KEY ( ceremonia_año )
        REFERENCES ceremonia ( año );

ALTER TABLE presentador
    ADD CONSTRAINT presentador_persona_fk FOREIGN KEY ( persona_doc_identidad )
        REFERENCES persona ( doc_identidad );

ALTER TABLE votos
    ADD CONSTRAINT votos_miembro_academia_fk FOREIGN KEY ( miembro_academia_id_miembroaacc,
                                                           miembro_academia_doc_identidad )
        REFERENCES miembro_academia ( id_miembroaacc,
                                      persona_doc_identidad );

ALTER TABLE votos
    ADD CONSTRAINT votos_nominacion_fk FOREIGN KEY ( nominacion_id,
                                                     nominacion_postulacion_id_pelicula,
                                                     nominacion_postulacion_categoria_premio_id,
                                                     nominacion_postulacion_id_miembroaacc,
                                                     nominacion_postulacion_id,
                                                     nominacion_postulacion_año_oscar,
                                                     nominacion_postulacion_doc_identidad1 )
        REFERENCES nominacion ( id,
                                postulacion_id_pelicula,
                                postulacion_categoria_premio_id,
                                postulacion_id_miembroaacc,
                                postulacion_id,
                                postulacion_año_oscar,
                                postulacion_doc_identidad1 );

ALTER TABLE votos
    ADD CONSTRAINT votos_postulacion_fk FOREIGN KEY ( postulacion_id_pelicula,
                                                      postulacion_categoria_premio_id,
                                                      postulacion_id_miembroaacc,
                                                      postulacion_doc_identidad1,
                                                      postulacion_id,
                                                      postulacion_año_oscar )
        REFERENCES postulacion ( pelicula_postulada_id_pelicula,
                                 categoria_premio_id,
                                 miembro_academia_id_miembroaacc,
                                 miembro_academia_doc_identidad,
                                 id,
                                 año_oscar );


ALTER TABLE votos_postular
    ADD CONSTRAINT VPmiembro_academia_fk FOREIGN KEY ( miembro_academia_id_miembroaacc,
                                                                    miembro_academia_doc_identidad )
        REFERENCES miembro_academia ( id_miembroaacc,
                                      persona_doc_identidad );


ALTER TABLE votos_postular
    ADD CONSTRAINT VPpelicula_postulada_fk FOREIGN KEY ( pelicula_postulada_id_pelicula )
        REFERENCES pelicula_postulada ( id_pelicula );

--Triggers





-- Procedures





--Roles (seguridad)






--Inserts