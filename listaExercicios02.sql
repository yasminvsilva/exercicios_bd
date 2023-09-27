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

-- 7
DELIMITER //
CREATE PROCEDURE sp_AdicionarLivro(IN nm_livro VARCHAR(80))
BEGIN
	DECLARE p_livros INT;
   
    SELECT l.Livro_ID 
    INTO p_livros
    FROM Livro l
    WHERE l.Titulo = nm_livro;
    
    IF p_livros IS NOT NULL THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Esse livro já existe.';
	ELSE
		INSERT INTO Livro (Titulo)
		VALUES (nm_livro);
	END IF;
END;
//
DELIMITER ;

CALL sp_AdicionarLivro('Amor e Gelato');
SELECT l.Titulo FROM Livro l;

-- 8
DELIMITER //
CREATE PROCEDURE sp_AutorMaisAntigo()
BEGIN
	SELECT Nome, Sobrenome, Data_Nascimento
    FROM Autor
    WHERE Data_Nascimento = (
		SELECT MIN(Data_Nascimento)
        FROM Autor
	);
END;
//
DELIMITER ;

CALL sp_AutorMaisAntigo();

-- 9
-- Escolhi o exercício 3 para poder comentar cada um dos comandos da stored procedure.

DELIMITER // -- É um delimitador temporário.
CREATE PROCEDURE sp_ContarLivrosPorCategoria(IN nm_categoria VARCHAR(50)) -- Cria a stored procedure com
-- o nome de 'sp_ContarLivrosPorCategoria', inserindo como parâmetro a variável 'nm_categoria' do tipo 
-- VARCHAR.
BEGIN -- Inicia a stored procedure.
	SELECT c.Nome, COUNT(l.Titulo) AS qtd_livros -- Seleciona a coluna Nome da tabela Categoria e também,
    -- é utilizada o comando COUNT para fazer a contagem de quantas vezes a coluna Título da tabela Livro
    -- aparece, obtendo o nome de 'qtd_livros'.
    FROM Livro l -- Seleciona a tabela Livro.
    INNER JOIN Categoria c ON l.Categoria_ID = c.Categoria_ID -- Traz para a minha seleção a tabela Categoria
    -- para obter o nome da categoria, sendo relacionada pelos ID's.
    WHERE c.Nome = nm_categoria -- Define que a coluna Nome da tabela Categoria será igual a variável
    -- 'nm_categoria', que é o meu parâmetro, para ser possível relacionar o nome da categoria passado pelo
    -- comando CALL com o nome da categoria inserido na tabela.
    GROUP BY c.Nome; -- Agrupa os resultados por Nome.
END; -- Encerra a stored procedure.
// -- Fecha com o delimitador temporário definido.
DELIMITER ; -- Volta para o delimitador padrão ';'. 

CALL sp_ContarLivrosPorCategoria('Ciência'); -- Chama a stored procedure, precisando passar um parâmetro
-- que é o nome da categoria.

