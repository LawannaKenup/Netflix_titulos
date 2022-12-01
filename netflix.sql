SELECT * FROM netflix_titles;

--  Criação de uma tabela chamada 'netflix' substituindo todos os valores vazios por NAN.

CREATE TABLE netflix AS (
	
	WITH tabela_netflix AS
	(
		SELECT
   			show_id,
    	 	"type", 
    	 	title,
    	 	CASE
				WHEN director = '' THEN 'NAN'
    	 			ELSE director
    	 	END AS director,
    	 	CASE 
				WHEN "cast"= '' THEN 'NAN'
    	 			ELSE "cast"
    	 	END AS "cast",
    	 	CASE 
				WHEN country = '' THEN 'NAN'
    	 			ELSE country
    	 	END AS country,
    	 	CASE
				WHEN date_added = '' THEN 'NAN'
    	 			ELSE date_added
    	 	END AS date_added,
    	 	release_year, 
    	 	CASE
				WHEN rating = '' THEN 'NAN'
    	 			ELSE rating
    	 	END AS rating,
    	 	CASE 
				WHEN duration ='' THEN 'NAN'
    	 			ELSE duration
    	 	END AS duration,
    	 	listed_in,
    	 	description
    	FROM netflix_titles
	)
	
SELECT * FROM tabela_netflix
);

-- Normaização da coluna 'cast' criando a tabela 'cast_table' de modo que tenhamos separadamente
-- os integrantes do elenco de cada programação.

CREATE TABLE cast_table AS (
	
	WITH cast_table AS 
	(
		SELECT show_id, UNNEST(string_to_array("cast", ',')) AS split_cast
    	FROM netflix
	)

SELECT * FROM cast_table
);

-- Normalização da coluna 'listed_in' criando a tabela 'genere_table' de modo que tenhamos 
-- separadamente os gêneros de cada programação.

CREATE TABLE genre_table AS (

	WITH genre_table AS 
	(
		SELECT show_id, UNNEST(string_to_array(listed_in, ',')) assplit_listed_in 
    	FROM netflix
	)

SELECT * FROM genre_table
);

-- Criação de uma tabela  chamada 'date_table' transformando os dados da coluna 'date_added' 
-- para os formatos: DD, MM, YY, YYYY-MM-DD,YYYY/MM/DD, YYMMDD, YYYYMMDD em cada coluna.

CREATE TABLE  date_table AS (
	
	WITH  date_table AS 
	(
		SELECT  show_id, date_added,
    	CASE 
    		WHEN date_added != 'NAN' THEN EXTRACT(DAY FROM CAST(date_added AS DATE)) 
    	END AS "day",
    	CASE
    		WHEN date_added != 'NAN' THEN EXTRACT(MONTH FROM CAST(date_added AS DATE))
    	END AS "month",
    	CASE
    		WHEN date_added != 'NAN' THEN EXTRACT(YEAR FROM CAST(date_added AS DATE) )
    	END  AS "YEAR", 
  		CASE
    		WHEN date_added != 'NAN' THEN CAST(date_added AS DATE)
  		END AS iso_date_1,
  		CASE
   			WHEN date_added != 'NAN' THEN (EXTRACT(YEAR FROM CAST(date_added AS DATE))||'/'||
    	                  	               EXTRACT(MONTH FROM CAST(date_added AS DATE))||'/'||
 	                         	           EXTRACT(DAY FROM CAST(date_added AS DATE))) 
 		END AS iso_date_2,
  		CASE
    		WHEN date_added != 'NAN' THEN TO_CHAR(CAST(date_added AS DATE), 'yymmdd') 
  				END AS iso_date_3,
  		CASE
    		WHEN date_added != 'NAN' THEN TO_CHAR(CAST(date_added AS DATE), 'yyyymmdd') 
  				END AS iso_date_4
		FROM netflix
	)

SELECT * FROM date_table
);

-- Criação de uma tabela  chamada 'time_table' na qual a mesma possui uma coluna que converte a
-- coluna 'duration' para horas e posteriormente outra que converte a mesma para minutos.

