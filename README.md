# Proiect de curs Școala Informală de IT
Acest proiect presupune realizarea unei baze de date pentru a facilita gestionarea unei firme ce oferă servicii de Internet/Tv.
Proiectul este realizat în SQL Server Management Studio.

## Tabele
Secțiunea curentă descrie tabelele din proiect

### Clients
Tabelul `Clients` conține informații despre clienți.

```sql
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
```

|Nume Coloană|Tip Date|Acceptă `NULL`|Observații|
|------------|--------|--------------|---------|
|ClientId|int|Nu|cheie primară|
|CNP|varchar(13)|Nu||
|Email|varchar(50)|Da||
|FirstName|nvarchar(100)|Nu||
|LastName|nvarchar(100)|Da||
|Notes|nvarchar(256)|Da||
|PhoneNumber|varchar(25)|Da||
|UserId|int|Nu||

### Users
Tabelul `Users` conține informații despre utilizatorii aplicației

```sql
CREATE TABLE [Users] ( 
	[UserId] [int] NOT NULL PRIMARY KEY CLUSTERED,
	[Name] [nvarchar](100) NOT NULL,
	[Role][nvarchar](15),
	[IsActive] [bit] NOT NULL);
```

|Nume Coloană|Tip Date|Acceptă `NULL`|Observații|
|------------|--------|--------------|---------|
|UserId|int|Nu|cheie primară|
|Name|nvarchar(100)|Nu||
|Role|nvarchar(15)|Da||
|IsActive|bit|Nu||


### ContractStatuses
Tabelul `ContractStatuses` conține statusurile pe care le pot avea contractele

```sql
CREATE TABLE [ContractStatuses](
	[StatusId] [int] NOT NULL PRIMARY KEY CLUSTERED,
	[Name] [nvarchar](20) NOT NULL);
```

|Nume Coloană|Tip Date|Acceptă `NULL`|Observații|
|------------|--------|--------------|---------|
|StatusId|int|Nu|cheie primară|
|Name|nvarchar(20)|Nu||


### TransactionTypes
Tabelul `TransactionTypes` conține tipurile de tranzacții financiare ce afecteaza soldul uni contract.

```sql
CREATE TABLE [TransactionTypes](
	[TransactionTypeId] [int] NOT NULL PRIMARY KEY CLUSTERED,
	[Name] [nvarchar](30) NOT NULL);
```

|Nume Coloană|Tip Date|Acceptă `NULL`|Observații|
|------------|--------|--------------|---------|
|TransactionTypeId|int|Nu|cheie primară|
|Name|nvarchar(30)|Nu||


### PaymentTypes
Tabelul `PaymentTypes` conține tipurile de plăți.

```sql
CREATE TABLE [PaymentTypes](
	[PaymentTypeId] [int] NOT NULL PRIMARY KEY CLUSTERED,
	[Name] [nvarchar](30) NOT NULL);
```

|Nume Coloană|Tip Date|Acceptă `NULL`|Observații|
|------------|--------|--------------|---------|
|PaymentTypeId|int|Nu|cheie primară|
|Name|nvarchar(30)|Nu||


### Subscriptions
Tabelul `Subscriptions` conține tipurile de abonamente.

```sql
CREATE TABLE [Subscriptions](
	[SubscriptionId] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY CLUSTERED,
	[Name] [nvarchar](150) NOT NULL,
	[Fee] [decimal](10, 2) NOT NULL,
	[IsActive] [bit] NOT NULL);
```

|Nume Coloană|Tip Date|Acceptă `NULL`|Observații|
|------------|--------|--------------|---------|
|SubscriptionId|int|Nu|cheie primară|
|Name|nvarchar(150)|Nu||
|Fee|decimal|Nu||
|IsActive|bit|Nu||


### Contracts
Tabelul `Contracts`

```sql
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
```

|Nume Coloană|Tip Date|Acceptă `NULL`|Observații|
|------------|--------|--------------|---------|
|ContractId|int|Nu|cheie primară|
|ClientId|int|Nu|cheie străină – referință la tabelul `Clients`|
|StatusId|int|Nu|cheie străină – referință la tabelul `ContractStatuses`|
|Number|varchar(20)|Nu||
|SubscriptionId|int|Nu|cheie străină – referință la tabelul `Subscriptions`|
|RegistrationDate|date|Nu||
|StartDate|date|Nu||
|EndDate|date|Da||
|UserId|int|Nu|cheie străină – referință la tabelul `Users`|


### Payments
Tabelul `Payments` - în care sunt înregistrate plățile efectuate de către clienți:

```sql
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
```

