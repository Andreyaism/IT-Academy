USE transactions;

########################################################### NIVEL 1 #################################################################
# Exercici 1
# La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit.
# La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules 
# ("transaction" i "company"). Després de crear la taula serà necessari que ingressis la informació del document denominat 
# "dades_introduir_credit". Recorda mostrar el diagrama i realitzar una breu descripció d'aquest.

-- Creamos la tabla credit_card
CREATE TABLE IF NOT EXISTS credit_card (
	id   VARCHAR(15) PRIMARY KEY, 
    iban VARCHAR(50),
    pan  VARCHAR(50), 
    pin  VARCHAR(4),
    cvv  VARCHAR(4), -- Creo que el tipo VARCHAR(4) será la mejor opción porque si el cvv se empieza por "0" o "00" se pierda los primeros
                    -- symbolos en caso de INT
    expiring_date VARCHAR(20)
);

-- Miramos la lista de las tablas
SHOW TABLES;

-- y la lista de las columnas de la tabla "credit_card".
SHOW COLUMNS FROM credit_card;

-- La tabla tiene 5000 filas
SELECT * 
FROM credit_card; 

-- Vinculamos la variable "id" de la tabla "credit_card" con la "credit_card_id" de la tabla "transaction",
-- creando FOREIGN KEY en la tabla "transaction".
ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_credit_card_id
FOREIGN KEY (credit_card_id)
REFERENCES credit_card(id);

SELECT 
    table_name, 
    column_name, 
    constraint_name, 
    referenced_table_name, 
    referenced_column_name 
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE 
referenced_table_schema = 'transactions' 
    AND referenced_table_name = 'credit_card'; 
    
# Exercici 2
# El departament de Recursos Humans ha identificat un error en el número de compte associat a la targeta de crèdit amb ID CcU-2938. 
# La informació que ha de mostrar-se per a aquest registre és: TR323456312213576817699999. Recorda mostrar que el canvi es va realitzar.

SELECT *
FROM credit_card
WHERE id = 'CcU-2938';

UPDATE credit_card
SET iban = 'TR323456312213576817699999'
WHERE id = 'CcU-2938';

SELECT *
FROM credit_card
WHERE id = 'CcU-2938';

# Exercici 3
# En la taula "transaction" ingressa una nova transacció amb la següent informació:
# Id	108B1D1D-5B23-A76C-55EF-C568E49A99DD
# credit_card_id	CcU-9999
# company_id	b-9999
# user_id	9999
# lat	829.999
# longitude	-117.999
# amount	111.11
# declined	0


SELECT *
FROM company
WHERE id = 'b-9999';

-- 
SELECT * 
FROM credit_card
WHERE id = 'CcU-9999';

-- Insertamos en la tabla "credit_card" el valor nuevo del "id" de la tarjeta credito nueva
INSERT INTO credit_card (id) VALUES ('CcU-9999');

-- Insertamos en la tabla "company" el valor de "id" de la empresa nueva
INSERT INTO company (id) VALUES ('b-9999');

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined) 
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 9999, 829.999, -117.999, 111.11, 0);

SELECT *
FROM transaction
WHERE id = '108B1D1D-5B23-A76C-55EF-C568E49A99DD';

# Exercici 4
# Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card. Recorda mostrar el canvi realitzat.

-- Lista de las columnas antes de eliminar la columna "pan"
SHOW COLUMNS FROM credit_card;

-- Eliminamos la columna "pan"
ALTER TABLE credit_card
DROP COLUMN pan;

-- Lista de las columnas despues de eliminar la columna "pan"
SHOW COLUMNS FROM credit_card;

########################################################### NIVEL 2 #################################################################
# Exercici 1
# Elimina de la taula transaction el registre amb ID 000447FE-B650-4DCF-85DE-C7ED0EE1CAAD de la base de dades.

SELECT *
FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

DELETE FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD'; 

SELECT *
FROM transaction
WHERE id = '000447FE-B650-4DCF-85DE-C7ED0EE1CAAD';

# Exercici 2
# La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives. 
# S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions. 
# Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació: 
# Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia. 
# Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.

CREATE VIEW VistaMarketing AS
SELECT c.company_name, c.phone, c.country, ROUND(AVG(t.amount), 2) AS media_ventas
FROM transaction t
JOIN company c
ON t.company_id = c.id
WHERE t.declined = 0
GROUP BY c.id, c.country;


