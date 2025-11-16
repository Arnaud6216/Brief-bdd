------------------------------------------------------------------------------------------
------------------ Création d'index sur les champs les plus utilisés  --------------------
------------------------------------------------------------------------------------------
CREATE INDEX idx_commune_code_postal ON commune(code_postal);

CREATE INDEX idx_commune_nom ON commune(nom_commune);

CREATE INDEX idx_adresse_id_voie ON adresse(id_voie);

CREATE INDEX idx_adresse_id_commune ON adresse(id_commune);

CREATE INDEX idx_voie_nom ON voie(nom_voie);

CREATE INDEX idx_position_coords ON position(lon, lat);