CREATE OR REPLACE TRIGGER tg_seq_toc
BEFORE INSERT ON TIPOS_OCORRENCIA
FOR EACH ROW
BEGIN
    :new.toc_id := seq_toc.nextval;
END;
/

CREATE OR REPLACE TRIGGER tg_seq_est
BEFORE INSERT ON ESTADOS
FOR EACH ROW
BEGIN
    :new.est_id := seq_est.nextval;
END;
/

CREATE OR REPLACE TRIGGER tg_seq_mun
BEFORE INSERT ON MUNICIPIOS
FOR EACH ROW
BEGIN
    :new.mun_id := seq_mun.nextval;
END;
/

CREATE OR REPLACE TRIGGER tg_seq_clb
BEFORE INSERT ON CALIBRES
FOR EACH ROW
BEGIN
    :new.clb_id := seq_clb.nextval;
END;
/

CREATE OR REPLACE TRIGGER tg_seq_mar
BEFORE INSERT ON MARCAS
FOR EACH ROW
BEGIN
    :new.mar_id := seq_mar.nextval;
END;
/

CREATE OR REPLACE TRIGGER tg_seq_arm
BEFORE INSERT ON ARMAS
FOR EACH ROW
BEGIN
    :new.arm_id := seq_arm.nextval;
END;
/

CREATE OR REPLACE TRIGGER tg_seq_oco
BEFORE INSERT ON OCORRENCIAS
FOR EACH ROW
BEGIN
    :new.oco_id := seq_oco.nextval;
END;
/
