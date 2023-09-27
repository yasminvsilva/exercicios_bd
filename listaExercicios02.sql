USE BibliotecaPessoal;

-- 1
DELIMITER //
CREATE PROCEDURE sp_ListarAutores()
BEGIN
	SELECT Nome, Sobrenome
    FROM Autor;
END;
//
DELIMITER ;

CALL sp_ListarAutores();

-- 2
DELIMITER //
CREATE PROCEDURE sp_LivrosPorCategoria(IN nm_categoria VARCHAR(50))
BEGIN
	SELECT l.Titulo, c.Nome AS Categoria
    FROM Livro l
    INNER JOIN Categoria c ON l.Categoria_ID = c.Categoria_ID
    WHERE c.Nome = nm_categoria;
END;
//
DELIMITER ;

CALL sp_LivrosPorCategoria('Autoajuda');

-- 3
DELIMITER //
CREATE PROCEDURE sp_ContarLivrosPorCategoria(IN nm_categoria VARCHAR(50))
BEGIN
	SELECT c.Nome, COUNT(l.Titulo) AS qtd_livros
    FROM Livro l
    INNER JOIN Categoria c ON l.Categoria_ID = c.Categoria_ID
    WHERE c.Nome = nm_categoria
    GROUP BY c.Nome;
END;
//
DELIMITER ;

CALL sp_ContarLivrosPorCategoria('Ciência');

-- 4
DELIMITER //
CREATE PROCEDURE sp_VerificarLivrosCategoria(IN nm_categoria VARCHAR(50), OUT tem_livros ENUM('sim', 'não'))
BEGIN
    DECLARE qtd_livros INT;

	SELECT COUNT(l.Categoria_ID) AS qtd_livros
    INTO qtd_livros
    FROM Categoria c
    INNER JOIN Livro l ON c.Categoria_ID = l.Categoria_ID
    WHERE c.Nome = nm_categoria
    GROUP BY c.Nome;
   
    IF qtd_livros > 0 THEN
		SET tem_livros = 'sim';
	ELSE
		SET tem_livros = 'não';
	END IF;
END;
//
DELIMITER ;

CALL sp_VerificarLivrosCategoria('Ficção Científica', @tem_livros);
SELECT @tem_livros;

-- 5
DELIMITER //
CREATE PROCEDURE sp_LivrosAteAno(IN ano_livro INT)
BEGIN
	SELECT l.Titulo, l.Ano_Publicacao
	FROM Livro l
	WHERE l.Ano_Publicacao < ano_livro
    ORDER BY l.Ano_Publicacao;
END;
//
DELIMITER ;

CALL sp_LivrosAteAno(2000);

-- 6
DELIMITER //
CREATE PROCEDURE sp_TitulosPorCategoria(IN nm_categoria VARCHAR(50))
BEGIN
	SELECT l.Titulo
    FROM Livro l
    INNER JOIN Categoria c ON l.Categoria_ID = c.Categoria_ID
    WHERE c.Nome = nm_categoria;
END;
//
DELIMITER ;

CALL sp_TitulosPorCategoria('Romance');

