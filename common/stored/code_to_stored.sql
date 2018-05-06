DROP PROCEDURE IF EXISTS code_to_stored_001;
DELIMITER //
-- ********************************************************************************************
-- code_to_stored_001 コード値から順番にデータを出力する
--
-- 【処理概要】
--   SQL文を受け取り、コード値から順番にデータを出力する
--
--
-- 【呼び出し元画面】
--   インデックス
--
-- 【引数】
--   SQL文                 : _sql
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
CREATE PROCEDURE `code_to_stored_001`(
    IN `_sql` VARCHAR(2500)
    , OUT `exit_cd` INTEGER
)
COMMENT 'コード値変換処理'

BEGIN

    -- 異常終了ハンドラ
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET exit_cd = 99;

        SET @query = CONCAT(_sql,";");

    SET @query_text = @query;

    -- 実行
    PREPARE main_query FROM @query_text;
    EXECUTE main_query;
    DEALLOCATE PREPARE main_query;

    SET exit_cd = 0;

END
//
DELIMITER ;