|Nume Coloană|Tip Date|Acceptă `NULL`|Observații|
|------------|--------|--------------|---------|
|PaymentId|int|Nu|cheie primară|
|ContractId|int|Nu|cheie străină – referință la tabelul `Contracts`|
|PaymentTypeId|int|Nu|cheie străină – referință la tabelul `PaymentTypes`|
|RegistrationDate|date|Nu||
|Amount|decimal|Nu||
|ExternalReference|nvarchar(100)|Da||
|UserId|int|Nu|cheie străină – referință la tabelul `Users`|


### ContractBalanceTransactions
 În acest tabel sunt înregistrate toate tranzacțiile financiare a contractelor.

```sql
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
```

|Nume Coloană|Tip Date|Acceptă `NULL`|Observații|
|------------|--------|--------------|---------|
|Amount|decimal|Nu||
|ContractId|int|Nu||
|Nume Coloană|Tip Date|Acceptă `NULL`|Observații|
|Reference|nvarchar(50)|Da||
|RowCreationTimestamp|datetime|Nu||
|TransactionId|int|Nu||
|TransactionTypeId|int|Nu||


## Populare tabele

Am populat unele tabele cu câteva date inițiale:

```sql
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

GO
```

## Funcții și Proceduri

### Funcția `GetContractNumber` 

Această funcție generează numerele de contracte (`Number` din tabelul `Contracts`).
Acestea sunt de tip `VARCHAR`, și sunt formate din 3 litere (MPM) și 5 cifre.
Funcția alocă primului contract numărul MPM00001.
Pentru următoarele, verifică care este cel mai mare număr de contract (transformând partea numerică în tip `INT`), adaugă 1, 
după care returnează rezultatul cu literele 'MPM' în față (transformând din nou șirul în `VARCHAR`).

```sql
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
```

### Procedura `RegisterContract` 

Această procedură stocată înregistrează contracte noi. 

**Parametri:**
- `@FirstName` - Prenumele clientului
- `@LastName` - Numele clientului
- `@CNP` - codul numeric personal
- `@PhoneNumber` - număr de telefon
- `@Email` - adresa de e-mail
- `@Notes` - observații
- `@SubscriptionId` - id-ul abonamentului
- `@StartDate` - data de început a contractului
- `@UserId` - id-ul angajatului care a înregistrat contractul

Procedura inserează datele clientului în tabelul `Clients`, alocă un număr de contract nou apelând funcția `GetContractNumber` și inserează datele contractului în tabelul `Contracts`.

```sql
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
```

Exemplu de apel:
```SQL
EXEC RegisterContract 'Munteanu','Vasile','1691218256358','078989894','vasilemunteanu@gmail.com','',1,'2020-05-01',123
```

### Procedura `MonthlyFee`

Această procedură stocată, inserează în tabelul `ContractBalanceTransactions` câte o tranzacție pentru fiecare contract activ, cu taxa lunară aferentă abonamentului.

```SQL
CREATE PROCEDURE MonthlyFee 
AS
	BEGIN
		SET NOCOUNT ON
		--@TransactionType INT = 2 --MonthlyFee
		INSERT INTO [dbo].[ContractBalanceTransactions] (ContractId, TransactionTypeId, Amount)
		SELECT C.ContractId, 2, -S.Fee
		FROM Contracts C
			JOIN Subscriptions S ON C.SubscriptionId=S.SubscriptionId
			JOIN ContractStatuses CS ON CS.StatusId=C.StatusId
		WHERE CS.Name='Active'
	END
GO
```
Procedura trebuie rulată lunar, pentru a actualiza soldul contractelor.
Întrucât acest proiect a fost realizat în versiunea Express a SQL Server, nu am avut opțiunea de a face un job care să ruleze procedura automat în fiecare lună.
Pentru a executa procedura stocată în fiecare lună, am folosit componenta Task Scheduler de la Windows. Am creat un task separat, care rulează procedura pe data de 1 a fiecărei luni, la ora 01.00.

```shell
sqlcmd -S localhost -E -d Proiect -Q "exec MonthlyFee"
```

## Trigger `InsertPaymentTransaction`

La înregistrarea/ștergerea unei plăți în tabelul `Payments`, trigger-ul inserează/șterge o tranzacție aferentă în tabelul `ContractBalanceTransactions`.

```SQL
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
```

## View `vwContractDetails`

Am creat un view în care putem vedea mai multe detalii despre un anumit contract, în același loc (inclusiv soldul contractului).

```sql
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
```
Exemplu:

```sql
SELECT * FROM [dbo].[vwContractDetails] 
	WHERE Contract_Number='MPM000ls';
```

|Contract_Number|Subscription|Contract_Status|First_Name|Last_Name|Phone|Start_Date|End_Date|Balance|
|---------------|------------|---------------|----------|---------|-----|----------|--------|-------|
|MPM00003|CATV|Active|Toparceanu|George|07823543|2020-04-01|NULL|-35.0000|