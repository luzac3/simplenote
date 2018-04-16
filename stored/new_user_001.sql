DROP PROCEDURE IF EXISTS new_user_001;
DELIMITER //
-- ********************************************************************************************
-- new_user_001 新規ユーザー登録
--
-- 【処理概要】
--   ユーザーを新規登録する
--
--
-- 【呼び出し元画面】
--   インデックス
--
-- 【引数】
--   _twitter_cd        ：ツイッター名
--   _mail              ：メールアドレス
--   _user_name         ：ユーザ名
--   _hash              ：ハッシュ値
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
CREATE PROCEDURE `new_user_001`(
    IN `_twitter_cd` VARCHAR(40)
    , IN `_mail` VARCHAR(80)
    , IN `_user_name` VARCHAR(40)
    , IN `_hash` VARCHAR(80)
    , OUT `exit_cd` INTEGER
)
COMMENT '新規ユーザー登録'

BEGIN

    -- 異常終了ハンドラ
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET exit_cd = 99;

    SET @query = CONCAT("
        INSERT INTO T_USR_MSTR
            (
            TRK_NUM
            ,TWITTER_USR_CD
            ,ML_ADDRSS
            ,USR_NAME
            ,HSH
            ,ADMN_CD
            ,TURK_NTJ
            ,KUSN_NTJ
            )
        SELECT
            IF(COUNT(1) = 0, '0000', LPAD( CAST( (MAX( CAST(TRK_NUM AS UNSIGNED) ) + 1) AS CHAR ),4,'0') ) AS TRK_NUM
            ,IF ('",_twitter_cd,"' = '', NULL, '",_twitter_cd,"')
            ,IF ('",_mail,"' = '', NULL, '",_mail,"')
            ,IF ('",_user_name,"' = '', NULL, '",_user_name,"')
            ,IF ('",_hash,"' = '', NULL, '",_hash,"')
            ,'2'
            ,now()
            ,now()
        FROM
            T_USR_MSTR
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
