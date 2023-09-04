USE aula_db_exemplos;

-- 1
SELECT titulo FROM livros;

-- 2
SELECT nome
FROM autores
WHERE nascimento < '1900-01-01';

-- 3
SELECT l.titulo, a.nome
FROM livros l
INNER JOIN autores a ON l.autor_id = a.id
WHERE nome = 'J.K. Rowling';