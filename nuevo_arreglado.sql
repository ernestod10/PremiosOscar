CREATE TYPE hist_premios AS (
fechai	DATE,
fechaf	DATE,
nombre	VARCHAR(28),
cant_nominaciones  INTEGER
);

CREATE TYPE hist_donacion AS (
anio	INTEGER,
porcentaje	INTEGER,
monto	INTEGER
);

CREATE TYPE areas AS (
nombre VARCHAR(28)
);

CREATE TYPE cancion AS(
nombre VARCHAR(28),
anio INTEGER,
compositor VARCHAR(28)
);



-- Main Script
CREATE TABLE a_c (
    categoria_premio_id             INTEGER NOT NULL,
    miembro_academia_id_miembro     INTEGER NOT NULL,
    miembro_academia_doc_id         INTEGER NOT NULL
);

ALTER TABLE a_c
    ADD CONSTRAINT a_c_pk PRIMARY KEY ( categoria_premio_id,
                                        miembro_academia_id_miembro,
                                        miembro_academia_doc_id );

CREATE TABLE categoria_premio (
    id                  serial not null,
    nombre              VARCHAR(50) NOT NULL,
    nivel               INTEGER NOT NULL,
    descripcion         TEXT NOT NULL,
    categoria_premio_id INTEGER,
    historico_premio	hist_premios ARRAY[100]
);

ALTER TABLE categoria_premio ADD CONSTRAINT categoria_premio_pk PRIMARY KEY ( id );



CREATE TABLE ceremonia (
    anio                   INTEGER NOT NULL,
    numero_edicion        INTEGER NOT NULL,
    fecha                 DATE NOT NULL,
    descripcion           TEXT,
    lugar                 VARCHAR(28) NOT NULL,
    persona_doc_identidad INTEGER NOT NULL

);

ALTER TABLE ceremonia ADD CONSTRAINT ceremonia_pk PRIMARY KEY ( anio );


CREATE TABLE critica (
    id     serial not null,
    anio  INTEGER NOT NULL,
    texto    TEXT NOT NULL,
    negativa CHAR(1) NOT NULL
);




ALTER TABLE critica ADD CONSTRAINT critica_pk PRIMARY KEY ( id );


CREATE TABLE donacion_organizacion (
    id            serial not null,
    nombre        VARCHAR(50) NOT NULL,
    mision        TEXT NOT NULL,
    historico_donacion hist_donacion ARRAY[100]

);

ALTER TABLE donacion_organizacion ADD CONSTRAINT donacion_organizacion_pk PRIMARY KEY ( id );



CREATE TABLE miembro_academia (
    id_miembroaacc        serial not null,
    fecha_i               DATE NOT NULL,
    fecha_f               DATE,
    vitalicio             VARCHAR(3) NOT NULL,
    area                  TEXT ARRAY[5]
,
    persona_doc_identidad INTEGER NOT NULL,
    CONSTRAINT Chk_vitalicio CHECK (vitalicio IN ('SI', 'NO'))
);




CREATE UNIQUE INDEX miembro_academia__idx ON
    miembro_academia (
        persona_doc_identidad
    ASC );

ALTER TABLE miembro_academia ADD CONSTRAINT miembro_academia_pk PRIMARY KEY ( id_miembroaacc,
                                                                              persona_doc_identidad );


CREATE TABLE nominacion (
    id          serial not null,
    ganador                         CHAR(1) NOT NULL,

    post_categoria_premio_id        INTEGER NOT NULL,
    postulacion_id_miembroaacc      INTEGER NOT NULL,
    postulacion_id                  INTEGER NOT NULL,
    postulacion_año_oscar           INTEGER NOT NULL,
    postulacion_doc_identidad     INTEGER NOT NULL
);

ALTER TABLE nominacion
    ADD CONSTRAINT nominacion_pk PRIMARY KEY ( id,
                                               
                                               post_categoria_premio_id,
                                               postulacion_id_miembroaacc,
                                               postulacion_id,
                                               postulacion_año_oscar,
                                               postulacion_doc_identidad );


CREATE TABLE p_m_r (
    pelicula_postulada_id_pelicula INTEGER NOT NULL,
    persona_doc_identidad          INTEGER NOT NULL,
    rol_id                         INTEGER NOT NULL,
    cancion_p_m_r 			   cancion
);

