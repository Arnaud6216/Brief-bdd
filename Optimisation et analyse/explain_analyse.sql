------------------------------------------------------------------------------------------
------------------------------------- Requêtes test --------------------------------------
------------------------------------------------------------------------------------------

-- Test 1 : Recherche par code postal
EXPLAIN ANALYZE
SELECT a.id, a.numero, a.rep, v.nom_voie, c.nom_commune, c.code_postal
FROM adresse a
JOIN commune c ON a.id_commune = c.code_insee
JOIN voie v ON a.id_voie = v.id_fantoir
WHERE c.code_postal = '25000';

-- Test 2 : Recherche par nom de commune
EXPLAIN ANALYZE
SELECT COUNT(*) 
FROM adresse a
JOIN commune c ON a.id_commune = c.code_insee
WHERE c.nom_commune = 'Besançon';

-- Test 3 : Recherche par nom de voie
EXPLAIN ANALYZE
SELECT a.id, a.numero, c.nom_commune, v.nom_voie
FROM adresse a
JOIN voie v ON a.id_voie = v.id_fantoir
JOIN commune c ON a.id_commune = c.code_insee
WHERE v.nom_voie LIKE 'Rue%';

-- Test 4 : Recherche géographique (zone rectangulaire)
EXPLAIN ANALYZE
SELECT a.id, a.numero, v.nom_voie, p.lon, p.lat
FROM adresse a
JOIN position p ON a.id_position = p.id_position
JOIN voie v ON a.id_voie = v.id_fantoir
WHERE p.lon BETWEEN 2.3 AND 2.4
  AND p.lat BETWEEN 48.85 AND 48.87;

-- Test 5 : Recherche d'adresses avec parcelles
EXPLAIN ANALYZE
SELECT a.id, a.numero, v.nom_voie, COUNT(ap.id_parcelle) as nb_parcelles
FROM adresse a
JOIN voie v ON a.id_voie = v.id_fantoir
LEFT JOIN adresse_parcelle ap ON a.id = ap.id_adresse
GROUP BY a.id, a.numero, v.nom_voie
HAVING COUNT(ap.id_parcelle) > 0;


------------------------------------------------------------------------------------------
------------------------------- Analyse avant indexation ---------------------------------
------------------------------------------------------------------------------------------


-- Test 1
Nested Loop  (cost=54.41..4697.13 rows=351 width=58) (actual time=2.441..142.180 rows=18299.00 loops=1)
->  Seq Scan on adresse a  (cost=0.00..4012.30 rows=197730 width=38) (actual time=0.024..10.566 rows=197730.00 loops=1)
->  Index Scan using commune_pkey on commune c  (cost=0.28..54.11 rows=1 width=24) (actual time=0.043..0.242 rows=1.00 loops=1)
->  Index Scan using voie_pkey on voie v  (cost=0.29..0.31 rows=1 width=28) (actual time=0.005..0.005 rows=1.00 loops=18299)
Execution Time: 142.952 ms

-- Test 2
Aggregate  (cost=4590.24..4590.25 rows=1 width=8) (actual time=31.526..31.529 rows=1.00 loops=1)
->  Seq Scan on adresse a  (cost=0.00..4012.30 rows=197730 width=6) (actual time=0.022..9.539 rows=197730.00 loops=1)
->  Index Scan using commune_pkey on commune c  (cost=0.28..54.11 rows=1 width=6) (actual time=0.030..0.204 rows=1.00 loops=1)
Execution Time: 31.562 ms

-- Test 3
Hash Join  (cost=1310.68..6164.15 rows=121739 width=51) (actual time=10.040..92.572 rows=121575.00 loops=1)
->  Seq Scan on adresse a  (cost=0.00..4012.30 rows=197730 width=37) (actual time=0.021..10.218 rows=197730.00 loops=1)
->  Index Scan using voie_pkey on voie v  (cost=0.29..1142.61 rows=8667 width=28) (actual time=0.014..7.298 rows=8608.00 loops=1)
->  Index Scan using commune_pkey on commune c  (cost=0.28..52.70 rows=563 width=18) (actual time=0.007..0.226 rows=563.00 loops=1)
Execution Time: 96.102 ms

-- Test 4
Nested Loop  (cost=8446.23..11949.80 rows=1 width=55) (actual time=66.656..73.681 rows=0.00 loops=1)
->  Parallel Seq Scan on adresse a  (cost=0.00..3198.12 rows=116312 width=35) (never executed)
->  Parallel Index Scan using position_pkey on "position" p  (cost=0.42..7445.93 rows=1 width=20) (actual time=50.639..50.639 rows=0.00 loops=1)
->  Index Scan using voie_pkey on voie v  (cost=0.29..0.31 rows=1 width=28) (never executed)
Execution Time: 73.716 ms

