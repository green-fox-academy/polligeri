USE [master]
GO

IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = '[Movies]')
BEGIN
CREATE DATABASE [Movies]
END
GO

USE [Movies]
GO

IF NOT EXISTS ( SELECT  * FROM sys.schemas  
WHERE name = N'[Movies]' ) 
EXEC('CREATE SCHEMA [Movies]');


CREATE TABLE [Movies].[Movies]
(
    [id]                INT           NOT NULL IDENTITY (1,1) PRIMARY KEY,
    [name]              NVARCHAR(100) NOT NULL,
    [language]          NVARCHAR(100) NOT NULL,
    [released]          DATE          NOT NULL,
    [length_in_minutes] INT           NOT NULL
)
GO

CREATE TABLE [Movies].[Actors]
(
    [id]               INT           NOT NULL IDENTITY (1,1) PRIMARY KEY,
    [name]             NVARCHAR(100) NOT NULL,
    [date_of_birth]    DATE          NOT NULL,
    [number_of_awards] INT           NOT NULL,
    [number_of_oscars] INT           NOT NULL DEFAULT 0,
    [popularity]       DECIMAL(4,2),

    CONSTRAINT [CK_Actor_Popularity] CHECK ([popularity] >= 0.00 AND [popularity] <= 10.00)
)
GO

CREATE TABLE [Movies].[Users]
(
    [id]      INT           NOT NULL IDENTITY (1,1) PRIMARY KEY,
    [name]    NVARCHAR(100) NOT NULL,
    [email]   NVARCHAR(100) NOT NULL,
    CONSTRAINT [UQ_Users_Email] UNIQUE ([email])
)
GO

CREATE TABLE [Movies].[Movie2Actor]
(
    [movie] [int] NOT NULL,
    [actor] [int] NOT NULL,
    CONSTRAINT [PK_Movie2Actor]        PRIMARY KEY ([movie], [actor]),
    CONSTRAINT [FK_Movie2Actor_Actors] FOREIGN KEY  ([actor]) REFERENCES [Movies].[Actors] ([id]),
    CONSTRAINT [FK_Movie2Actor_Movies] FOREIGN KEY  ([movie]) REFERENCES [Movies].[Movies] ([id])
)
GO