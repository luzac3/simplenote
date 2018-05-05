DROP PROCEDURE IF EXISTS content_list_001;
DELIMITER //
-- ********************************************************************************************
-- content_list_001 コンテンツ数カウント処理
--
-- 【処理概要】
--   コンテンツ数をカウントする
--
--
-- 【呼び出し元画面】
--   インデックス
--
-- 【引数】
--   _title_serial_num  ：タイトル通番
--
--
-- 【戻り値】
--       exit_cd          : exit_cd
--      正常：0
--      異常：99
-- --------------------------------------------------------------------------------------------
-- 【更新履歴】

-- ********************************************************************************************
CREATE PROCEDURE `content_list_001`(
    IN `_title_serial_num` CHAR(10)
    , OUT `exit_cd` INTEGER
)
COMMENT 'タイトル数取得処理'

BEGIN

    -- 異常終了ハンドラ
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET exit_cd = 99;

        SET @query = CONCAT("
            SELECT
                COUNT(1) AS COUNT
            FROM
                T_CNTNT
            WHERE
                TTL_SRAL_NUM = '",_title_serial_num ,"'
        ")
        ;

        SET @query_text = @query;

    -- 実行
    PREPARE main_query FROM @query_text;
    EXECUTE main_query;
    DEALLOCATE PREPARE main_query;

    SET exit_cd = 0;

END
//
DELIMITER ;
