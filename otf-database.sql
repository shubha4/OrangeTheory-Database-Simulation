--Create and Use the Database
CREATE DATABASE OTF_DATABASE
USE OTF_DATABASE
GO

--Create Look-Up Tables
CREATE TABLE tblSTATUS (
   StatusID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   StatusName varchar(255) NOT NULL,
   StatusDesc varchar(255)
)
GO
 
CREATE TABLE tblORDERTYPE (
   OrderTypeID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   OrderTypeName varchar(50) NOT NULL,
   OrderTypeDesc varchar(255)
)
GO
 
CREATE TABLE tblMERCHANDISETYPE (
   MerchTypeID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   MerchTypeName varchar(255) NOT NULL,
   MerchTypeDesc varchar(255)
)
GO
 
 
CREATE TABLE tblCOACHROLE (
  CoachRoleID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  CoachRoleName varchar(50) NOT NULL,
  RoleDesc varchar(500) NULL
)
GO

CREATE TABLE tblCOACH (
   CoachID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   CoachFName varchar(50) NOT NULL,
   CoachLName varchar(50) NOT NULL,
   CoachDOB date NOT NULL,
   CoachEmail varchar(255) NOT NULL,
   CoachPhone char(10) NOT NULL
)
GO

CREATE TABLE tblMEMBERSHIPTYPE (
   MembershipTypeID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   MembershipTypeName varchar(50) NOT NULL,
   MembershipTypePrice numeric(6,2) NOT NULL,
   MembershipTypeDesc varchar(500) NULL
)
GO

CREATE TABLE tblNEIGHBORHOOD (
   NeighborhoodID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   NeighborhoodName varchar(50) NOT NULL,
   NeighborhoodDesc varchar(500) NULL
)
GO

CREATE TABLE tblCLASSTYPE (
   ClassTypeID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   ClassTypeName varchar(50) NOT NULL,
   ClassTypeDesc varchar(255) NULL
)
GO

CREATE TABLE tblCUSTOMER
(CustomerID INT NOT NULL IDENTITY (1,1) PRIMARY KEY,
CustomerFName varchar(50) NOT NULL,
CustomerLName varchar(50) NOT NULL,
CustomerDOB date NOT NULL,
CustomerEmail varchar(255) NOT NULL,
CustomerPhone char(10) NOT NULL,
CustomerStreetAddress varchar(255) NOT NULL,
CustomerState varchar(20) NOT NULL,
CustomerCity varchar(30) NOT NULL,
CustomerZipCode char(5) NOT NULL
)
GO

--Create Transactional Tables
CREATE TABLE tblMERCHANDISE (
   MerchID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   MerchTypeID INT NOT NULL FOREIGN KEY REFERENCES tblMERCHANDISETYPE(MerchTypeID),
   MerchName varchar(255) NOT NULL,
   MerchPrice numeric(6,2) NOT NULL
)
GO
 
CREATE TABLE tblORDER (
   OrderID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   CustomerID INT NOT NULL FOREIGN KEY REFERENCES tblCUSTOMER(CustomerID),
   OrderTypeID INT NOT NULL FOREIGN KEY REFERENCES tblORDERTYPE(OrderTypeID),
   OrderDate date NOT NULL
)
GO
 
CREATE TABLE tblSHIPMENT (
   ShipmentID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   OrderID INT NOT NULL FOREIGN KEY REFERENCES tblORDER(OrderID),
   ShipmentCreatedDate date NOT NULL,
   ShipmentStreetAddress varchar(255) NOT NULL,
   ShipmentState varchar(20) NOT NULL,
   ShipmentCity varchar(30) NOT NULL,
   ShipmentZipCode char(5) NOT NULL
)
GO
 
CREATE TABLE tblORDERMERCHANDISE (
   OrderMerchID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   MerchID INT NOT NULL FOREIGN KEY REFERENCES tblMERCHANDISE(MerchID),
   OrderID INT NOT NULL FOREIGN KEY REFERENCES tblORDER(OrderID),
   Quantity INT NOT NULL
)
GO
 
CREATE TABLE tblORDERSTATUS (
   OrderStatusID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   OrderID INT NOT NULL FOREIGN KEY REFERENCES tblORDER(OrderID),
   StatusID INT NOT NULL FOREIGN KEY REFERENCES tblSTATUS(StatusID))
GO

CREATE TABLE tblMEMBERSHIP (
  MembershipID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  CustomerID INT NOT NULL FOREIGN KEY REFERENCES tblCUSTOMER(CustomerID),
  MembershipTypeID INT NOT NULL FOREIGN KEY REFERENCES tblMEMBERSHIPTYPE(MembershipTypeID),
  CustomerMembershipName VARCHAR(50) NOT NULL,
  BeginDate date NOT NULL,
  EndDate date NULL
)
GO
 
CREATE TABLE tblCLASS (
  ClassID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  ClassTypeID INT NOT NULL FOREIGN KEY REFERENCES tblCLASSTYPE(ClassTypeID),
  ClassTime TIME NOT NULL,
  ClassDate DATE NOT NULL
)
GO
 
CREATE TABLE tblFRANCHISE (
   FranchiseID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   NeighborhoodID INT NOT NULL FOREIGN KEY REFERENCES tblNEIGHBORHOOD(NeighborhoodID),
   NumMemReg INT NOT NULL
)
GO

CREATE TABLE tblFRANCHISECOACH (
   FranchiseCoachID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
   FranchiseID INT NOT NULL FOREIGN KEY REFERENCES tblFRANCHISE(FranchiseID),
   CoachID INT NOT NULL FOREIGN KEY REFERENCES tblCOACH(CoachID),
   CoachRoleID INT NOT NULL FOREIGN KEY REFERENCES tblCOACHROLE(CoachRoleID),
   BeginDate Date NOT NULL,
   EndDate Date NULL
)
GO

CREATE TABLE tblREGISTRATION (
  RegistrationID INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
  CustomerID INT NOT NULL FOREIGN KEY REFERENCES tblCUSTOMER(CustomerID),
  FranchiseCoachID INT NOT NULL FOREIGN KEY REFERENCES tblFRANCHISECOACH(FranchiseCoachID),
  ClassID INT NOT NULL FOREIGN KEY REFERENCES tblCLASS(ClassID),
  NeighborhoodID INT NOT NULL FOREIGN KEY REFERENCES tblNEIGHBORHOOD(NeighborhoodID)
)
GO

--Get ID Stored Procedures
CREATE PROCEDURE GetStatusID
@Stat1_Name varchar(255),
@Stat1_ID INT OUTPUT
AS
 
SET @Stat1_ID = (SELECT StatusID FROM tblSTATUS WHERE StatusName = @Stat1_Name)
GO
 
CREATE PROCEDURE GetOrderTypeID
@OType1_Name varchar(50),
@OType1_ID INT OUTPUT
AS
 
SET @OType1_ID = (SELECT OrderTypeID FROM tblORDERTYPE WHERE OrderTypeName = @OType1_Name)
GO
 
