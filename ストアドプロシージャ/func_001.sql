DROP PROCEDURE IF EXISTS func_001;
DELIMITER //
-- ********************************************************************************************
-- func_001 タイトル数取得処理
--
-- 【処理概要】
--   ユーザに紐づくタイトル一覧を呼び出す
--   
--
-- 【呼び出し元画面】
--   インデックス
--
-- 【引数】
--   _case				：検索条件
--   
--
-- 【戻り値】
--		exit_cd			: exit_cd
--		正常：0
--		異常：99
-- --------------------------------------------------------------------------------------------
-- 【更新履歴】

-- ********************************************************************************************
CREATE PROCEDURE `func_001`(
	IN `_case` VARCHAR(50)
	, OUT `exit_cd` INTEGER
)
COMMENT 'タイトル数取得処理'

BEGIN
	
	-- 異常終了ハンドラ
	DECLARE EXIT HANDLER FOR SQLEXCEPTION SET exit_cd = 99;

		SET @query = CONCAT("
			SELECT
				SORT_CD
				,SORT_NAME
			FROM
				C_SORT_CD
		")
		;

	SET @query_add = ' WHERE';
	SET @query_add = CONCAT(@query_add," SORT_CD IN ('",_case ,"')");
	
	SET @query = CONCAT(@query,@query_add);

	-- 実行
	PREPARE main_query FROM @query;
	EXECUTE main_query;
	DEALLOCATE PREPARE main_query;
	
	SET exit_cd = 0;

END
//
DELIMITER ;
