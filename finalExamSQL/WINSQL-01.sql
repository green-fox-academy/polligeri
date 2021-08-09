-- create table: [Recipes] 

CREATE TABLE [Recipes](
		[id] int IDENTITY(1,1) NOT NULL
		CONSTRAINT [PK_recipes_id] PRIMARY KEY ([id]),
        [recipeName] nvarchar(100) NOT NULL,
		[note] text,
		[DifficultyLevels] varchar(26)
		CONSTRAINT [DF_recipes_difficulty] DEFAULT ('Easy, Intermediate or Hard'),
		[timeToMakeInMinutes] int,
		[kcalPerPortion] float,
		[uploadDate] datetime
        );
-- create table: [Ingredients] 

   CREATE TABLE [Ingredients](
		[id] int IDENTITY(1,1) NOT NULL
		CONSTRAINT [PK_ingredient_id] PRIMARY KEY ([id]),
        [ingredientName] nvarchar(100) NOT NULL,
		[detailedDescription] ntext  
		);

-- create junction table [IngredientsForRecipes] (Many to Many)

CREATE TABLE [IngredientsForRecipes] (
		[id] int IDENTITY(1,1) NOT NULL
		CONSTRAINT [PK_recipe_id] PRIMARY KEY ([id]),
		[recipe_id] int  NOT NULL
		CONSTRAINT [FK_recipes_id] FOREIGN KEY ([recipe_id])
		REFERENCES [Recipes] ([id])
        ON DELETE CASCADE
        ON UPDATE CASCADE,
		[ingredient_id] int  NOT NULL
		CONSTRAINT [FK_ingredients_id] FOREIGN KEY ([ingredient_id])
		REFERENCES [Ingredients]([id])
        ON DELETE CASCADE
        ON UPDATE CASCADE,
		);