CREATE PROCEDURE GetMerchTypeID
@MType1_Name varchar(255),
@MType1_ID INT OUTPUT
AS
 
SET @MType1_ID = (SELECT MerchTypeID FROM tblMERCHANDISETYPE WHERE MerchTypeName = @MType1_Name)
GO

CREATE PROCEDURE GetMerchID
@M1_Name varchar(255),
@M1_ID INT OUTPUT
AS
 
SET @M1_ID = (SELECT MerchID FROM tblMERCHANDISE WHERE MerchName = @M1_Name)
GO
 
CREATE PROCEDURE GetOrderID
@C1_FName varchar(50),
@C1_LName varchar(50),
@C1_DOB date,
@OType1_Name varchar(50),
@O1_Date date,
@O1_ID INT OUTPUT
AS
 
SET @O1_ID = (SELECT OrderID FROM tblORDER O
               JOIN tblCUSTOMER C ON O.CustomerID = C.CustomerID
               JOIN tblORDERTYPE OT ON O.OrderTypeID = OT.OrderTypeID
               WHERE C.CustomerFName = @C1_FName
               AND C.CustomerLName = @C1_LName
               AND C.CustomerDOB = @C1_DOB
               AND OT.OrderTypeName = @OType1_Name
               AND O.OrderDate = @O1_Date)
GO
 
CREATE PROCEDURE GetMembershipTypeID
@MemType1_Name varchar(50),
@MemType1_ID INT OUTPUT
AS
 
SET @MemType1_ID = (SELECT MembershipTypeID FROM tblMEMBERSHIPTYPE WHERE MembershipTypeName = @MemType1_Name)
GO
 
CREATE PROCEDURE GetClassTypeID
@ClassType1_Name varchar(50),
@ClassType1_ID INT OUTPUT
AS
 
SET @ClassType1_ID = (SELECT ClassTypeID FROM tblCLASSTYPE WHERE ClassTypeName = @ClassType1_Name)
GO
 
CREATE PROCEDURE GetCustomerID
@First1_Name varchar(50),
@Last1_Name varchar(50),
@DOB1 date,
@Customer1_ID INT OUTPUT
AS
 
SET @Customer1_ID = (SELECT CustomerID FROM tblCUSTOMER WHERE CustomerFName = @First1_Name AND CustomerLName = @Last1_Name AND CustomerDOB = @DOB1)
GO
 
CREATE PROCEDURE GetClassID
@CType1_Name varchar(50),
@Class1_Time time,
@Class1_Date date,
@Class1_ID INT OUTPUT
 
AS
 
SET @Class1_ID = (SELECT ClassID FROM tblCLASS WHERE ClassTypeID = (SELECT ClassTypeID FROM tblCLASSTYPE WHERE ClassTypeName = @CType1_Name) AND ClassTime = @Class1_Time AND ClassDate = @Class1_Date)
GO

CREATE PROCEDURE GetNeighborhoodID
@N_Name varchar(255),
@N_ID INT OUTPUT
AS
SET @N_ID = (SELECT NeighborhoodID FROM tblNEIGHBORHOOD WHERE NeighborhoodName = @N_Name)
GO
 
CREATE PROCEDURE GetCoachID
@CF_Name varchar(30),
@CL_Name varchar(30),
@C_DOB Date,
@CO_ID INT OUTPUT
AS
SET @CO_ID = (SELECT CoachID FROM tblCOACH WHERE CoachFName = @CF_Name AND CoachLName = @CL_Name AND CoachDOB = @C_DOB)
GO
 
CREATE PROCEDURE GetCoachRoleID
@CR_Name varchar(100),
@CR_ID INT OUTPUT
AS
SET @CR_ID = (SELECT CoachRoleID FROM tblCOACHROLE WHERE CoachRoleName = @CR_Name)
GO

CREATE PROCEDURE GetFranchiseID
@Neigh_Name varchar(50),
@F_ID INT OUTPUT
AS
SET @F_ID = (SELECT FranchiseID FROM tblFRANCHISE WHERE NeighborhoodID =
               (SELECT NeighborhoodID FROM tblNEIGHBORHOOD WHERE NeighborhoodName = @Neigh_Name))
GO
 
CREATE PROCEDURE GetFranchiseCoachID
@CoachFirst1_Name VARCHAR(30),
@CoachLast1_Name VARCHAR(30),
@CoachDOB Date,
@Neig_Name VARCHAR(225),
@CoachRole1_Name VARCHAR(50),
@Begin1_Date Date,
@FC_ID INT OUTPUT
AS
 
SET @FC_ID = (SELECT FranchiseCoachID FROM tblFRANCHISECOACH WHERE FranchiseID =
(SELECT FranchiseID FROM tblFRANCHISE WHERE NeighborhoodID =
(SELECT NeighborhoodID FROM tblNEIGHBORHOOD WHERE NeighborhoodName = @Neig_Name))
AND CoachID = (SELECT CoachID FROM tblCOACH WHERE CoachFName = @CoachFirst1_Name AND CoachLName = @CoachLast1_Name AND CoachDOB = @CoachDOB)
AND CoachRoleID = (SELECT CoachRoleID FROM tblCOACHROLE WHERE CoachRoleName = @CoachRole1_Name)
AND BeginDate = @Begin1_Date)
GO

--Insertion Stored Procedures
CREATE PROCEDURE InsertMerchandise
@MType_Name varchar(255),
@M_Price numeric(6,2)
AS
 
DECLARE @MType_ID INT
 
EXEC GetMerchTypeID
@MType1_Name = @MType_Name,
@MType1_ID = @MType_ID OUTPUT
 
IF @MType_ID IS NULL
   BEGIN
       PRINT 'Hey...@MType_ID is coming back empty;check spelling'
       RAISERROR ('@MType_ID cannot be null;process is terminating', 11, 1)
       RETURN
   END
 
BEGIN TRANSACTION T1
INSERT INTO tblMERCHANDISE (MerchTypeID, MerchPrice)
VALUES (@MType_ID, @M_Price)
IF @@ERROR <> 0
   BEGIN
       ROLLBACK TRANSACTION T1
   END
ELSE
COMMIT TRANSACTION T1
GO

EXEC InsertMerchandise
@MType_Name = '',
@M_Price = 
GO
 
ALTER PROCEDURE InsertOrder
@C_FName varchar(50),
@C_LName varchar(50),
@C_DOB date,
@OType_Name varchar(50),
@O_Date date
AS
 
DECLARE @C_ID INT, @OType_ID INT
 
EXEC GetCustomerID
@First1_Name = @C_FName,
@Last1_Name = @C_LName,
@DOB1 = @C_DOB,
@Customer1_ID = @C_ID OUTPUT
 
EXEC GetOrderTypeID
@OType1_Name = @OType_Name,
@OType1_ID = @OType_ID OUTPUT
 
IF @OType_ID IS NULL
   BEGIN
       PRINT 'Hey...@OType_ID is coming back empty;check spelling'
       RAISERROR ('@OType_ID cannot be null;process is terminating', 11, 1)
       RETURN
   END
 
