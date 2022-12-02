<h1 align="center"> Netflix Títulos </h1>


<h4 align="center">Exercício desenvolvido em SQL, contendo uma exploração dos dados de uma tabela contendo títulos da Netflix.</h4>

<h2 align="center"><img src="https://img.shields.io/static/v1?label=STATUS&message=CONCLUIDO&color=green&style=for-the-badge"/></h2>

<img src="https://img.shields.io/static/v1?label=Language&message=SQL&color=blue"/> 

 <h2>:gear: Acesso ao Projeto</h2>
 
- Para acessar o projeto, basta clonar o repositório.

<h3> 📝 Dataset utilizado: </h3>

 - Encontram-se na pasta dados todos os datasets utilizados no exercício.
 
<h3> :teacher: Enunciado: </h3>

- Somos uma empresa de Streaming que conseguiu um contrato para retransmitir dos nossos parceiros netflix, disney_plus e amazon_prime os seus conteúdos. A equipe de dados solicitou ao time diversas entregas que precisam ser realizadas para ajustes na base assim como as regras de negócio.

<h3> 📝 Questões a serem resolvidas: </h3>

1. A base possui diversos valores nulos. Preencha nas colunas onde os valores 
são nulls com 'NAN'.

3. Normalize a coluna CAST criando uma nova tabela 'cast_table' de modo que tenhamos separadamente, ou seja, 
uma coluna com o nome do elenco de cada filme.

4. Normalize a coluna listed_in criando uma nova tabela 'genre_table' de modo que tenhamos separadamente os gêneros
de cada programação.

5. Normalize a coluna date_added em uma nova base 'date_table' e construa as seguintes colunas:
- coluna day: DD
- coluna mouth: MM
- coluna year: YY
- coluna iso_date_1: YYYY-MM-DD
- coluna iso_date_2: YYYY/MM/DD
- coluna iso_date_3: YYMMDD
- coluna iso_date_4: YYYYMMDD


6. Normalize a coluna duration e construa uma nova base 'time_table' e faça as seguintes conversões.

- Converta a coluna duration para horas e crie a coluna hours hh. Obs. A média de cada 
season TV SHOW é 10 horas, assim também converta para horas

- Converta todas as horas para minutos e armazena na coluna minutes mm.

7. Normalize a coluna country criando uma nova tabela 'country_table' de modo que tenhamos separadamente 
uma coluna com o nome do país de cada filme.


<h4 align="center">Questões de negócios:</h4>


8. Qual o filme de duração máxima em minutos ?

9.  Qual o filme de duraçã mínima em minutos ?

10. Qual a série de duração máxima em minutos ?

11. Qual a série de duração mínima em minutos ?

12. Qual a média de tempo de duração dos filmes?

13. Qual a média de tempo de duração das series?

14. Qual a lista de filmes o ator Leonardo DiCaprio participa?

15. Quantas vezes o ator Tom Hanks apareceu nas telas do netflix, ou seja, tanto série quanto filmes?

16. Quantas produções séries e filmes brasileiras já foram ao ar no netflix?

17. Quantos filmes americanos já foram para o ar no netflix?

18. Crie uma nova coluna com o nome last_name_director com uma nova formatação para o nome dos diretores, por exemplo.
João Roberto para Roberto, João.

19. Procure a lista de conteúdos que tenha como temática a segunda guerra mundial (WWII)?

20. Conte o número de produções dos países que apresentaram conteúdos no netflix?

