INSERT INTO commune (code_insee, code_postal, nom_commune, code_insee_ancienne_commune, nom_ancienne_commune, libelle_acheminement, certification_commune)
VALUES ('25999', '25998', 'Hurlevent', NULL, NULL, 'HURLEVENT', 1);

INSERT INTO voie (id_fantoir, nom_voie, source_nom_voie, nom_afnor)
VALUES ('25990_001', 'Quartier des nains', 'commune', 'QUARTIER DES NAINS');

INSERT INTO position (x, y, lon, lat, type_position, source_position)
VALUES ('253125.46', '4500402.52', '50.6189', '85.3474', 'bâtiment', 'commune')
RETURNING id_position;

INSERT INTO parcelle (cad_parcelles)
VALUES ('256359999B9999')
RETURNING id_parcelle;

INSERT INTO adresse (id, numero, rep, alias, nom_ld, id_voie, id_commune, id_position)
VALUES ('25990_001_9999', '10', NULL, NULL, NULL, '25990_001', '25999', 194070);

INSERT INTO adresse_parcelle (id_adresse, id_parcelle)
VALUES ('25990_001_9999', 52244);