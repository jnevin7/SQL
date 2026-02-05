-- DROP TABLES IF THEY EXIST (clean reruns)
DROP TABLE IF EXISTS contact_interest;
DROP TABLE IF EXISTS contact_seeking;
DROP TABLE IF EXISTS my_contacts;
DROP TABLE IF EXISTS interests;
DROP TABLE IF EXISTS seeking;
DROP TABLE IF EXISTS profession;
DROP TABLE IF EXISTS status;
DROP TABLE IF EXISTS zip_code;

-- PROFESSION (UNIQUE constraint)
CREATE TABLE profession (
    prof_id SERIAL PRIMARY KEY,
    profession VARCHAR(50) UNIQUE NOT NULL
);

-- STATUS
CREATE TABLE status (
    status_id SERIAL PRIMARY KEY,
    status VARCHAR(30) NOT NULL
);

-- ZIP CODE (natural key + CHECK constraint)
CREATE TABLE zip_code (
    zip_code CHAR(4) PRIMARY KEY,
    city VARCHAR(50) NOT NULL,
    province VARCHAR(50) NOT NULL,
    CHECK (zip_code ~ '^[0-9]{4}$')
);

-- INTERESTS
CREATE TABLE interests (
    interest_id SERIAL PRIMARY KEY,
    interest VARCHAR(50) NOT NULL
);

-- SEEKING
CREATE TABLE seeking (
    seeking_id SERIAL PRIMARY KEY,
    seeking VARCHAR(50) NOT NULL
);

-- MY CONTACTS
CREATE TABLE my_contacts (
    contact_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    gender VARCHAR(10),
    birthday DATE,
    prof_id INT REFERENCES profession(prof_id),
    zip_code CHAR(4) REFERENCES zip_code(zip_code),
    status_id INT REFERENCES status(status_id)
);

-- CONTACT ↔ INTEREST (M:M)
CREATE TABLE contact_interest (
    contact_id INT REFERENCES my_contacts(contact_id),
    interest_id INT REFERENCES interests(interest_id),
    PRIMARY KEY (contact_id, interest_id)
);

-- CONTACT ↔ SEEKING (M:M)
CREATE TABLE contact_seeking (
    contact_id INT REFERENCES my_contacts(contact_id),
    seeking_id INT REFERENCES seeking(seeking_id),
    PRIMARY KEY (contact_id, seeking_id)
);

INSERT INTO profession (profession) VALUES
('Developer'),
('Teacher'),
('Designer'),
('Engineer'),
('Writer');

INSERT INTO status (status) VALUES
('Single'),
('Married'),
('Complicated');

INSERT INTO interests (interest) VALUES
('Music'),
('Sports'),
('Reading'),
('Gaming'),
('Travel'),
('Cooking');

INSERT INTO seeking (seeking) VALUES
('Friendship'),
('Relationship'),
('Networking');

INSERT INTO zip_code VALUES
-- Gauteng
('2000','Johannesburg','Gauteng'),
('0001','Pretoria','Gauteng'),

-- Western Cape
('8000','Cape Town','Western Cape'),
('7600','Stellenbosch','Western Cape'),

-- KwaZulu-Natal
('4000','Durban','KwaZulu-Natal'),
('3201','Pietermaritzburg','KwaZulu-Natal'),

-- Eastern Cape
('6001','Gqeberha','Eastern Cape'),
('5201','East London','Eastern Cape'),

-- Free State
('9300','Bloemfontein','Free State'),
('9459','Welkom','Free State'),

-- Limpopo
('0700','Polokwane','Limpopo'),
('0920','Tzaneen','Limpopo'),

-- Mpumalanga
('1200','Nelspruit','Mpumalanga'),
('1270','White River','Mpumalanga'),

-- North West
('2745','Rustenburg','North West'),
('2570','Klerksdorp','North West'),

-- Northern Cape
('8301','Kimberley','Northern Cape'),
('8801','Upington','Northern Cape');

