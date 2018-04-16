DROP PROCEDURE IF EXISTS index_002;
DELIMITER //
-- ********************************************************************************************
-- index_002 タイトル数取得処理
--
-- 【処理概要】
--   ユーザに紐づくタイトル一覧を呼び出す
--
--
-- 【呼び出し元画面】
--   インデックス
--
-- 【引数】
--   _trk_num			：ユーザCD(登録番号)
--   _shbt_cd			：種別CD
--   _junle_cd			：ジャンルCD
--   _limit				：表示数
--   _offset			：ページ番号
--   _sort				：ソート条件
--
--
-- 【戻り値】
--		exit_cd			: exit_cd
--		正常：0
--		異常：99
-- --------------------------------------------------------------------------------------------
-- 【更新履歴】

-- ********************************************************************************************
CREATE PROCEDURE `index_002`(
	IN `_trk_num` CHAR(4)
	, IN `_shbt_cd` CHAR(2)
	, IN `_junle_cd` CHAR(2)
	, IN `_limit` VARCHAR(3)
	, IN `_offset` VARCHAR(2)
	, IN `_sort` VARCHAR(40)
	, OUT `exit_cd` INTEGER
	, OUT `test` INTEGER
)
COMMENT 'タイトル数取得処理'

BEGIN

	-- 異常終了ハンドラ
	DECLARE EXIT HANDLER FOR SQLEXCEPTION SET exit_cd = 99;

		SET @query = CONCAT("
			SELECT
				*
			FROM
				T_TITLE_MSTR
			WHERE
				TRK_NUM = '",_trk_num ,"'
		")
		;
SET @test = 1;
		# 絞る条件
		SET @query_add = "";

		-- 種別コード
		IF IFNULL(_shbt_cd, '') != '' THEN
			SET @query_add = CONCAT(@query_add, ' AND');
			SET @query_add = CONCAT(@query_add, " SHBT_CD = '",_shbt_cd ,"'");
		END IF;

SET @test = 2;
		-- ジャンルコード
		IF IFNULL(_junle_cd, '') != '' THEN
			SET @query_add = CONCAT(@query_add, ' AND');
			SET @query_add = CONCAT(@query_add, " JUNLE_CD = '",_junle_cd ,"'");
		END IF;

		-- ソート
		SET @query_order = " ";

		IF IFNULL(_sort, '') != '' THEN
			SET @query_order = CONCAT(@query_order,_sort);
		ELSE
			SET @query_order = CONCAT(@query_order,"ORDER BY KUSN_NTJ ASC");
		END IF;

		-- 表示数
		IF IFNULL(_limit, '') != '' THEN
			SET @query_limit = CONCAT(" LIMIT ",_limit);
		ELSE
			SET @query_limit = " LIMIT 20";
		END IF;

		-- ページ番号
		SET @query_offset = CONCAT(" OFFSET ",_offset);

		SET @query_text = CONCAT(@query,@query_add,@query_order,@query_limit,@query_offset);

	-- 実行
	PREPARE main_query FROM @query_text;
	EXECUTE main_query;
	DEALLOCATE PREPARE main_query;

	SET exit_cd = 0;

END
//
DELIMITER ;
