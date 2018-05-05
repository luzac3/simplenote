DROP PROCEDURE IF EXISTS login_check_001;
DELIMITER //
-- ********************************************************************************************
-- login_check_001 ログイン確認処理
--
-- 【処理概要】
--   ユーザ名からログイン情報を取得する
--
--
-- 【呼び出し元画面】
--   インデックス
--
-- 【引数】
--   _user_name  ：ユーザ名
--
--
-- 【戻り値】
--		exit_cd            : exit_cd
--		正常：0
--		異常：99
-- --------------------------------------------------------------------------------------------
-- 【更新履歴】
--  2018.4.15 大杉　新規作成
-- ********************************************************************************************
CREATE PROCEDURE `login_check_001`(
    IN `_user_name` VARCHAR(40)
    -- , OUT `trk_num` CHAR(4)
    -- , OUT `hsh` VARCHAR(30)
    , OUT `exit_cd` INTEGER
)
COMMENT 'ログイン確認処理'

BEGIN

    -- 異常終了ハンドラ
    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET exit_cd = 99;

        SET @query = CONCAT("
            SELECT
                TRK_NUM
                ,HSH
            FROM
                T_USR_MSTR
            WHERE
                USR_NAME = '",_user_name,"'
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
