-- Active: 1747456605427@@127.0.0.1@5433@conservation_db

CREATE DATABASE conservation_db;


CREATE TABLE rangers(
  ranger_id SERIAL PRIMARY KEY,
  "name" TEXT NOT NULL,
  region TEXT NOT NULL
);


CREATE TABLE species(
  species_id SERIAL PRIMARY KEY,
  common_name TEXT NOT NULL,
  scientific_name TEXT NOT NULL,
  discovery_date DATE NOT NULL,
  conservation_status TEXT NOT NULL
);


CREATE TABLE sightings (
  sighting_id SERIAL PRIMARY KEY,
  ranger_id INT NOT NULL,
  species_id INT NOT NULL,
  sighting_time TIMESTAMP NOT NULL,
  "location" TEXT NOT NULL,
  notes TEXT,
  FOREIGN KEY (ranger_id) REFERENCES rangers(ranger_id),
  Foreign Key (species_id) REFERENCES species(species_id)
);


INSERT INTO rangers("name", region) VALUES('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');

INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status)
VALUES('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris','1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

INSERT INTO sightings(species_id, ranger_id, "location", sighting_time, notes) 
VALUES(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding Observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);


SELECT * FROM rangers;
SELECT* FROM species;
SELECT * from sightings;



-- Problem 1
INSERT INTO rangers("name", region)
VALUES('Derek Fox', 'Coastal Plains');

-- Problem 2
SELECT count(DISTINCT species_id) as unique_species_count from sightings;

-- Problem 3
SELECT * FROM sightings
WHERE "location" LIKE '%Pass%';

-- Problem 4
select rangers.name, count(sightings.sighting_id) as total_sightings FROM rangers 
JOIN sightings on rangers.ranger_id = sightings.ranger_id
GROUP BY rangers.name
ORDER BY rangers.name ASC;

-- Problem 5
SELECT common_name from species
WHERE species_id not in (SELECT species_id from sightings);

-- Problem 6
select common_name, sighting_time, "name" 
from sightings
join species on sightings.species_id = species.species_id
join rangers on sightings.ranger_id = rangers.ranger_id
ORDER BY sightings.sighting_time desc
limit 2;

-- Problem 7
UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';

-- Problem 8
SELECT sighting_id,
CASE 
  WHEN extract(HOUR FROM sighting_time) BETWEEN 5 and 11 THEN 'Morning'
  WHEN extract(HOUR FROM sighting_time) BETWEEN 12 and 16 THEN 'Afternoon'
  WHEN extract(HOUR FROM sighting_time) BETWEEN 17 and 20 THEN 'Evening'
  ELSE 'Night'
END as time_of_day
from sightings;

-- Problem 9
DELETE FROM rangers
WHERE ranger_id NOT IN (
SELECT ranger_id from sightings
); 
SELECT * from rangers;



