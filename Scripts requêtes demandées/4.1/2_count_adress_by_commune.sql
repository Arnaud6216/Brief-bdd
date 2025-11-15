SELECT c.nom_commune, COUNT(*) AS nombre_adresse
FROM adresse a
JOIN commune c ON a.id_commune = c.code_insee
GROUP BY c.nom_commune
ORDER BY nom_commune ASC;



-- Bonus : par voie

SELECT c.nom_commune, v.nom_voie, COUNT(*) AS nombre_adresse
FROM adresse a
JOIN commune c ON a.id_commune = c.code_insee
LEFT JOIN voie v ON a.id_voie = v.id_fantoir
GROUP BY c.nom_commune, v.nom_voie
ORDER BY c.nom_commune, v.nom_voie;

