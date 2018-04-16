DROP PROCEDURE IF EXISTS prmssn_cd;
DELIMITER //
-- ********************************************************************************************
-- prmssn_cd 許可コード取得
--
-- 【処理概要】
--   許可コード取得
--
--
-- 【呼び出し元画面】
--   インデックス
--
-- 【引数】
--   なし
--
--
-- 【戻り値】
--		exit_cd            : exit_cd
--		正常：0
--		異常：99
-- --------------------------------------------------------------------------------------------
-- 【更新履歴】

-- ********************************************************************************************
CREATE PROCEDURE `prmssn_cd`(
    OUT `exit_cd` INTEGER
)
COMMENT '許可コード取得処理'

BEGIN

    -- 異常終了ハンドラ
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET exit_cd = 99;

        SET @query = CONCAT("
            SELECT
                PRMSSN_CD
                ,PRMSSN_NAME
            FROM
                C_PRMSSN_CD
        ")
        ;

    -- 実行
    PREPARE main_query FROM @query_text;
    EXECUTE main_query;
    DEALLOCATE PREPARE main_query;

    SET exit_cd = 0;

END
//
DELIMITER ;
