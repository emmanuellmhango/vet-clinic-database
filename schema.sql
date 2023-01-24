/* Database schema to keep the structure of entire database. */

/* CREATE DATABASE */
CREATE DATABASE vet_clinic;

/* CREATE TABLE */
CREATE TABLE animals(
    id INT GENERATED ALWAYS AS IDENTITY, 
    name VARCHAR(255), 
    date_of_birth DATE, 
    escape_attempts INT, 
    neutered BOOLEAN, 
    weight_kg DECIMAL
);

ALTER TABLE animals 
ADD COLUMN species VARCHAR(200);

/*==========================================================*/
/* CREATING MULTIPLE TABLES */
CREATE TABLE owners (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(100) NOT NULL,
  age INTEGER
);

CREATE TABLE species (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL
);

ALTER TABLE animals 
DROP COLUMN species;

ALTER TABLE animals 
ADD COLUMN species_id INTEGER;

ALTER TABLE animals 
ADD COLUMN owner_id INTEGER;

/* ===================================================================== */

CREATE TABLE vets(
  id INT GENERATED ALWAYS AS IDENTITY, 
  name VARCHAR(255), 
  age INT, 
  date_of_graduation DATE
);

CREATE TABLE specializations(
  vets_id INT, 
  species_id INT 
);

CREATE TABLE visits(
  vets_id INT, 
  animals_id INT,
  visit_date DATE 
);

/* =================================================================*/

  /* INDEXES */

  ALTER TABLE visits 
    RENAME COLUMN animals_id TO animal_id;

  ALTER TABLE visits 
    RENAME COLUMN vets_id TO vet_id;
    
  ALTER TABLE visits 
    RENAME COLUMN visit_date TO date_of_visit;

  CREATE INDEX visits_animal_id ON visits(animal_id ASC);

  CREATE INDEX visits_vet_id ON visits(vet_id ASC);

  CREATE INDEX visits_date_desc ON visits(date_of_visit DESC);

  CREATE INDEX owner_full_name_asc ON owners(full_name ASC);

  CREATE INDEX owner_age_asc ON owners(age ASC);

  CREATE INDEX owner_email ON owners (email);


