-- Exemple pour le mot clé "Rue"
SELECT c.nom_commune, v.nom_voie, a.numero, a.rep
FROM adresse a
JOIN commune c ON a.id_commune = c.code_insee
JOIN voie v ON a.id_voie = v.id_fantoir
WHERE v.nom_voie LIKE 'Rue%'
ORDER BY c.nom_commune, v.nom_voie, a.numero;

-- Exemple pour le mot clé "Boulevard"
SELECT c.nom_commune, v.nom_voie, a.numero, a.rep
FROM adresse a
JOIN commune c ON a.id_commune = c.code_insee
JOIN voie v ON a.id_voie = v.id_fantoir
WHERE v.nom_voie LIKE 'Boulevard%'
ORDER BY c.nom_commune, v.nom_voie, a.numero;