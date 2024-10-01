CREATE TABLE StoreReviewers (
    reviewer_id INT PRIMARY KEY,
    nr_stores_reviewed INT UNIQUE,
    reviewer_name VARCHAR(50)
);

CREATE TABLE StoreRating (
    store_rating_id INT PRIMARY KEY,
    rating INT,
    store_location VARCHAR(50)
);

CREATE TABLE StoreReviewerRating (
    srr_id INT PRIMARY KEY,
    FK_reviewer_id INT REFERENCES StoreReviewers(reviewer_id) ON DELETE CASCADE,
    FK_store_rating_id INT REFERENCES StoreRating(store_rating_id) ON DELETE CASCADE
);




GO
CREATE OR ALTER PROCEDURE insertIntoRev (@rows INT) AS
BEGIN
	DECLARE @rev_id INT = 1;
	DECLARE @nr INT = 1;
	DECLARE @name VARCHAR(50) = 'Anonymous reviewer';

	WHILE @rows > 0
	BEGIN
		INSERT INTO StoreReviewers(reviewer_id, nr_stores_reviewed, reviewer_name)
		VALUES (@rev_id, @nr, @name);

		SET @rev_id = @rev_id + 1;
		SET @nr = @nr + 1;
		SET @rows = @rows - 1;
	END
	
END
GO

CREATE OR ALTER PROCEDURE insertIntoRat (@rows INT) AS
BEGIN
	DECLARE @rat_id INT = 1;
	DECLARE @rat INT = 1;
	DECLARE @loc VARCHAR(50) = 'Earth';

	WHILE @rows > 0
	BEGIN
		INSERT INTO StoreRating(store_rating_id, rating, store_location)
		VALUES (@rat_id, @rat % 5, @loc);

		SET @rat_id = @rat_id + 1;
		SET @rat = @rat + 1;
		SET @rows = @rows - 1;
	END
	
END
GO

CREATE OR ALTER PROCEDURE insertIntoSRR (@rows INT) AS
BEGIN
	DECLARE @srr INT = 1;
	DECLARE @rev INT = 1;
	DECLARE @rat INT = 1;

	WHILE @rows > 0
	BEGIN
		INSERT INTO StoreReviewerRating(srr_id, FK_reviewer_id, FK_store_rating_id)
		VALUES (@srr, @rev, @rat);

		SET @srr = @srr + 1;
		SET @rev = @rev + 1;
		SET @rat = @rat + 1;
		SET @rows = @rows - 1;
	END

END
GO

DELETE FROM StoreReviewers;
DELETE FROM StoreRating;
DELETE FROM StoreReviewerRating;

EXEC insertIntoRat 1000;
EXEC insertIntoRev 1000;
EXEC insertIntoSRR 1000;

SELECT * FROM StoreRating
SELECT * FROM StoreReviewers
SELECT * FROM StoreReviewerRating

EXEC sp_helpindex StoreReviewers;
SELECT * FROM StoreReviewers

EXEC sp_helpindex StoreReviewers;
SELECT * FROM StoreReviewers
WHERE reviewer_id < 44;

