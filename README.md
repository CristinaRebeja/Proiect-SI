# Proiect de curs Școala Informală de IT
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
|`ClientId`|int|Nu|cheie primară|