BEGIN TRANSACTION T1
INSERT INTO tblORDER (CustomerID, OrderTypeID, OrderDate)
VALUES (@C_ID, @OType_ID, @O_Date)
IF @@ERROR <> 0
   BEGIN
       ROLLBACK TRANSACTION T1
   END
ELSE
COMMIT TRANSACTION T1
GO
 
EXEC InsertOrder
@C_FName ='',
@C_LName ='',
@C_DOB ='',
@OType_Name ='',
@O_Date =''
GO
 
 
CREATE PROCEDURE InsertOrderMerchandise
@M_Name varchar(255),
@C_FName varchar(50),
@C_LName varchar(50),
@C_DOB date,
@OType_Name varchar(50),
@O_Date date,
@Q INT
AS
 
DECLARE @M_ID INT, @O_ID INT
 
EXEC GetMerchID
@M1_Name = @M_Name,
@M1_ID = @M_ID OUTPUT
 
IF @M_ID IS NULL
   BEGIN
       PRINT 'Hey...@M_ID is coming back empty;check spelling'
       RAISERROR ('@M_IDcannot be null;process is terminating', 11, 1)
       RETURN
   END
 
EXEC GetOrderID
@C1_FName = @C_FName,
@C1_LName = @C_LName,
@C1_DOB = @C_DOB,
@OType1_Name = @OType_Name,
@O1_Date = @O_Date,
@O1_ID = @O_ID OUTPUT
 
IF @O_ID IS NULL
   BEGIN
       PRINT 'Hey...@O_ID is coming back empty;check spelling'
       RAISERROR ('@O_IDcannot be null;process is terminating', 11, 1)
       RETURN
   END
 
BEGIN TRANSACTION T1
INSERT INTO tblORDERMERCHANDISE (MerchID, OrderID, Quantity)
VALUES (@M_ID, @O_ID, @Q)
IF @@ERROR <> 0
   BEGIN
       ROLLBACK TRANSACTION T1
   END
ELSE
COMMIT TRANSACTION T1
GO
 
EXEC InsertOrderMerchandise
@M_Name ='',
@C_FName ='',
@C_LName ='',
@C_DOB ='',
@OType_Name ='',
@O_Date ='',
@Q =''
GO
 
ALTER PROCEDURE InsertOrderStatus
@C_FName varchar(50),
@C_LName varchar(50),
@C_DOB date,
@OType_Name varchar(50),
@O_Date date,
@Stat_Name varchar(255)
AS
 
DECLARE @O_ID INT, @Stat_ID INT
 
EXEC GetOrderID
@C1_FName = @C_FName,
@C1_LName = @C_LName,
@C1_DOB = @C_DOB,
@OType1_Name = @OType_Name,
@O1_Date = @O_Date,
@O1_ID = @O_ID OUTPUT
 
IF @O_ID IS NULL
   BEGIN
       PRINT 'Hey...@O_ID is coming back empty;check spelling'
       RAISERROR ('@O_ID cannot be null;process is terminating', 11, 1)
       RETURN
   END
 
EXEC GetStatusID
@Stat1_Name = @Stat_Name,
@Stat1_ID = @Stat_ID OUTPUT
 
IF @Stat_ID IS NULL
   BEGIN
       PRINT 'Hey...@Stat_IDis coming back empty;check spelling'
       RAISERROR ('@Stat_ID cannot be null;process is terminating', 11, 1)
       RETURN
   END
 
BEGIN TRANSACTION T1
INSERT INTO tblORDERSTATUS (OrderID, StatusID)
VALUES (@O_ID, @Stat_ID)
IF @@ERROR <> 0
   BEGIN
       ROLLBACK TRANSACTION T1
   END
ELSE
COMMIT TRANSACTION T1
GO
 
EXEC InsertOrderStatus
@C_FName ='',
@C_LName ='',
@C_DOB ='',
@OType_Name ='',
@O_Date ='',
@Stat_Name =''
GO
 
CREATE PROCEDURE InsertShipment
@C_FName varchar(50),
@C_LName varchar(50),
@C_DOB date,
@OType_Name varchar(50),
@O_Date date,
@S_Date date,
@S_Address varchar(255),
@S_State varchar(20),
@S_City varchar(30),
@S_Zip char(5)
AS
 
DECLARE @O_ID INT
 
EXEC GetOrderID
@C1_FName = @C_FName,
@C1_LName = @C_LName,
@C1_DOB = @C_DOB,
@OType1_Name = @OType_Name,
@O1_Date = @O_Date,
@O1_ID = @O_ID OUTPUT
 
IF @O_ID IS NULL
   BEGIN
       PRINT 'Hey...@O_ID is coming back empty;check spelling'
       RAISERROR ('@O_ID cannot be null;process is terminating', 11, 1)
       RETURN
   END
 
BEGIN TRANSACTION T1
INSERT INTO tblSHIPMENT (OrderID, ShipmentCreatedDate, ShipmentStreetAddress, ShipmentState, ShipmentCity, ShipmentZipCode)
VALUES (@O_ID, @S_Date, @S_Address, @S_State, @S_City, @S_Zip)
IF @@ERROR <> 0
   BEGIN
       ROLLBACK TRANSACTION T1
   END
ELSE
COMMIT TRANSACTION T1
GO
 
EXEC InsertShipment
@C_FName ='',
@C_LName ='',
@C_DOB ='',
@OType_Name ='',
@O_Date ='',
@S_Date ='',
@S_Address ='',
@S_State ='',
@S_City ='',
@S_Zip =''
GO
 
CREATE PROCEDURE InsertMembership
@First_Name varchar(50),
@Last_Name varchar(50),
@DOB date,
@MemType_Name varchar(50),
@Membership_Name varchar(50),
@Begin_Date date
AS
 
DECLARE @Customer_ID INT, @MemType_ID INT
 
EXEC GetCustomerID
@First1_Name = @First_Name,
@Last1_Name = @Last_Name,
@DOB1 = @DOB,
@Customer1_ID = @Customer_ID OUTPUT
 
IF @Customer_ID IS NULL
  BEGIN
      PRINT 'Hey...@Customer_ID is coming back empty;check spelling'
      RAISERROR ('@Customer_ID cannot be null;process is terminating', 11, 1)
      RETURN
  END
 
EXEC GetMembershipTypeID
@MemType1_Name = @MemType_Name,
@MemType1_ID = @MemType_ID OUTPUT
 
IF @MemType_ID IS NULL
  BEGIN
      PRINT 'Hey...@MemType_ID is coming back empty;check spelling'
      RAISERROR ('@MemType_ID cannot be null;process is terminating', 11, 1)
      RETURN
  END
 
BEGIN TRANSACTION T1
INSERT INTO tblMEMBERSHIP (CustomerID, MembershipTypeID, CustomerMembershipName, BeginDate)
VALUES (@Customer_ID, @MemType_ID, @Membership_Name, @Begin_Date)
IF @@ERROR <> 0
   BEGIN
       ROLLBACK TRANSACTION T1
   END
ELSE
COMMIT TRANSACTION T1
GO
 
