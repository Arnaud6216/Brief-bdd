-- Champs critiques pour la table adresse : numero 

-- On supprime d’abord les lignes de adresse_parcelle qui pointent vers des adresses invalides, pour éviter une erreur de clé étrangère
DELETE FROM adresse_parcelle
WHERE id_adresse IN (
    SELECT id
    FROM adresse
    WHERE numero IS NULL    
);

DELETE FROM adresse
WHERE numero IS NULL;
