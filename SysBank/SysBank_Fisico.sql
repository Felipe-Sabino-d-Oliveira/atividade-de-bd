/* SysBank_Fisico */
CREATE DATABASE SysBank;
USE SysBank;

-- Executar Selects;
SELECT * FROM Agencias;
SELECT * FROM Funcionarios;
SELECT * FROM Clientes;
SELECT * FROM Contas;
SELECT * FROM Cartoes;
SELECT * FROM Faturas;
SELECT * FROM Beneficiarios;
SELECT * FROM Transacoes;
SELECT * FROM Emprestimos;
SELECT * FROM Parcelas_do_Emprestimo;
SELECT * FROM Investimentos;
SELECT * FROM Vincula;

CREATE TABLE Agencias (
    num_agencia INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(100)
);

CREATE TABLE Funcionarios (
    ID_Funcionario INT AUTO_INCREMENT PRIMARY KEY,
    cpf VARCHAR(14) UNIQUE,
    nome VARCHAR(50) NOT NULL,
    cargo VARCHAR(100),
    fk_Agencias_num_agencia INT,
    FOREIGN KEY (fk_Agencias_num_agencia) REFERENCES Agencias(num_agencia) ON DELETE RESTRICT
);

CREATE TABLE Clientes (
    ID_Cliente INT AUTO_INCREMENT PRIMARY KEY,
    cpf VARCHAR(14) UNIQUE,
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE,
    endereco VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    telefone VARCHAR(20)
);

CREATE TABLE Contas (
    ID_Conta INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('CORRENTE', 'POUPANCA'),
    saldo_atual DECIMAL(10,2) DEFAULT 0,
    data_de_abertura DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('ATIVA', 'INATIVA', 'BLOQUEADA'),
    fk_Clientes_ID_Cliente INT,
    FOREIGN KEY (fk_Clientes_ID_Cliente) REFERENCES Clientes(ID_Cliente) ON DELETE RESTRICT
);

CREATE TABLE Cartoes (
    ID_Cartao INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('DEBITO', 'CREDITO'),
    data_de_validade DATE,
    limite DECIMAL(10,2),
    status ENUM('ATIVO', 'BLOQUEADO'),
    fk_Clientes_ID_Cliente INT,
    fk_Contas_ID_Conta INT,
    FOREIGN KEY (fk_Clientes_ID_Cliente) REFERENCES Clientes(ID_Cliente) ON DELETE RESTRICT,
    FOREIGN KEY (fk_Contas_ID_Conta) REFERENCES Contas(ID_Conta) ON DELETE RESTRICT
);

CREATE TABLE Faturas (
    ID_Fatura INT AUTO_INCREMENT PRIMARY KEY,
    data_vencimento DATE,
    valor_total DECIMAL(10,2),
    status ENUM('ABERTA', 'PAGA', 'VENCIDA'),
    fk_Cartoes_ID_Cartao INT,
    FOREIGN KEY (fk_Cartoes_ID_Cartao) REFERENCES Cartoes(ID_Cartao) ON DELETE RESTRICT
);

CREATE TABLE Beneficiarios (
    ID_Beneficiario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf_cnpj VARCHAR(20) UNIQUE,
    banco VARCHAR(50),
    agencia INT,
    conta INT
);

CREATE TABLE Transacoes (
    ID_Transacao INT AUTO_INCREMENT PRIMARY KEY,
    conta_origem INT,
    conta_destino INT,
    tipo VARCHAR(50),
    valor DECIMAL(10,2),
    data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
    fk_Clientes_ID_Cliente INT,
    fk_Contas_ID_Conta INT,
    fk_Beneficiario_ID INT,
    FOREIGN KEY (fk_Clientes_ID_Cliente) REFERENCES Clientes(ID_Cliente) ON DELETE RESTRICT,
    FOREIGN KEY (fk_Contas_ID_Conta) REFERENCES Contas(ID_Conta) ON DELETE RESTRICT,
    FOREIGN KEY (fk_Beneficiario_ID) REFERENCES Beneficiarios(ID_Beneficiario) ON DELETE SET NULL
);

CREATE TABLE Emprestimos (
    ID_Emprestimo INT AUTO_INCREMENT PRIMARY KEY,
    valor_total DECIMAL(10,2),
    taxa_de_juros DECIMAL(10,2),
    num_parcelas INT,
    data_da_solicitacao DATE,
    status ENUM('EM_ANALISE','APROVADO','QUITADO'),
    fk_Clientes_ID_Cliente INT,
    fk_Contas_ID_Conta INT,
    FOREIGN KEY (fk_Clientes_ID_Cliente) REFERENCES Clientes(ID_Cliente) ON DELETE RESTRICT,
    FOREIGN KEY (fk_Contas_ID_Conta) REFERENCES Contas(ID_Conta) ON DELETE RESTRICT
);

CREATE TABLE Parcelas_do_Emprestimo (
    ID_Parcela INT AUTO_INCREMENT PRIMARY KEY,
    num_parcela INT,
    valor DECIMAL(10,2),
    data_de_vencimento DATE,
    data_de_pagamento DATE,
    fk_Emprestimos_ID_Emprestimo INT,
    FOREIGN KEY (fk_Emprestimos_ID_Emprestimo) REFERENCES Emprestimos(ID_Emprestimo) ON DELETE RESTRICT
);

