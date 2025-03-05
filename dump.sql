-- Criar o banco de dados
CREATE DATABASE fluxo_caixa;

-- Usar o banco de dados
\c fluxo_caixa;

-- Criar tabela de lançamentos financeiros
CREATE TABLE lancamentos (
    id SERIAL PRIMARY KEY,
    tipo VARCHAR(10) CHECK (tipo IN ('credito', 'debito')) NOT NULL,
    valor NUMERIC(10,2) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criar tabela de saldo consolidado
CREATE TABLE saldo_consolidado (
    id SERIAL PRIMARY KEY,
    data DATE UNIQUE NOT NULL,
    saldo NUMERIC(10,2) NOT NULL,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Criar índice para melhorar a performance nas buscas por data
CREATE INDEX idx_lancamentos_data ON lancamentos (data_criacao);
CREATE INDEX idx_saldo_data ON saldo_consolidado (data);

-- Criar trigger para atualizar saldo consolidado automaticamente
CREATE OR REPLACE FUNCTION atualizar_saldo()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO saldo_consolidado (data, saldo, atualizado_em)
    VALUES (CURRENT_DATE, (SELECT COALESCE(SUM(CASE WHEN tipo = 'credito' THEN valor ELSE -valor END), 0) FROM lancamentos WHERE data_criacao::DATE = CURRENT_DATE), NOW())
    ON CONFLICT (data) DO UPDATE SET
        saldo = EXCLUDED.saldo,
        atualizado_em = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_atualizar_saldo
AFTER INSERT ON lancamentos
FOR EACH ROW
EXECUTE FUNCTION atualizar_saldo();
