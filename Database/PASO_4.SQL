DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_GET_INVOICES_BY_STATUS`(IN pstatus INT)
BEGIN
	SELECT * FROM db_control_fe.hnl_invoice WHERE status = pstatus;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_UPDATE_INVOICE`(
IN pid INT,
IN pruc NVARCHAR(20),
IN pbranchOffice NVARCHAR(8), 
IN ppointSales NVARCHAR(20),
IN pxml TEXT, 
IN pinvoiceNumber NVARCHAR(10),
IN pinvoiceAmount double, 
IN ptaxes double,
IN ptotal double, 
IN pcufe NVARCHAR(75), 
IN pcustomer NVARCHAR(45),
IN pcustomerNumber NVARCHAR(10), 
IN pqrCode TEXT,
IN pstatusPAC NVARCHAR(4),
IN pauthorizationNumber NVARCHAR(15),
IN preceptionDate DATETIME,
IN preason NVARCHAR(100),
IN pstatus INT
)
BEGIN
	UPDATE db_control_fe.hnl_invoice
	SET 
		ruc = pruc, 
		branchOffice = pbranchOffice,
		pointSales = ppointSales,
		xml = pxml,
		invoiceNumber = pinvoiceNumber,
		invoiceAmount = pinvoiceAmount,
		taxes = ptaxes,
		total = ptotal,
		customer = pcustomer,
		customerNumber = pcustomerNumber,
		qrCode = pqrCode,
		statusPAC = pstatusPAC,
		authorizationNumber = pauthorizationNumber,
        modificationDate = DATE(NOW()),
        receptionDate = preceptionDate,
		reason = preason,
		status = pstatus
	WHERE idAuto = pid;
END$$
DELIMITER ;



DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_UPDATE_INVOICE_BY_CUFE`(
IN pcufe NVARCHAR(75),
IN pruc NVARCHAR(20),
IN pbranchOffice NVARCHAR(8), 
IN ppointSales NVARCHAR(20),
IN pxml TEXT, 
IN pinvoiceNumber NVARCHAR(10),
IN pinvoiceAmount double, 
IN ptaxes double,
IN ptotal double, 
IN pcustomer NVARCHAR(45),
IN pcustomerNumber NVARCHAR(10), 
IN pqrCode TEXT,
IN pstatusPAC NVARCHAR(4),
IN pauthorizationNumber NVARCHAR(15),
IN preceptionDate DATETIME,
IN preason NVARCHAR(100),
IN pstatus INT
)
BEGIN

UPDATE db_control_fe.hnl_invoice
SET 
	ruc = pruc, 
	branchOffice = pbranchOffice,
	pointSales = ppointSales,
	xml = pxml,
	invoiceNumber = pinvoiceNumber,
	invoiceAmount = pinvoiceAmount,
	taxes = ptaxes,
	total = ptotal,
	customer = pcustomer,
	customerNumber = pcustomerNumber,
	qrCode = pqrCode,
	statusPAC = pstatusPAC,
	authorizationNumber = pauthorizationNumber,
	modificationDate = DATE(NOW()),
	receptionDate = preceptionDate,
	reason = preason,
	status = pstatus
WHERE cufe = pcufe;

END$$
DELIMITER ;
