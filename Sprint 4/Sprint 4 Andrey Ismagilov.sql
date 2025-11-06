########################################################### NIVEL 1 #################################################################
# Descàrrega els arxius CSV, estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui,
#  almenys 4 taules.

DROP DATABASE transactions_sp4;

CREATE DATABASE IF NOT EXISTS transactions_sp4;

USE transactions_sp4;

-- Creamos la tabla "transaction"
CREATE TABLE transaction (
	id          VARCHAR(255) NULL,
    card_id     VARCHAR(20) NULL,
    company_id  VARCHAR(20) NULL,
    timestamp   VARCHAR(255) NULL,
    amount      VARCHAR(255) NULL,
    declined    VARCHAR(4) NULL,
    product_ids VARCHAR(255) NULL,
    user_id     VARCHAR(20) NULL,
    lat         VARCHAR(255) NULL,
    longitude   VARCHAR(255)  NULL
);
-- Insertamos los datos del archivo transactions.csv en la tabla "transaction" 
LOAD DATA
INFILE 'C:\\transactions.csv'
-- C:\Users\evgen\Downloads\Barcelona Activa\Data Analytics\Sprint 4 SQL
-- 'C:\\Users\\evgen\\Downloads\\Barcelona Activa\\Data Analytics\\Sprint 4 SQL\\transactions.csv'
INTO TABLE transaction
FIELDS TERMINATED BY ';'
IGNORE 1 ROWS;

SELECT * 
FROM transaction;


##############################  credit_cards ############################
-- Creamos la tabla "credit_cards"
CREATE TABLE  IF NOT EXISTS credit_cards (
	id            VARCHAR(20) NULL,
    user_id       VARCHAR(20) NULL,
    iban          VARCHAR(50) NULL,
    pan           VARCHAR(50) NULL,
    pin           VARCHAR(4) NULL,
    cvv           VARCHAR(4) NULL,
    track1        VARCHAR(255) NULL,
    track2        VARCHAR(255) NULL,
    expiring_date VARCHAR(20) NULL
);
-- Insertamos los datos del archivo credit_cards.csv en la tabla "credit_cards" 
LOAD DATA
INFILE 'C:\\credit_cards.csv'
INTO TABLE credit_cards
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

SELECT *
FROM credit_cards;


################################# companies ##############################
-- Creamos la tabla companies
CREATE TABLE  IF NOT EXISTS companies (
	company_id   VARCHAR(20) NULL,
    company_name VARCHAR(255) NULL,
    phone        VARCHAR(15) NULL,
    email        VARCHAR(100) NULL,
    country      VARCHAR(100) NULL,
    website      VARCHAR(255) NULL
);
-- Insertamos los datos del archivo companies.csv en la tabla "companies" 
LOAD DATA
INFILE 'C:\\companies.csv'
INTO TABLE companies
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

SELECT *
FROM companies;


################################# american_users #################################
-- Creamos la tabla companies
CREATE TABLE  IF NOT EXISTS american_users (
	id          VARCHAR(20) NULL,
    name        VARCHAR(100) NULL,
    surname     VARCHAR(100) NULL,
    phone       VARCHAR(150) NULL,
    email       VARCHAR(150) NULL,
    birth_date  VARCHAR(100) NULL,
    country     VARCHAR(150) NULL,
    city        VARCHAR(150) NULL,
    postal_code VARCHAR(100) NULL,
    address     VARCHAR(255) NULL
);
-- Insertamos los datos del archivo american_users.csv en la tabla "american_users" 
LOAD DATA
INFILE 'C:\\american_users.csv'
INTO TABLE american_users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;


SELECT *
FROM american_users;