INSERT INTO my_contacts
(first_name, last_name, phone, email, gender, birthday, prof_id, zip_code, status_id)
VALUES
('James','Smith','0811111111','j1@mail.com','Male','1990-01-01',1,'2000',1),
('Anna','Jones','0822222222','j2@mail.com','Female','1992-02-02',2,'8000',1),
('Mark','Brown','0833333333','j3@mail.com','Male','1988-03-03',3,'4000',2),
('Lucy','Green','0844444444','j4@mail.com','Female','1995-04-04',4,'6001',1),
('Tom','White','0855555555','j5@mail.com','Male','1991-05-05',5,'9300',3),
('Sara','Black','0866666666','j6@mail.com','Female','1993-06-06',1,'0700',1),
('Leo','Grey','0877777777','j7@mail.com','Male','1989-07-07',2,'1200',2),
('Nina','Blue','0888888888','j8@mail.com','Female','1994-08-08',3,'2745',1),
('Paul','Red','0899999999','j9@mail.com','Male','1990-09-09',4,'8301',3),
('Amy','Gold','0800000000','j10@mail.com','Female','1996-10-10',5,'7600',1),
('Ben','Hill','0811112222','j11@mail.com','Male','1992-11-11',1,'3201',2),
('Kate','Wood','0822223333','j12@mail.com','Female','1993-12-12',2,'5201',1),
('Sam','Stone','0833334444','j13@mail.com','Male','1987-01-13',3,'9459',3),
('Lily','Fox','0844445555','j14@mail.com','Female','1995-02-14',4,'0920',1),
('Josh','King','0855556666','j15@mail.com','Male','1991-03-15',5,'1270',2),
('Mia','Queen','0866667777','j16@mail.com','Female','1994-04-16',1,'2570',1);

INSERT INTO contact_interest VALUES
(1,1),(1,2),(1,3),
(2,1),(2,4),(2,5),
(3,2),(3,3),(3,6),
(4,1),(4,5),(4,6),
(5,3),(5,4),(5,6),
(6,1),(6,2),(6,3),
(7,2),(7,4),(7,5),
(8,1),(8,3),(8,6),
(9,2),(9,5),(9,6),
(10,1),(10,4),(10,5),
(11,2),(11,3),(11,6),
(12,1),(12,4),(12,6),
(13,3),(13,4),(13,5),
(14,1),(14,2),(14,6),
(15,2),(15,3),(15,4),
(16,1),(16,5),(16,6);

INSERT INTO contact_seeking VALUES
(1,1),(1,2),
(2,2),(2,3),
(3,1),(3,3),
(4,1),(4,2),
(5,2),(5,3),
(6,1),(6,2),
(7,3),
(8,1),(8,2),
(9,2),(9,3),
(10,1),
(11,1),(11,3),
(12,2),
(13,1),(13,2),
(14,3),
(15,2),
(16,1),(16,3);

SELECT
    c.first_name,
    c.last_name,
    p.profession,
    z.zip_code,
    z.city,
    z.province,
    s.status,
    STRING_AGG(DISTINCT i.interest, ', ') AS interests,
    STRING_AGG(DISTINCT se.seeking, ', ') AS seeking
FROM my_contacts c
LEFT JOIN profession p ON c.prof_id = p.prof_id
LEFT JOIN zip_code z ON c.zip_code = z.zip_code
LEFT JOIN status s ON c.status_id = s.status_id
LEFT JOIN contact_interest ci ON c.contact_id = ci.contact_id
LEFT JOIN interests i ON ci.interest_id = i.interest_id
LEFT JOIN contact_seeking cs ON c.contact_id = cs.contact_id
LEFT JOIN seeking se ON cs.seeking_id = se.seeking_id
GROUP BY
    c.contact_id,
    p.profession,
    z.zip_code,
    z.city,
    z.province,
    s.status
ORDER BY c.contact_id;