-- Test 5
GroupAggregate  (cost=11960.05..43720.65 rows=65910 width=47) (actual time=121.582..926.044 rows=197730.00 loops=1)
->  Index Scan using adresse_pkey on adresse a  (cost=0.42..8932.43 rows=197730 width=31) (actual time=0.012..42.688 rows=197730.00 loops=1)
->  Index Scan using voie_pkey on voie v  (cost=0.29..0.31 rows=1 width=28) (actual time=0.005..0.005 rows=1.00 loops=14077)
->  Seq Scan on adresse_parcelle ap  (cost=0.00..1961.96 rows=68796 width=122) (actual time=0.036..26.142 rows=197731.00 loops=1)
Execution Time: 933.713 ms

------------------------------------------------------------------------------------------
------------------------------- Analyse après indexation ---------------------------------
------------------------------------------------------------------------------------------

-- Test 1
Nested Loop  (cost=0.73..148.64 rows=351 width=58) (actual time=0.091..109.131 rows=18299.00 loops=1)
->  Index Scan using idx_commune_code_postal on commune c  (cost=0.15..8.17 rows=1 width=24) (actual time=0.032..0.033 rows=1.00 loops=1)
->  Index Scan using idx_adresse_id_commune on adresse a  (cost=0.29..29.17 rows=353 width=38) (actual time=0.041..3.125 rows=18299.00 loops=1)
->  Index Scan using voie_pkey on voie v  (cost=0.29..0.31 rows=1 width=28) (actual time=0.005..0.005 rows=1.00 loops=18299)
Execution Time: 109.719 ms

-- Test 2
Aggregate  (cost=23.17..23.18 rows=1 width=8) (actual time=3.256..3.256 rows=1.00 loops=1)
->  Index Scan using idx_commune_nom on commune c  (cost=0.28..8.29 rows=1 width=6) (actual time=0.070..0.071 rows=1.00 loops=1)
->  Index Only Scan using idx_adresse_id_commune on adresse a  (cost=0.29..10.47 rows=353 width=6) (actual time=0.022..1.259 rows=18299.00 loops=1)
Execution Time: 3.279 ms

-- Test 3
Hash Join  (cost=1310.98..7907.31 rows=121739 width=51) (actual time=9.901..115.970 rows=121575.00 loops=1)
->  Index Scan using idx_adresse_id_commune on adresse a  (cost=0.29..5755.46 rows=197730 width=37) (actual time=0.013..29.837 rows=197730.00 loops=1)
->  Index Scan using voie_pkey on voie v  (cost=0.29..1142.61 rows=8667 width=28) (actual time=0.009..7.234 rows=8608.00 loops=1)
->  Index Scan using commune_pkey on commune c  (cost=0.28..52.70 rows=563 width=18) (actual time=0.009..0.226 rows=563.00 loops=1)
Execution Time: 119.824 ms

-- Test 4
Nested Loop  (cost=9.16..7966.23 rows=1 width=55) (actual time=0.030..0.030 rows=0.00 loops=1)
->  Index Scan using idx_adresse_id_voie on adresse a  (cost=0.42..7438.41 rows=197730 width=35) (actual time=0.006..0.006 rows=1.00 loops=1)
->  Index Scan using idx_position_coords on "position" p  (cost=0.42..8.45 rows=1 width=20) (actual time=0.021..0.021 rows=0.00 loops=1)
->  Index Scan using voie_pkey on voie v  (cost=0.29..0.31 rows=1 width=28) (never executed)
Execution Time: 0.056 ms

-- Test 5
HashAggregate  (cost=39761.56..45708.94 rows=65910 width=47) (actual time=430.692..510.233 rows=197730.00 loops=1)
->  Seq Scan on adresse_parcelle ap  (cost=0.00..3251.31 rows=197731 width=21) (actual time=0.026..20.835 rows=197731.00 loops=1)
->  Index Scan using idx_adresse_id_voie on adresse a  (cost=0.42..7438.41 rows=197730 width=31) (actual time=0.034..44.928 rows=197730.00 loops=1)
->  Index Scan using idx_voie_nom on voie v  (cost=0.29..1023.43 rows=14077 width=28) (actual time=0.064..7.244 rows=14077.00 loops=1)
Execution Time: 519.430 ms

------------------------------------------------------------------------------------------
-------------------------------------- Conclusion ----------------------------------------
------------------------------------------------------------------------------------------

Test 1 
142.95 ms -> 109.72 ms / gain de 33.23 ms(23% plus rapide)

Test 2
31.56 ms -> 3.28 ms / gain de 28.28 ms(89% plus rapide)

Test 3
96.10 ms -> 119.82 ms / perte de 23.72 ms(25% plus lent)

Test 4
73.72 ms -> 0.06 ms / gain de 73.66 ms(99% plus rapide)

Test 5
933.71 ms -> 519.43 ms / gain de 414.28 ms(44% plus rapide)

-- Globalement, l'indexation a permis d'améliorer significativement les performances des requêtes,
-- à l'exception de la troisième requête où une légère dégradation a été observée. 
-- Cela souligne l'importance de choisir judicieusement les index en fonction des requêtes les plus fréquentes.