CREATE PROCEDURE InsertClass
@ClassType_Name varchar(50),
@Class_Time time,
@Class_Date date
AS
 
DECLARE @CT_ID INT
 
EXEC GetClassTypeID
@ClassType1_Name = @ClassType_Name,
@ClassType1_ID = @CT_ID OUTPUT
 
IF @CT_ID IS NULL
  BEGIN
      PRINT 'Hey...@CT_ID is coming back empty;check spelling'
      RAISERROR ('@CT_ID cannot be null;process is terminating', 11, 1)
      RETURN
  END
 
BEGIN TRANSACTION T1
INSERT INTO tblCLASS (ClassTypeID, ClassTime, ClassDate)
VALUES (@CT_ID, @Class_Time, @Class_Date)
IF @@ERROR <> 0
   BEGIN
       ROLLBACK TRANSACTION T1
   END
ELSE
   COMMIT TRANSACTION T1
GO
 
CREATE PROCEDURE InsertFranchise
@N1_Name varchar(255),
@Num_MemReg INT
 
AS
 
DECLARE @N1_ID INT
 
EXEC GetNeighborhoodID
@N_Name = @N1_Name,
@N_ID = @N1_ID OUTPUT
 
IF @N1_ID IS NULL
  BEGIN
      PRINT 'Hey...@N1_ID is coming back empty;check spelling'
      RAISERROR ('@N1_ID cannot be null;process is terminating', 11, 1)
      RETURN
  END
 
BEGIN TRANSACTION T1
INSERT INTO tblFRANCHISE (NeighborhoodID, NumMemReg)
VALUES (@N1_ID, @Num_MemReg)
IF @@ERROR <> 0
  BEGIN
      ROLLBACK TRANSACTION T1
  END
ELSE
COMMIT TRANSACTION T1
GO
 
EXEC InsertFranchise
@N1_Name = 'U-District',
@Num_MemReg = 100001
GO

CREATE PROCEDURE InsertFranchiseCoach
@Firsty varchar(50),
@Lasty varchar(50),
@DOB Date,
@C_Role varchar(50),
@Num_MemReg INT,
@Begin_Date Date
 
AS
 
DECLARE @Franchise_ID INT, @Coach_ID INT, @CoachRole_ID INT
 
EXEC GetFranchiseID
@Num_Reg = @Num_MemReg,
@F_ID = @Franchise_ID OUTPUT
 
IF @Franchise_ID IS NULL
 BEGIN
     PRINT 'Hey...@Franchise_ID is coming back empty;check spelling'
     RAISERROR ('@Franchise_ID cannot be null;process is terminating', 11, 1)
     RETURN
 END
 
 
EXEC GetCoachID
@CF_Name = @Firsty,
@CL_Name = @Lasty,
@C_DOB = @DOB,
@CO_ID = @Coach_ID OUTPUT
 
IF @Coach_ID IS NULL
 BEGIN
     PRINT 'Hey...@Coach_ID is coming back empty;check spelling'
     RAISERROR ('@Coach_ID cannot be null;process is terminating', 11, 1)
     RETURN
 END
 
 
EXEC GetCoachRoleID
@CR_Name = @C_Role,
@CR_ID = @CoachRole_ID OUTPUT
 
IF @CoachRole_ID IS NULL
 BEGIN
     PRINT 'Hey...@CoachRole_ID is coming back empty;check spelling'
     RAISERROR ('@CoachRole_ID cannot be null;process is terminating', 11, 1)
     RETURN
 END
 
BEGIN TRANSACTION T1
INSERT INTO tblFRANCHISECOACH(FranchiseId, CoachID, CoachRoleID, BeginDate)
VALUES (@Franchise_ID, @Coach_ID, @CoachRole_ID, @Begin_Date)
IF @@ERROR <> 0
  BEGIN
      ROLLBACK TRANSACTION T1
  END
ELSE
COMMIT TRANSACTION T1
GO
 
EXEC InsertFranchiseCoach
@Firsty = 'Lelah',
@Lasty = 'Garhart',
@DOB = '1993-06-08',
@C_Role = 'Coach',
@Num_MemReg = 100001,
@Begin_Date = '2022-04-02'
GO
 
CREATE PROCEDURE InsertRegistration
@Cust_FName varchar(50),
@Cust_LName varchar(50),
@Cust_DOB date,
@Coach_FName varchar(30),
@Coach_LName varchar(30),
@Coach_DOB date,
@Coach_Role varchar(50),
@CType_Name varchar(50),
@Class_Time time,
@Class_Date date,
@Neighborhood varchar(255),
@Begin_Date date
AS
 
DECLARE @Cust_ID INT, @FranC_ID INT, @Class_ID INT, @Neigbor_ID INT, @Reg_ID INT
 
EXEC GetCustomerID
@First1_Name = @Cust_FName,
@Last1_Name = @Cust_LName,
@DOB1 = @Cust_DOB,
@Customer1_ID = @Cust_ID OUTPUT
 
IF @Cust_ID IS NULL
  BEGIN
      PRINT 'Hey...@Cust_ID is coming back empty;check spelling'
      RAISERROR ('@Cust_ID cannot be null;process is terminating', 11, 1)
      RETURN
  END
 
EXEC GetFranchiseCoachID
@CoachFirst1_Name = @Coach_FName,
@CoachLast1_Name = @Coach_LName,
@CoachDOB = @Coach_DOB,
@Neig_Name = @Neighborhood,
@CoachRole1_Name = @Coach_Role,
@Begin1_Date = @Begin_Date,
@FC_ID = @FranC_ID OUTPUT
 
IF @FranC_ID IS NULL
  BEGIN
      PRINT 'Hey...@FranC_ID is coming back empty;check spelling'
      RAISERROR ('@FranC_ID cannot be null;process is terminating', 11, 1)
      RETURN
  END
 
EXEC GetClassID
@CType1_Name = @CType_Name,
@Class1_Time = @Class_Time,
@Class1_Date = @Class_Date,
@Class1_ID = @Class_ID OUTPUT
 
IF @Class_ID IS NULL
  BEGIN
      PRINT 'Hey...@Class_ID is coming back empty;check spelling'
      RAISERROR ('@Class_ID cannot be null;process is terminating', 11, 1)
      RETURN
  END
 
EXEC GetNeighborhoodID
@N_Name = @Neighborhood,
@N_ID = @Neigbor_ID OUTPUT
 
IF @Neigbor_ID IS NULL
  BEGIN
      PRINT 'Hey...@Neigbor_ID is coming back empty;check spelling'
      RAISERROR ('@Neigbor_ID cannot be null;process is terminating', 11, 1)
      RETURN
  END
 
BEGIN TRANSACTION T1
INSERT INTO tblREGISTRATION (CustomerID, FranchiseCoachID, ClassID, NeighborhoodID)
VALUES (@Cust_ID, @FranC_ID, @Class_ID, @Neighborhood)
IF @@ERROR <> 0
  BEGIN
      ROLLBACK TRANSACTION T1
  END
ELSE
COMMIT TRANSACTION T1
GO

