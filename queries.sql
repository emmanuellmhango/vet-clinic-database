/*Queries that provide answers to the questions FROM all projects.*/

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

/* ===============multiple table queries ==================================*/

SELECT * FROM animals 
  JOIN owners 
  ON animals.owner_id = owners.id 
  WHERE owners.full_name = 'Melody Pond';

SELECT * FROM animals 
  JOIN species 
  ON animals.species_id = species.id 
  WHERE species.name = 'Pokemon';

SELECT * FROM owners 
  LEFT JOIN animals 
  ON owners.id = animals.owner_id;

SELECT species.name, COUNT(animals.species_id) FROM animals 
  JOIN species 
  ON animals.species_id = species.id 
  GROUP BY species.name;

SELECT * FROM animals 
  JOIN species 
  ON animals.species_id = species.id 
  JOIN owners 
  ON animals.owner_id = owners.id 
  WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell';

SELECT * FROM animals 
  JOIN owners 
  ON animals.owner_id = owners.id
  WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0;

SELECT owners.full_name, COUNT(animals.owner_id) FROM animals
  JOIN owners 
  ON animals.owner_id = owners.id 
  GROUP BY owners.full_name
  ORDER BY COUNT(animals.owner_id) 
  DESC LIMIT 1;

/* =============================================================================================================== */

-- 1. Who was the last animal seen by William Tatcher?
SELECT a.name AS animal FROM animals a
  JOIN visits vs 
    ON a.id = vs.animals_id
  JOIN vets vt 
    ON vt.id = vs.vets_id
  WHERE 
    vt.id = 1
  ORDER BY 
    vs.visit_date DESC
  LIMIT 1;

-- 2. How many different animals did Stephanie Mendez see?
SELECT COUNT(*) AS Total FROM (
  SELECT COUNT(*) FROM visits WHERE vets_id = 3 GROUP BY animals_id
) AS results;

-- 3. List all vets and their specialties, including vets with no specialties.
SELECT vt.name AS vet, sp.name AS Specialty FROM vets vt
  LEFT JOIN specializations spz 
    ON vt.id=spz.vets_id
  LEFT JOIN species sp 
    ON spz.species_id = sp.id;

-- 4. List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.name as Dog FROM animals a
  JOIN visits vs 
    ON a.id = vs.animals_id
  WHERE 
    vs.vets_id = 3
    AND
    vs.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

-- 5. What animal has the most visits to vets?
SELECT a.name as dog_name FROM animals a 
  JOIN visits vs 
    ON a.id = vs.animals_id
  GROUP BY 
    vs.animals_id, a.name
  ORDER BY 
    COUNT(vs.animals_id) DESC
  LIMIT 1;

-- 6. Who was Maisy Smith's first visit?
SELECT a.name FROM animals a
  JOIN visits vs
    ON a.id = vs.animals_id
  WHERE 
    vs.vets_id = 2
  ORDER BY vs.visit_date ASC
  LIMIT 1;

-- 7. Details for most recent visit: animal information, vet information, and date of visit.
SELECT a.name AS dog, a.date_of_birth, vt.name AS vet_name,vt.date_of_graduation, vs.visit_date AS date_of_visit FROM visits vs
  JOIN animals a 
    ON vs.animals_id = a.id
  JOIN vets vt 
    ON vt.id = vs.vets_id
  ORDER BY date_of_visit DESC
  LIMIT 6;

-- 8. How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) AS total_visits FROM visits 
  WHERE 
    vets_id=(SELECT id FROM vets 
              WHERE 
                id NOT IN (
                  SELECT vets_id FROM specializations
                )
            );

-- 9. What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT a.name FROM animals a 
  JOIN visits vs
    ON a.id = vs.animals_id
  WHERE 
      vs.vets_id=(SELECT id FROM vets 
                WHERE 
                  id NOT IN (
                    SELECT vets_id FROM specializations
                  )
              )
  GROUP BY 
    vs.animals_id, a.name
  ORDER BY COUNT(vs.vets_id) DESC
  LIMIT 1;
