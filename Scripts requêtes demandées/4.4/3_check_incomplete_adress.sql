-- Le resultat de la requête retourne la liste des adresses incomplètes
SELECT 
    a.id,
    a.numero,
    v.nom_voie,
    c.code_postal,
    c.nom_commune
FROM adresse a
LEFT JOIN voie v ON a.id_voie = v.id_fantoir
LEFT JOIN commune c ON a.id_commune = c.code_insee
WHERE a.numero IS NULL
   OR a.id_voie IS NULL
   OR c.code_postal IS NULL
   OR a.id_commune IS NULL
ORDER BY c.nom_commune, v.nom_voie, a.numero;