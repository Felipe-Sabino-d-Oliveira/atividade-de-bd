/* SIGA_Fisico */

CREATE DATABASE SIGA;
USE SIGA;

CREATE TABLE Alunos (
    Matricula INT AUTO_INCREMENT PRIMARY KEY,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefone VARCHAR(11),
    data_ingresso DATE NOT NULL
);

CREATE TABLE Professores (
    ID_Professor INT AUTO_INCREMENT PRIMARY KEY,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE NOT NULL,
    maior_titulacao ENUM('GRADUADO', 'MESTRE', 'DOUTOR') NOT NULL
);

CREATE TABLE Cursos (
    ID_Curso INT AUTO_INCREMENT PRIMARY KEY,
    nome_curso VARCHAR(50) NOT NULL UNIQUE,
    duracao_semestres INT NOT NULL
);

CREATE TABLE Disciplinas (
    ID_Disciplina INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    carga_horaria INT NOT NULL,
    ementa VARCHAR(200)
);

CREATE TABLE Turmas (
    ID_Turma INT AUTO_INCREMENT PRIMARY KEY,
    ano_semestre VARCHAR(6) NOT NULL,
    horario TIME,
    sala VARCHAR(10),
    fk_Professores_ID_Professor INT NOT NULL,
    CONSTRAINT FK_Turmas_2 FOREIGN KEY (fk_Professores_ID_Professor)
        REFERENCES Professores (ID_Professor)
        ON DELETE RESTRICT
);

CREATE TABLE Matricula (
    fk_Alunos_Matricula INT NOT NULL,
    fk_Turmas_ID_Turma INT NOT NULL,
    nota DECIMAL(5,2),
    frequencia DECIMAL(5,2),
    PRIMARY KEY (fk_Alunos_Matricula, fk_Turmas_ID_Turma),
    CONSTRAINT FK_Matricula_1 FOREIGN KEY (fk_Alunos_Matricula)
        REFERENCES Alunos (Matricula)
        ON DELETE RESTRICT,
    CONSTRAINT FK_Matricula_2 FOREIGN KEY (fk_Turmas_ID_Turma)
        REFERENCES Turmas (ID_Turma)
        ON DELETE RESTRICT
);

CREATE TABLE Contem (
    fk_Turmas_ID_Turma INT NOT NULL,
    fk_Disciplinas_ID_Disciplina INT NOT NULL,
    PRIMARY KEY (fk_Turmas_ID_Turma, fk_Disciplinas_ID_Disciplina),
    CONSTRAINT FK_Contem_1 FOREIGN KEY (fk_Turmas_ID_Turma)
        REFERENCES Turmas (ID_Turma)
        ON DELETE RESTRICT,
    CONSTRAINT FK_Contem_2 FOREIGN KEY (fk_Disciplinas_ID_Disciplina)
        REFERENCES Disciplinas (ID_Disciplina)
        ON DELETE RESTRICT
);

CREATE TABLE Compoe (
    fk_Disciplinas_ID_Disciplina INT NOT NULL,
    fk_Cursos_ID_Curso INT NOT NULL,
    PRIMARY KEY (fk_Disciplinas_ID_Disciplina , fk_Cursos_ID_Curso),
    CONSTRAINT FK_Compoe_1 FOREIGN KEY (fk_Disciplinas_ID_Disciplina)
        REFERENCES Disciplinas (ID_Disciplina)
        ON DELETE RESTRICT,
    CONSTRAINT FK_Compoe_2 FOREIGN KEY (fk_Cursos_ID_Curso)
        REFERENCES Cursos (ID_Curso)
        ON DELETE RESTRICT
);

DELIMITER $$

/* Inserir 100 Alunos */
CREATE PROCEDURE inserir_alunos()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100 DO
        INSERT INTO Alunos (cpf, nome, data_nascimento, email, telefone, data_ingresso)
        VALUES (
            LPAD(i, 11, '0'), 
            CONCAT('Aluno_', i),
            DATE_ADD('1990-01-01', INTERVAL i DAY),
            CONCAT('aluno', i, '@email.com'),
            LPAD(i, 11, '9'),
            CURDATE()
        );
        SET i = i + 1;
    END WHILE;
END$$

/* Inserir 100 Professores */
CREATE PROCEDURE inserir_professores()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100 DO
        INSERT INTO Professores (cpf, nome, data_nascimento, maior_titulacao)
        VALUES (
            LPAD(i+1000, 11, '0'),
            CONCAT('Professor_', i),
            DATE_ADD('1970-01-01', INTERVAL i DAY),
            ELT((i % 3) + 1, 'GRADUADO', 'MESTRE', 'DOUTOR')
        );
        SET i = i + 1;
    END WHILE;
END$$

/* Inserir 100 Cursos */
CREATE PROCEDURE inserir_cursos()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100 DO
        INSERT INTO Cursos (nome_curso, duracao_semestres)
        VALUES (
            CONCAT('Curso_', i),
            FLOOR(1 + (RAND() * 10)) -- duração entre 1 e 10 semestres
        );
        SET i = i + 1;
    END WHILE;
END$$

/* Inserir 100 Disciplinas */
CREATE PROCEDURE inserir_disciplinas()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100 DO
        INSERT INTO Disciplinas (nome, carga_horaria, ementa)
        VALUES (
            CONCAT('Disciplina_', i),
            30 + (i % 5) * 10, -- carga horária variável
            CONCAT('Ementa da disciplina ', i)
        );
        SET i = i + 1;
    END WHILE;
END$$

/* Inserir 100 Turmas */
CREATE PROCEDURE inserir_turmas()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100 DO
        INSERT INTO Turmas (ano_semestre, horario, sala, fk_Professores_ID_Professor)
        VALUES (
            CONCAT('202', (i % 5), '-', (i % 2)+1), -- 2020-1, 2021-2, etc.
            SEC_TO_TIME(RAND() * 86400),            -- horário aleatório
            CONCAT('Sala_', i),
            ((i-1) % 100) + 1                      -- garante professor existente
        );
        SET i = i + 1;
    END WHILE;
END$$

/* Inserir 100 Matrículas */
CREATE PROCEDURE inserir_matriculas()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100 DO
        INSERT INTO Matricula (fk_Alunos_Matricula, fk_Turmas_ID_Turma, nota, frequencia)
        VALUES (
            ((i-1) % 100) + 1,   -- aluno entre 1 e 100
            ((i-1) % 100) + 1,   -- turma entre 1 e 100
            ROUND(RAND()*10,2),  -- nota entre 0 e 10
            ROUND(RAND()*100,2)  -- frequência em %
        );
        SET i = i + 1;
    END WHILE;
END$$

/* Inserir 100 Relações Contem */
CREATE PROCEDURE inserir_contem()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100 DO
        INSERT INTO Contem (fk_Turmas_ID_Turma, fk_Disciplinas_ID_Disciplina)
        VALUES (
            ((i-1) % 100) + 1,
            ((i-1) % 100) + 1
        );
        SET i = i + 1;
    END WHILE;
END$$

/* Inserir 100 Relações Compoe */
CREATE PROCEDURE inserir_compoe()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100 DO
        INSERT INTO Compoe (fk_Disciplinas_ID_Disciplina, fk_Cursos_ID_Curso)
        VALUES (
            ((i-1) % 100) + 1,
            ((i-1) % 100) + 1
        );
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

CALL inserir_alunos();
CALL inserir_professores();
CALL inserir_cursos();
CALL inserir_disciplinas();
CALL inserir_turmas();
CALL inserir_matriculas();
CALL inserir_contem();
CALL inserir_compoe();