CREATE TABLE time_table AS (
	
	WITH time_table1 AS 
	(
		SELECT show_id, duration, 
  		CASE
  			WHEN (string_to_array(duration, ' '))[2] LIKE 'Season%' 
				then (string_to_array(duration, ' '))[1]::int * 10
  			WHEN (string_to_array(duration, ' '))[2] = 'min' 
				then to_char(to_timestamp((string_to_array(duration, ' '))[1]::int * 60),'HH24')::int
  		END AS HOURS,
    	CASE
	  		WHEN (string_to_array(duration, ' '))[2] LIKE 'Season%' 
				THEN (string_to_array(duration, ' '))[1]::int * 600
  			WHEN (string_to_array(duration, ' '))[2] = 'min' 
				THEN (string_to_array(duration, ' '))[1]::int
  		END AS MINUTES
  		FROM netflix
	)
    
  SELECT * FROM time_table1
);
  
-- Análise dos dados para averiguar qual o filme de duração máxima em minutos.

SELECT DISTINCT(title), MAX(minutes) AS max_minutes
FROM netflix AS t
INNER JOIN time_table AS tt ON t.show_id = tt.show_id
WHERE "type" = 'Movie' AND t.duration !='NAN'
GROUP BY title
ORDER BY max_minutes DESC
LIMIT 1;

-- Foi constatado que o filme com máxima duração em minutos é Black Mirror: Bandersnatch.
 
 
-- Análise dos dados para averiguar qual o filme de duraçã mínima em minutos.

SELECT DISTINCT(title), MIN(minutes) AS min_minutes
FROM netflix AS n
INNER JOIN time_table AS tt ON n.show_id = tt.show_id
WHERE "type" =  'Movie' AND n.duration != 'NAN'
GROUP BY title
ORDER BY min_minutes ASC
LIMIT 1;

-- Foi constatado que o filme com duração mínima de minutos é Silent.

-- Análise dos dados para averiguar qual a série de duração máxima em minutos.

SELECT DISTINCT(title), MAX(minutes) AS max_minutes
FROM netflix AS n
INNER JOIN time_table AS tt ON n.show_id = tt.show_id
WHERE "type" = 'TV Show' AND n.duration != 'NAN'
GROUP BY title
ORDER BY max_minutes DESC
LIMIT 1;
  
-- Foi constatado que a série com duração máxima de minutos é Grey's Anatomy. 

-- Análise dos dados para averiguar qual a série de duração mínima em minutos.

SELECT DISTINCT(title), MIN(minutes) AS min_minutes
FROM netflix AS n
INNER JOIN time_table AS tt ON n.show_id = tt.show_id
WHERE "type" = 'TV Show' AND n.duration != 'NAN'
GROUP BY title
ORDER BY min_minutes ASC;

-- Foi constatado que  as séries cujo as duraçoes são mínimas são todas as que possuem 
-- a duração de 1 Session.


-- Análise dos dados para averiguar qual a média de tempo de duração dos filmes.

SELECT "type", round(AVG(minutes), 2) AS media_duracao
FROM netflix AS n
INNER JOIN time_table AS tt ON n.show_id = tt.show_id
WHERE "type" = 'Movie'
GROUP BY "type";

-- Foi constatado que a média de tempo de duração dos filmes é de 99.58.


-- Análise dos dados para averiguar qual a média de tempo de duração das séries.
  
SELECT "type", round(AVG(minutes), 2) AS media_duracao
FROM netflix AS n
INNER JOIN time_table AS tt ON n.show_id = tt.show_id
WHERE "type" LIKE  '%TV Show%'
GROUP BY "type";
  
-- Foi constatado que a média de tempo de duração das séries é de 1058.97.
  
-- Análise dos dados para averiguar qual a lista de filmes o ator Leonardo DiCaprio participa.

SELECT title, split_cast
FROM netflix AS n
INNER JOIN cast_table AS cc ON n.show_id = cc.show_id
WHERE split_cast LIKE '%Leonardo DiCaprio%' AND  "type" = 'Movie';
 
  
-- Análise dos dados para averiguar qunatas vezes o ator Tom Hanks apareceu nas telas da 
-- netflix, tanto em séries, quanto em filmes.

WITH tabela_aux as 
(
	SELECT  split_cast, COUNT(split_cast) AS total
 	FROM netflix AS T
	INNER JOIN cast_table AS cc ON T.show_id = cc.show_id
	WHERE split_cast LIKE '%Tom Hanks%'
	GROUP BY  split_cast
)
  