################################# european_users ##############################
-- Creamos la tabla companies
CREATE TABLE  IF NOT EXISTS european_users (
	id          VARCHAR(20) NULL,
    name        VARCHAR(100) NULL,
    surname     VARCHAR(100) NULL,
    phone       VARCHAR(150) NULL,
    email       VARCHAR(150) NULL,
    birth_date  VARCHAR(100) NULL,
    country     VARCHAR(150) NULL,
    city        VARCHAR(150) NULL,
    postal_code VARCHAR(100) NULL,
    address     VARCHAR(255) NULL
);
-- Insertamos los datos del archivo european_users.csv en la tabla "european_users" 
LOAD DATA
INFILE 'C:\\european_users.csv'
INTO TABLE european_users
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
IGNORE 1 ROWS;


SELECT *
FROM  european_users;


############################################ american_users, european_users -> data_user #################################################
-- Hemos creado dos tablas la "american_users" y la "european_users" que tienen las variables iguales.
SHOW COLUMNS FROM american_users;


SHOW COLUMNS FROM european_users;


-- Ademas si combinamos las columnas "id" de ambas tablas, observamos que el valor "id" es unico y representa cada user concreto.
SELECT id, COUNT(*) FROM (
	SELECT id
	FROM  american_users
	UNION 
	SELECT id
	FROM european_users) t
GROUP BY id
HAVING COUNT(*) > 1;

-- Podemos combinar las dos tablas a la una data_user.
CREATE TABLE data_user AS
SELECT *
FROM american_users
UNION
SELECT *
FROM european_users;


DROP TABLE american_users, european_users;
SHOW TABLES FROM transactions_sp4;


-- Los valores de "id" son numeros de 1 a 5000. Entonces modificamos el tipo de la variable a INT.
ALTER TABLE data_user
MODIFY id INT NOT NULL;


-- y creamos el Primary KEY de la tabla data_user
ALTER TABLE data_user
ADD PRIMARY KEY (id);

SHOW COLUMNS FROM data_user;


############################################ credit_cards #################################################
-- Comprobamos que no hay valores repetidos en la columna "id"

SELECT id, COUNT(*)
FROM credit_cards
GROUP BY id
HAVING COUNT(*) > 1;

-- Creamos el PRIMARY KEY de la tabla "credit_cards"
ALTER TABLE credit_cards
MODIFY id VARCHAR(20) NOT NULL;
ALTER TABLE credit_cards
ADD PRIMARY KEY(id);

-- La tabla "credit_card" modificada
SHOW COLUMNS FROM credit_cards;


############################################ companies #################################################
-- Comprobamos que no hay valores repetidos en la columna "id"

SELECT company_id, COUNT(*)
FROM companies
GROUP BY company_id
HAVING COUNT(*) > 1;

-- Renombramos la columna "company_id" a la "id"
ALTER TABLE companies
RENAME COLUMN company_id TO id;

-- Creamos el PRIMARY KEY de la tabla "companies"
--
ALTER TABLE companies
MODIFY id VARCHAR(20) NOT NULL;
ALTER TABLE companies
ADD PRIMARY KEY(id);

-- La tabala "companies"
SHOW COLUMNS FROM companies;


############################################ transaction #################################################

SHOW COLUMNS FROM transaction;

-- Comprobamos que no hay valores repetidos en la columna "id"
SELECT id, COUNT(*)
FROM transaction
GROUP BY id
HAVING COUNT(*) > 1;

-- Creamos el PRIMARY KEY de la tabla "transaction"
ALTER TABLE transaction
MODIFY id VARCHAR(255) NOT NULL;
ALTER TABLE transaction
ADD PRIMARY KEY(id);

-- Renombramos la columna "card_id" a la "credit_card_id"
ALTER TABLE transaction
RENAME COLUMN card_id TO credit_card_id;

-- Modificamos el tipo de la columna "user_id" a INT para que podamos vincularla con la columna "id" de la tabla "data_user" a continuacion. 
ALTER TABLE transaction
MODIFY user_id INT;

-- Modificamos el tipo de la variable "amount" de VARCHAR(255) a DECIMAL(10,2) 
 
ALTER TABLE transaction
MODIFY amount DECIMAL(10,2);

