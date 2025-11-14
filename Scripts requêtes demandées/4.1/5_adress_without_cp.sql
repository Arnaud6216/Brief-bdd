SELECT c.nom_commune, v.nom_voie, a.numero, a.rep
FROM adresse a
JOIN commune c ON a.id_commune = c.code_insee
LEFT JOIN voie v ON a.id_voie = v.id_fantoir
WHERE c.code_postal IS NULL
ORDER BY c.nom_commune, v.nom_voie, a.numero;