--Insert data into the Look-Up Tables
INSERT INTO tblCUSTOMER (CustomerFName, CustomerLName, CustomerDOB, CustomerEmail, CustomerPhone, CustomerStreetAddress, CustomerState, CustomerCity, CustomerZipCode)
SELECT Top 500000 CustomerFName, CustomerLName, DateOfBirth, Email, PhoneNum, CustomerAddress, CustomerState, CustomerCity, CustomerZIP
FROM PEEPS.dbo.tblCUSTOMER
WHERE YEAR(DateOfBirth) BETWEEN 1952 and 2004
GO
 
INSERT INTO tblMEMBERSHIPTYPE (MembershipTypeName, MembershipTypePrice, MembershipTypeDesc)
VALUES ('Basic', 59, '4 classes/month'), ('Elite', 99, '8 classes/month'), ('Premier', 159, 'Unlimited classes/month')
GO

INSERT INTO tblCLASSTYPE (ClassTypeName)
VALUES ('Orange 45 min 3G'), ('Orange 60 min 2G'), ('Orange 60 min 3G'), ('Lift 45 (Total Body 1)'), ('Lift 45 (Total Body 2)'), ('Lift 45 (Total Body 3)')
GO
 
INSERT INTO tblNEIGHBORHOOD (NeighborhoodName, NeighborhoodDesc)
VALUES ('Belltown', 'Downtown location'), ('Capitol Hill', 'Cap Hill location'),
      ('U-District', 'Close to UW'), ('Lower Queen Anne', 'Fancy Seattle location'),
      ('Wallingford', 'Fremont side location'), ('Ballard', 'Golden Gardens beach location'),
      ('Mercer Island', 'Fancy rich peeps location')
GO
 
INSERT INTO tblCOACHROLE (CoachRoleName, RoleDesc)
VALUES ('Coach', 'A regular coach with limited benefits'), ('Head Coach', 'A legendary species of coach')
GO
 
INSERT INTO tblCOACH (CoachFName, CoachLName, CoachDOB, CoachEmail, CoachPhone)
SELECT TOP 100 CustomerFname, CustomerLName, DateOfBirth, Email, PhoneNum
FROM PEEPS.dbo.tblCUSTOMER
WHERE YEAR(DateOfBirth) BETWEEN 1970 and 2000 AND CustomerID > 700000
GO
 
INSERT INTO tblSTATUS (StatusName, StatusDesc)
VALUES ('Shipped', 'Shipment is released'),
       ('Not Shipped', 'Shipment is not released'),
       ('Ready to Process', 'Went into system on queue'),
       ('In Process', 'Process to release'),
       ('Not Ready to Process', 'Transaction is still being validated')
GO
 
INSERT INTO tblORDERTYPE (OrderTypeName, OrderTypeDesc)
VALUES ('Online', 'Order submitted on website'),
      ('Physical', 'Order submitted in store'),
      ('Call Center', 'Order submitted through call center')
GO
 
INSERT INTO tblMERCHANDISETYPE (MerchTypeName, MerchTypeDesc)
VALUES ('Clothing', 'Anything related to clothing'),
       ('Accessories', 'Anything other than clothing. ex: bags, bottle water, any equipments'),
       ('Gift cards', 'Gift-card purchases'),
       ('Stationaries', 'pencil, stickers, white-board, etc')
GO

--Insert into the Transactional Tables
-- 1. INSERT INTO tblORDER
CREATE PROCEDURE WRAPPER_INSERTORDER
@Run INT
AS
 
DECLARE @C_FN varchar(50), @C_LN varchar(50), @C_DOBy date, @OType_N varchar(50), @O_Datey date
DECLARE @CustPK INT, @OtypePK INT
DECLARE @C_Count INT = (SELECT COUNT(*) FROM tblCUSTOMER)
DECLARE @OT_Count INT = (SELECT COUNT(*) FROM tblORDERTYPE)
 
WHILE @Run > 0
BEGIN
SET @CustPK = (SELECT RAND() * @C_Count + 1)
SET @OtypePK = (SELECT RAND() * @OT_Count + 1)
 
SET @C_FN = (SELECT CustomerFname FROM tblCUSTOMER WHERE CustomerID = @CustPK)
SET @C_LN = (SELECT CustomerLname FROM tblCUSTOMER WHERE CustomerID = @CustPK)
SET @C_DOBy = (SELECT CustomerDOB FROM tblCUSTOMER WHERE CustomerID = @CustPK)
SET @OType_N = (SELECT OrderTypeName FROM tblORDERTYPE WHERE OrderTypeID = @OtypePK)
SET @O_Datey = (SELECT GetDate() - (SELECT Rand() * 100))
 
EXEC InsertOrder
@C_FName = @C_FN,
@C_LName = @C_LN,
@C_DOB = @C_DOBy,
@OType_Name = @OType_N,
@O_Date = @O_Datey
 
SET @Run = @Run - 1
END
GO
 
-- RUN WRAPPER_INSERTORDER TO INSERT 5000 ORDER
EXEC WRAPPER_INSERTORDER 5000
GO

-- 2. INSERT INTO tblSHIPMENT
INSERT INTO tblSHIPMENT (OrderID, ShipmentCreatedDate, ShipmentStreetAddress, ShipmentState, ShipmentCity, ShipmentZipCode)
SELECT OrderID, (SELECT DATEADD(day, 4, O.OrderDate)), C.CustomerStreetAddress, CustomerState, CustomerCity, CustomerZipCode
FROM tblORDER O
JOIN tblCUSTOMER C ON O.CustomerID = C.CustomerID
GO
-- 3. INSERT INTO tblORDERSTATUS
INSERT INTO tblORDERSTATUS (OrderID, StatusID)
SELECT OrderID, (SELECT StatusID FROM tblSTATUS WHERE StatusName = 'Shipped')
FROM tblORDER

