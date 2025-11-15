------------------------------------------------------------------------------------------
-- Modification des tables pour ajouter les colonnes date_creation et date_modification --
------------------------------------------------------------------------------------------
ALTER TABLE adresse 
ADD COLUMN IF NOT EXISTS date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN IF NOT EXISTS date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE position 
ADD COLUMN IF NOT EXISTS date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN IF NOT EXISTS date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE commune 
ADD COLUMN IF NOT EXISTS date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN IF NOT EXISTS date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE voie 
ADD COLUMN IF NOT EXISTS date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN IF NOT EXISTS date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE parcelle 
ADD COLUMN IF NOT EXISTS date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN IF NOT EXISTS date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE adresse_parcelle 
ADD COLUMN IF NOT EXISTS date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN IF NOT EXISTS date_modification TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

------------------------------------------------------------------------------------------
------------ Création de la fonction de mise à jour de la date de modification -----------
------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_date_modification()
RETURNS TRIGGER AS $$
BEGIN
    NEW.date_modification = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

------------------------------------------------------------------------------------------
-------------------------- Création du trigger sur chaque table --------------------------
------------------------------------------------------------------------------------------
CREATE TRIGGER trigger_update_adresse_date
BEFORE UPDATE ON adresse
FOR EACH ROW
EXECUTE FUNCTION update_date_modification();

CREATE TRIGGER trigger_update_position_date
BEFORE UPDATE ON position
FOR EACH ROW
EXECUTE FUNCTION update_date_modification();

CREATE TRIGGER trigger_update_commune_date
BEFORE UPDATE ON commune
FOR EACH ROW
EXECUTE FUNCTION update_date_modification();

CREATE TRIGGER trigger_update_voie_date
BEFORE UPDATE ON voie
FOR EACH ROW
EXECUTE FUNCTION update_date_modification();

CREATE TRIGGER trigger_update_parcelle_date
BEFORE UPDATE ON parcelle
FOR EACH ROW
EXECUTE FUNCTION update_date_modification();

CREATE TRIGGER trigger_update_adresse_parcelle_date
BEFORE UPDATE ON adresse_parcelle
FOR EACH ROW
EXECUTE FUNCTION update_date_modification();