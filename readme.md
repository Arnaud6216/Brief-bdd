# 🧭 National Address Database (BAN) — PostgreSQL Project

This project consists of modeling, cleaning, structuring, and optimizing a PostgreSQL database based on the National Address Database (BAN), the official reference containing more than 26 million French addresses.


## Requirements

To run this project, you need :  
- Docker   
- Docker Compose   
- DBeaver (or another database management tool)  
- CSV file from the National Address Database (BAN)


## 🐳 Docker Installation

This project uses Docker to simplify the installation and management of the PostgreSQL database, allowing you to quickly run an isolated instance without installing PostgreSQL locally.


### Configuration with .env

1. Copy the example file `.env.example` to `.env` :

2. Fill in the values according to your local setup :

- `POSTGRES_USER : PostgreSQL username`  
- `POSTGRES_PASSWORD : PostgreSQL password`  
- `POSTGRES_DB : database name`  
- `POSTGRES_PORT : local port to access PostgreSQL`


### Steps to launch the database with automatic data import :

1. Make sure you have the CSV file from the Base Adresse Nationale for your department.

2. Rename it to `raw_data.csv` and place it in the project’s data/ folder.

3. Open a terminal and run :  
`docker-compose up -d`

**The container will :**

- Automatically create all the tables.
- Import the data from `raw_data.csv`.
- Execute the transformation script to populate the normalized tables.


### Connect to the Database

Connect via DBeaver or another PostgreSQL client using : 

`Host: localhost`  
`Port: <POSTGRES_PORT from .env, ex. 5432>`  
`Database: <POSTGRES_DB>`  
`Username: <POSTGRES_USER>`  
`Password: <POSTGRES_PASSWORD>`


## 1. 📥 Data Exploration

I used the file from the Doubs department (25) for this exercise.  
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

**✦ Adresse**  
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
- The script to create indexes on the most frequently used fields (`create_index.sql`).
- A performance analysis before and after indexing, using several queries (`explain_analyse.sql`).

The analyses show that indexes generally provide a significant reduction in query cost and execution time.

------------------------------------------------------------------------------------------------------------------------------------------

# 🧭 Base Adresses Nationales (BAN) — Projet PostgreSQL

Ce projet consiste à modéliser, nettoyer, structurer et optimiser une base de données PostgreSQL à partir de la Base Adresse Nationale (BAN), la référence officielle contenant plus de 26 millions d’adresses françaises.


## Prérequis

Pour exécuter ce projet, vous devez avoir les éléments suivants installés sur votre système :
- Docker  
- Docker Compose  
- DBeaver (ou autre outil de base de données)  
- Fichier CSV de la Base Adresse Nationale (BAN)


## 🐳 Installation avec Docker

Pour faciliter l’installation et la gestion de la base PostgreSQL, ce projet utilise Docker. Cela permet de lancer rapidement une instance PostgreSQL isolée sans avoir à installer PostgreSQL localement.

### Configuration avec .env

1. Copiez le fichier `.env.example` en `.env` :

2. Remplissez les valeurs selon votre configuration locale :
- `POSTGRES_USER : nom d’utilisateur PostgreSQL`
- `POSTGRES_PASSWORD : mot de passe PostgreSQL`
- `POSTGRES_DB : nom de la base de données`
- `POSTGRES_PORT : port local pour accéder à PostgreSQL`

### Étapes pour lancer la base avec import automatique :

1. Assurez-vous d’avoir le fichier CSV de la Base Adresse Nationale pour votre département.

2. Renommez-le en `raw_data.csv` et placez-le dans le dossier data/ du projet.

3. Ouvrez un terminal et exécutez :  
`docker-compose up -d`

**Le conteneur :**

- Créera automatiquement toutes les tables.
- Importera les données depuis `raw_data.csv`.
- Exécutera le script de transformation pour remplir les tables normalisées.

### Connexion à la base

Connectez-vous via DBeaver ou un autre client PostgreSQL sur :  

`Host: localhost`  
`Port: <POSTGRES_PORT défini dans .env, ex. 5432>`  
`Database: <POSTGRES_DB>`  
`Username: <POSTGRES_USER>`  
`Password: <POSTGRES_PASSWORD>`


## 1. 📥 Découverte de la donnée

J’ai utilisé pour cet exercice le fichier du département du Doubs (25).  
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

Enfin, un script permet d’importer la totalité des données brutes du fichier CSV dans la base normalisée :  
**📂 Script import des données brutes**


## 4. 🔍 Requêtes SQL

Toutes les requêtes demandées dans l’exercice sont regroupées dans le dossier :  
**📂 Script requêtes demandées**


## 5. ⚡ Optimisation et analyse

Dans le dossier **Optimisation et analyse** se trouvent :
- Le script pour la création des index sur les champs les plus sollicités (`create_index.sql`).
- Une analyse des performances avant et après indexation via plusieurs requêtes (`explain_analyse.sql`).

Les analyses montrent que les index permettent, dans la majorité des cas, une réduction notable du coût et du temps d’exécution des requêtes.