-- 4. INSERT INTO tblMERCHANDISE
INSERT INTO tblMERCHANDISE (MerchTypeID, MerchName, MerchPrice)
VALUES ((SELECT MerchTypeID FROM tblMERCHANDISETYPE WHERE MerchTypeName = 'Clothing'), 'Leggings', 59.99),
((SELECT MerchTypeID FROM tblMERCHANDISETYPE WHERE MerchTypeName = 'Clothing'), 'Sports Bra', 49.99),
((SELECT MerchTypeID FROM tblMERCHANDISETYPE WHERE MerchTypeName = 'Clothing'), 'Shorts', 54.99),
((SELECT MerchTypeID FROM tblMERCHANDISETYPE WHERE MerchTypeName = 'Clothing'), 'Tshirt', 39.99),
((SELECT MerchTypeID FROM tblMERCHANDISETYPE WHERE MerchTypeName = 'Clothing'), 'Winbreaker', 89.99),
((SELECT MerchTypeID FROM tblMERCHANDISETYPE WHERE MerchTypeName = 'Accessories'), 'Running Shoes', 139.99),
((SELECT MerchTypeID FROM tblMERCHANDISETYPE WHERE MerchTypeName = 'Accessories'), 'Water Bottle', 27.99),
((SELECT MerchTypeID FROM tblMERCHANDISETYPE WHERE MerchTypeName = 'Accessories'), 'Cap', 29.99),
((SELECT MerchTypeID FROM tblMERCHANDISETYPE WHERE MerchTypeName = 'Accessories'), 'Headband', 29.99),
((SELECT MerchTypeID FROM tblMERCHANDISETYPE WHERE MerchTypeName = 'Accessories'), 'Duffle Bag', 59.99),
((SELECT MerchTypeID FROM tblMERCHANDISETYPE WHERE MerchTypeName = 'Gift cards'), '$25 Gift card', 24.99),
((SELECT MerchTypeID FROM tblMERCHANDISETYPE WHERE MerchTypeName = 'Gift cards'), '$50 Gift card', 49.99),
((SELECT MerchTypeID FROM tblMERCHANDISETYPE WHERE MerchTypeName = 'Gift cards'), '$100 Gift card', 99.99),
((SELECT MerchTypeID FROM tblMERCHANDISETYPE WHERE MerchTypeName = 'Stationaries'), 'Stickers', 25.99),
((SELECT MerchTypeID FROM tblMERCHANDISETYPE WHERE MerchTypeName = 'Stationaries'), 'Pen', 25.99),
((SELECT MerchTypeID FROM tblMERCHANDISETYPE WHERE MerchTypeName = 'Accessories'), 'Crossbody Bag', 39.99),
((SELECT MerchTypeID FROM tblMERCHANDISETYPE WHERE MerchTypeName = 'Accessories'), 'Yoga Mat', 44.99),
((SELECT MerchTypeID FROM tblMERCHANDISETYPE WHERE MerchTypeName = 'Accessories'), 'Dumbell (1-20lb) 2pcs', 25.99),
((SELECT MerchTypeID FROM tblMERCHANDISETYPE WHERE MerchTypeName = 'Accessories'), 'Dumbell (25-40lb) 2pcs', 35.99),
((SELECT MerchTypeID FROM tblMERCHANDISETYPE WHERE MerchTypeName = 'Clothing'), 'Tank tops', 24.99)
GO
 
-- 5. INSERT INTO tblORDERMERCHANDISE
SELECT *
INTO WORKING_COPY_ORDER
FROM tblORDER
ORDER BY OrderID
 
DECLARE @Q INT
DECLARE @MIN_PK INT
DECLARE @MerchPK INT, @OrderPK INT
DECLARE @M_Count INT = (SELECT COUNT(*) FROM tblMERCHANDISE)
DECLARE @RUN INT = (SELECT COUNT(*) FROM WORKING_COPY_ORDER)
 
WHILE @RUN > 0
 
BEGIN
SET @MIN_PK = (SELECT Min(OrderID) FROM WORKING_COPY_ORDER)
SET @OrderPK = (SELECT OrderID FROM WORKING_COPY_ORDER WHERE OrderID = @MIN_PK)
SET @MerchPK = (SELECT RAND() * @M_Count + 1)
SET @Q = (SELECT RAND()*(4-1+1)+1)
 
BEGIN TRAN T1
INSERT INTO  tblORDERMERCHANDISE (MerchID, OrderID, Quantity)
VALUES (@MerchPK, @OrderPK, @Q)
COMMIT TRAN T1
 
DELETE FROM WORKING_COPY_ORDER WHERE OrderID = @MIN_PK
 
SET @RUN = @RUN - 1
END
 
DROP TABLE WORKING_COPY_ORDER
 
-- 6. Insert into tblFRANCHISE
CREATE PROCEDURE WRAPPER_INSERTFRANCHISE
@Run INT
AS
 
DECLARE @N_Name varchar(50), @Num_Mem INT
DECLARE @NeighPK INT
DECLARE @N_Count INT = (SELECT COUNT(*) FROM tblNEIGHBORHOOD)
 
WHILE @Run > 0
BEGIN
SET @NeighPK = (SELECT RAND() * @N_Count + 1)
 
SET @N_Name = (SELECT NeighborhoodName FROM tblNEIGHBORHOOD WHERE NeighborhoodID = @NeighPK)
SET @Num_Mem = (SELECT FLOOR(RAND()*(4-1+1)+1))
 
EXEC InsertFranchise
@N1_Name = @N_Name,
@Num_MemReg = @Num_Mem
 
SET @Run = @Run - 1
END
GO
 
-- RUN WRAPPER_INSERTFRANCHISE TO INSERT 20 Franchise
EXEC WRAPPER_INSERTFRANCHISE 20
GO
 
-- 7. Insert into tblFRANCHISECOACH
 
SELECT *
INTO WORKING_COPY_FRANCHISE
FROM tblFRANCHISE
ORDER BY FranchiseID
 
DECLARE @BDate Date
DECLARE @MIN_PK INT
DECLARE @FranchisePK INT, @CoachPK INT, @CoachRolePK INT
DECLARE @CO_Count INT = (SELECT COUNT(*) FROM tblCOACH)
DECLARE @COR_Count INT = (SELECT COUNT(*) FROM tblCOACHROLE)
DECLARE @RUN INT = (SELECT COUNT(*) FROM WORKING_COPY_FRANCHISE)
 
WHILE @RUN > 0
 
BEGIN
SET @MIN_PK = (SELECT Min(FranchiseID) FROM WORKING_COPY_FRANCHISE)
SET @FranchisePK = (SELECT FranchiseID FROM WORKING_COPY_FRANCHISE WHERE FranchiseID = @MIN_PK)
SET @CoachPK = (SELECT RAND() * @CO_Count + 1)
SET @CoachRolePK = (SELECT FLOOR(RAND() * @CO_Count + 1))
SET @BDate = (SELECT GetDate() - (SELECT Rand() * 100))
 
BEGIN TRAN T1
INSERT INTO tblFRANCHISECOACH (FranchiseID, CoachID, CoachRoleID, BeginDate)
VALUES (@FranchisePK, @CoachPK, @CoachRolePK, @BDate)
COMMIT TRAN T1
 
DELETE FROM WORKING_COPY_FRANCHISE WHERE FranchiseID = @MIN_PK
 
SET @RUN = @RUN - 1
END
 
DROP TABLE WORKING_COPY_FRANCHISE
 
-- 7. Insert into tblREGISTRATION
ALTER PROCEDURE striWRAPPER_striInsertRegistration
@Run INT
AS
DECLARE @CustFName varchar(50), @CustLName varchar(50), @CustDOB date, @CoachFName varchar(50), @CoachLName varchar(50), @CoachDOB date, @CoachRole varchar(50), @ClassType varchar(50), @ClassTime time, @ClassDate date, @NeighborhoodName varchar(225), @BeginDate date
DECLARE @Cust_PK INT, @FranCoach_PK INT, @Class_PK INT
DECLARE @Cu_Count INT = (SELECT COUNT(*) FROM tblCUSTOMER)
DECLARE @FranCo_Count INT = (SELECT COUNT(*) FROM tblFRANCHISECOACH)
DECLARE @Cl_Count INT = (SELECT COUNT(*) FROM tblCLASS)
 
