DROP DATABASE IF EXISTS `db_control_fe`;

CREATE DATABASE IF NOT EXISTS `db_control_fe` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

CREATE TABLE `db_control_fe`.`invoice` (
  `id` varchar(36) NOT NULL COMMENT 'LLAVE PRINCIPAL',
  `ruc` varchar(100) DEFAULT NULL COMMENT 'RUC',
  `branchOffice` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'SUCURSAL',
  `pointSales` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'PUNTO DE VENTA',
  `xml` text COMMENT 'XML',
  `invoiceNumber` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'NUMERO DE LA FACTURA',
  `invoiceAmount` double DEFAULT NULL COMMENT 'MONTO DE LA FACTURA',
  `taxes` double DEFAULT NULL COMMENT 'IMPUESTO',
  `total` double DEFAULT NULL COMMENT 'TOTAL',
  `cufe` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'CUFE',
  `customer` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'CLIENTE',
  `customerNumber` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'NUMERO DE CLIENTE',
  `qrCode` text COMMENT 'CODIGO QR',
  `statusPAC` varchar(4) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'ESTADO DEL PAC',
  `authorizationNumber` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'NUMERO DE AUTORIZACION',
  `creationDate` datetime DEFAULT NULL COMMENT 'FECHA DE CREACION',
  `modificationDate` datetime DEFAULT NULL COMMENT 'FECHA DE MODIFICACION DEL REGISTRO',
  `receptionDate` datetime DEFAULT NULL COMMENT 'FECHA DE RECEPCION',
  `reason` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'RAZON',
  `statusId` int DEFAULT NULL COMMENT 'CONTROL INTERNO DE ERRORES Y PERSISTENCIA',
  `receiverCode` varchar(100) DEFAULT NULL COMMENT 'CODIGO DE RECEPTOR ENVIADO POR MDL16 ALUDRA',
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  KEY `idx_cufe` (`cufe`),
  KEY `idx_status` (`statusId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='tabla de factura';

CREATE TABLE `db_control_fe`.`status` (
  `statusId` int NOT NULL,
  `description` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`statusId`),
  KEY `status` (`statusId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `db_control_fe`.`SP_ADD_INVOICE`(
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
pstatusId INT
)
BEGIN
	DECLARE uuid_aut NVARCHAR(36);
	DECLARE created_on DATETIME;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SELECT 'Error occured';
	
    SET	uuid_aut = UUID();
    SET created_on = DATE(NOW());
	INSERT INTO db_control_fe.invoice 
    (id, ruc, branchOffice, pointSales, xml, invoiceNumber, invoiceAmount, taxes, total, cufe, customer, customerNumber, qrCode, statusPAC,
    authorizationNumber, creationDate, receptionDate, reason, statusId)
	VALUES 
    (uuid_aut, pruc, pbranchOffice, ppointSales, pxml, pinvoiceNumber, pinvoiceAmount, ptaxes, ptotal, pcufe, pcustomer, pcustomerNumber, 
	pqrCode, pstatusPAC, pauthorizationNumber, created_on, preceptionDate, preason, pstatusId);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `db_control_fe`.`SP_DELETE_INVOICE`(IN pid NVARCHAR(36))
BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT 'Error occured';    
    
	DELETE FROM db_control_fe.invoice 
	WHERE id = pid;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `db_control_fe`.`SP_DELETE_INVOICE_BY_CUFE`(IN pcufe nvarchar(75))
BEGIN
	DELETE FROM db_control_fe.invoice 
    WHERE cufe = pcufe;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `db_control_fe`.`SP_GET_INVOICES`(IN pid NVARCHAR(36))
BEGIN 
	DECLARE EXIT HANDLER FOR SQLEXCEPTION SELECT 'Error occured' Message;    
	IF pid IS NULL THEN
		SELECT * FROM db_control_fe.invoice;
	ELSE
		SELECT * FROM db_control_fe.invoice 
		WHERE id = pid;
	END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `db_control_fe`.`SP_GET_INVOICES_BY_STATUS`(IN pstatusId INT)
BEGIN
	SELECT * FROM db_control_fe.invoice WHERE statusId = pstatusId;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `db_control_fe`.`SP_UPDATE_INVOICE`(
IN pid NVARCHAR(36),
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
IN pstatusId INT
)
BEGIN
	UPDATE db_control_fe.invoice
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
		statusId = pstatusId
	WHERE id = pid;
END$$
DELIMITER ;


DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `db_control_fe`.`SP_UPDATE_INVOICE_BY_CUFE`(
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
IN pstatusId INT
)
BEGIN

UPDATE db_control_fe.invoice
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
	statusId = pstatusId
WHERE cufe = pcufe;

END$$
DELIMITER ;



INSERT INTO db_control_fe.status VALUES (0, 'Completado');
INSERT INTO db_control_fe.status VALUES (1, 'Error');
INSERT INTO db_control_fe.status VALUES (2, 'En Cola');
INSERT INTO db_control_fe.status VALUES (3, 'Procesando');
INSERT INTO db_control_fe.status VALUES (4, 'Pendiente');




CALL `db_control_fe`.`SP_ADD_INVOICE`
('155646463-2-2017',
'7005',
'C:\FILE\10393',
'<env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope" xmlns:dgi="http://dgi-fep.mef.gob.pa/wsdl/FeRecepFE">
    <env:Header>
        <dgi:feHeaderMsg>
            <dgi:dVerForm>1.00</dgi:dVerForm>
        </dgi:feHeaderMsg>
    </env:Header>
    <env:Body>
        <dgi:feDatosMsg>
            <rEnviFeDGI xmlns="http://dgi-fep.mef.gob.pa">
                <dVerForm>1.00</dVerForm>
                <iAmb>2</iAmb>
                <gRucPAC>
                    <dTipContPAC>2</dTipContPAC>
                    <dRucPAC>155646463-2-2017</dRucPAC>
                    <dDvPAC>86</dDvPAC>
                </gRucPAC>
                <dFecProc>2022-05-14T01:22:26-05:00</dFecProc>
             <rFE xmlns="http://dgi-fep.mef.gob.pa"><dVerForm>1.00</dVerForm><dId>FE012000000521-136-113133-0270062022051590000008910080125781091727</dId><gDGen><iAmb>2</iAmb><iTpEmis>01</iTpEmis><iDoc>01</iDoc><dNroDF>9000000891</dNroDF><dPtoFacDF>008</dPtoFacDF><dSeg>578109172</dSeg><dFechaEm>2022-05-15T01:00:00-05:00</dFechaEm><dFechaSalida>2021-05-15T01:00:00-05:00</dFechaSalida><iNatOp>01</iNatOp><iTipoOp>1</iTipoOp><iDest>1</iDest><iFormCAFE>1</iFormCAFE><iEntCAFE>1</iEntCAFE><dEnvFE>2</dEnvFE><iProGen>2</iProGen><iTipoTranVenta>1</iTipoTranVenta><gEmis><gRucEmi><dTipoRuc>2</dTipoRuc><dRuc>521-136-113133</dRuc><dDV>02</dDV></gRucEmi><dNombEm>FE generada en ambiente de pruebas - sin valor comercial ni fiscal</dNombEm><dSucEm>7006</dSucEm><dCoordEm>+8.410497,-82.456178</dCoordEm><dDirecEm>Panama, Ciudad de Panama</dDirecEm><gUbiEm><dCodUbi>8-8-7</dCodUbi><dCorreg>BELLA VISTA</dCorreg><dDistr>PANAMA</dDistr><dProv>PANAMA</dProv></gUbiEm><dTfnEm>300-9200</dTfnEm></gEmis><gDatRec><iTipoRec>02</iTipoRec><gRucRec><dTipoRuc>1</dTipoRuc><dRuc>6-67-5306</dRuc></gRucRec><dNombRec>PRUEBA Operación Interna</dNombRec><dDirecRec>Costa del Este</dDirecRec><dTfnRec>6657-8711</dTfnRec><dCorElectRec>equiroz@hypernovalabs.com</dCorElectRec><cPaisRec>PA</cPaisRec></gDatRec><gAutXML><gRucAutXML><dTipoRuc>2</dTipoRuc><dRuc>521-136-113133</dRuc><dDV>02</dDV></gRucAutXML></gAutXML></gDGen><gItem><dSecItem>001</dSecItem><dDescProd>Agua embotellada individual 300ml</dDescProd><dCodProd>P0000001</dCodProd><dCantCodInt>35.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>0.350000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>12.25</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>13.11</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>0.86</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>002</dSecItem><dDescProd>PASTILLAS MULTIVITAMINAS 30 SERVIDAS</dDescProd><dCodProd>P000054645</dCodProd><dCantCodInt>35.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>0.350000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>12.25</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>13.11</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>0.86</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>003</dSecItem><dDescProd>DESINFECTANTE LIQUIDO 1GAL</dDescProd><dCodProd>P000029732</dCodProd><dCantCodInt>35.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>0.350000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>12.25</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>13.11</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>0.86</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>004</dSecItem><dDescProd>MANTEQUILLA DE ALMENDRAS ORGÁNICA</dDescProd><dCodProd>P000029728</dCodProd><dCantCodInt>35.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>0.330000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>11.55</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>12.36</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>0.81</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>005</dSecItem><dDescProd>JABÓN EN POLVO 1kg</dDescProd><dCodProd>P000029646</dCodProd><dCantCodInt>4.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>1.030000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>4.12</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>4.41</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>0.29</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>006</dSecItem><dDescProd>Agua con gas caja 24 unidades</dDescProd><dCodProd>P000009592</dCodProd><dCantCodInt>1.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>6.000000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>6.00</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>6.42</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>0.42</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>007</dSecItem><dDescProd>SERVILLETAS DE PAPEL 100 UNIDADES</dDescProd><dCodProd>P000024262</dCodProd><dCantCodInt>1.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>3.530000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>3.53</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>3.78</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>0.25</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>008</dSecItem><dDescProd>Sandwich Bags Extra Large 200unidades</dDescProd><dCodProd>P000039814</dCodProd><dCantCodInt>1.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>4.080000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>4.08</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>4.37</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>0.29</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>009</dSecItem><dDescProd>Bolsas de Jardinería 9 Litros 20 unidades</dDescProd><dCodProd>P000043680</dCodProd><dCantCodInt>1.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>13.000000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>13.00</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>13.91</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>0.91</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>010</dSecItem><dDescProd>LICUADORA PORTATIL RECARGABLE 200ML</dDescProd><dCodProd>P000039357</dCodProd><dCantCodInt>1.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>1.750000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>1.75</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>1.75</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>00</dTasaITBMS><dValITBMS>0.00</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>011</dSecItem><dDescProd>Tostadora negra</dDescProd><dCodProd>P000066290</dCodProd><dCantCodInt>1.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>7.490000</dPrUnit><dPrUnitDesc>0.700000</dPrUnitDesc><dPrItem>6.79</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>7.27</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>0.48</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>012</dSecItem><dDescProd>Fertilizante para plantas florares 100g</dDescProd><dCodProd>1234567896</dCodProd><cUnidad>dm</cUnidad><dCantCodInt>6.00</dCantCodInt><dFechaFab>2016-10-06</dFechaFab><dFechaCad>2016-10-06</dFechaCad><dCodCPBSabr>13</dCodCPBSabr><cUnidadCPBS>cm</cUnidadCPBS><dInfEmFE>FACTURA DE PRUEBA PRODUCT X CON ESPECIFICACIONS X</dInfEmFE><gPrecios><dPrUnit>93.000000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>558.00</dPrItem><dPrAcarItem>5.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>602.06</dValTotItem></gPrecios><gCodItem><dGTINCom>0</dGTINCom><dCantGTINCom>0</dCantGTINCom><dGTINInv>0</dGTINInv><dCantComInvent>0.00</dCantComInvent></gCodItem><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>39.06</dValITBMS></gITBMSItem></gItem><gTot><dTotNeto>645.57</dTotNeto><dTotITBMS>45.09</dTotITBMS><dTotGravado>45.09</dTotGravado><dTotDesc>10.00</dTotDesc><dVTot>685.66</dVTot><dTotRec>685.66</dTotRec><iPzPag>1</iPzPag><dNroItems>12</dNroItems><dVTotItems>695.66</dVTotItems><gDescBonif><dDetalDesc>Descuento de compra</dDetalDesc><dValDesc>10.00</dValDesc></gDescBonif><gFormaPago><iFormaPago>04</iFormaPago><dVlrCuota>685.66</dVlrCuota></gFormaPago></gTot><Signature xmlns="http://www.w3.org/2000/09/xmldsig#"><SignedInfo><CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256" /><Reference URI=""><Transforms><Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#" /><Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" /></Transforms><DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" /><DigestValue>6DAmQE2MHCLS5sCNiivAVTFcSVz4VcVcWkrEFIpT8RY=</DigestValue></Reference></SignedInfo><SignatureValue>Z56LGyMwjdw6w0cZTCpOn06Y7mCIQEYbtGpeAdYkFB/qfUfBguc4tUHyu31ed/vahk4Xwhj2WOlU0/iCiWV8wHNX9EZFMmmgnGwn1UfWig7I91S9hjnS9DjAaCsHOy37p4hN4XGZinU2JCvB9HHKigEoheAX4p0UnXoPTZHou6nloNeCRhKQZT4Zo/sAoKWs6XRaBUhqFos1MTAuViuOg09PpPkrNhttmJB1GmvF5V3UslIUy3YQOU2/sLYlw0+Z63LIfmifFtD9ezYWVfy/3Hk+aoynzVRQ/i5fmOO4XlL04jRWifkirz9kxhPs4AKSN3vnh8Kf4yv5AF+eGHD1tw==</SignatureValue><KeyInfo><X509Data><X509SubjectName>CN=[F] HYPERNOVA LABS S A - 155646463-2-2017 - 86 - DE LEON FLORES AXEL YOEL, OU=FACTURA ELECTRONICA, O=FIRMA ELECTRONICA, C=PA</X509SubjectName><X509Certificate>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</X509Certificate></X509Data></KeyInfo></Signature><gNoFirm><dQRCode><![CDATA[https://dgi-fep-test.mef.gob.pa:40001/Consultas/FacturasPorQR?chFE=FE012000000521-136-113133-0270062022051590000008910080125781091727&iAmb=2&digestValue=6DAmQE2MHCLS5sCNiivAVTFcSVz4VcVcWkrEFIpT8RY=&jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjaEZFIjoiRkUwMTIwMDAwMDA1MjEtMTM2LTExMzEzMy0wMjcwMDYyMDIyMDUxNTkwMDAwMDA4OTEwMDgwMTI1NzgxMDkxNzI3IiwiaUFtYiI6IjIiLCJkaWdlc3RWYWx1ZSI6IjZEQW1RRTJNSENMUzVzQ05paXZBVlRGY1NWejRWY1ZjV2tyRUZJcFQ4Ulk9In0.rVj0kUmtSvyAypUuJkjU0oM3JpsfizEuXpGsIQp9R0M]]></dQRCode></gNoFirm></rFE>
            </rEnviFeDGI>
        </dgi:feDatosMsg>
    </env:Body>
</env:Envelope>', 
'9000000890', 
55.00, 
7.00, 
57.00, 
'FE012000000521-136-113133-0270062022051590000008910080125781091727',
'SMREY',
'300-9200',
'<![CDATA[https://dgi-fep-test.mef.gob.pa:40001/Consultas/FacturasPorQR?chFE=FE012000000521-136-113133-0270062022051590000008910080125781091727&iAmb=2&digestValue=6DAmQE2MHCLS5sCNiivAVTFcSVz4VcVcWkrEFIpT8RY=&jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjaEZFIjoiRkUwMTIwMDAwMDA1MjEtMTM2LTExMzEzMy0wMjcwMDYyMDIyMDUxNTkwMDAwMDA4OTEwMDgwMTI1NzgxMDkxNzI3IiwiaUFtYiI6IjIiLCJkaWdlc3RWYWx1ZSI6IjZEQW1RRTJNSENMUzVzQ05paXZBVlRGY1NWejRWY1ZjV2tyRUZJcFQ4Ulk9In0.rVj0kUmtSvyAypUuJkjU0oM3JpsfizEuXpGsIQp9R0M]]>', 
'86', 
'578109172',
DATE(NOW()), 
NULL, 
4);



CALL `db_control_fe`.`SP_ADD_INVOICE`
('155646463-2-2022',
'7005',
'C:\FILE\10393',
'<env:Envelope xmlns:env="http://www.w3.org/2003/05/soap-envelope" xmlns:dgi="http://dgi-fep.mef.gob.pa/wsdl/FeRecepFE">
    <env:Header>
        <dgi:feHeaderMsg>
            <dgi:dVerForm>1.00</dgi:dVerForm>
        </dgi:feHeaderMsg>
    </env:Header>
    <env:Body>
        <dgi:feDatosMsg>
            <rEnviFeDGI xmlns="http://dgi-fep.mef.gob.pa">
                <dVerForm>1.00</dVerForm>
                <iAmb>2</iAmb>
                <gRucPAC>
                    <dTipContPAC>2</dTipContPAC>
                    <dRucPAC>155646463-2-2017</dRucPAC>
                    <dDvPAC>86</dDvPAC>
                </gRucPAC>
                <dFecProc>2022-05-14T01:22:26-05:00</dFecProc>
             <rFE xmlns="http://dgi-fep.mef.gob.pa"><dVerForm>1.00</dVerForm><dId>FE012000000521-136-113133-0270062022051590000008910080125781091727</dId><gDGen><iAmb>2</iAmb><iTpEmis>01</iTpEmis><iDoc>01</iDoc><dNroDF>9000000891</dNroDF><dPtoFacDF>008</dPtoFacDF><dSeg>578109172</dSeg><dFechaEm>2022-05-15T01:00:00-05:00</dFechaEm><dFechaSalida>2021-05-15T01:00:00-05:00</dFechaSalida><iNatOp>01</iNatOp><iTipoOp>1</iTipoOp><iDest>1</iDest><iFormCAFE>1</iFormCAFE><iEntCAFE>1</iEntCAFE><dEnvFE>2</dEnvFE><iProGen>2</iProGen><iTipoTranVenta>1</iTipoTranVenta><gEmis><gRucEmi><dTipoRuc>2</dTipoRuc><dRuc>521-136-113133</dRuc><dDV>02</dDV></gRucEmi><dNombEm>FE generada en ambiente de pruebas - sin valor comercial ni fiscal</dNombEm><dSucEm>7006</dSucEm><dCoordEm>+8.410497,-82.456178</dCoordEm><dDirecEm>Panama, Ciudad de Panama</dDirecEm><gUbiEm><dCodUbi>8-8-7</dCodUbi><dCorreg>BELLA VISTA</dCorreg><dDistr>PANAMA</dDistr><dProv>PANAMA</dProv></gUbiEm><dTfnEm>300-9200</dTfnEm></gEmis><gDatRec><iTipoRec>02</iTipoRec><gRucRec><dTipoRuc>1</dTipoRuc><dRuc>6-67-5306</dRuc></gRucRec><dNombRec>PRUEBA Operación Interna</dNombRec><dDirecRec>Costa del Este</dDirecRec><dTfnRec>6657-8711</dTfnRec><dCorElectRec>equiroz@hypernovalabs.com</dCorElectRec><cPaisRec>PA</cPaisRec></gDatRec><gAutXML><gRucAutXML><dTipoRuc>2</dTipoRuc><dRuc>521-136-113133</dRuc><dDV>02</dDV></gRucAutXML></gAutXML></gDGen><gItem><dSecItem>001</dSecItem><dDescProd>Agua embotellada individual 300ml</dDescProd><dCodProd>P0000001</dCodProd><dCantCodInt>35.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>0.350000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>12.25</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>13.11</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>0.86</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>002</dSecItem><dDescProd>PASTILLAS MULTIVITAMINAS 30 SERVIDAS</dDescProd><dCodProd>P000054645</dCodProd><dCantCodInt>35.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>0.350000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>12.25</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>13.11</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>0.86</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>003</dSecItem><dDescProd>DESINFECTANTE LIQUIDO 1GAL</dDescProd><dCodProd>P000029732</dCodProd><dCantCodInt>35.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>0.350000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>12.25</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>13.11</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>0.86</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>004</dSecItem><dDescProd>MANTEQUILLA DE ALMENDRAS ORGÁNICA</dDescProd><dCodProd>P000029728</dCodProd><dCantCodInt>35.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>0.330000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>11.55</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>12.36</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>0.81</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>005</dSecItem><dDescProd>JABÓN EN POLVO 1kg</dDescProd><dCodProd>P000029646</dCodProd><dCantCodInt>4.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>1.030000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>4.12</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>4.41</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>0.29</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>006</dSecItem><dDescProd>Agua con gas caja 24 unidades</dDescProd><dCodProd>P000009592</dCodProd><dCantCodInt>1.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>6.000000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>6.00</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>6.42</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>0.42</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>007</dSecItem><dDescProd>SERVILLETAS DE PAPEL 100 UNIDADES</dDescProd><dCodProd>P000024262</dCodProd><dCantCodInt>1.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>3.530000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>3.53</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>3.78</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>0.25</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>008</dSecItem><dDescProd>Sandwich Bags Extra Large 200unidades</dDescProd><dCodProd>P000039814</dCodProd><dCantCodInt>1.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>4.080000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>4.08</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>4.37</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>0.29</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>009</dSecItem><dDescProd>Bolsas de Jardinería 9 Litros 20 unidades</dDescProd><dCodProd>P000043680</dCodProd><dCantCodInt>1.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>13.000000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>13.00</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>13.91</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>0.91</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>010</dSecItem><dDescProd>LICUADORA PORTATIL RECARGABLE 200ML</dDescProd><dCodProd>P000039357</dCodProd><dCantCodInt>1.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>1.750000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>1.75</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>1.75</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>00</dTasaITBMS><dValITBMS>0.00</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>011</dSecItem><dDescProd>Tostadora negra</dDescProd><dCodProd>P000066290</dCodProd><dCantCodInt>1.000000</dCantCodInt><dCodCPBSabr>85</dCodCPBSabr><gPrecios><dPrUnit>7.490000</dPrUnit><dPrUnitDesc>0.700000</dPrUnitDesc><dPrItem>6.79</dPrItem><dPrAcarItem>0.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>7.27</dValTotItem></gPrecios><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>0.48</dValITBMS></gITBMSItem></gItem><gItem><dSecItem>012</dSecItem><dDescProd>Fertilizante para plantas florares 100g</dDescProd><dCodProd>1234567896</dCodProd><cUnidad>dm</cUnidad><dCantCodInt>6.00</dCantCodInt><dFechaFab>2016-10-06</dFechaFab><dFechaCad>2016-10-06</dFechaCad><dCodCPBSabr>13</dCodCPBSabr><cUnidadCPBS>cm</cUnidadCPBS><dInfEmFE>FACTURA DE PRUEBA PRODUCT X CON ESPECIFICACIONS X</dInfEmFE><gPrecios><dPrUnit>93.000000</dPrUnit><dPrUnitDesc>0.00</dPrUnitDesc><dPrItem>558.00</dPrItem><dPrAcarItem>5.00</dPrAcarItem><dPrSegItem>0.00</dPrSegItem><dValTotItem>602.06</dValTotItem></gPrecios><gCodItem><dGTINCom>0</dGTINCom><dCantGTINCom>0</dCantGTINCom><dGTINInv>0</dGTINInv><dCantComInvent>0.00</dCantComInvent></gCodItem><gITBMSItem><dTasaITBMS>01</dTasaITBMS><dValITBMS>39.06</dValITBMS></gITBMSItem></gItem><gTot><dTotNeto>645.57</dTotNeto><dTotITBMS>45.09</dTotITBMS><dTotGravado>45.09</dTotGravado><dTotDesc>10.00</dTotDesc><dVTot>685.66</dVTot><dTotRec>685.66</dTotRec><iPzPag>1</iPzPag><dNroItems>12</dNroItems><dVTotItems>695.66</dVTotItems><gDescBonif><dDetalDesc>Descuento de compra</dDetalDesc><dValDesc>10.00</dValDesc></gDescBonif><gFormaPago><iFormaPago>04</iFormaPago><dVlrCuota>685.66</dVlrCuota></gFormaPago></gTot><Signature xmlns="http://www.w3.org/2000/09/xmldsig#"><SignedInfo><CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" /><SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256" /><Reference URI=""><Transforms><Transform Algorithm="http://www.w3.org/2001/10/xml-exc-c14n#" /><Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" /></Transforms><DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" /><DigestValue>6DAmQE2MHCLS5sCNiivAVTFcSVz4VcVcWkrEFIpT8RY=</DigestValue></Reference></SignedInfo><SignatureValue>Z56LGyMwjdw6w0cZTCpOn06Y7mCIQEYbtGpeAdYkFB/qfUfBguc4tUHyu31ed/vahk4Xwhj2WOlU0/iCiWV8wHNX9EZFMmmgnGwn1UfWig7I91S9hjnS9DjAaCsHOy37p4hN4XGZinU2JCvB9HHKigEoheAX4p0UnXoPTZHou6nloNeCRhKQZT4Zo/sAoKWs6XRaBUhqFos1MTAuViuOg09PpPkrNhttmJB1GmvF5V3UslIUy3YQOU2/sLYlw0+Z63LIfmifFtD9ezYWVfy/3Hk+aoynzVRQ/i5fmOO4XlL04jRWifkirz9kxhPs4AKSN3vnh8Kf4yv5AF+eGHD1tw==</SignatureValue><KeyInfo><X509Data><X509SubjectName>CN=[F] HYPERNOVA LABS S A - 155646463-2-2017 - 86 - DE LEON FLORES AXEL YOEL, OU=FACTURA ELECTRONICA, O=FIRMA ELECTRONICA, C=PA</X509SubjectName><X509Certificate>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</X509Certificate></X509Data></KeyInfo></Signature><gNoFirm><dQRCode><![CDATA[https://dgi-fep-test.mef.gob.pa:40001/Consultas/FacturasPorQR?chFE=FE012000000521-136-113133-0270062022051590000008910080125781091727&iAmb=2&digestValue=6DAmQE2MHCLS5sCNiivAVTFcSVz4VcVcWkrEFIpT8RY=&jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjaEZFIjoiRkUwMTIwMDAwMDA1MjEtMTM2LTExMzEzMy0wMjcwMDYyMDIyMDUxNTkwMDAwMDA4OTEwMDgwMTI1NzgxMDkxNzI3IiwiaUFtYiI6IjIiLCJkaWdlc3RWYWx1ZSI6IjZEQW1RRTJNSENMUzVzQ05paXZBVlRGY1NWejRWY1ZjV2tyRUZJcFQ4Ulk9In0.rVj0kUmtSvyAypUuJkjU0oM3JpsfizEuXpGsIQp9R0M]]></dQRCode></gNoFirm></rFE>
            </rEnviFeDGI>
        </dgi:feDatosMsg>
    </env:Body>
</env:Envelope>', 
'9000000890', 
154.10, 
2.00, 
156.10, 
'FE012000000521-136-113133-0270062022051590000008910080125781091727',
'SMREY',
'300-9200',
'<![CDATA[https://dgi-fep-test.mef.gob.pa:40001/Consultas/FacturasPorQR?chFE=FE012000000521-136-113133-0270062022051590000008910080125781091727&iAmb=2&digestValue=6DAmQE2MHCLS5sCNiivAVTFcSVz4VcVcWkrEFIpT8RY=&jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjaEZFIjoiRkUwMTIwMDAwMDA1MjEtMTM2LTExMzEzMy0wMjcwMDYyMDIyMDUxNTkwMDAwMDA4OTEwMDgwMTI1NzgxMDkxNzI3IiwiaUFtYiI6IjIiLCJkaWdlc3RWYWx1ZSI6IjZEQW1RRTJNSENMUzVzQ05paXZBVlRGY1NWejRWY1ZjV2tyRUZJcFQ4Ulk9In0.rVj0kUmtSvyAypUuJkjU0oM3JpsfizEuXpGsIQp9R0M]]>', 
'86', 
'578109172',
DATE(NOW()), 
NULL, 
4);



CALL `db_control_fe`.`SP_GET_INVOICES`(NULL);


