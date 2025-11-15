SELECT 
    c.nom_commune,
    COUNT(a.id) AS nombre_adresses
FROM adresse a
JOIN commune c ON a.id_commune = c.code_insee
GROUP BY c.nom_commune
ORDER BY nombre_adresses DESC
LIMIT 10;