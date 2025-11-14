-- Creation d'un jeu d'essai de 100 lignes à partir de la table raw_data importée à partir du fichier csv.
DROP TABLE IF EXISTS jeu_essai;

CREATE TABLE jeu_essai AS
SELECT *
FROM raw_data
LIMIT 100;
