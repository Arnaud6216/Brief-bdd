SELECT
    c.nom_commune,
    COUNT(a.id)::DECIMAL / COUNT(DISTINCT a.id_voie) AS moyenne_adresses_par_voie
FROM adresse a
JOIN commune c ON a.id_commune = c.code_insee
GROUP BY c.nom_commune
ORDER BY c.nom_commune;