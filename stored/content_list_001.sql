DROP PROCEDURE IF EXISTS content_list_001;
DELIMITER //
-- ********************************************************************************************
-- content_list_001 コンテンツリスト取得処理
--
-- 【処理概要】
--   タイトル連番を受け取り、紐づくコンテンツリストを取得する
--
--
-- 【呼び出し元画面】
--   インデックス
--
-- 【引数】
--   _title_serial_num  ：タイトル連番
--   _trk_num           ：ユーザ登録番号
--   _limit             ：表示数
--   _offset            ：ページ番号
--   _sort              ：ソート条件
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
    , IN `_trk_num` VARCHAR(4)
    , IN `_limit` VARCHAR(3)
    , IN `_offset` VARCHAR(2)
    , IN `_sort` VARCHAR(40)
    , OUT `exit_cd` INTEGER
)
COMMENT 'タイトル数取得処理'

BEGIN

    -- 異常終了ハンドラ
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET exit_cd = 99;

        SET @query = CONCAT("
            SELECT
                TC.CNTNT_SRAL_NUM
                ,TC.CNTNT_NUM
                ,TC.CNTNT
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
                    WHEN IFNULL(ADMN_CD.USR_ADMN_CD,0) < IFNULL(ADMN_CD.GRP_ADMN_CD,0) THEN ADMN_CD.USR_ADMN_CD
                    WHEN IFNULL(ADMN_CD.GRP_ADMN_CD,0) < IFNULL(ADMN_CD.USR_ADMN_CD,0) THEN ADMN_CD.GRP_ADMN_CD
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
                ) AS ADMN_CD
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
                ,T_TTL_MSTR TTM
                LEFT OUTER JOIN T_CNTNT TC
                    ON TTM.SHZK_CD = TC.SHZK_CD
                    AND TTM.TRK_NUM = TC.TRK_NUM
            WHERE
                TTM.TTL_SRAL_NUM = '",_title_serial_num ,"'
        ")
        ;

        -- ソート
        SET @query_order = " ";

        IF IFNULL(_sort, '') != '' THEN
            SET @query_order = CONCAT(@query_order,_sort);
        ELSE
            SET @query_order = CONCAT(@query_order,"ORDER BY TC.CNTNT_NUM ASC");
        END IF;

        -- 表示数
        IF IFNULL(_limit, '') != '' THEN
            SET @query_limit = CONCAT(" LIMIT ",_limit);
        ELSE
            SET @query_limit = " LIMIT 20";
        END IF;

        -- ページ番号(ページ番号×LIMIT数の形)
        SET @query_offset = CONCAT(" OFFSET ",_offset * _limit);

        SET @query_text = CONCAT(@query,@query_order,@query_limit,@query_offset);

    -- 実行
    PREPARE main_query FROM @query_text;
    EXECUTE main_query;
    DEALLOCATE PREPARE main_query;

    SET exit_cd = 0;

END
//
DELIMITER ;
