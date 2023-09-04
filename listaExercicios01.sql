USE aula_db_exemplos;

-- 1
SELECT titulo FROM livros;

-- 2
SELECT nome
FROM autores
WHERE nascimento < '1900-01-01';