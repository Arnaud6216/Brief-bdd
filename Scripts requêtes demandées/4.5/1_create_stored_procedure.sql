--------------------------------------------------------------
------------- CREATION DE LA PROCEDURE STOCKEE ---------------
--------------------------------------------------------------
CREATE OR REPLACE FUNCTION create_or_update_adress(
    p_id VARCHAR,
    p_id_fantoir VARCHAR,
    p_numero INT,
    p_rep VARCHAR,
    p_nom_voie VARCHAR,
    p_code_postal VARCHAR,
    p_code_insee VARCHAR,
    p_nom_commune VARCHAR,
    p_code_insee_ancienne_adresse VARCHAR,
    p_nom_ancienne_commune VARCHAR,
    p_x DECIMAL,
    p_y DECIMAL,
    p_lon DECIMAL,
    p_lat DECIMAL,
    p_type_position VARCHAR,
    p_alias VARCHAR,
    p_nom_ld VARCHAR,
    p_libelle_acheminement VARCHAR,
    p_nom_afnor VARCHAR,
    p_source_position VARCHAR,
    p_source_nom_voie VARCHAR,
    p_certification_commune INT,
    p_cad_parcelles TEXT
)
RETURNS VOID AS $$
DECLARE
    v_id_position INT;
    v_id_parcelle INT;
    v_parcelle TEXT;
BEGIN

    -- Insertion de la table position
    INSERT INTO position(x, y, lon, lat, type_position, source_position)
    VALUES(p_x, p_y, p_lon, p_lat, p_type_position, p_source_position)
    RETURNING id_position INTO v_id_position;

    -- Insertion ou mise à jour de la table commune
    INSERT INTO commune(code_insee, code_postal, nom_commune, code_insee_ancienne_commune, nom_ancienne_commune, libelle_acheminement, certification_commune)
    VALUES(p_code_insee, p_code_postal, p_nom_commune, p_code_insee_ancienne_adresse, p_nom_ancienne_commune, p_libelle_acheminement, p_certification_commune)
    ON CONFLICT (code_insee) DO UPDATE SET
        code_postal = EXCLUDED.code_postal,
        nom_commune = EXCLUDED.nom_commune,
        code_insee_ancienne_commune = EXCLUDED.code_insee_ancienne_commune,
        nom_ancienne_commune = EXCLUDED.nom_ancienne_commune,
        libelle_acheminement = EXCLUDED.libelle_acheminement,
        certification_commune = EXCLUDED.certification_commune;

    -- Insertion ou mise à jour de la table voie
    INSERT INTO voie(id_fantoir, nom_voie, source_nom_voie, nom_afnor)
    VALUES(p_id_fantoir, p_nom_voie, p_source_nom_voie, p_nom_afnor)
    ON CONFLICT (id_fantoir) DO UPDATE SET
        nom_voie = EXCLUDED.nom_voie,
        source_nom_voie = EXCLUDED.source_nom_voie,
        nom_afnor = EXCLUDED.nom_afnor;

    -- Mise à jour ou insertion de la table adresse
    UPDATE adresse
    SET id = p_id,
        numero = p_numero,
        rep = p_rep,
        alias = p_alias,
        nom_ld = p_nom_ld,
        id_voie = p_id_fantoir,
        id_commune = p_code_insee,
        id_position = v_id_position
    WHERE id = p_id;

    IF NOT FOUND THEN
        INSERT INTO adresse(id, numero, rep, alias, nom_ld, id_voie, id_commune, id_position)
        VALUES(p_id, p_numero, p_rep, p_alias, p_nom_ld, p_id_fantoir, p_code_insee, v_id_position);
    END IF;

    -- Traitement des parcelles
    IF p_cad_parcelles IS NOT NULL AND p_cad_parcelles != '' THEN
        FOREACH v_parcelle IN ARRAY string_to_array(p_cad_parcelles, '|')
        LOOP
        -- Ne traiter que les parcelles non vides
            IF v_parcelle IS NOT NULL AND trim(v_parcelle) != '' THEN
             -- Insertion de la table parcelle
                INSERT INTO parcelle(cad_parcelles)
                VALUES(trim(v_parcelle))
                ON CONFLICT (cad_parcelles) DO NOTHING
                RETURNING id_parcelle INTO v_id_parcelle;
                
                 -- Si la parcelle existait déjà, récupérer son id
                IF v_id_parcelle IS NULL THEN
                    SELECT id_parcelle INTO v_id_parcelle 
                    FROM parcelle 
                    WHERE cad_parcelles = trim(v_parcelle);
                END IF;
                
                -- Association adresse-parcelle
                IF v_id_parcelle IS NOT NULL THEN
                    INSERT INTO adresse_parcelle(id_adresse, id_parcelle)
                    VALUES(p_id, v_id_parcelle)
                    ON CONFLICT DO NOTHING;
                END IF;
            END IF;
        END LOOP;
    END IF;

END;
$$ LANGUAGE plpgsql;

--------------------------------------------------------------
------------------ REQUETE TEST CREATION ---------------------
--------------------------------------------------------------
SELECT create_or_update_adress(
    '28888_8888_00002',              
    '28888_8888',           
    210,                      
    NULL,                   
    'Rue du test',        
    '25888',                  
    '25877',                 
    'Testville',             
    NULL,                     
    NULL,                    
    6.0234,                 
    47.2378,               
    6.0234,                  
    47.2378,               
    'entrée',               
    NULL,                   
    NULL,                     
    'TESTVILLE',              
    'RUE DU TEST',        
    'cadastre',               
    'cadastre',            
    1,                     
    '25230000AK8888'          
);

--------------------------------------------------------------
----------------- REQUETE TEST MISE A JOUR -------------------
--------------------------------------------------------------
SELECT create_or_update_adress(
    '28888_8888_00002',              
    '28888_8888',           
    210,                      
    'bis',         -- modification du rep              
    'Rue du test',        
    '25888',                  
    '25877',                 
    'Testville',             
    NULL,                     
    NULL,                    
    6.0234,                 
    47.2378,               
    6.0234,                  
    47.2378,               
    'entrée',               
    NULL,                   
    NULL,                     
    'TESTVILLE',              
    'RUE DU TEST',        
    'cadastre',               
    'cadastre',            
    1,                     
    ''          -- modification du cad_parcelles
);