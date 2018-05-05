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

    DECLARE in_sral_num CHAR(10);

    -- 異常終了ハンドラ
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET exit_cd = 99;

    SELECT
        IF(COUNT(1) = 0, '0000000000', LPAD( CAST( (MAX( CAST(TTL_SRAL_NUM AS UNSIGNED) ) + 1) AS CHAR ),10,'0') ) INTO in_sral_num
    FROM
        T_TTL_MSTR
    ;

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
                    ,TTL_NUM
                    ,TURK_NTJ
                    ,KUSN_NTJ
                )
            SELECT
                '",in_sral_num,"'
                ,'",_shzk_cd,"'
                ,'",_trk_num,"'
                ,null
                ,null
                ,'",_title,"'
                ,TTL_NUM_TBL.TTL_NUM AS TTL_NUM
                ,NOW()
                ,NOW()
            FROM
                (
                    SELECT
                        IF(COUNT(1) = 0, '000', LPAD( CAST( (MAX( CAST(TTL_NUM AS UNSIGNED) ) + 1) AS CHAR ),3,'0') ) AS TTL_NUM
                    FROM
                        T_TTL_MSTR
                    WHERE
                        SHZK_CD = '",_shzk_cd,"'
                    AND
                        TRK_NUM = '",_trk_num,"'
                ) TTL_NUM_TBL
        ;
        ")
        ;

    -- 実行
    PREPARE main_query FROM @query;
    EXECUTE main_query;
    DEALLOCATE PREPARE main_query;

        SET @query2 = CONCAT("
        INSERT INTO
                T_TTL_PRMSSN_MSTR
                (
                    TTL_SRAL_NUM
                    ,GU_TRK_NUM
                    ,PRMSSN_CD
                    ,PBLSH_FLG
                    ,TURK_NTJ
                    ,KUSN_NTJ
                )
            SELECT
                '",in_sral_num,"'
                ,'",_trk_num,"'
                ,'0'
                ,'1'
                ,NOW()
                ,NOW()
        ;
        ")
        ;

    -- 実行
    PREPARE main_query FROM @query2;
    EXECUTE main_query;
    DEALLOCATE PREPARE main_query;


    SET exit_cd = 0;

END
//
DELIMITER ;