WHILE @Run > 0
BEGIN
SET @FranCoach_PK = (SELECT FLOOR (RAND()*@FranCo_Count+1))
SET @Cust_PK = (SELECT RAND()*@Cu_Count+1)
SET @Class_PK  = (SELECT RAND()*@Cl_Count+1)
 
SET @CustFName = (SELECT CustomerFName FROM tblCUSTOMER WHERE CustomerID = @Cust_PK)
SET @CustLName = (SELECT CustomerLName FROM tblCUSTOMER WHERE CustomerID = @Cust_PK)
SET @CustDOB = (SELECT CustomerDOB FROM tblCUSTOMER WHERE CustomerID = @Cust_PK)
SET @CoachFName = (SELECT CoachFName FROM tblCOACH WHERE CoachID = (SELECT CoachID FROM tblFRANCHISECOACH WHERE FranchiseCoachID = @FranCoach_PK))
SET @CoachLName = (SELECT CoachLName FROM tblCOACH WHERE CoachID = (SELECT CoachID FROM tblFRANCHISECOACH WHERE FranchiseCoachID = @FranCoach_PK))
SET @CoachDOB = (SELECT CoachDOB FROM tblCOACH WHERE CoachID = (SELECT CoachID FROM tblFRANCHISECOACH WHERE FranchiseCoachID = @FranCoach_PK))
SET @CoachRole = (SELECT CoachRoleName FROM tblCOACHROLE WHERE CoachRoleID = (SELECT CoachRoleID FROM tblFRANCHISECOACH WHERE FranchiseCoachID = @FranCoach_PK))
SET @ClassType = (SELECT ClassTypeName FROM tblCLASSTYPE WHERE ClassTypeID = (SELECT ClassTypeID FROM tblCLASS WHERE ClassID = @Class_PK))
SET @ClassTime = (SELECT ClassTime FROM tblCLASS WHERE ClassID = @Class_PK)
SET @ClassDate = (SELECT ClassDate FROM tblCLASS WHERE ClassID = @Class_PK)
SET @NeighborhoodName = (SELECT NeighborhoodName FROM tblNEIGHBORHOOD WHERE NeighborhoodID = (SELECT NeighborhoodID FROM tblFRANCHISE WHERE FranchiseID = @FranCoach_PK))
SET @BeginDate = (SELECT BeginDate FROM tblFRANCHISECOACH WHERE FranchiseCoachID = @FranCoach_PK)
 
EXEC InsertRegistration
@Cust_FName = @CustFName,
@Cust_LName = @CustLName,
@Cust_DOB = @CustDOB,
@Coach_FName = @CoachFName,
@Coach_LName = @CoachLName,
@Coach_DOB = @CoachDOB,
@Coach_Role = @CoachRole,
@CType_Name = @ClassType,
@Class_Time = @ClassTime,
@Class_Date = @ClassDate ,
@Neighborhood = @NeighborhoodName,
@Begin_Date = @BeginDate
 
SET @Run = @Run - 1
END
GO
 
-- RUN WRAPPER_striInsertRegistration TO INSERT 100 Registrations
EXEC striWRAPPER_striInsertRegistration 100

--Computed Columns
--Customer Age
CREATE FUNCTION IMT563_Proj_Customer_Age(@PK INT)
RETURNS INT
AS
BEGIN
 
DECLARE @RET INT=(SELECT DateDiff(Year, CustomerDOB, GetDate())
                FROM tblCUSTOMER
                WHERE @PK = CustomerID)
RETURN @RET
END
GO
 
ALTER TABLE tblCUSTOMER
ADD CustomerAge AS(dbo.IMT563_Proj_Customer_Age(CustomerID))

--Coach Age
CREATE FUNCTION IMT563_Proj_Coach_Age(@PK INT)
RETURNS INT
AS
BEGIN
DECLARE @RET INT=(SELECT DateDiff(Year, CoachDOB, GetDate())
                FROM tblCOACH
                WHERE @PK = CoachID)
RETURN @RET
END
GO
ALTER TABLE tblCOACH
ADD CoachAge AS(dbo.IMT563_Proj_Coach_Age(CoachID))

--Customer Full Name
ALTER TABLE tblCOACH
ADD CoachFullName AS (CoachFName + ' ' + CoachLName) PERSISTED

--Total Price of the Order
CREATE FUNCTION IMT563_Proj_Total_Price_Order (@PK INT)
RETURNS NUMERIC(10, 2)
AS
BEGIN
   DECLARE @RET NUMERIC(10,2) = (SELECT OM.Quantity * M.MerchPrice
                                FROM dbo.tblORDERMERCHANDISE OM
                                    JOIN tblMERCHANDISE M ON OM.MerchID = M.MerchID
                                WHERE OrderMerchID = @PK)
RETURN @RET
END
GO
 
ALTER TABLE dbo.tblORDERMERCHANDISE
ADD TotalPrice AS (dbo.IMT563_Proj_Total_Price_Order (OrderMerchID))

--Total Number of Classes
CREATE FUNCTION IMT563_Proj_Total_Classes_Customer (@PK INT)
RETURNS INT
AS
BEGIN  
   DECLARE @RET INT = (SELECT COUNT(R.RegistrationID)
                    FROM dbo.tblMEMBERSHIP M
                        JOIN tblCUSTOMER C ON M.CustomerID = C.CustomerID
                        JOIN tblREGISTRATION R ON C.CustomerID = R.CustomerID
                    WHERE R.CustomerID = @PK)
 
 
RETURN @RET
END
GO
 
ALTER TABLE dbo.tblMEMBERSHIP
ADD TotalClasses AS (dbo.IMT563_Proj_Total_Classes_Customer (CustomerID))

--Business Rules
--No members under 18 years of age
CREATE FUNCTION IMT563_Proj_MemberAgeAtLeast18()
RETURNS INTEGER
AS
BEGIN
DECLARE @RET INTEGER = 0
   IF EXISTS(SELECT *
       FROM tblCUSTOMER C
       WHERE C.CustomerDOB > DateAdd(Year,-18,GetDate()))
   SET @RET = 1
RETURN @RET
END
GO
 
SELECT dbo.IMT563_Proj_MemberAgeAtLeast18()
 
ALTER TABLE tblCUSTOMER WITH Nocheck
ADD CONSTRAINT ST_noMemberUnder18
CHECK(dbo.IMT563_Proj_MemberAgeAtLeast18()=0)
GO

--No shipping outside of US
CREATE FUNCTION IMT563_Proj_NoShipOutUS()
RETURNS INT
AS
BEGIN
DECLARE @RET INT = 0
  IF EXISTS(SELECT *
      FROM tblSHIPMENT S
       WHERE S.ShipmentZipCode > 99950
       OR S.ShipmentZipCode < 00501)
  SET @RET = 1
RETURN @RET
END
GO
 
SELECT dbo.IMT563_Proj_NoShipOutUS()
 
ALTER TABLE tblSHIPMENT WITH NOCHECK
ADD CONSTRAINT ST_OutsideUSNoShipment
CHECK(dbo.IMT563_Proj_NoShipOutUS()=0)
GO

