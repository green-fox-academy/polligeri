USE [master]
GO

CREATE TABLE [Faculties]
(
    [id]        INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
    [name]      NVARCHAR(100),
    [birthDate] DATE
)


CREATE TABLE [Teachers]
(
    [id]        INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
    [email]     NVARCHAR(100),
    [birthDate] DATE,
    [phone]     NVARCHAR(100),
    [faculty]   INT NOT NULL -- AZÉRT, MERT EGY TANÁR EGY TANTÁRGYAT OKTAT!
    CONSTRAINT [FK_TEACHERS_FACULTY] FOREIGN KEY ([faculty]) REFERENCES [Faculties] ([id])
        ON DELETE NO ACTION
        ON UPDATE CASCADE
)

CREATE TABLE [Students]
(
    [id]               INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
    [email]            NVARCHAR(100),
    [birthDate]        DATE,
    [description]      NVARCHAR(1000),
    [yearOfAcceptance] INT,
    [class]            NVARCHAR(100)
)


CREATE TABLE [Student2Faculty]
(
    [student] INT NOT NULL,
    [faculty] INT NOT NULL,

    CONSTRAINT [PK_S2F] PRIMARY KEY ([student], [faculty]),

    CONSTRAINT [FK_S2F_STUDENT] FOREIGN KEY ([student]) REFERENCES [Students] ([id])
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT [FK_S2F_FACULTY] FOREIGN KEY ([faculty]) REFERENCES [Faculties] ([id])
        ON DELETE CASCADE
        ON UPDATE CASCADE
)