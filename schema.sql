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
