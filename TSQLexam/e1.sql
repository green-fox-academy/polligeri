/*
Exercise #1:
Design a small subset of an imaginary Movies database.
In the Movies database, you want to store data about the following at least:
•	movies
•	genres
•	the relationship between movies and genres
Each movie can belong to multiple genres (eg: Sci-fi, Action, Horror etc.) and each genre has multiple movies (there are many Action movies for example).
The following data must be stored at minimum:
•	Title of the movie (plan with storing non-English characters too)
•	Length (or running time) of the movie in minutes
•	Release date of the movie
•	Language of the movie
•	The name of the genre (eg: Sci-fi, Action, Horror etc.)
Create the relevant tables with the required data columns and the appropriate data types.
Create the following constraints at minimum:
•	PRIMARY KEY
•	FOREIGN KEY
Specify additional constraints if necessary.
Script out the tables.

*/
DROP DATABASE IF EXISTS MoviesDB;
GO
CREATE DATABASE MoviesDB;

USE MoviesDB;

DROP TABLE IF EXISTS movies
    CREATE TABLE movies(
        mId int NOT NULL
		CONSTRAINT PK_movie_id PRIMARY KEY (mId),
        title nvarchar(50) NOT NULL,
        LengthInMinutes smallint NOT NULL,
		releaseDate date NOT NULL,
		mLanguage nvarchar(50) NOT NULL
    );

DROP TABLE IF EXISTS genres
    CREATE TABLE genres(
        gId int NOT NULL
		CONSTRAINT PK_genre_id PRIMARY KEY (gId),
        mId int NOT NULL
			CONSTRAINT FK_movie_id 
			FOREIGN KEY (mId) 
			REFERENCES movies (mId),		
        genre nvarchar(50) NOT NULL   
    );