SELECT 
    a.numero,
    v.nom_voie,
    c.code_postal,
    c.nom_commune
FROM adresse a
JOIN voie v ON a.id_voie = v.id_fantoir
JOIN commune c ON a.id_commune = c.code_insee
JOIN position p ON a.id_position = p.id_position
WHERE p.x IS NULL 
   OR p.y IS NULL
   OR p.lon IS NULL
   OR p.lat IS NULL
ORDER BY c.nom_commune, v.nom_voie, a.numero;