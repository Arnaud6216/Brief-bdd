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

📂 Le MCD, MLD, MPD, le dictionnaire de données et les règles de gestion se trouvent dans le dossier Modélisation.


## 3. 🛠️ Mise en place de la base

À partir du MPD, un script permet de créer toutes les tables :  
📂 Script création des tables

Deux autres scripts pour la création d'une table jeu_essai et l'insertion de 100 lignes issues du fichier CSV :  
📂 Script jeu d’essai

Enfin, un script permet d’importer la totalité des données brutes du fichier CSV dans la base normalisée (réutilisable sur d'autres fichiers CSV) :  
📂 Script import des données brutes


## 4. 🔍 Requêtes SQL

Toutes les requêtes demandées dans l’exercice sont regroupées dans le dossier :  
📂 Script requêtes demandées


## 5. ⚡ Optimisation et analyse

Dans le dossier "Optimisation et analyse" se trouvent :
- Le script pour la création des index sur les champs les plus sollicités (create_index.sql).
- Une analyse des performances avant et après indexation via plusieurs requêtes (explain_analyse.sql).

Les analyses montrent que les index permettent, dans la majorité des cas, une réduction notable du coût et du temps d’exécution des requêtes.