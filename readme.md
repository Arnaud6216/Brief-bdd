# 🧭 National Address Database (BAN) — PostgreSQL Project

This project consists of modeling, cleaning, structuring, and optimizing a PostgreSQL database based on the National Address Database (BAN), the official reference containing more than 26 million French addresses.


## 1. 📥 Data Exploration

I used the file from the Doubs department (25) for this exercise.  
After importing it through DBeaver, I obtained a table containing the raw CSV data.  
This first step allowed me to explore the structure, data types, missing values, and potential duplicates.


## 2. 🧩 MERISE Modeling

To build the MCD, I analyzed the structure of the CSV file to identify logical entities.
An address depends on several concepts, so I isolated the following entities:

**✦ Commune**  
Contains administrative information (INSEE code, postal code, name, etc.) and is linked to multiple addresses (1,N).

**✦ Voie**  
Represents the official name of a street (via FANTOIR) and can belong to several addresses (1,N).

**✦ Position**  
Stores geographic coordinates; it is separated to avoid repeating the same coordinates across several records.

**✦ Addresse**  
Central entity linking: number, street, commune, and position.

**✦ Parcelle**  
Independent entity because an address can be linked to several cadastral parcels, and a parcel can contain several addresses.
This requires an N,N relationship, hence the associative table adresse_parcelle.

📂 The MCD, MLD, MPD, data dictionary, and business rules are located in the **Modelisation** folder.


## 3. 🛠️ Database Setup

Based on the MPD, a script is used to create all tables:  
**📂 Script création des tables**

Two additional scripts are used to create a jeu_essai table and insert 100 rows extracted from the CSV:  
**📂 Script jeu d’essai**

Finally, a script imports all raw data from the CSV file into the normalized database (reusable for other CSV files):  
**📂 Script import des données brutes**


## 4. 🔍 SQL Queries

All required SQL queries for the exercise are gathered in the folder:  
**📂 Script requêtes demandées**


## 5. ⚡ Optimization and Analysis

Inside the **Optimisation et analyse** folder, you will find:
- The script to create indexes on the most frequently used fields (create_index.sql).
- A performance analysis before and after indexing, using several queries (explain_analyse.sql).

The analyses show that indexes generally provide a significant reduction in query cost and execution time.

------------------------------------------------------------------------------------------------------------------------------------------

# 🧭 Base Adresses Nationales (BAN) — Projet PostgreSQL

Ce projet consiste à modéliser, nettoyer, structurer et optimiser une base de données PostgreSQL à partir de la Base Adresse Nationale (BAN), la référence officielle contenant plus de 26 millions d’adresses françaises.


## 1. 📥 Découverte de la donnée

J’ai utilisé pour cet exercice le fichier du département du Doubs (25).  
Après importation via **DBeaver**, j’ai obtenu une table contenant les données brutes du CSV.  
Cette première étape m’a permis d’explorer la structure, les types de données, les valeurs manquantes et les éventuels doublons.  


## 2. 🧩 Modélisation MERISE

Pour construire le MCD, j’ai analysé la structure du fichier CSV afin d’identifier les entités logiques.
Une adresse dépend de plusieurs concepts, j’ai donc isolé les entités suivantes :

**✦ Commune**  
Contient les informations administratives (INSEE, code postal, nom, etc.) et est liée à plusieurs adresses (1,N).

**✦ Voie**  
Représente le nom officiel d'une rue (via FANTOIR) et peut appartenir à plusieurs adresses (1,N).

**✦ Position**  
Stocke les coordonnées géographiques ; elle est séparée pour éviter de répéter les mêmes coordonnées entre plusieurs enregistrements.

**✦ Adresse**  
Entité centrale reliant : numéro, voie, commune, position.

**✦ Parcelle**  
Entité indépendante car une adresse peut être rattachée à plusieurs parcelles cadastrales, et une parcelle peut contenir plusieurs adresses. Cela impose une relation N,N, donc une table associative adresse_parcelle.

📂 Le MCD, MLD, MPD, le dictionnaire de données et les règles de gestion se trouvent dans le dossier **Modélisation**.


## 3. 🛠️ Mise en place de la base

À partir du MPD, un script permet de créer toutes les tables :  
**📂 Script création des tables**

Deux autres scripts pour la création d'une table jeu_essai et l'insertion de 100 lignes issues du fichier CSV :  
**📂 Script jeu d’essai**

Enfin, un script permet d’importer la totalité des données brutes du fichier CSV dans la base normalisée (réutilisable sur d'autres fichiers CSV) :  
**📂 Script import des données brutes**


## 4. 🔍 Requêtes SQL

Toutes les requêtes demandées dans l’exercice sont regroupées dans le dossier :  
**📂 Script requêtes demandées**


## 5. ⚡ Optimisation et analyse

Dans le dossier **Optimisation et analyse** se trouvent :
- Le script pour la création des index sur les champs les plus sollicités (create_index.sql).
- Une analyse des performances avant et après indexation via plusieurs requêtes (explain_analyse.sql).

Les analyses montrent que les index permettent, dans la majorité des cas, une réduction notable du coût et du temps d’exécution des requêtes.