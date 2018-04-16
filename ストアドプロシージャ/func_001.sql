DROP PROCEDURE IF EXISTS func_001;
DELIMITER //
-- ********************************************************************************************
-- func_001 �^�C�g�����擾����
--
-- �y�����T�v�z
--   ���[�U�ɕR�Â��^�C�g���ꗗ���Ăяo��
--   
--
-- �y�Ăяo������ʁz
--   �C���f�b�N�X
--
-- �y�����z
--   _case				�F��������
--   
--
-- �y�߂�l�z
--		exit_cd			: exit_cd
--		����F0
--		�ُ�F99
-- --------------------------------------------------------------------------------------------
-- �y�X�V�����z

-- ********************************************************************************************
CREATE PROCEDURE `func_001`(
	IN `_case` VARCHAR(50)
	, OUT `exit_cd` INTEGER
)
COMMENT '�^�C�g�����擾����'

BEGIN
	
	-- �ُ�I���n���h��
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

	-- ���s
	PREPARE main_query FROM @query;
	EXECUTE main_query;
	DEALLOCATE PREPARE main_query;
	
	SET exit_cd = 0;

END
//
DELIMITER ;
