DROP PROCEDURE IF EXISTS content_edit_001;
DELIMITER //
-- ********************************************************************************************
-- content_001 コンテンツ取得処理
--
-- 【処理概要】
--   コンテンツ詳細を取得する
--
--
-- 【呼び出し元画面】
--   インデックス
--
-- 【引数】
--   _content_serial_num  ：コンテンツ通番
--   _trk_num             ：登録番号
--   _cntnt               ：コンテンツ内容
--
--
-- 【戻り値】
--		exit_cd            : exit_cd
--		正常：0
--		異常：99
-- --------------------------------------------------------------------------------------------
-- 【更新履歴】
--  2018.4.17 大杉　新規作成
-- ********************************************************************************************
CREATE PROCEDURE `content_edit_001`(
    IN `_content_serial_num` CHAR(10)
    , IN `_trk_num` CHAR(4)
    , IN `_cntnt` VARCHAR(2500)
    , OUT `exit_cd` INTEGER
)
COMMENT 'コンテンツ取得処理'

BEGIN

    -- 異常終了ハンドラ
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET exit_cd = 99;

        SET @query = CONCAT("
            UPDATE
                T_CNTNT
            SET
                CNTNT = '",_cntnt,"'
                ,LAST_KUSN_SH_TRK_NUM = '",_trk_num,"'
                ,KUSN_NTJ = NOW()
            WHERE
                CNTNT_SRAL_NUM = '",_content_serial_num,"'
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
