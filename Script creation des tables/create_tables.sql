DROP TABLE IF EXISTS adresse_parcelle CASCADE;
DROP TABLE IF EXISTS adresse CASCADE;
DROP TABLE IF EXISTS commune CASCADE;
DROP TABLE IF EXISTS voie CASCADE;
DROP TABLE IF EXISTS position CASCADE;
DROP TABLE IF EXISTS parcelle CASCADE;

CREATE TABLE voie (
    id_fantoir VARCHAR(20) primary KEY,
    nom_voie VARCHAR(255),
    source_nom_voie VARCHAR(50),
    nom_afnor VARCHAR(255)
);

CREATE TABLE position (
    id_position SERIAL PRIMARY KEY,
    x DECIMAL(22,15),
    y DECIMAL(22,15),
    lon DECIMAL(18,15),
    lat DECIMAL(17,15),
    type_position VARCHAR(50),
    source_position VARCHAR(50)
);

CREATE TABLE parcelle (
    id_parcelle SERIAL PRIMARY KEY,
    cad_parcelles TEXT
);

CREATE TABLE commune (
    code_insee VARCHAR(5) primary key,
    code_postal VARCHAR(5),
    nom_commune VARCHAR(50),
    code_insee_ancienne_commune VARCHAR(5),
    nom_ancienne_commune VARCHAR(50),
    libelle_acheminement VARCHAR(50),
    certification_commune INT
);

CREATE TABLE adresse (
    id VARCHAR(50) primary KEY,
    numero INT,
    rep VARCHAR(10),
    alias VARCHAR(50),
    nom_ld VARCHAR(255),
    id_voie VARCHAR(20) REFERENCES voie(id_fantoir),
    id_position INT REFERENCES position(id_position),
    id_commune VARCHAR(5) REFERENCES commune(code_insee)
);

CREATE TABLE adresse_parcelle (
    id_adresse VARCHAR(50) REFERENCES adresse(id),
    id_parcelle INT REFERENCES parcelle(id_parcelle)
);