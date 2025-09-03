/* SysBank_Logico: */

CREATE TABLE Agencias (
    num_agencia INT PRIMARY KEY,
    nome VARCHAR(100),
    endereco VARCHAR(100)
);

CREATE TABLE Funcionarios (
    ID_Funcionario INT PRIMARY KEY,
    cpf VARCHAR(14),
    nome VARCHAR(50),
    cargo VARCHAR(100),
    fk_Agencias_num_agencia INT
);

CREATE TABLE Clientes (
    ID_Cliente INT PRIMARY KEY,
    cpf VARCHAR(14),
    nome VARCHAR(100),
    data_nascimento DATE,
    endereco VARCHAR(100),
    email VARCHAR(100),
    telefone VARCHAR(13)
);

CREATE TABLE Contas (
    ID_Conta INT PRIMARY KEY,
    tipo ENUM('CORRENTE', 'POUPANCA'),
    saldo_atual DECIMAL(10,2),
    data_de_abertura DATETIME,
    status ENUM('ATIVA', 'INATIVA', 'BLOQUEADA'),
    fk_Clientes_ID_Cliente INT
);

CREATE TABLE Cartoes (
    ID_Cartao INT PRIMARY KEY,
    tipo ENUM('DEBITO', 'CREDITO'),
    data_de_validade DATE,
    limite DECIMAL(10,2),
    status ENUM('ATIVO', 'BLOQUEADO'),
    fk_Clientes_ID_Cliente INT,
    fk_Contas_ID_Conta INT
);

CREATE TABLE Faturas (
    ID_Fatura INT PRIMARY KEY,
    data_vencimento DATE,
    valor_total DECIMAL(10,2),
    status ENUM('ABERTA', 'PAGA', 'VENCIDA'),
    fk_Cartoes_ID_Cartao INT
);

CREATE TABLE Beneficiarios___Favorecidos_Transacoes (
    ID_Beneficiario INT,
    nome_do_favorecido VARCHAR(100),
    cpf_cnpj VARCHAR(20),
    banco_do_favorecido VARCHAR(50),
    agencia_do_favorecido INT,
    conta INT,
    ID_Transacoes INT,
    conta_de_origem INT,
    conta_de_destino INT,
    tipo VARCHAR(50),
    valor DECIMAL(10,2),
    data_e_hora DATETIME,
    fk_Clientes_ID_Cliente INT,
    fk_Contas_ID_Conta INT,
    PRIMARY KEY (ID_Beneficiario, ID_Transacoes)
);

CREATE TABLE Emprestimos (
    ID_Emprestimo INT PRIMARY KEY,
    valor_total DECIMAL(10,2),
    taxa_de_juros DECIMAL(10,2),
    num_parcelas INT,
    data_da_solicitacao DATE,
    status ENUM('EM_ANALISE','APROVADO','QUITADO'),
    fk_Clientes_ID_Cliente INT,
    fk_Contas_ID_Conta INT
);

CREATE TABLE Parcelas_do_Emprestimo (
    ID_Parcela INT PRIMARY KEY,
    num_parcela INT,
    valor DECIMAL(10,2),
    data_de_vencimento DATE,
    data_de_pagamento DATE,
    fk_Emprestimos_ID_Emprestimo INT
);

CREATE TABLE Investimentos (
    ID_Investimento INT PRIMARY KEY,
    tipo ENUM('CDB', 'LCI_LCA', 'POUPANCA', 'TESOURO_DIRETO'),
    valor_aplicado DECIMAL(10,2),
    data_da_aplicacao DATE,
    rentabilidade DECIMAL(10,2),
    fk_Clientes_ID_Cliente INT,
    fk_Contas_ID_Conta INT
);

CREATE TABLE Vincula (
    fk_Agencias_num_agencia INT,
    fk_Clientes_ID_Cliente INT
);

CREATE TABLE PodeSer (
    fk_Clientes_ID_Cliente INT,
    fk_Beneficiarios___Favorecidos_Transacoes_ID_Beneficiario INT,
    fk_Beneficiarios___Favorecidos_Transacoes_ID_Transacoes INT
);
 
ALTER TABLE Funcionarios ADD CONSTRAINT FK_Funcionarios_2
    FOREIGN KEY (fk_Agencias_num_agencia)
    REFERENCES Agencias (num_agencia)
    ON DELETE RESTRICT;
 
