CREATE TABLE `hnl_invoice` (
  `idAuto` int NOT NULL AUTO_INCREMENT COMMENT 'LLAVE PRINCIPAL',
  `ruc` varchar(20) DEFAULT NULL COMMENT 'RUC',
  `branchOffice` varchar(8) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'SUCURSAL',
  `pointSales` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'PUNTO DE VENTA',
  `xml` text COMMENT 'XML',
  `invoiceNumber` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'NUMERO DE LA FACTURA',
  `invoiceAmount` double DEFAULT NULL COMMENT 'MONTO DE LA FACTURA',
  `taxes` double DEFAULT NULL COMMENT 'IMPUESTO',
  `total` double DEFAULT NULL COMMENT 'TOTAL',
  `cufe` varchar(75) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'CUFE',
  `customer` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'CLIENTE',
  `customerNumber` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'NUMERO DE CLIENTE',
  `qrCode` text COMMENT 'CODIGO QR',
  `statusPAC` varchar(4) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'ESTADO DEL PAC',
  `authorizationNumber` varchar(15) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'NUMERO DE AUTORIZACION',
  `creationDate` datetime DEFAULT NULL COMMENT 'FECHA DE CREACION',
  `modificationDate` datetime DEFAULT NULL COMMENT 'FECHA DE MODIFICACION DEL REGISTRO',
  `receptionDate` datetime DEFAULT NULL COMMENT 'FECHA DE RECEPCION',
  `reason` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8_general_ci DEFAULT NULL COMMENT 'RAZON',
  `status` int DEFAULT NULL COMMENT 'CONTROL INTERNO DE ERRORES Y PERSISTENCIA',
  PRIMARY KEY (`idAuto`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='tabla de factura';


CREATE TABLE `hnl_status` (
  `statusId` int NOT NULL,
  `description` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`statusId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

