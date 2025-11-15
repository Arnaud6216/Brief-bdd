-----------------------------------------------------------------
------------- CREATION DES TRIGGERS DE VALIDATION ---------------
-----------------------------------------------------------------
CREATE OR REPLACE FUNCTION validate_position_and_postal()
RETURNS TRIGGER AS $$
BEGIN
    -- Validation latitude
    IF NEW.lat IS NOT NULL AND (NEW.lat < -90 OR NEW.lat > 90) THEN
        RAISE EXCEPTION 'Latitude invalide : % (doit être entre -90 et 90)', NEW.lat;
    END IF;
    
    -- Validation longitude
    IF NEW.lon IS NOT NULL AND (NEW.lon < -180 OR NEW.lon > 180) THEN
        RAISE EXCEPTION 'Longitude invalide : % (doit être entre -180 et 180)', NEW.lon;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger sur la table position
CREATE TRIGGER check_position_coordinates
BEFORE INSERT OR UPDATE ON position
FOR EACH ROW
EXECUTE FUNCTION validate_position_and_postal();

-- Code postal --
CREATE OR REPLACE FUNCTION validate_code_postal()
RETURNS TRIGGER AS $$
BEGIN
    -- Validation code postal (5 chiffres)
    IF NEW.code_postal IS NOT NULL AND NEW.code_postal !~ '^[0-9]{5}$' THEN
        RAISE EXCEPTION 'Code postal invalide : % (doit être au format 5 chiffres)', NEW.code_postal;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger sur la table commune
CREATE TRIGGER check_commune_code_postal
BEFORE INSERT OR UPDATE ON commune
FOR EACH ROW
EXECUTE FUNCTION validate_code_postal();


-----------------------------------------------------------------
----------------------------- TESTs ------------------------------
-----------------------------------------------------------------

-- Test 1 : Latitude invalide ❌
INSERT INTO position(x, y, lon, lat, type_position, source_position)
VALUES(6.0234, 47.2378, 6.0234, 95.0, 'entrée', 'cadastre');
-- ERREUR: Latitude invalide : 95.0 (doit être entre -90 et 90)

-- Test 2 : Longitude invalide ❌
INSERT INTO position(x, y, lon, lat, type_position, source_position)
VALUES(6.0234, 47.2378, 200.0, 47.2378, 'entrée', 'cadastre');
-- ERREUR: Longitude invalide : 200.0 (doit être entre -180 et 180)

-- Test 3 : Code postal invalide ❌
INSERT INTO commune(code_insee, code_postal, nom_commune)
VALUES('25414', '250', 'Besançon');
-- ERREUR: Code postal invalide : 250 (doit être au format 5 chiffres)

-- Test 4 : Code postal invalide avec lettres ❌
INSERT INTO commune(code_insee, code_postal, nom_commune)
VALUES('25414', '25ABC', 'Besançon');
-- ERREUR: Code postal invalide : 25ABC (doit être au format 5 chiffres)

-- Test 5 : Coordonnées valides ✅
INSERT INTO position(x, y, lon, lat, type_position, source_position)
VALUES(6.0234, 47.2378, 6.0234, 47.2378, 'entrée', 'cadastre');
-- OK

-- Test 6 : Code postaux valides ✅
INSERT INTO commune(code_insee, code_postal, nom_commune, code_insee_ancienne_commune, nom_ancienne_commune, libelle_acheminement, certification_commune)
VALUES('25414', '25000', 'Besançon' , NULL, NULL, 'BESANCON', 1);
-- OK