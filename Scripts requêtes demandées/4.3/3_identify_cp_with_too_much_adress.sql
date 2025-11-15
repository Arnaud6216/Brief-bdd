SELECT 
    c.code_postal,
    COUNT(*) AS nombre_adresse
FROM commune c
JOIN adresse a ON c.code_insee = a.id_commune
GROUP BY c.code_postal
HAVING COUNT(*) > 10000
ORDER BY nombre_adresse DESC;
