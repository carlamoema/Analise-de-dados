-- Tabela original do csv

CREATE TABLE IF NOT EXISTS TabelaOriginal (
    data_base DATE,
    uf VARCHAR(2),
    tcb VARCHAR(50),
    sr VARCHAR(2),
    cliente VARCHAR(2),
    ocupacao VARCHAR(100), -- Ajuste o tamanho conforme necessário
    cnae_secao VARCHAR(100), -- Ajuste o tamanho conforme necessário
    cnae_subclasse VARCHAR(200), -- Ajuste o tamanho conforme necessário
    porte VARCHAR(50), -- Ajuste o tamanho conforme necessário
    modalidade VARCHAR(100), -- Ajuste o tamanho conforme necessário
    origem VARCHAR(50), -- Ajuste o tamanho conforme necessário
    indexador VARCHAR(50), -- Ajuste o tamanho conforme necessário
    numero_de_operacoes INT,
    a_vencer_ate_90_dias DECIMAL(18,2),
    a_vencer_de_91_ate_360_dias DECIMAL(18,2),
    a_vencer_de_361_ate_1080_dias DECIMAL(18,2),
    a_vencer_de_1081_ate_1800_dias DECIMAL(18,2),
    a_vencer_de_1801_ate_5400_dias DECIMAL(18,2),
    a_vencer_acima_de_5400_dias DECIMAL(18,2),
    vencido_acima_de_15_dias DECIMAL(18,2),
    carteira_ativa DECIMAL(18,2),
    carteira_inadimplida_arrastada DECIMAL(18,2),
    ativo_problematico DECIMAL(18,2)
);

-- Tabelas de Dimensão

CREATE or replace TABLE dimcalendario (
    data_id INT NOT NULL AUTO_INCREMENT,
    data_base DATE NOT NULL,
    ano INT NOT NULL,
    mes INT NOT NULL,
    mes_abreviado varchar(3) not null,
    trimestre INT NOT NULL,
    PRIMARY KEY (data_id),
    UNIQUE KEY (data_base) -- Garante unicidade nas datas
);

CREATE TABLE IF NOT EXISTS DimCalendario (
    data_id INT AUTO_INCREMENT PRIMARY KEY,
    data_base DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS DimUF (
    uf_id INT AUTO_INCREMENT PRIMARY KEY,
    uf VARCHAR(2) NOT NULL
);

CREATE TABLE IF NOT EXISTS DimTCB (
    tcb_id INT AUTO_INCREMENT PRIMARY KEY,
    tcb VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS DimSR (
    sr_id INT AUTO_INCREMENT PRIMARY KEY,
    sr VARCHAR(2) NOT NULL
);

CREATE TABLE IF NOT EXISTS DimCliente (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente VARCHAR(2) NOT NULL
);

CREATE TABLE IF NOT EXISTS DimOcupacao (
    ocupacao_id INT AUTO_INCREMENT PRIMARY KEY,
    ocupacao VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS DimCNAE (
    cnae_id INT AUTO_INCREMENT PRIMARY KEY,
    cnae_descricao VARCHAR(128)
);


CREATE TABLE IF NOT EXISTS DimPorte (
    porte_id INT AUTO_INCREMENT PRIMARY KEY,
    porte VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS DimModalidade (
    modalidade_id INT AUTO_INCREMENT PRIMARY KEY,
    modalidade VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS DimOrigem (
    origem_id INT AUTO_INCREMENT PRIMARY KEY,
    origem VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS DimIndexador (
    indexador_id INT AUTO_INCREMENT PRIMARY KEY,
    indexador VARCHAR(50)
);

-- Tabela de Fatos
CREATE TABLE IF NOT EXISTS FactOperacoes (
    operacao_id INT AUTO_INCREMENT PRIMARY KEY,
    data_id INT,
    uf_id INT,
    tcb_id INT,
    sr_id INT,
    cliente_id INT,
    ocupacao_id INT,
    cnae_id INT,
    porte_id INT,
    modalidade_id INT,
    origem_id INT,
    indexador_id INT,
    numero_de_operacoes INT,
    a_vencer_ate_90_dias DECIMAL(18,2),
    a_vencer_de_91_ate_360_dias DECIMAL(18,2),
    a_vencer_de_361_ate_1080_dias DECIMAL(18,2),
    a_vencer_de_1081_ate_1800_dias DECIMAL(18,2),
    a_vencer_de_1801_ate_5400_dias DECIMAL(18,2),
    a_vencer_acima_de_5400_dias DECIMAL(18,2),
    vencido_acima_de_15_dias DECIMAL(18,2),
    carteira_ativa DECIMAL(18,2),
    carteira_inadimplida_arrastada DECIMAL(18,2),
    ativo_problematico DECIMAL(18,2),
    FOREIGN KEY (data_id) REFERENCES Dimcalendario(data_id),
    FOREIGN KEY (uf_id) REFERENCES DimUF(uf_id),
    FOREIGN KEY (tcb_id) REFERENCES DimTCB(tcb_id),
    FOREIGN KEY (sr_id) REFERENCES DimSR(sr_id),
    FOREIGN KEY (cliente_id) REFERENCES DimCliente(cliente_id),
    FOREIGN KEY (ocupacao_id) REFERENCES DimOcupacao(ocupacao_id),
    FOREIGN KEY (cnae_id) REFERENCES DimCNAE(cnae_id),
    FOREIGN KEY (porte_id) REFERENCES DimPorte(porte_id),
    FOREIGN KEY (modalidade_id) REFERENCES DimModalidade(modalidade_id),
    FOREIGN KEY (origem_id) REFERENCES DimOrigem(origem_id),
    FOREIGN KEY (indexador_id) REFERENCES DimIndexador(indexador_id)
);
