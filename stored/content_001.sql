DROP PROCEDURE IF EXISTS content_001;
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
--
--
-- 【戻り値】
--		exit_cd            : exit_cd
--		正常：0
--		異常：99
-- --------------------------------------------------------------------------------------------
-- 【更新履歴】
--  2018.3.20 大杉　新規作成
--  2018.4.11 大杉　役職対応
-- ********************************************************************************************
CREATE PROCEDURE `content_001`(
    IN `_content_serial_num` CHAR(10)
    , IN `_trk_num` CHAR(4)
    , OUT `exit_cd` INTEGER
)
COMMENT 'コンテンツ取得処理'

BEGIN

    -- 異常終了ハンドラ
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET exit_cd = 99;

        SET @query = CONCAT("
            SELECT
                TC.CNTNT_SRAL_NUM
                ,TC.CNTNT
                ,TC.REP_CD
                ,TC.LAST_KUSN_SH_TRK_NUM
                ,TC.KUSN_NTJ
                -- 作成者コード
                ,IF(
                    TC.TRK_NUM = '",_trk_num,"'
                    ,'1'
                    ,NULL
                ) AS ATH_FLG
                -- ユーザ管理権限コードとグループ管理権限コードの小さい方
                ,(
                    CASE
                    WHEN IFNULL(SUM_AC.USR_ADMN_CD,0) < IFNULL(SUM_AC.GRP_ADMN_CD,0) THEN SUM_AC.USR_ADMN_CD
                    WHEN IFNULL(SUM_AC.GRP_ADMN_CD,0) < IFNULL(SUM_AC.USR_ADMN_CD,0) THEN SUM_AC.GRP_ADMN_CD
                    ELSE NULL END
                ) AS ADMN_CD
                -- コンテンツごとの権限コード
                ,PRMSSN_CD.PRMSSN_CD AS PRMSSN_CD
            FROM
                (
                    SELECT
                        TUM.ADMN_CD AS USR_ADMN_CD
                        ,MIN(TGM.ADMN_CD) AS GRP_ADMN_CD
                    FROM
                        T_USR_MSTR TUM
                    LEFT OUTER JOIN T_GRP TG
                        ON TG.USR_TRK_NUM = TUM.TRK_NUM
                    LEFT OUTER JOIN T_GRP_MSTR TGM
                        ON TGM.GRP_TRK_NUM = TG.GRP_TRK_NUM
                    WHERE
                        TUM.TRK_NUM = '",_trk_num,"'
                    GROUP BY
                        TUM.ADMN_CD
                ) AS SUM_AC
                ,(
                    SELECT MIN(TCPM.PRMSSN_CD) AS PRMSSN_CD
                    FROM
                        T_USR_MSTR TUM
                    LEFT OUTER JOIN T_GRP TG
                        ON TG.USR_TRK_NUM = TUM.TRK_NUM
                    LEFT OUTER JOIN T_GRP_MSTR TGM
                        ON TGM.GRP_TRK_NUM = TG.GRP_TRK_NUM
                    LEFT OUTER JOIN T_CNTNT_PRMSSN_MSTR TCPM
                        ON (
                                TGM.GRP_TRK_NUM = TCPM.GU_TRK_NUM
                            OR
                                TUM.TRK_NUM = TCPM.GU_TRK_NUM
                        )
                    WHERE TUM.TRK_NUM = '",_trk_num,"'
                ) AS PRMSSN_CD
                ,T_CNTNT TC
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
