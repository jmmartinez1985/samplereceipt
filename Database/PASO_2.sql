DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ADD_INVOICE`(
pruc NVARCHAR(20),
pbranchOffice NVARCHAR(8),
ppointSales NVARCHAR(20),
pxml TEXT,
pinvoiceNumber NVARCHAR(10),
pinvoiceAmount DOUBLE,
ptaxes DOUBLE,
ptotal DOUBLE,
pcufe NVARCHAR(75),
pcustomer NVARCHAR(45),
pcustomerNumber NVARCHAR(10),
pqrCode TEXT,
pstatusPAC NVARCHAR(4),
pauthorizationNumber NVARCHAR(15),
preceptionDate DATETIME,
preason NVARCHAR(100),
pstatus INT
)
BEGIN
	DECLARE created_on DATETIME;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SELECT 'Error occured';
    
    SET created_on = DATE(NOW());
	INSERT INTO db_control_fe.hnl_invoice 
    (ruc, branchOffice, pointSales, xml, invoiceNumber, invoiceAmount, taxes, total, cufe, customer, customerNumber, qrCode, statusPAC,
    authorizationNumber, creationDate, receptionDate, reason, status)
	VALUES 
    (pruc, pbranchOffice, ppointSales, pxml, pinvoiceNumber, pinvoiceAmount, ptaxes, ptotal, pcufe, pcustomer, pcustomerNumber, 
	pqrCode, pstatusPAC, pauthorizationNumber, created_on, preceptionDate, preason, pstatus);
END$$
DELIMITER ;




DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_DELETE_INVOICE`(IN pid INT)
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT 'Error occured';    
    
	DELETE FROM db_control_fe.hnl_invoice 
	WHERE idAuto = pid;
END$$
DELIMITER ;

