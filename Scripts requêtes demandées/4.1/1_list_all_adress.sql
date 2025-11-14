-- Pris comme exemple : ville d'Étupes (code_postal 25460)
SELECT a.numero, a.rep, v.nom_voie, c.nom_commune
FROM adresse a
JOIN commune c ON a.id_commune = c.code_insee
LEFT JOIN voie v ON a.id_voie = v.id_fantoir
WHERE c.nom_commune = 'Étupes'
ORDER BY v.nom_voie;