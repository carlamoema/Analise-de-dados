-- Identificando os valores máximo e mínimo na base
SELECT 
    MIN(data_base) AS data_minima,
    MAX(data_base) AS data_maxima
FROM 
    tabelaoriginal t ;


-- Populando a tabela dimcalendario com datas de 2023-01-31 a 2024-12-31

DELIMITER //

CREATE PROCEDURE popular_dimcalendario()  
BEGIN
    DECLARE data_atual DATE;
    DECLARE data_final DATE;
    
    SET data_atual = '2023-01-31';
    SET data_final = '2024-12-31';
    
    WHILE data_atual <= data_final DO
        INSERT INTO dimcalendario (data_base, ano, mes, mes_abreviado, trimestre)
        VALUES (data_atual, YEAR(data_atual), MONTH(data_atual), DATE_FORMAT(data_atual, '%b'),  QUARTER(data_atual));
        SET data_atual = LAST_DAY(DATE_ADD(data_atual, INTERVAL 1 MONTH));
    END WHILE;
    
END //

DELIMITER ;

commit;

CALL popular_dimcalendario();

-- Populando a tabela factoperacoes com os dados da tabela original 

INSERT INTO factoperacoes (
    data_id, uf_id, tcb_id, sr_id, cliente_id, ocupacao_id, cnae_id, 
    porte_id, modalidade_id, origem_id, indexador_id, numero_de_operacoes,
    a_vencer_ate_90_dias, a_vencer_de_91_ate_360_dias,
    a_vencer_de_361_ate_1080_dias, a_vencer_de_1081_ate_1800_dias,
    a_vencer_de_1801_ate_5400_dias, a_vencer_acima_de_5400_dias,
    vencido_acima_de_15_dias, carteira_ativa,
    carteira_inadimplida_arrastada, ativo_problematico
)
select
    dc.data_id, du.uf_id, dt.tcb_id, ds.sr_id, dcl.cliente_id,
    do.ocupacao_id, dce.cnae_id, dp.porte_id, dm.modalidade_id,
    doi.origem_id, di.indexador_id, 
    numero_de_operacoes, a_vencer_ate_90_dias, a_vencer_de_91_ate_360_dias,
    a_vencer_de_361_ate_1080_dias, a_vencer_de_1081_ate_1800_dias,
    a_vencer_de_1801_ate_5400_dias, a_vencer_acima_de_5400_dias,
    vencido_acima_de_15_dias, carteira_ativa,
    carteira_inadimplida_arrastada, ativo_problematico
FROM
    tabelaoriginal orig
LEFT JOIN dimcalendario dc ON orig.data_base = dc.data_base 
LEFT JOIN dimuf du ON orig.uf = du.uf
LEFT JOIN dimtcb dt ON orig.tcb = dt.tcb
LEFT JOIN dimsr ds ON orig.sr = ds.sr
LEFT JOIN dimcliente dcl ON orig.cliente = dcl.cliente
LEFT JOIN dimocupacao do ON orig.ocupacao = do.ocupacao
left join dimcnae dce on orig.cnae_secao = dce.cnae_descricao
LEFT JOIN dimporte dp ON orig.porte = dp.porte
LEFT JOIN dimmodalidade dm ON orig.modalidade = dm.modalidade
LEFT JOIN dimorigem doi ON orig.origem = doi.origem
LEFT JOIN dimindexador di ON orig.indexador = di.indexador
where ORIG.data_base between '2023-01-31' and '2023-12-31'     -- 1
and orig.uf <> 'GO'                                            -- 1 
;

commit;

