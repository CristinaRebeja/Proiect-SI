USE [master]
GO

ALTER DATABASE [Proiect] SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;
GO

DROP DATABASE [Proiect]
GO

CREATE DATABASE [Proiect]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Proiect', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Proiect.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Proiect_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Proiect_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Proiect].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

USE [Proiect]
GO 

--CREARE TABELE

CREATE TABLE [Users] ( 
	[UserId] [int] NOT NULL PRIMARY KEY CLUSTERED,
	[Name] [nvarchar](100) NOT NULL,
	[Role][nvarchar](15),
	[IsActive] [bit] NOT NULL);

CREATE TABLE [Clients](
	[ClientId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED ,
	[FirstName] [nvarchar](100) NOT NULL,
	[LastName] [nvarchar](100) NULL,
	[CNP] [varchar](13) NOT NULL,
	[PhoneNumber] [varchar](25) NULL ,
	[Email] [varchar](50) NULL,
	[Notes] [nvarchar](256) NULL,
	[UserId] [int] NOT NULL,
	CONSTRAINT [FK_Clients_Users] FOREIGN KEY([UserId]) REFERENCES [Users] ([UserId]));

CREATE TABLE [ContractStatuses](
	[StatusId] [int] NOT NULL PRIMARY KEY CLUSTERED,
	[Name] [nvarchar](20) NOT NULL);

CREATE TABLE [TransactionTypes](
	[TransactionTypeId] [int] NOT NULL PRIMARY KEY CLUSTERED,
	[Name] [nvarchar](30) NOT NULL);

CREATE TABLE [PaymentTypes](
	[PaymentTypeId] [int] NOT NULL PRIMARY KEY CLUSTERED,
	[Name] [nvarchar](30) NOT NULL);

CREATE TABLE [Subscriptions](
	[SubscriptionId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
	[Name] [nvarchar](150) NOT NULL,
	[Fee] [decimal](10, 2) NOT NULL,
	[IsActive] [bit] NOT NULL);

CREATE TABLE [Contracts](
	[ContractId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
	[ClientId] [int] NOT NULL,
	[StatusId] [int] NOT NULL,
	[Number] [varchar](20) NOT NULL,
	[SubscriptionId] [int] NOT NULL,
	[RegistrationDate] [date] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
	[UserId] [int] NOT NULL,
	CONSTRAINT [FK_Contracts_Clients] FOREIGN KEY([ClientId]) REFERENCES [Clients] ([ClientId]),
	CONSTRAINT [FK_Contracts_Statuses] FOREIGN KEY([StatusId]) REFERENCES [ContractStatuses] ([StatusId]),
	CONSTRAINT [FK_Contracts_Subscriptions] FOREIGN KEY([SubscriptionId]) REFERENCES [Subscriptions] ([SubscriptionId]),
	CONSTRAINT [FK_Contracts_Users] FOREIGN KEY([UserId]) REFERENCES [Users] ([UserId]));
	
CREATE UNIQUE INDEX [IX_Contrats_Number] on [Contracts] (Number); 

CREATE TABLE [Payments](
	[PaymentId] [int] IDENTITY(1,1) NOT NULL,
	[ContractId] [int] NOT NULL,
	[PaymentTypeId] [int] NOT NULL,
	[RegistrationDate] [date] NOT NULL,
	[Amount] [decimal](10, 2) NOT NULL,
	[ExternalReference] [nvarchar](100) NULL,
	[UserId] [int] NOT NULL,
	CONSTRAINT [FK_Payments_Contracts] FOREIGN KEY([ContractId]) REFERENCES [Contracts] ([ContractId]),
	CONSTRAINT [FK_Payments_PaymentTypes] FOREIGN KEY([PaymentTypeId]) REFERENCES [PaymentTypes] ([PaymentTypeId]),
	CONSTRAINT [FK_Payments_Users] FOREIGN KEY([UserId]) REFERENCES [Users] ([UserId]));

CREATE TABLE [ContractBalanceTransactions](
	[TransactionId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
	[ContractId] [int] NOT NULL,
	[TransactionTypeId] [int] NOT NULL,
	[Reference] [nvarchar](50) NULL,
	[Amount] [decimal](18, 4) NOT NULL,
	[RowCreationTimestamp] [datetime] NOT NULL,
	CONSTRAINT [FK_ContractBalanceTransactions_Contracts] FOREIGN KEY([ContractId]) REFERENCES [Contracts] ([ContractId]),
	CONSTRAINT [FK_ContractBalanceTransactions_TransactionTypes] FOREIGN KEY([TransactionTypeId]) REFERENCES [TransactionTypes] ([TransactionTypeId]));

ALTER TABLE [dbo].[ContractBalanceTransactions] ADD  DEFAULT (getdate()) FOR [RowCreationTimestamp]
GO


--POPULARE TABELE
INSERT INTO [dbo].[Users] VALUES (123,'Valentin Popescu', 'administrator', 1);
INSERT INTO [dbo].[Users] VALUES (124,'Ioana Deleanu', 'contabil', 1);
INSERT INTO [dbo].[Users] VALUES (125,'Vasile Cercel', 'agent vanzari', 1);
INSERT INTO [dbo].[Users] VALUES (126,'Valentin Popescu', 'colaborator', 1);

INSERT INTO [dbo].[ContractStatuses] VALUES (0,'Draft');
INSERT INTO [dbo].[ContractStatuses] VALUES (1,'Active');
INSERT INTO [dbo].[ContractStatuses] VALUES (2,'Terminated');
INSERT INTO [dbo].[ContractStatuses] VALUES (3,'Suspended');
INSERT INTO [dbo].[ContractStatuses] VALUES (4,'Terminated for debt');

INSERT INTO [dbo].[PaymentTypes] VALUES (1,'Post Office');
INSERT INTO [dbo].[PaymentTypes] VALUES (2,'Bank');
INSERT INTO [dbo].[PaymentTypes] VALUES (3,'Cash');
INSERT INTO [dbo].[PaymentTypes] VALUES (4,'Payment terminal');

INSERT INTO [dbo].[TransactionTypes] VALUES (1,'Payment');
INSERT INTO [dbo].[TransactionTypes] VALUES (2,'Monthly fee');
INSERT INTO [dbo].[TransactionTypes] VALUES (3,'Manual adjustment');
INSERT INTO [dbo].[TransactionTypes] VALUES (4,'Technical suspension');

INSERT INTO [dbo].[Subscriptions] VALUES ('CATV', 35, 1);
INSERT INTO [dbo].[Subscriptions] VALUES ('5M+CATV', 65, 1);
INSERT INTO [dbo].[Subscriptions] VALUES ('10M+CATV', 75, 1);
INSERT INTO [dbo].[Subscriptions] VALUES ('40M+CATV', 85, 0);
INSERT INTO [dbo].[Subscriptions] VALUES ('Internet 10M', 45, 1);
INSERT INTO [dbo].[Subscriptions] VALUES ('Internet 100M', 55, 1);


--FUNCTIE GENERARE NUMAR CONTRACT
GO

CREATE FUNCTION GetContractNumber()
RETURNS VARCHAR(20)
AS
  BEGIN
      DECLARE @ContractNumber VARCHAR(20)

      IF NOT EXISTS (SELECT 1
                     FROM   Contracts)
        SET @ContractNumber='MPM00001'
      ELSE
        BEGIN
            DECLARE @LastContractNumber VARCHAR(20),
                    @Num                INT

            SELECT @Num = Max(Cast(RIGHT(Number, 5) AS INT))
            FROM   Contracts

            SET @Num=@Num + 1
            SET @ContractNumber='MPM' + Format(@Num, '00000')
        END

      RETURN @ContractNumber
  END

GO 

--PROCEDURA STOCATA CE INREGISTREAZA CONTRACTE NOI
CREATE PROCEDURE RegisterContract 
	@FirstName nvarchar(100),
	@LastName nvarchar(100),
	@CNP varchar(13),
	@PhoneNumber varchar(25),
	@Email varchar(50),
	@Notes nvarchar(256),
	@SubscriptionId int,
	@StartDate date,
	@UserId int
	
	AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRANSACTION

		INSERT INTO Clients (FirstName, LastName, CNP, PhoneNumber, Email, Notes, UserId)
		VALUES (@FirstName, @LastName, @CNP, @PhoneNumber, @Email, @Notes, @UserId)
		select SCOPE_IDENTITY() as ID
		DECLARE 
			@ClientId INT,
			@StatusId INT = 1, --0 for Active
			@Number VARCHAR(20),
			@RegistrationDate DATE = GETDATE(),
			@EndDate DATE = NULL
		
		SET @ClientId = SCOPE_IDENTITY();
		SET @Number = dbo.Getcontractnumber();
		SELECT @ClientId, @Number, SCOPE_IDENTITY();
		
		INSERT INTO Contracts (ClientId, StatusId, Number, SubscriptionId, RegistrationDate, StartDate, EndDate, UserId)
		VALUES (@ClientId, @StatusId, @Number, @SubscriptionId, @RegistrationDate, @StartDate, @EndDate, @UserId)
	COMMIT
END
GO

EXEC RegisterContract 'Munteanu','Vasile','1691218256358','078989894','vasilemunteanu@gmail.com','',1,'2020-05-01',123
EXEC RegisterContract 'Ionescu','Ioana','2861010254896','078985894','ioanaionescu@gmail.com','',2,'2020-06-01',125
EXEC RegisterContract 'Toparceanu','George','1830608469521','07823543','toparceanu@gmail.com','',1,'2020-04-01',125
EXEC RegisterContract 'Vlad','Andrei','1800608469521','07898123','andreivlad@gmail.com','',3,'2020-04-01',125
EXEC RegisterContract 'Voronet','Sucevel','1700610469521','078325123','voronet@gmail.com','',5,'2020-05-01',124

go
--TRIGGER - INSEREAZA TRANZACTII CAND SE INSEREAZA/STERG PLATI
CREATE TRIGGER InsertPaymentTransaction
ON [dbo].[Payments]
AFTER INSERT, DELETE
AS
  BEGIN
      SET NOCOUNT ON;

      INSERT INTO [dbo].[ContractBalanceTransactions]
                  (ContractId, TransactionTypeId, Reference, Amount)
      SELECT I.ContractId, 1, I.ExternalReference, I.Amount 
      FROM   inserted AS I
		UNION ALL
      SELECT D.ContractId, 1, D.ExternalReference, -D.Amount
      FROM   deleted AS D;
  END

INSERT INTO [dbo].[Payments] (ContractId, PaymentTypeId, RegistrationDate, Amount, ExternalReference, UserId)
VALUES (1, 2, '2020-07-05', '20', 'ING', 125);


GO


CREATE VIEW vwContractDetails
AS
  SELECT	C.Number AS Contract_Number, 
			S.Name AS Subscription, 
			CS.Name Contract_Status,
			CL.FirstName AS First_Name, 
			CL.LastName AS Last_Name,
			CL.PhoneNumber AS Phone,
			C.StartDate AS Start_Date,
			C.EndDate AS End_Date,
			(SELECT SUM(Amount) FROM ContractBalanceTransactions 
			WHERE ContractId=C.ContractId
			GROUP BY ContractId) as Balance
  FROM Clients CL
	JOIN Contracts C ON C.ClientId=CL.ClientId
	JOIN Subscriptions S ON S.SubscriptionId=C.SubscriptionId
	JOIN ContractStatuses CS ON CS.StatusId=C.StatusId
GO