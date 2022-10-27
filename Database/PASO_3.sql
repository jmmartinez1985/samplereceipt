DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_DELETE_INVOICE_BY_CUFE`(IN pcufe nvarchar(75))
BEGIN
	DELETE FROM my_database.hnl_invoice 
    WHERE cufe = pcufe;
END$$
DELIMITER ;




DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GET_INVOICES`(IN pid INT)
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT 'Error occured' Message;    
	IF pid IS NULL THEN
		SELECT * FROM my_database.hnl_invoice;
	ELSE
		SELECT * FROM my_database.hnl_invoice 
		WHERE idAuto = pid;
	END IF;
END$$
DELIMITER ;
