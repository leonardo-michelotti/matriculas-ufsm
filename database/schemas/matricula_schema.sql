CREATE DATABASE matriculas;
USE matriculas;

CREATE TABLE Centro (
    codigo_centro VARCHAR(10) NOT NULL,
    PRIMARY KEY (codigo_centro)
);
INSERT INTO Centro (codigo_centro) VALUES 
    ('CAL'), ('CCNE'), ('CCR'), ('CCS'),
    ('CCSH'), ('CE'), ('CEFD'), ('CT'),
    ('CTISM'), ('POLI'), ('CS'), ('FW'), ('PM');
  
CREATE TABLE Sala (
    centro VARCHAR(10) NOT NULL,
    numero INT NOT NULL,
    capacidade_alunos TINYINT NOT NULL,
    tipo ENUM('Laboratório', 'Sala'),
    PRIMARY KEY (centro, numero),
    FOREIGN KEY (centro) REFERENCES Centro(codigo_centro)
);

CREATE TABLE Disciplina (
    codigo_disciplina VARCHAR(10) NOT NULL, 
    nome VARCHAR(100) NOT NULL,
    semestre_disciplina TINYINT NOT NULL,
    ementa VARCHAR(220),
    carga_horaria INT,
    PRIMARY KEY (codigo_disciplina)
);

-- Tabela Curso
CREATE TABLE Curso (
    id INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    campus VARCHAR(100) NOT NULL,
    ementa VARCHAR(220),  -- URL da ementa
    centro VARCHAR(10) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (centro) REFERENCES Centro(codigo_centro)
);

CREATE TABLE Professor (
    Matricula BIGINT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    centro VARCHAR(10) NOT NULL,
    PRIMARY KEY (Matricula),
    FOREIGN KEY (centro) REFERENCES Centro(codigo_centro)
);

CREATE TABLE Aluno (
    matricula BIGINT NOT NULL,
    nome VARCHAR(100) NOT NULL,
    id_curso INT NOT NULL,  
    PRIMARY KEY (matricula),
    FOREIGN KEY (id_curso) REFERENCES Curso(id)
);

CREATE TABLE Turma (
    ano YEAR NOT NULL,
    semestre_turma ENUM('1','2') NOT NULL,
    N_vagas INT,
    data_inicio DATE,
    data_fim DATE,
    codigo_disciplina VARCHAR(10) NOT NULL,
    Matricula_Professor BIGINT NOT NULL,
    Centro_Sala VARCHAR(10) NOT NULL,
    Numero_Sala INT NOT NULL,
    dia_semana ENUM('Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab', 'Dom') NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    PRIMARY KEY (ano, semestre_turma, codigo_disciplina, Matricula_Professor),
    FOREIGN KEY (codigo_disciplina) REFERENCES Disciplina(codigo_disciplina),
    FOREIGN KEY (Matricula_Professor) REFERENCES Professor(Matricula),
    FOREIGN KEY (Centro_Sala, Numero_Sala) REFERENCES Sala(centro, numero),
    CHECK (hora_inicio >= '07:30:00' AND hora_inicio <= '20:00:00'),
    CHECK (hora_fim >= ADDTIME(hora_inicio, '01:00:00') AND hora_fim <= ADDTIME(hora_inicio, '04:00:00')),
    CHECK (hora_fim <= '23:00:00')
);

CREATE TABLE Turma_Aluno (
    ano_turma YEAR NOT NULL,
    semestre_turma ENUM ('1','2') NOT NULL,
    codigo_disciplina VARCHAR(10) NOT NULL,
    Matricula_Aluno BIGINT NOT NULL,
    Matricula_Professor BIGINT NOT NULL,
    situacao_aluno ENUM('Matricula', 'Aprovado com nota', 'Reprovado por Frequência', 'Reprovado com Nota'),
    PRIMARY KEY (ano_turma, semestre_turma, codigo_disciplina, Matricula_Aluno),
    FOREIGN KEY (ano_turma, semestre_turma, codigo_disciplina, Matricula_Professor) 
        REFERENCES Turma(ano, semestre_turma, codigo_disciplina, Matricula_Professor),
    FOREIGN KEY (Matricula_Aluno) REFERENCES Aluno(matricula)
);
