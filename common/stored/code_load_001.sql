DROP PROCEDURE IF EXISTS code_load_001;
DELIMITER //
-- ********************************************************************************************
-- code_load_001 コード値と対応する名称を取得する処理
--
-- 【処理概要】
--   コード値と対応する名称を取得する
--
--
-- 【呼び出し元画面】
--   インデックス
--
-- 【引数】
--   テーブル名            : _table_name
--   コードカラム名        : _cd_clmn_name
--
--
-- 【戻り値】
--		exit_cd            : exit_cd
--		正常：0
--		異常：99
-- --------------------------------------------------------------------------------------------
-- 【更新履歴】
--  2018.5.6 大杉　新規作成
-- ********************************************************************************************
CREATE PROCEDURE `code_load_001`(
    IN `_table_name` VARCHAR(40)
    , IN `_cd_clmn_name` VARCHAR(40)
    , OUT `exit_cd` INTEGER
)
COMMENT 'コード値取得処理'

BEGIN

    -- 異常終了ハンドラ
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET exit_cd = 99;

        SET @query = CONCAT("
            SELECT
                *
            FROM
                ",_table_name,"
            ORDER BY
                ",_cd_clmn_name," ASC
        ;
        ");

    SET @query_text = @query;

    -- 実行
    PREPARE main_query FROM @query_text;
    EXECUTE main_query;
    DEALLOCATE PREPARE main_query;

    SET exit_cd = 0;

END
//
DELIMITER ;
