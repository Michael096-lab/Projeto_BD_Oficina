-- Criação das tabelas
CREATE TABLE Clientes (
    id_cliente INT PRIMARY KEY,
    nome VARCHAR(100),
    telefone VARCHAR(20),
    email VARCHAR(100),
    endereco VARCHAR(200)
);

CREATE TABLE Veiculos (
    id_veiculo INT PRIMARY KEY,
    id_cliente INT,
    marca VARCHAR(50),
    modelo VARCHAR(50),
    ano INT,
    placa VARCHAR(20),
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE Servicos (
    id_servico INT PRIMARY KEY,
    descricao VARCHAR(200),
    preco DECIMAL(10, 2)
);

CREATE TABLE Agendamentos (
    id_agendamento INT PRIMARY KEY,
    id_cliente INT,
    id_veiculo INT,
    data_hora DATETIME,
    id_servico INT,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_veiculo) REFERENCES Veiculos(id_veiculo),
    FOREIGN KEY (id_servico) REFERENCES Servicos(id_servico)
);

CREATE TABLE Pagamentos (
    id_pagamento INT PRIMARY KEY,
    id_agendamento INT,
    valor DECIMAL(10, 2),
    data_pagamento DATE,
    FOREIGN KEY (id_agendamento) REFERENCES Agendamentos(id_agendamento)
);


-- Recuperação simples de todos os clientes
SELECT * FROM Clientes;

-- Filtro de veículos por ano
SELECT * FROM Veiculos WHERE ano > 2015;


-- Valor total de um agendamento
SELECT a.*, s.preco AS preco_servico, (s.preco + COALESCE(p.valor, 0)) AS valor_total
FROM Agendamentos a
INNER JOIN Servicos s ON a.id_servico = s.id_servico
LEFT JOIN Pagamentos p ON a.id_agendamento = p.id_agendamento;


-- Agendamentos por data e hora
SELECT * FROM Agendamentos ORDER BY data_hora;


-- Mais de 2 agendamentos
SELECT s.descricao, COUNT(a.id_agendamento) AS quantidade_agendamentos
FROM Agendamentos a
INNER JOIN Servicos s ON a.id_servico = s.id_servico
GROUP BY s.descricao
HAVING COUNT(a.id_agendamento) > 2;


-- Informações completas de um agendamento
SELECT c.nome, v.marca, v.modelo, a.data_hora, s.descricao
FROM Agendamentos a
INNER JOIN Clientes c ON a.id_cliente = c.id_cliente
INNER JOIN Veiculos v ON a.id_veiculo = v.id_veiculo
INNER JOIN Servicos s ON a.id_servico = s.id_servico
WHERE a.id_agendamento = 1;