CREATE TABLE Investimentos (
    ID_Investimento INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('CDB', 'LCI_LCA', 'POUPANCA', 'TESOURO_DIRETO'),
    valor_aplicado DECIMAL(10,2),
    data_da_aplicacao DATE,
    rentabilidade DECIMAL(10,2),
    fk_Clientes_ID_Cliente INT,
    fk_Contas_ID_Conta INT,
    FOREIGN KEY (fk_Clientes_ID_Cliente) REFERENCES Clientes(ID_Cliente) ON DELETE RESTRICT,
    FOREIGN KEY (fk_Contas_ID_Conta) REFERENCES Contas(ID_Conta) ON DELETE RESTRICT
);

CREATE TABLE Vincula (
    fk_Agencias_num_agencia INT,
    fk_Clientes_ID_Cliente INT,
    PRIMARY KEY (fk_Agencias_num_agencia, fk_Clientes_ID_Cliente),
    FOREIGN KEY (fk_Agencias_num_agencia) REFERENCES Agencias(num_agencia) ON DELETE RESTRICT,
    FOREIGN KEY (fk_Clientes_ID_Cliente) REFERENCES Clientes(ID_Cliente) ON DELETE RESTRICT
);

-- 1. Inserir Agencias
DELIMITER ??
CREATE PROCEDURE InserirAgencias()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 100 DO
    INSERT INTO Agencias(nome, endereco)
    VALUES (
      CONCAT('Agencia_', i),
      CONCAT('Endereco_', i)
    );
    SET i = i + 1;
  END WHILE;
END ??
DELIMITER ;

-- 2. Inserir Clientes
DELIMITER ??
CREATE PROCEDURE InserirClientes()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 100 DO
    INSERT INTO Clientes(cpf, nome, data_nascimento, endereco, email, telefone)
    VALUES (
      LPAD(i,11,'0'),
      CONCAT('Cliente_', i),
      ADDDATE('1980-01-01', INTERVAL (i*100) DAY),
      CONCAT('Endereco_', i),
      CONCAT('cliente', i, '@email.com'),
      CONCAT('(81)9', LPAD(i,8,'0'))
    );
    SET i = i + 1;
  END WHILE;
END ??
DELIMITER ;

-- 3. Inserir Contas
DELIMITER ??
CREATE PROCEDURE InserirContas()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 100 DO
    INSERT INTO Contas(tipo, saldo_atual, data_de_abertura, status, fk_Clientes_ID_Cliente)
    VALUES (
      IF(i%2=0,'CORRENTE','POUPANCA'),
      ROUND(RAND()*10000,2),
      NOW(),
      CASE WHEN i%3=0 THEN 'ATIVA' WHEN i%3=1 THEN 'INATIVA' ELSE 'BLOQUEADA' END,
      (i % 100) + 1
    );
    SET i = i + 1;
  END WHILE;
END ??
DELIMITER ;

-- 4. Inserir Funcionarios
DELIMITER ??
CREATE PROCEDURE InserirFuncionarios()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 100 DO
    INSERT INTO Funcionarios(cpf, nome, cargo, fk_Agencias_num_agencia)
    VALUES (
      CONCAT('00000000', i),
      CONCAT('Funcionario_', i),
      CASE WHEN i%2=0 THEN 'Gerente' ELSE 'Caixa' END,
      (i % 100) + 1
    );
    SET i = i + 1;
  END WHILE;
END ??
DELIMITER ;

-- 5. Inserir Cartoes
DELIMITER ??
CREATE PROCEDURE InserirCartoes()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 100 DO
    INSERT INTO Cartoes(tipo, data_de_validade, limite, status, fk_Clientes_ID_Cliente, fk_Contas_ID_Conta)
    VALUES (
      IF(i%2=0,'DEBITO','CREDITO'),
      ADDDATE(CURDATE(), INTERVAL (i*30) DAY),
      ROUND(RAND()*5000,2),
      IF(i%3=0,'ATIVO','BLOQUEADO'),
      (i % 100) + 1,
      (i % 100) + 1
    );
    SET i = i + 1;
  END WHILE;
END ??
DELIMITER ;

-- 6. Inserir Faturas
DELIMITER ??
CREATE PROCEDURE InserirFaturas()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 100 DO
    INSERT INTO Faturas(data_vencimento, valor_total, status, fk_Cartoes_ID_Cartao)
    VALUES (
      ADDDATE(CURDATE(), INTERVAL (i*5) DAY),
      ROUND(RAND()*3000,2),
      CASE WHEN i%3=0 THEN 'ABERTA' WHEN i%3=1 THEN 'PAGA' ELSE 'VENCIDA' END,
      (i % 100) + 1
    );
    SET i = i + 1;
  END WHILE;
END ??
DELIMITER ;

