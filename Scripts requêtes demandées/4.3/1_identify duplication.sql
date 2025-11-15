SELECT 
    a.numero,
    v.nom_voie,
    c.code_postal,
    c.nom_commune,
    COUNT(*) AS nombre_occurrences
FROM adresse a
JOIN voie v ON a.id_voie = v.id_fantoir
JOIN commune c ON a.id_commune = c.code_insee
GROUP BY 
    a.numero,
    v.nom_voie,
    c.code_postal,
    c.nom_commune
HAVING COUNT(*) > 1;