SELECT SUM(CAST(total AS INT)) FROM tabela_aux;
  
-- Foi constatado que o ator Tom Hanks apareceu nas telas da netflix 8 vezes. 


-- Criação de uma tabela para normalizar os dados da coluna 'country' chamada 'country_table', de
-- modo em que tenhamos separadamente os países das respectivas produçoes.

CREATE TABLE country_table AS (
	
	WITH country_table AS
	(
		SELECT show_id, UNNEST(string_to_array(country, ',')) AS "split_country" 
		FROM netflix
	)
	
SELECT * FROM country_table 
);
  
-- Análise dos dados para averiguar qunatas produções séries e filmes brasileiras já foram 
-- ao ar na netflix.

WITH brasil as 
(
	SELECT split_country, COUNT(split_country) AS total
	FROM netflix
	INNER JOIN country_table ON netflix.show_id = country_table.show_id
	WHERE split_country LIKE '%Brazil%'
	GROUP BY split_country
)
  
SELECT  SUM(CAST(total AS INT)) AS total 
FROM  brasil;
  
-- Foi constatado que o total de séries e filmes braseileiros é de 97. 
  
-- Análise dos dados para averiguar qunatas filmes americanos já foram ao ar na netflix.

WITH tabela AS 
(
	SELECT split_country, COUNT(split_country) AS total 
	from netflix
	INNER JOIN country_table ON tabela1.show_id = country_table.show_id
	WHERE split_country LIKE '%United States%' AND "type" = 'Movie'
	GROUP BY split_country
)
   
SELECT SUM(CAST(total AS int)) FROM tabela;

-- Foi constatado que 2752 filmes americanos já foram ao ar na netflix. 


-- Criação uma tabela para normalizar os dados da coluna 'director' chamada 'director_table', de
-- modo em que tenhamos separadamente os diretores de cada produção.

CREATE TABLE director_table AS (
	
	WITH director_table AS
	( 
		SELECT show_id, UNNEST(string_to_array(director, ',')) AS "split_director" 
		FROM netflix
	)

SELECT * FROM director_table
);

-- Criação de uma coluna com uma nova formatação para os nomes dos diretores.

SELECT
	split_director,
	CASE 
		WHEN split_director != 'NAN' THEN concat(NomeMeio,' ', SobreNome, ', ', nome)
			ELSE 'NAN'
	END AS last_name_director
	FROM(
		SELECT split_director,
		LEFT(split_director,Inicio) AS nome,
		CASE 
			WHEN Inicio = Fim THEN '' 
				ELSE SUBSTRING(split_director,Inicio + 1,Fim - Inicio - 1) END AS NomeMeio,
		CASE
			WHEN Fim = 0 THEN ''
				ELSE RIGHT(split_director, LENGTH(split_director) - Fim) END AS SobreNome
		FROM(
			SELECT
     			split_director,
     			POSITION(' ' IN split_director) AS Inicio,
     		CASE 
				WHEN POSITION(' ' in split_director) = 0 THEN 0 
     			ELSE
					LENGTH(split_director) - POSITION(' ' IN REVERSE(split_director)) + 1 END AS Fim
			FROM(
				SELECT 
					CASE WHEN split_director LIKE ' %' THEN LTRIM(split_director)
						ELSE split_director
			END AS split_director
			FROM director_table
				) nomes
			) nomes2
		) nomes3;


-- Análise dos dados para averiguar a listagem de conteúdos que tenha como temática a 
-- segunda guerra mundial (WWII).

SELECT title, description 
FROM netflix
WHERE description LIKE '%WWII%';

-- Análise dos dados para averiguar a contagem do número de produções por países
-- que apresentaram conteúdos na netflix.

SELECT DISTINCt(split_country), COUNT(title) AS total_paises
FROM netflix n
INNER JOIN country_table c on n.show_id = c.show_id
WHERE split_country != '' and split_country != 'NAN'
GROUP BY split_country;

-- Verificação para cosnstatar se não há perca de dados após encontrar supostos valores vazios.

SELECT show_id, split_country 
FROM  country_table
WHERE split_country = '';

SELECT show_id, country
FROM netflix 
WHERE country LIKE ',%' OR country LIKE '%,';

-- Foi constatado que não há perca de dados.