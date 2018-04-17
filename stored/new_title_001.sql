DROP PROCEDURE IF EXISTS new_title_001;
DELIMITER //
-- ********************************************************************************************
-- new_title_001 新規タイトル作成処理
--
-- 【処理概要】
--   ユーザに紐づくタイトル一覧を呼び出す
--
--
-- 【呼び出し元画面】
--   インデックス
--
-- 【引数】
--   _trk_num           ：ユーザCD(登録番号)
--   _shzk_cd           ：所属CD
--   _title             ：新規タイトル
--
--
-- 【戻り値】
--      exit_cd         : exit_cd
--      正常：0
--      異常：99
-- --------------------------------------------------------------------------------------------
-- 【更新履歴】

-- ********************************************************************************************
CREATE PROCEDURE `new_title_001`(
    IN `_trk_num` CHAR(4)
    , IN `_shzk_cd` CHAR(7)
    , IN `_title` VARCHAR(40)
    , OUT `exit_cd` INTEGER
)
COMMENT 'タイトル数取得処理'

BEGIN

    -- 異常終了ハンドラ
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET exit_cd = 99;

        SET @query = CONCAT("
            INSERT INTO
                T_TTL_MSTR
                (
                    TTL_SRAL_NUM
                    ,SHZK_CD
                    ,TRK_NUM
                    ,SHBT_CD
                    ,JUNLE_CD
                    ,TITLE
                    ,TITLE_NUM
                    ,TURK_NTJ
                    ,KUSN_NTJ
                )
            SELECT
                TTL_SRAL_NUM_TBL.TTL_SRAL_NUM AS TTL_SRAL_NUM
                ,'",_shzk_cd,"'
                ,'",_trk_num,"'
                ,null
                ,null
                ,'",_title,"'
                ,TITLE_NUM_TBL.TITLE_NUM AS TITLE_NUM
                ,NOW()
                ,NOW()
            FROM
                (
                   SELECT
                       IF(COUNT(1) = 0, '0000000000', LPAD( CAST( (MAX( CAST(TTL_SRAL_NUM AS UNSIGNED) ) + 1) AS CHAR ),10,'0') ) AS TTL_SRAL_NUM
                   FROM
                       T_TTL_MSTR
                ) TTL_SRAL_NUM_TBL
                ,(
                    SELECT
                        IF(COUNT(1) = 0, '000', LPAD( CAST( (MAX( CAST(TITLE_NUM AS UNSIGNED) ) + 1) AS CHAR ),3,'0') ) AS TITLE_NUM
                    FROM
                        T_TTL_MSTR
                    WHERE
                        SHZK_CD = '",_shzk_cd,"'
                    AND
                        TRK_NUM = '",_trk_num,"'
                ) TITLE_NUM_TBL
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
