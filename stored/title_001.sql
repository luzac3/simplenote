DROP PROCEDURE IF EXISTS title_001;
DELIMITER //
-- ********************************************************************************************
-- title_001 新コンテンツ番号取得処理
--
-- 【処理概要】
--   ユーザー番号を受け取り新コンテンツ番号を取得する
--
--
-- 【呼び出し元画面】
--   インデックス
--
-- 【引数】
--   _trk_num           ：ユーザ登録番号
--   _shzk_cd           ：所属コード
--
--
-- 【戻り値】
--      exit_cd          : exit_cd
--      正常：0
--      異常：99
-- --------------------------------------------------------------------------------------------
-- 【更新履歴】

-- ********************************************************************************************
CREATE PROCEDURE `title_001`(
    IN `_trk_num` CHAR(4)
    , IN `_shzk_cd` CHAR(7)
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
                T_TTL_MSTR
            WHERE
                TRK_NUM ='",_trk_num,"'
            AND
                SHZK_CD = '",_shzk_cd ,"'
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
