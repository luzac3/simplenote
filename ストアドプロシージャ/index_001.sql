DROP PROCEDURE IF EXISTS index_001;
DELIMITER //
-- ********************************************************************************************
-- index_001 タイトル数取得処理
--
-- 【処理概要】
--   タイトル数をカウントする
--   
--
-- 【呼び出し元画面】
--   インデックス
--
-- 【引数】
--   _trk_num			：ユーザCD(登録番号)
--   _shbt_cd			：種別CD
--   _junle_cd			：ジャンルCD
--   
--
-- 【戻り値】
--   exit_cd			: exit_cd
--		正常：0
--		異常：99
-- --------------------------------------------------------------------------------------------
-- 【更新履歴】

-- ********************************************************************************************
CREATE PROCEDURE `index_001`(
	IN `_trk_num` CHAR(4)
	, IN `_shbt_cd` CHAR(2)
	, IN `_junle_cd` CHAR(2)
	, OUT `exit_cd` INTEGER
)
COMMENT 'タイトル数取得処理'

BEGIN
	-- 異常終了ハンドラ
	DECLARE EXIT HANDLER FOR SQLEXCEPTION SET exit_cd = 1;

	SET @query = CONCAT("
		SELECT
			COUNT(TITLE_NUM) AS num
		FROM
			T_TITLE_MSTR
		WHERE
			TRK_NUM = '",_trk_num ,"'
	")
	;
	
	# 絞る条件
	SET @query_add = "";
	
	-- 種別コード
	IF IFNULL(_shbt_cd, '') != '' THEN
		SET @query_add = CONCAT(@query_add, ' AND');
		SET @query_add = CONCAT(@query_add, " SHBT_CD = '",_shbt_cd ,"'");
	END IF;
	
	-- ジャンルコード
	IF IFNULL(_junle_cd, '') != '' THEN
		SET @query_add = CONCAT(@query_add, ' AND');
		SET @query_add = CONCAT(@query_add, " JUNLE_CD = '",_junle_cd ,"'");
	END IF;
	
	SET @query_text = CONCAT(@query,@query_add);
	
	-- 実行
	PREPARE main_query FROM @query_text;
	EXECUTE main_query;
	DEALLOCATE PREPARE main_query;

	SET exit_cd = 0;

END
//
DELIMITER ;
