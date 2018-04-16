DROP PROCEDURE IF EXISTS index_001;
DELIMITER //
-- ********************************************************************************************
-- index_001 �^�C�g�����擾����
--
-- �y�����T�v�z
--   �^�C�g�������J�E���g����
--   
--
-- �y�Ăяo������ʁz
--   �C���f�b�N�X
--
-- �y�����z
--   _trk_num			�F���[�UCD(�o�^�ԍ�)
--   _shbt_cd			�F���CD
--   _junle_cd			�F�W������CD
--   
--
-- �y�߂�l�z
--   exit_cd			: exit_cd
--		����F0
--		�ُ�F99
-- --------------------------------------------------------------------------------------------
-- �y�X�V�����z

-- ********************************************************************************************
CREATE PROCEDURE `index_001`(
	IN `_trk_num` CHAR(4)
	, IN `_shbt_cd` CHAR(2)
	, IN `_junle_cd` CHAR(2)
	, OUT `exit_cd` INTEGER
)
COMMENT '�^�C�g�����擾����'

BEGIN
	-- �ُ�I���n���h��
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
	
	# �i�����
	SET @query_add = "";
	
	-- ��ʃR�[�h
	IF IFNULL(_shbt_cd, '') != '' THEN
		SET @query_add = CONCAT(@query_add, ' AND');
		SET @query_add = CONCAT(@query_add, " SHBT_CD = '",_shbt_cd ,"'");
	END IF;
	
	-- �W�������R�[�h
	IF IFNULL(_junle_cd, '') != '' THEN
		SET @query_add = CONCAT(@query_add, ' AND');
		SET @query_add = CONCAT(@query_add, " JUNLE_CD = '",_junle_cd ,"'");
	END IF;
	
	SET @query_text = CONCAT(@query,@query_add);
	
	-- ���s
	PREPARE main_query FROM @query_text;
	EXECUTE main_query;
	DEALLOCATE PREPARE main_query;

	SET exit_cd = 0;

END
//
DELIMITER ;