ALTER TABLE Contas ADD CONSTRAINT FK_Contas_2
    FOREIGN KEY (fk_Clientes_ID_Cliente)
    REFERENCES Clientes (ID_Cliente)
    ON DELETE RESTRICT;
 
ALTER TABLE Cartoes ADD CONSTRAINT FK_Cartoes_2
    FOREIGN KEY (fk_Clientes_ID_Cliente)
    REFERENCES Clientes (ID_Cliente)
    ON DELETE RESTRICT;
 
ALTER TABLE Cartoes ADD CONSTRAINT FK_Cartoes_3
    FOREIGN KEY (fk_Contas_ID_Conta)
    REFERENCES Contas (ID_Conta)
    ON DELETE RESTRICT;
 
ALTER TABLE Faturas ADD CONSTRAINT FK_Faturas_2
    FOREIGN KEY (fk_Cartoes_ID_Cartao)
    REFERENCES Cartoes (ID_Cartao)
    ON DELETE RESTRICT;
 
ALTER TABLE Beneficiarios___Favorecidos_Transacoes ADD CONSTRAINT FK_Beneficiarios___Favorecidos_Transacoes_2
    FOREIGN KEY (fk_Clientes_ID_Cliente)
    REFERENCES Clientes (ID_Cliente)
    ON DELETE RESTRICT;
 
ALTER TABLE Beneficiarios___Favorecidos_Transacoes ADD CONSTRAINT FK_Beneficiarios___Favorecidos_Transacoes_3
    FOREIGN KEY (fk_Contas_ID_Conta)
    REFERENCES Contas (ID_Conta)
    ON DELETE RESTRICT;
 
ALTER TABLE Emprestimos ADD CONSTRAINT FK_Emprestimos_2
    FOREIGN KEY (fk_Clientes_ID_Cliente)
    REFERENCES Clientes (ID_Cliente)
    ON DELETE RESTRICT;
 
ALTER TABLE Emprestimos ADD CONSTRAINT FK_Emprestimos_3
    FOREIGN KEY (fk_Contas_ID_Conta)
    REFERENCES Contas (ID_Conta)
    ON DELETE RESTRICT;
 
ALTER TABLE Parcelas_do_Emprestimo ADD CONSTRAINT FK_Parcelas_do_Emprestimo_2
    FOREIGN KEY (fk_Emprestimos_ID_Emprestimo)
    REFERENCES Emprestimos (ID_Emprestimo)
    ON DELETE RESTRICT;
 
ALTER TABLE Investimentos ADD CONSTRAINT FK_Investimentos_2
    FOREIGN KEY (fk_Clientes_ID_Cliente)
    REFERENCES Clientes (ID_Cliente)
    ON DELETE RESTRICT;
 
ALTER TABLE Investimentos ADD CONSTRAINT FK_Investimentos_3
    FOREIGN KEY (fk_Contas_ID_Conta)
    REFERENCES Contas (ID_Conta)
    ON DELETE RESTRICT;
 
ALTER TABLE Vincula ADD CONSTRAINT FK_Vincula_1
    FOREIGN KEY (fk_Agencias_num_agencia)
    REFERENCES Agencias (num_agencia)
    ON DELETE RESTRICT;
 
ALTER TABLE Vincula ADD CONSTRAINT FK_Vincula_2
    FOREIGN KEY (fk_Clientes_ID_Cliente)
    REFERENCES Clientes (ID_Cliente)
    ON DELETE RESTRICT;
 
ALTER TABLE PodeSer ADD CONSTRAINT FK_PodeSer_1
    FOREIGN KEY (fk_Clientes_ID_Cliente)
    REFERENCES Clientes (ID_Cliente)
    ON DELETE SET NULL;
 
ALTER TABLE PodeSer ADD CONSTRAINT FK_PodeSer_2
    FOREIGN KEY (fk_Beneficiarios___Favorecidos_Transacoes_ID_Beneficiario, fk_Beneficiarios___Favorecidos_Transacoes_ID_Transacoes)
    REFERENCES Beneficiarios___Favorecidos_Transacoes (ID_Beneficiario, ID_Transacoes)
    ON DELETE SET NULL;