SELECT * FROM vistamarketing
ORDER BY media_ventas DESC;


# Exercici 3
# Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany"

SELECT * 
FROM vistamarketing
WHERE country = "Germany";

########################################################### NIVEL 3 #################################################################
# Exercici 1
# La setmana vinent tindràs una nova reunió amb els gerents de màrqueting. 
# Un company del teu equip va realitzar modificacions en la base de dades, però no recorda com les va realitzar. 
# Et demana que l'ajudis a deixar els comandos executats per a obtenir el següent diagrama:

-- Creamos la tabla "user"
CREATE TABLE IF NOT EXISTS user (
	id   CHAR(10) PRIMARY KEY,
	name        VARCHAR(100),
	surname     VARCHAR(100),
	phone       VARCHAR(150),
	email       VARCHAR(150),
	birth_date  VARCHAR(100),
	country     VARCHAR(150),
	city        VARCHAR(150),
	postal_code VARCHAR(100),
	address      VARCHAR(255)    
);

SELECT *
FROM user;

-- Renombramos la tabla "user" a "data_user"
RENAME TABLE user to data_user;
SHOW TABLES;


-- Modificamos el tipo de la variable "id" de CHAR(10) a INT.
ALTER TABLE data_user MODIFY COLUMN id INT;
SHOW COLUMNS FROM data_user;



ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_user_id
FOREIGN KEY (user_id)
REFERENCES data_user(id);

# Se ve, que no se puede crear la FK porque antes hemos agregado la nueva transaccion con el "user_id" = 9999.
# Por lo tanto debemos que agregar el user nuevo con el valor de "id" 9999 en la tabla "data_user".
INSERT INTO data_user (id) VALUES (9999);

# Ahora creamos la FK en la tabla "transaction"
ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_user_id
FOREIGN KEY (user_id)
REFERENCES data_user(id);
-- Vamos a mirar todas las FK creadas
SELECT 
    table_name, 
    column_name, 
    constraint_name, 
    referenced_table_name, 
    referenced_column_name 
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE 
referenced_table_schema = 'transactions' ;

-- Cambiamos el tipo de la columna "id" en la tabla "credit_card" de VARCHAR(15) a VARCHAR(20).
ALTER TABLE credit_card MODIFY id VARCHAR(20);

-- Cambiamos el tipo de la columna "id" de la tabla "company" de VARCHAR(15) a VARCHAR(20) para que la "id" tenga el tipo igual que la 
-- "company_id" de la tabla "transaction".
ALTER TABLE company MODIFY id VARCHAR(20);

-- Renombramos la columna "email" de la tabla "data_user" a la "personal_email"
ALTER TABLE data_user
RENAME COLUMN email TO personal_email;

-- Y por ultimo creamos la nueva columna "fecha_actual" de tipo DATE en la tabla "credit_card".
ALTER TABLE credit_card
ADD fecha_actual DATE;

-- ALTER TABLE credit_card
-- ADD fecha_actual DATETIME DEFAULT now();
-- ALTER TABLE credit_card
-- MODIFY COLUMN fecha_actual DATE;

SHOW COLUMNS FROM credit_card;

# Exercici 2
# L'empresa també us demana crear una vista anomenada "InformeTecnico" que contingui la següent informació:
# ID de la transacció
# Nom de l'usuari/ària
# Cognom de l'usuari/ària
# IBAN de la targeta de crèdit usada.
# Nom de la companyia de la transacció realitzada.
# Assegureu-vos d'incloure informació rellevant de les taules que coneixereu i utilitzeu àlies per canviar de nom columnes segons calgui.
# Mostra els resultats de la vista, ordena els resultats de forma descendent en funció de la variable ID de transacció.

CREATE VIEW InformeTecnico AS
SELECT t.id AS transaction_id, u.name AS cust_name, u.surname AS cust_surname, cc.iban AS cust_iban, c.company_name AS seller_company
FROM transaction t
JOIN data_user u
ON t.user_id = u.id
JOIN company c
ON t.company_id = c.id
JOIN credit_card cc 
ON t.credit_card_id = cc.id;

SELECT * FROM InformeTecnico
ORDER BY transaction_id DESC;


