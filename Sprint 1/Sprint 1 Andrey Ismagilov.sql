USE transactions;
########################################### NIVEL 1 ###############################################
# Exercici 2
# Utilitzant JOIN realitzaràs les següents consultes:

## 1. Llistat dels països que estan generant vendes.
SELECT DISTINCT c.country
FROM transaction AS t
JOIN company AS c
ON c.id = t.company_id
WHERE t.declined = 0;

## 2. Des de quants països es generen les vendes.

SELECT count(DISTINCT c.country) AS num_paises
FROM transaction t
JOIN company c
ON t.company_id = c.id
WHERE t.declined = 0;
      
## 3. Identifica la companyia amb la mitjana més gran de vendes.
SELECT c.company_name, t.company_id, ROUND(AVG(t.amount), 2) AS media_ventas
FROM transaction t
JOIN company c ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY t.company_id
ORDER BY media_ventas DESC
LIMIT 3;

# Exercici 3
# Utilitzant només subconsultes (sense utilitzar JOIN):

## 1. Mostra totes les transaccions realitzades per empreses d'Alemanya.
SELECT * 
FROM transaction t
WHERE declined = 0 AND EXISTS (SELECT c.id 
					       	   FROM company c
							   WHERE c.country = 'Germany'
							   AND c.id = t.company_id);
                                                      
## 2. Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
SELECT c.company_name
FROM company c
WHERE EXISTS (SELECT t.company_id 
			  FROM transaction t
			  WHERE c.id = t.company_id AND t.declined = 0 AND t.amount > (SELECT AVG(amount) 
													                       FROM transaction
                                                                           WHERE declined = 0) );

## 3. Eliminaran del sistema les empreses que no tenen transaccions registrades, entrega el llistat d'aquestes empreses.
SELECT id 
FROM company
WHERE id NOT IN ( SELECT DISTINCT company_id
                  FROM transaction);
                  
########################################### NIVEL 2 ###############################################
# Exercici 1
# Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. 
# Mostra la data de cada transacció juntament amb el total de les vendes. 

SELECT DATE(timestamp) as fecha, ROUND(sum(amount),2) AS ingresos
FROM transaction
WHERE declined = 0
GROUP BY fecha
ORDER BY ingresos DESC
LIMIT 5;

# Exercici 2
# Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.
SELECT c.country, ROUND(AVG(t.amount), 2) AS media_ventas
FROM transaction t
JOIN company c
ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY c.country
ORDER BY media_ventas DESC;


# Exercici 3
# En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries per a fer competència a la companyia 
# "Non Institute". Per a això, et demanen la llista de totes les transaccions realitzades per empreses que estan situades 
# en el mateix país que aquesta companyia.

## 1. Muestra el listado aplicando JOIN y subconsultas.
SELECT t.*
FROM transaction t
JOIN company c
ON t.company_id = c.id 
WHERE t.declined = 0 AND c.company_name != "Non Institute" AND c.country = ( SELECT country
                                                                             FROM company
                                                                             WHERE company_name = "Non Institute");

## 2. Muestra el listado aplicando solo subconsultas.
SELECT *
FROM transaction 
WHERE declined = 0 AND company_id = ANY ( SELECT id
                                          FROM company
                                          WHERE company_name != "Non Institute"
										  AND country = ( SELECT country
				                                          FROM company
                                                          WHERE company_name = "Non Institute"));
                                           
########################################### NIVEL 3 ###############################################
# Exercici 1
# Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions amb un valor comprès 
# entre 350 i 400 euros i en alguna d'aquestes dates: 29 d'abril del 2015, 20 de juliol del 2018 i 13 de març del 2024. 
# Ordena els resultats de major a menor quantitat.

SELECT c.company_name, c.phone, c.country, DATE(t.timestamp) AS fecha, t.amount
FROM transaction t
JOIN company c
ON c.id = t.company_id
WHERE t.amount > 350 AND t.amount < 400 AND DATE(t.timestamp) IN ('2015-04-29', '2018-07-20', '2024-03-13')
ORDER BY t.amount DESC;

# Exercici 2
# Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi, 
# per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, 
# però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis 
# si tenen més de 400 transaccions o menys.

SELECT c.company_name,
CASE 
	WHEN count(*) > 400 THEN "Si"
    ELSE "No"
END AS tiene_mas_que_400_transactiones,  count(*) AS num_transactions
FROM transaction t
JOIN company c
ON c.id = t.company_id
GROUP BY c.id
ORDER BY num_transactions;


 
