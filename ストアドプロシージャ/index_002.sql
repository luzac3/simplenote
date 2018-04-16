DROP PROCEDURE IF EXISTS index_002;
DELIMITER //
-- ********************************************************************************************
-- index_002 �^�C�g�����擾����
--
-- �y�����T�v�z
--   ���[�U�ɕR�Â��^�C�g���ꗗ���Ăяo��
--   
--
-- �y�Ăяo������ʁz
--   �C���f�b�N�X
--
-- �y�����z
--   _trk_num			�F���[�UCD(�o�^�ԍ�)
--   _shbt_cd			�F���CD
--   _junle_cd			�F�W������CD
--   _limit				�F�\����
--   _offset			�F�y�[�W�ԍ�
--   _sort				�F�\�[�g����
--   
--
-- �y�߂�l�z
--		exit_cd			: exit_cd
--		����F0
--		�ُ�F99
-- --------------------------------------------------------------------------------------------
-- �y�X�V�����z

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
COMMENT '�^�C�g�����擾����'

BEGIN
	
	-- �ُ�I���n���h��
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
		# �i�����
		SET @query_add = "";
		
		-- ��ʃR�[�h
		IF IFNULL(_shbt_cd, '') != '' THEN
			SET @query_add = CONCAT(@query_add, ' AND');
			SET @query_add = CONCAT(@query_add, " SHBT_CD = '",_shbt_cd ,"'");
		END IF;

SET @test = 2;
		-- �W�������R�[�h
		IF IFNULL(_junle_cd, '') != '' THEN
			SET @query_add = CONCAT(@query_add, ' AND');
			SET @query_add = CONCAT(@query_add, " JUNLE_CD = '",_junle_cd ,"'");
		END IF;

		-- �\�[�g
		SET @query_order = " ";
		
		IF IFNULL(_sort, '') != '' THEN
			SET @query_order = CONCAT(@query_order,_sort);
		ELSE
			SET @query_order = CONCAT(@query_order,"ORDER BY KUSN_NTJ ASC");
		END IF;
		
		-- �\����
		IF IFNULL(_limit, '') != '' THEN
			SET @query_limit = CONCAT(" LIMIT ",_limit);
		ELSE
			SET @query_limit = " LIMIT 20";
		END IF;
		
		-- �y�[�W�ԍ�
		SET @query_offset = CONCAT(" OFFSET ",_offset);
		
		SET @query_text = CONCAT(@query,@query_add,@query_order,@query_limit,@query_offset);
	
	-- ���s
	PREPARE main_query FROM @query_text;
	EXECUTE main_query;
	DEALLOCATE PREPARE main_query;
	
	SET exit_cd = 0;

END
//
DELIMITER ;
