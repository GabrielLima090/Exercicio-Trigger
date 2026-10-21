CREATE TABLE funcionarios(
ID SERIAL PRIMARY KEY,
nome VARCHAR(50) NOT NULL,
cargo VARCHAR(50) NOT NULL,
salario NUMERIC (10,2) NOT NULL
);

CREATE TABLE historico_carreira (
ID SERIAL PRIMARY KEY,
funcionario_id INT NOT NULL,
cargo_antigo VARCHAR(100),
cargo_novo VARCHAR(100),
salario_antigo NUMERIC(10,2),
salario_novo NUMERIC(10,2),
data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION fn_log_alteracao()
RETURNS TRIGGER AS $$
BEGIN
IF OLD.cargo IS DISTINCT FROM NEW.cargo OR OLD.salario IS DISTINCT FROM NEW.salario THEN
INSERT INTO historico_carreira (funcionario_id, cargo_antigo, cargo_novo, salario_antigo, salario_novo) VALUES (OLD.id, OLD.cargo, NEW.cargo, OLD.salario, NEW.salario);
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_carreira
AFTER UPDATE ON funcionarios
FOR EACH ROW
EXECUTE FUNCTION fn_log_alteracao_carreira();

INSERT INTO funcionarios (nome, cargo, salario) VALUES ('Nicolas Silveira', 'Desenvolvedor Sênior', 5500.00)
UPDATE funcionarios SET cargo = 'Desenvolvedora Pleno', salario = 3500.00 WHERE id = 1;;
SELECT * FROM historico_carreira;