ALTER TABLE p_m_r
    ADD CONSTRAINT p_m_r_pk PRIMARY KEY ( pelicula_postulada_id_pelicula,
                                          persona_doc_identidad,
                                          rol_id );


CREATE TABLE pelicula_postulada (
    id_pelicula      serial not null,
    nombre           VARCHAR(50) NOT NULL,
    titulo_original  VARCHAR(50) NOT NULL,
    sinopsis         TEXT NOT NULL,
    anio              INTEGER NOT NULL,
    genero           TEXT ARRAY[4],
    pais             TEXT ARRAY[4],
    distribuidor     VARCHAR(50) NOT NULL,
    duracion_min     INTEGER NOT NULL,
    censura          VARCHAR(28) NOT NULL,
    fecha_estreno_la DATE NOT NULL,
    total_nominaciones INTEGER,
    total_Premios    INTEGER,
    foto             TEXT
);

ALTER TABLE pelicula_postulada ADD CONSTRAINT pelicula_postulada_pk PRIMARY KEY ( id_pelicula );


CREATE TABLE persona (
    doc_identidad        INTEGER NOT NULL,
    nombre               VARCHAR(28) NOT NULL,
    fecha_nacimiento     DATE NOT NULL,
    apellido             VARCHAR(28) NOT NULL,
    segundo_Nombre       VARCHAR(28),
    segundo_Apellido     VARCHAR(28),
    fecha_defuncion      DATE ,
    fecha_inicio_carrera DATE,
    sexo                 VARCHAR(3) NOT NULL,
    CONSTRAINT Chk_sexo CHECK (sexo IN ('M', 'F'))

);

ALTER TABLE persona ADD CONSTRAINT persona_pk PRIMARY KEY ( doc_identidad );


CREATE TABLE postulacion (
    id                              serial not null,
    anio_oscar                       INTEGER NOT NULL,
    pelicula_postulada_id_pelicula  INTEGER NOT NULL,
    categoria_premio_id             INTEGER NOT NULL,

    miembro_academia_id_maacc       INTEGER NOT NULL,
    p_m_r_id_pelicula               INTEGER NOT NULL,
    p_m_r_doc_identidad             INTEGER NOT NULL,
    p_m_r_rol_id                    INTEGER NOT NULL,
    miembro_academia_doc_identidad  INTEGER NOT NULL
);

ALTER TABLE postulacion
    ADD CONSTRAINT postulacion_pk PRIMARY KEY ( categoria_premio_id,
                                                miembro_academia_id_maacc,
                                                miembro_academia_doc_identidad,
                                                id,
                                                anio_oscar );


CREATE TABLE presentador (
    ceremonia_anio         INTEGER NOT NULL,
    categoria_premio_id   INTEGER NOT NULL,
    persona_doc_identidad INTEGER NOT NULL
);

ALTER TABLE presentador
    ADD CONSTRAINT presentador_pk PRIMARY KEY ( ceremonia_anio,
                                                categoria_premio_id,
                                                persona_doc_identidad );


CREATE TABLE rol (
    id          serial not null,
    nombre      VARCHAR(28) NOT NULL,
    descripcion TEXT NOT NULL
);




ALTER TABLE rol ADD CONSTRAINT rol_pk PRIMARY KEY ( id );


CREATE TABLE votos (
    id                                         serial not null,
    fecha_hora                                 TIMESTAMP(0) NOT NULL,
    tipo                                       VARCHAR(1) NOT NULL,

    miembro_academia_id_miembro                INTEGER NOT NULL,
    nominacion_id                              INTEGER NOT NULL,

    nominacion_post_id_pelicula                INTEGER NOT NULL,
    nom_post_cat_premio_id                     INTEGER NOT NULL,
    nominacion_postulacion_id_miemb            INTEGER NOT NULL,
    nominacion_postulacion_id                  INTEGER NOT NULL,
    nominacion_postulacion_año_oscar           INTEGER
,
    postulacion_id_pelicula                    INTEGER NOT NULL,

    post_categoria_premio_id                   INTEGER NOT NULL,
    postulacion_id_miembroaacc                 INTEGER NOT NULL,
    postulacion_id                             INTEGER NOT NULL,
    postulacion_año_oscar                      INTEGER
,
    postulacion_doc_identidad1                 INTEGER NOT NULL,
    nom_post_doc_identidad1                    INTEGER NOT NULL,
    miembro_academia_doc_identidad             INTEGER NOT NULL
);