-- Modificamos 
-- el tipo de la variable "lat" de VARCHAR(255) a FLOAT, 
-- el tipo de la variable "longitude" de VARCHAR(255) a FLOAT,
-- el tipo de la variable "declined" de VARCHAR(4) a TINYINT(1),
-- el tipo de la variable "timestamp" de VARCHAR(255) a TIMESTAMP.

ALTER TABLE transaction
MODIFY lat FLOAT, 
MODIFY longitude FLOAT, 
MODIFY declined TINYINT, 
MODIFY timestamp TIMESTAMP;


-- Al final tenemos la tabla "transaction" preparada para hacel la esquema de estrella.
SHOW COLUMNS FROM transaction;


############################################ el esquema de estrella #################################################
-- Creamos la esquema de estrella.
-- Vemos que la tabla "transaction" es la tabla de hechos del esquema de estrella. 
-- Contiene campos claves que se unen a las tablas de dimensiónes: credit_card_id, company_id, user_id.
-- Contiene métricas que podemos media y analizar: amount, timestamp, declined, lat, longitude.
-- Cada fila de la tabla representa la transaccion unica de la tarjeta credito.

-- Vinculamos la columna "id" de la tabla "data_user" con la "user_id" de la "transaction"

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_user_id
FOREIGN KEY (user_id)
REFERENCES data_user (id); 

-- Vinculamos la columna "id" de la tabla "companies" con la "company_id" de la "transaction"
ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_company_id
FOREIGN KEY (company_id)
REFERENCES companies (id);

-- Vinculamos la columna "id" de la tabla "credit_cards" con la "credit_card_id" de la "transaction"
ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_credit_card_id
FOREIGN KEY (credit_card_id)
REFERENCES credit_cards (id);

-- Miramos los FOREIGN KEYS creados.
SELECT 
    table_name, 
    column_name, 
    constraint_name, 
    referenced_table_name, 
    referenced_column_name 
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE 
referenced_table_schema = 'transactions_sp4' ;

# Exercici 1
# Realitza una subconsulta que mostri tots els usuaris amb més de 80 transaccions utilitzant almenys 2 taules.
SELECT u.id, u.name, u.surname
FROM data_user u
WHERE EXISTS (
			  SELECT t.user_id, COUNT(t.user_id) AS num_transacciones
	          FROM transaction t
              WHERE t.user_id = u.id
			  GROUP BY t.user_id
              HAVING num_transacciones > 80
              );

-- Lo he realizado con un JOIN para comparar los resultados.
SELECT t.user_id, u.name, u.surname, COUNT(*) AS num_transacciones
FROM transaction t
JOIN data_user u
WHERE u.id = t.user_id
GROUP BY t.user_id, u.name, u.surname
HAVING num_transacciones > 80
ORDER BY num_transacciones DESC;

# Exercici 2
# Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.
SELECT c.company_name, cc.iban, ROUND(AVG(amount), 2) AS media_amount
FROM transaction t
JOIN credit_cards cc
ON cc.id = t.credit_card_id
JOIN companies c
ON c.id = t.company_id
WHERE c.company_name = "Donec Ltd" AND t.declined = 0
GROUP BY cc.iban
ORDER BY media_amount DESC;

########################################################### NIVEL 2 #################################################################
# Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les tres últimes transaccions han estat declinades 
# aleshores és inactiu, si almenys una no és rebutjada aleshores és actiu.

-- Creamos la vista para guardar el resultado intermedio - las tarjetas con tres ultimas transacciones rechazadas
CREATE VIEW credit_cards_declined_3_ult_trans AS 
	SELECT credit_card_id, SUM(declined) AS sum_declined_3_ult_trans
	FROM (
		SELECT id, credit_card_id, timestamp, declined,
		ROW_NUMBER() OVER (PARTITION BY credit_card_id ORDER BY timestamp DESC) AS num_fila
		FROM transaction
	) t
	WHERE num_fila < 4
	GROUP BY credit_card_id
	HAVING sum_declined_3_ult_trans = 3;

