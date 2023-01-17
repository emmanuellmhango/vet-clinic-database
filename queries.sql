/*Queries that provide answers to the questions from all projects.*/

SELECT * FROM animals WHERE name LIKE '%mon';
SELECT * FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT * FROM animals WHERE neutered AND escape_attempts < 3;
SELECT date_of_birth FROM animals WHERE name IN ('Agumon','Pikachu');
SELECT name, escape_attempts FROM animals WHERE weight_KG > 10.5;
SELECT * FROM animals WHERE neutered;
SELECT * FROM animals WHERE NOT name='Gabumon';
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;
/*===================================================================*/

/* Inside a transaction update the animals table by setting the species */
BEGIN TRANSACTION;
  UPDATE animals SET species='digimon' WHERE name LIKE '%mon';
  UPDATE animals SET species='pokemon' WHERE species IS null;
COMMIT;

/* Inside a transaction delete all records in the animals table, then roll back the transaction */
BEGIN TRANSACTION;
  DELETE FROM animals;
ROLLBACK;

/* Delete all animals born after Jan 1st, 2022 and savepoint*/
BEGIN TRANSACTION;
  DELETE FROM animals WHERE date_of_birth > '2022-01-01';
  SAVEPOINT SP1;
    UPDATE animals SET weight_kg = weight_kg*-1;
  ROLLBACK TO SP1;
  UPDATE animals SET weight_kg = weight_kg*-1 WHERE weight_kg < 0;
COMMIT;

/* Write queries to answer the following questions: */
  /* 1. How many animals are there? */
  SELECT COUNT(*) FROM animals;

  /* 2. How many animals have never tried to escape? */
  SELECT COUNT(*) FROM animals WHERE escape_attempts < 1;

  /* 3. What is the average weight of animals? */
  SELECT AVG(weight_kg) FROM animals;

  /* 4. Who escapes the most, neutered or not neutered animals? */
  SELECT MAX(escape_attempts), neutered FROM animals GROUP BY neutered;

  /* 5. What is the minimum and maximum weight of each type of animal? */
  SELECT MIN(weight_kg), MAX(weight_kg), species FROM animals GROUP BY species;

  /* 6. What is the average number of escape attempts per animal type of those born between 1990 and 2000? */
  SELECT AVG(escape_attempts) FROM animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31';