ALTER TABLE votos
    ADD CONSTRAINT votos_pk PRIMARY KEY ( miembro_academia_id_miembro,
                                          id,
                                          nominacion_id,
                                          nominacion_post_id_pelicula,
                                          nom_post_cat_premio_id,
                                          nominacion_postulacion_id_miemb,
                                          nominacion_postulacion_id,
                                          nominacion_postulacion_año_oscar,
                                          nom_post_doc_identidad1,
                                          postulacion_id_pelicula,
                                          post_categoria_premio_id,
                                          postulacion_id_miembroaacc,
                                          postulacion_id,
                                          postulacion_año_oscar,
                                          postulacion_doc_identidad1 );


CREATE TABLE votos_postular (
    anio                             VARCHAR(28) NOT NULL,
    pelicula_postulada_id_pelicula  INTEGER NOT NULL,
    miembro_academia_id_miembro     INTEGER NOT NULL,
    miembro_academia_doc_identidad  INTEGER NOT NULL
);

ALTER TABLE votos_postular
    ADD CONSTRAINT votos_postular_pk PRIMARY KEY ( anio,
                                                   pelicula_postulada_id_pelicula,
                                                   miembro_academia_id_miembro,
                                                   miembro_academia_doc_identidad );

ALTER TABLE a_c
    ADD CONSTRAINT a_c_categoria_premio_fk FOREIGN KEY ( categoria_premio_id )
        REFERENCES categoria_premio ( id );

ALTER TABLE a_c
    ADD CONSTRAINT a_c_miembro_academia_fk FOREIGN KEY ( miembro_academia_id_miembro,
                                                         miembro_academia_doc_id )
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
    ADD CONSTRAINT nominacion_postulacion_fk FOREIGN KEY (
                                                           post_categoria_premio_id,
                                                            postulacion_doc_identidad,
                                                          postulacion_id_miembroaacc,

                                                           postulacion_id,
                                                           postulacion_año_oscar )
        REFERENCES postulacion (
                                 categoria_premio_id,
                                miembro_academia_doc_identidad,
                                miembro_academia_id_maacc,
                                 id,
                                 anio_oscar );

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
    ADD CONSTRAINT presentador_ceremonia_fk FOREIGN KEY ( ceremonia_anio )
        REFERENCES ceremonia ( anio );

ALTER TABLE presentador
    ADD CONSTRAINT presentador_persona_fk FOREIGN KEY ( persona_doc_identidad )
        REFERENCES persona ( doc_identidad );

ALTER TABLE votos
    ADD CONSTRAINT votos_miembro_academia_fk FOREIGN KEY ( miembro_academia_id_miembro,
                                                           miembro_academia_doc_identidad )
        REFERENCES miembro_academia ( id_miembroaacc,
                                      persona_doc_identidad );

ALTER TABLE votos
    ADD CONSTRAINT votos_nominacion_fk FOREIGN KEY ( nominacion_id,

                                                     nom_post_cat_premio_id,
                                                     nominacion_postulacion_id_miemb,
                                                     nominacion_postulacion_id,
                                                     nominacion_postulacion_año_oscar,
                                                     nom_post_doc_identidad1 )
        REFERENCES nominacion ( id,

                                post_categoria_premio_id,
                                postulacion_id_miembroaacc,
                                postulacion_id,
                                postulacion_año_oscar,
                                postulacion_doc_identidad );

ALTER TABLE votos
    ADD CONSTRAINT votos_postulacion_fk FOREIGN KEY (
                                                      post_categoria_premio_id,
                                                      postulacion_id_miembroaacc,
                                                     postulacion_doc_identidad1,
                                                      postulacion_id,
                                                      postulacion_año_oscar )
        REFERENCES postulacion (
                                 categoria_premio_id,
                                miembro_academia_id_maacc,
                                miembro_academia_doc_identidad,

                                 id,
                                 anio_oscar );


ALTER TABLE votos_postular
    ADD CONSTRAINT VPmiembro_academia_fk FOREIGN KEY ( miembro_academia_id_miembro,
                                                                    miembro_academia_doc_identidad )
        REFERENCES miembro_academia ( id_miembroaacc,
                                      persona_doc_identidad );


ALTER TABLE votos_postular
    ADD CONSTRAINT VPpelicula_postulada_fk FOREIGN KEY ( pelicula_postulada_id_pelicula )
        REFERENCES pelicula_postulada ( id_pelicula );


