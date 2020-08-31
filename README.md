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
