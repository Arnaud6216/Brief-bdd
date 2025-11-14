-- Insertion du jeu d'essai dans les tables.
INSERT INTO commune (
    code_insee,
    code_postal,
    nom_commune,
    code_insee_ancienne_commune,
    nom_ancienne_commune,
    libelle_acheminement,
    certification_commune
)
SELECT DISTINCT
    code_insee,
    code_postal,
    nom_commune,
    code_insee_ancienne_commune,   
    nom_ancienne_commune,         
    libelle_acheminement,
    certification_commune         
FROM jeu_essai
WHERE code_insee IS NOT NULL
ON CONFLICT (code_insee) DO NOTHING;


INSERT INTO voie (id_fantoir, nom_voie, source_nom_voie, nom_afnor)
SELECT DISTINCT
    id_fantoir,
    nom_voie,
    source_nom_voie,
    nom_afnor
FROM jeu_essai
WHERE id_fantoir IS NOT NULL
ON CONFLICT (id_fantoir) DO NOTHING;


INSERT INTO position (x, y, lon, lat, type_position, source_position)
SELECT DISTINCT
    x, y, lon, lat, type_position, source_position
FROM jeu_essai;


INSERT INTO parcelle (cad_parcelles)
SELECT DISTINCT
    cad_parcelles
FROM jeu_essai;


INSERT INTO adresse (id, numero, rep, alias, nom_ld, id_voie, id_commune, id_position)
SELECT DISTINCT ON (r.id)
    r.id,
    r.numero,
    r.rep,
    r.alias,
    r.nom_ld,
    v.id_fantoir,
    c.code_insee,
    p.id_position
FROM jeu_essai r
JOIN commune c ON r.code_insee = c.code_insee
LEFT JOIN voie v ON r.id_fantoir = v.id_fantoir
LEFT JOIN position p ON r.x = p.x AND r.y = p.y
WHERE r.id IS NOT NULL
ORDER BY r.id;


INSERT INTO adresse_parcelle (id_adresse, id_parcelle)
SELECT a.id, p.id_parcelle
FROM adresse a
JOIN jeu_essai r ON r.id = a.id   
JOIN parcelle p ON p.cad_parcelles = r.cad_parcelles
GROUP BY a.id, p.id_parcelle;