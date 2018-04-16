DROP PROCEDURE IF EXISTS new_content_001;
DELIMITER //
-- ********************************************************************************************
-- edit_content_001 コンテンツ新規登録処理
--
-- 【処理概要】
--   コンテンツ内容を新規登録する
--
--
-- 【呼び出し元画面】
--   インデックス
--
-- 【引数】
--   _title_serial_num  ：タイトル通番
--   _trk_num           ：登録番号
--   _cntnt             ：コンテンツ
--   _rep_cd            ：返信コード
--   _rep_no            ：返信先番号
--   _rep_no2           ：返信先番号2
--
--
-- 【戻り値】
--		exit_cd            : exit_cd
--		正常：0
--		異常：99
-- --------------------------------------------------------------------------------------------
-- 【更新履歴】
--  2018.4.14 大杉　新規作成
-- ********************************************************************************************
CREATE PROCEDURE `new_content_001`(
    IN `_title_serial_num` CHAR(10)
    , IN `_trk_num` CHAR(4)
    , IN `_cntnt` VARCHAR(2500)
    , IN `_rep_cd` CHAR(2)
    , IN `_rep_no` CHAR(2)
    , IN `_rep_no2` CHAR(2)
    , OUT `exit_cd` INTEGER
)
COMMENT 'コンテンツ新規登録処理'

BEGIN

    -- 異常終了ハンドラ
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET exit_cd = 99;

    SET @test = "test";

        SET @query = CONCAT("
            INSERT INTO T_CNTNT
                (
                CNTNT_SRAL_NUM
                ,TTL_SRAL_NUM
                ,SHZK_CD
                ,TRK_NUM
                ,CNTNT_NUM
                ,CNTNT
                ,REP_CD
                ,REP_NO
                ,REP_NO2
                ,LAST_KUSN_SH_TRK_NUM
                ,TURK_NTJ
                ,KUSN_NTJ
                )
            SELECT
                CNTNT_SRAL_NUM_TBL.CNTNT_SRAL_NUM AS CNTNT_SRAL_NUM
               ,'",_title_serial_num,"'
                ,TTM_TBL.SHZK_CD
                ,'",_trk_num,"'
               ,CNTNT_NUM_TBL.CNTNT_NUM AS CNTNT_NUM
                ,'",_cntnt,"'
                ,'",_rep_cd,"'
                ,'",_rep_no,"'
                ,'",_rep_no2,"'
                ,'",_trk_num,"'
                ,now()
                ,now()
            FROM
               (
                   SELECT
                       IF(COUNT(1) = 0, '0000000000', LPAD( CAST( (MAX( CAST(CNTNT_SRAL_NUM AS UNSIGNED) ) + 1) AS CHAR ),10,'0') ) AS CNTNT_SRAL_NUM
                   FROM
                       T_CNTNT
               ) CNTNT_SRAL_NUM_TBL
               ,(
                    SELECT
                        SHZK_CD
                    FROM
                        T_TTL_MSTR TTM
                    WHERE
                        TTM.TTL_SRAL_NUM = '",_title_serial_num,"'
                ) TTM_TBL
                ,(
                   SELECT
                       IF(COUNT(1) = 0, '00', LPAD( CAST( (MAX( CAST(CNTNT_NUM AS UNSIGNED) ) + 1) AS CHAR ),2,'0') ) AS CNTNT_NUM
                    FROM
                        T_CNTNT
                    WHERE
                        TTL_SRAL_NUM = '",_title_serial_num ,"'
                    AND
                        TRK_NUM = '",_trk_num ,"'
        ")
        ;

        SET @query2 = CONCAT("
                ) CNTNT_NUM_TBL
                ,(
                    SELECT
                        IF(COUNT(1) = 0, '00', LPAD( CAST( (MAX( CAST(CNTNT_NUM AS UNSIGNED) ) + 1) AS CHAR ),2,'0') ) AS CNTNT_NUM
                    FROM
                        T_CNTNT
                    WHERE
                        REP_CD = '",_rep_cd ,"'
        ")
        ;

        SET @query3 = CONCAT("
                ) REP_TBL
        ")
        ;

       SET @query_rep = "";

       IF IFNULL(_rep_no, '') != '' THEN
           SET @query_rep = CONCAT(@query_rep," AND ");
           SET @query_rep = CONCAT(@query_rep,"REP_NO = '",_rep_no ,"'");
       END IF;

       IF IFNULL(_rep_no2, '') != '' THEN
           SET @query_rep = CONCAT(@query_rep," AND ");
           SET @query_rep = CONCAT(@query_rep,"REP_NO2 = '",_rep_no2 ,"'");
       END IF;

       SET @query_text = CONCAT(@query,@query_rep,@query2,@query_rep,@query3);

    -- 実行
    PREPARE main_query FROM @query_text;
    EXECUTE main_query;
    DEALLOCATE PREPARE main_query;

    SET exit_cd = 0;

END
//
DELIMITER ;