--Minimum purchase of $20
CREATE FUNCTION IMT563_Proj_MinimumPurchase_20()
RETURNS INT
AS
BEGIN
DECLARE @RET INT = 0
IF EXISTS (SELECT * FROM tblOrderMerchandise O where O.TotalPrice < 20.00)
   SET @RET = 1
RETURN @RET
END
GO
 
SELECT dbo.IMT563_Proj_MinimumPurchase_20()
 
ALTER TABLE tblOrderMerchandise WITH Nocheck
ADD CONSTRAINT ST_MinimumPurchaseOf20
CHECK(dbo.IMT563_Proj_MinimumPurchase_20()=0)
GO

--Coaches must be at least 18 years old
CREATE FUNCTION IMT563_CoachAgeAtLeast18()
RETURNS INTEGER
AS
BEGIN
DECLARE @RET INTEGER = 0
   IF EXISTS(SELECT *
             FROM tblCOACH C
             WHERE C.CoachDOB > DateAdd(Year, -18, GetDate()))
   SET @RET = 1
 
RETURN @RET
END
GO
 
SELECT dbo.IMT563_CoachAgeAtLeast18()
 
ALTER TABLE tblCOACH WITH Nocheck
ADD CONSTRAINT CK_under18NoTeachingForYou
CHECK(dbo.IMT563_CoachAgeAtLeast18()=0)
GO

--Limit the quantity of specific product a customer can buy
CREATE FUNCTION IMT563_LimitingProducts()
RETURNS INTEGER
AS
BEGIN
DECLARE @RET INT = 0
   IF EXISTS (SELECT *               
              FROM tblCUSTOMER C
                  JOIN tblORDER O ON C.CustomerID = O.CustomerID
                  JOIN tblORDERMERCHANDISE OM ON O.OrderID = OM.OrderID
              WHERE Quantity > 4)
   SET @RET = 1
 
RETURN @RET
END
GO
 
SELECT dbo.IMT563_LimitingProducts()
 
ALTER TABLE tblORDER WITH NOCHECK
ADD CONSTRAINT ST_NoMoreProductForYou
CHECK (dbo.IMT563_LimitingProducts() = 0)
GO

--Shipping date cannot be before the order date
CREATE FUNCTION IMT563_NoShipDate_EarlierThan_OrderDate()
RETURNS INTEGER
AS
BEGIN
DECLARE @RET INT = 0
  IF EXISTS (SELECT *
            FROM tblSHIPMENT S
                JOIN tblORDER O ON S.OrderID = O.OrderID
            WHERE S.ShipmentCreatedDate <= O.OrderDate)
   SET @RET = 1
 
RETURN @RET
END
GO
 
SELECT dbo.IMT563_NoShipDate_EarlierThan_OrderDate()
 
ALTER TABLE tblSHIPMENT WITH NOCHECK
ADD CONSTRAINT NoShipmentBeforeOrder
CHECK (dbo.IMT563_NoShipDate_EarlierThan_OrderDate() = 0)
GO

--Views
--What is the total revenue of sales for the year 2022 for each merchandise type in physical stores?
CREATE VIEW [vw_Orange_Theory_Sales]
AS
SELECT MT.MerchTypeName, OT.OrderTypeName, O.OrderDate, SUM(OM.TotalPrice) AS TotalSales,
RANK() OVER (PARTITION BY MerchTypeName ORDER BY SUM(OM.TotalPrice) DESC) AS SalesRank
FROM tblORDER O
   JOIN tblORDERTYPE OT ON O.OrderTypeID = OT.OrderTypeID
   JOIN tblORDERMERCHANDISE OM ON O.OrderID = OM.OrderID
   JOIN tblMERCHANDISE M ON OM.MerchID = M.MerchID
   JOIN tblMERCHANDISETYPE MT ON M.MerchTypeID = MT.MerchTypeID
WHERE OT.OrderTypeName = 'Physical' AND (O.OrderDate >= '2022-01-01')
GROUP BY MT.MerchTypeName, OT.OrderTypeName, O.OrderDate
GO

--What is the most preferred class type based on the number of registrations?
CREATE VIEW [vw_Orange_Theory_BestClassType_Neighborhood]
AS
SELECT ClassTypeName, NeighborhoodName, Count(RegistrationID) As NoOfRegistrations, Rank() Over (Partition By NeighborhoodName Order By Count(RegistrationID) DESC) As ClassTypeRanking
FROM tblREGISTRATION R
JOIN tblCLASS C ON R.ClassID = C.ClassID
JOIN tblNEIGHBORHOOD N ON R.NeighborhoodID = N.NeighborhoodID
JOIN tblCLASSTYPE CT ON C.ClassTypeID = CT.ClassTypeID
GROUP BY ClassTypeName, NeighborhoodName
GO

--What is the best selling merchandise based on the total quantity sold?
CREATE VIEW [vw_bestsellingmerchandise]
AS
SELECT M.MerchName, MT.MerchTypeName, SUM(OM.Quantity) AS TotalQuantity, DENSE_RANK() OVER (ORDER BY SUM(OM.Quantity) DESC) AS DenseRanky
FROM tblMERCHANDISE M
JOIN tblMERCHANDISETYPE MT ON M.MerchTypeID = MT.MerchTypeID
JOIN tblORDERMERCHANDISE OM ON M.MerchID = OM.MerchID
GROUP BY M.MerchName, MT.MerchTypeName;
GO

--Who is the most popular coach based on the number of registrations?
CREATE VIEW [vw_most_popular_coach_basedontotalregisteredclassestaught]
AS
SELECT CoachFname, CoachLname, COUNT(R.FranchiseCoachID) AS NumberofClassesTaught , DENSE_RANK() OVER (Order by COUNT(R.FranchiseCoachID) DESC) AS CoachRank
FROM tblCOACH C
JOIN tblFRANCHISECOACH FC ON C.CoachID = FC.CoachID
JOIN tblREGISTRATION R ON FC.FranchiseCoachID = R.FranchiseCoachID
GROUP BY CoachFName, CoachLName
GO

--Which order method is most preferred by the customers?
CREATE VIEW [vw_preferredmethod_order]
AS
SELECT OrderTypeName, COUNT(O.OrderTypeID) AS TotalNumberofOrders, DENSE_RANK() OVER (Order by COUNT(O.OrderTypeID) DESC) AS OrderTypeRank
FROM tblORDER O
JOIN tblORDERTYPE OT ON O.OrderTypeID = OT.OrderTypeID
GROUP BY OrderTypeName
GO

--Rank customers based on total number of registrations
CREATE VIEW [vw_rankcustomer_basedonnumberofregistrations]
AS
SELECT CustomerFname, CustomerLname, COUNT(R.CustomerID) AS NumberofRegistrations , DENSE_RANK() OVER (Order by COUNT(R.CustomerID) DESC) AS CustomerRank
FROM tblCUSTOMER C
JOIN tblREGISTRATION R ON C.CustomerID = R.CustomerID
GROUP BY CustomerFname, CustomerLname
GO