-- 7. Inserir Beneficiarios
DELIMITER ??
CREATE PROCEDURE InserirBeneficiarios()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 100 DO
    INSERT INTO Beneficiarios(nome, cpf_cnpj, banco, agencia, conta)
    VALUES (
      CONCAT('Beneficiario_', i),
      LPAD(i,14,'0'),
      CONCAT('Banco_', (i%10)+1),
      (i % 1000) + 1,
      (i % 5000) + 1
    );
    SET i = i + 1;
  END WHILE;
END ??
DELIMITER ;

-- 8. Inserir Transacoes
DELIMITER ??
CREATE PROCEDURE InserirTransacoes()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 100 DO
    INSERT INTO Transacoes(conta_origem, conta_destino, tipo, valor, fk_Clientes_ID_Cliente, fk_Contas_ID_Conta, fk_Beneficiario_ID)
    VALUES (
      (i % 100) + 1,
      ((i+1) % 100) + 1,
      IF(i%2=0,'PIX','TED'),
      ROUND(RAND()*2000,2),
      (i % 100) + 1,
      (i % 100) + 1,
      (i % 100) + 1
    );
    SET i = i + 1;
  END WHILE;
END ??
DELIMITER ;

-- 9. Inserir Emprestimos
DELIMITER ??
CREATE PROCEDURE InserirEmprestimos()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 100 DO
    INSERT INTO Emprestimos(valor_total, taxa_de_juros, num_parcelas, data_da_solicitacao, status, fk_Clientes_ID_Cliente, fk_Contas_ID_Conta)
    VALUES (
      ROUND(RAND()*20000,2),
      ROUND(RAND()*5,2),
      (i % 24) + 1,
      ADDDATE(CURDATE(), INTERVAL -i DAY),
      CASE WHEN i%3=0 THEN 'EM_ANALISE' WHEN i%3=1 THEN 'APROVADO' ELSE 'QUITADO' END,
      (i % 100) + 1,
      (i % 100) + 1
    );
    SET i = i + 1;
  END WHILE;
END ??
DELIMITER ;

-- 10. Inserir Parcelas_do_Emprestimo
DELIMITER ??
CREATE PROCEDURE InserirParcelas()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 100 DO
    INSERT INTO Parcelas_do_Emprestimo(num_parcela, valor, data_de_vencimento, data_de_pagamento, fk_Emprestimos_ID_Emprestimo)
    VALUES (
      i,
      ROUND(RAND()*1500,2),
      ADDDATE(CURDATE(), INTERVAL i DAY),
      ADDDATE(CURDATE(), INTERVAL (i+1) DAY),
      (i % 100) + 1
    );
    SET i = i + 1;
  END WHILE;
END ??
DELIMITER ;

-- 11. Inserir Investimentos
DELIMITER ??
CREATE PROCEDURE InserirInvestimentos()
BEGIN
  DECLARE i INT DEFAULT 1;
  WHILE i <= 100 DO
    INSERT INTO Investimentos(tipo, valor_aplicado, data_da_aplicacao, rentabilidade, fk_Clientes_ID_Cliente, fk_Contas_ID_Conta)
    VALUES (
      CASE WHEN i%4=0 THEN 'CDB' WHEN i%4=1 THEN 'LCI_LCA' WHEN i%4=2 THEN 'POUPANCA' ELSE 'TESOURO_DIRETO' END,
      ROUND(RAND()*10000,2),
      ADDDATE(CURDATE(), INTERVAL -i DAY),
      ROUND(RAND()*10,2),
      (i % 100) + 1,
      (i % 100) + 1
    );
    SET i = i + 1;
  END WHILE;
END ??
DELIMITER ;

-- 12. Inserir Vincula
DELIMITER ??
CREATE PROCEDURE InserirVincula()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE max_ag INT;
  DECLARE max_cli INT;

  -- capturar limites existentes
  SELECT COALESCE(MAX(num_agencia),0) INTO max_ag FROM Agencias;
  SELECT COALESCE(MAX(ID_Cliente),0) INTO max_cli FROM Clientes;

  -- validação mínima
  IF max_ag = 0 OR max_cli < 100 THEN
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Necessário ter ao menos 1 agencia e 100 clientes (IDs 1..100). Execute InserirAgencias() e InserirClientes() primeiro.';
  END IF;

  -- inserir 100 vínculos
  WHILE i <= 100 DO
    -- usa cliente = i (assumindo IDs 1..100 presentes)
    -- e escolhe agência em ciclo para distribuir (1..max_ag)
    INSERT IGNORE INTO Vincula (fk_Agencias_num_agencia, fk_Clientes_ID_Cliente)
    VALUES ( ((i - 1) % max_ag) + 1, i );

    SET i = i + 1;
  END WHILE;
END ??
DELIMITER ;


-- Executar Procedures;
CALL InserirAgencias();
CALL InserirClientes();
CALL InserirContas();
CALL InserirFuncionarios();
CALL InserirCartoes();
CALL InserirFaturas();
CALL InserirBeneficiarios();
CALL InserirTransacoes();
CALL InserirEmprestimos();
CALL InserirParcelas();
CALL InserirInvestimentos();
CALL InserirVincula();