-- Creamos la tabla "credit_card_status" que repersenta el estado de la tarjetas de crédito
CREATE TABLE IF NOT EXISTS credit_card_status AS
SELECT id AS cc_id, 
CASE
	WHEN EXISTS (
		SELECT credit_card_id 
		FROM credit_cards_declined_3_ult_trans
			WHERE id = credit_card_id)
		THEN "Inactive"
		ELSE "Active"
	END AS status 
FROM credit_cards;

ALTER TABLE credit_card_status
ADD PRIMARY KEY(cc_id);

SELECT *
FROM credit_card_status
ORDER BY status DESC;

DROP VIEW credit_cards_declined_3_ult_trans;

-- Vinculamos la columna "id" de la tabla "credit_cards" con la cc_id de la tabla "credit_card_status".
ALTER TABLE credit_cards
ADD CONSTRAINT fk_credit_cards_id
FOREIGN KEY (id)
REFERENCES credit_card_status(cc_id);
-- Miramos los FOREIGN KEYS creados.
SELECT 
    table_name, 
    column_name, 
    constraint_name, 
    referenced_table_name, 
    referenced_column_name 
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE 
referenced_table_schema = 'transactions_sp4' ;

# Exercici 1
#Quantes targetes estan actives?
SELECT COUNT(*) AS num_tarjetas_activas
FROM credit_card_status
WHERE status = "Active";


########################################################### NIVEL 3 #################################################################
# Crea una taula amb la qual puguem unir les dades del nou arxiu products.csv amb la base de dades creada, 
# tenint en compte que des de transaction tens product_ids.
CREATE TABLE  IF NOT EXISTS products (
	id INT,
    product_name VARCHAR(50),
    price VARCHAR(255),
    colour VARCHAR(20),
    weight VARCHAR(20),
    warehouse_id VARCHAR(20)
);

LOAD DATA
INFILE 'C:\\products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;

SELECT *
FROM products;

-- Creamos la tabla temporal "trans_prod_temp" con la columna "products_ids_json" que tendrá los valores en formato JSON
-- para que podamos extraer los valores de "product_ids" con JSON_TABLE() funcion  a continuacion

CREATE TEMPORARY TABLE IF NOT EXISTS trans_prod_temp AS
SELECT id, product_ids, CONCAT('[', product_ids, ']') AS products_ids_json
FROM transaction;


SELECT * 
FROM trans_prod_temp;


-- Creamos la nueva tabla "transaction_products" con la columna "transaction_id" y la "product_id" 
CREATE TABLE IF NOT EXISTS transaction_products AS
SELECT id AS transaction_id, product_id from
trans_prod_temp, 
JSON_TABLE (
	products_ids_json,
	'$[*]' COLUMNS(
		product_id INT PATH '$'
    )) AS t;

DROP TABLE trans_prod_temp;

SELECT *
FROM transaction_products;

-- Vinculamos la columna "transaction_id" de la tabla "transaction_products" con la "id" de la tabla "transaction".
ALTER TABLE transaction_products
ADD CONSTRAINT fk_transaction_products_transaction_id
FOREIGN KEY(transaction_id)
REFERENCES transaction(id);

-- Vinculamos la columna "id" de la tabla "products" con la columna "product_id" de la tabla "transaction_products".
ALTER TABLE products
ADD PRIMARY KEY(id);

ALTER TABLE transaction_products
ADD CONSTRAINT fk_transaction_products_product_id
FOREIGN KEY(product_id)
REFERENCES products(id);

-- Miramos los FOREIGN KEYS creados.
SELECT 
    table_name, 
    column_name, 
    constraint_name, 
    referenced_table_name, 
    referenced_column_name 
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE 
referenced_table_schema = 'transactions_sp4'  AND table_name = 'transaction_products';



# Exercici 1
# Necessitem conèixer el nombre de vegades que s'ha venut cada producte.
SELECT tp.product_id, p.product_name, count(*) AS num_veces_vendido
FROM transaction_products tp
JOIN products p
ON tp.product_id = p.id
JOIN transaction t
ON t.id = tp.transaction_id
WHERE t.declined = 0
GROUP By tp.product_id, p.product_name
ORDER BY num_veces_vendido DESC;



