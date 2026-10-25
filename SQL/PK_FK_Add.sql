-- ===== PRIMARY KEY =====
ALTER TABLE dbo.airlines ADD CONSTRAINT PK_airlines PRIMARY KEY (airline_id);
ALTER TABLE dbo.airports ADD CONSTRAINT PK_airports PRIMARY KEY (airport_id);
ALTER TABLE dbo.airline_reviews ADD CONSTRAINT PK_airline_reviews PRIMARY KEY (review_id);
ALTER TABLE dbo.airport_reviews ADD CONSTRAINT PK_airport_reviews PRIMARY KEY (review_id);
ALTER TABLE dbo.lounge_reviews ADD CONSTRAINT PK_lounge_reviews PRIMARY KEY (review_id);
ALTER TABLE dbo.seat_reviews ADD CONSTRAINT PK_seat_reviews PRIMARY KEY (review_id);
GO

-- ===== FOREIGN KEY =====
ALTER TABLE dbo.airline_reviews ADD CONSTRAINT FK_airline_reviews_airlines
    FOREIGN KEY (airline_id) REFERENCES dbo.airlines(airline_id);

ALTER TABLE dbo.airport_reviews ADD CONSTRAINT FK_airport_reviews_airports
    FOREIGN KEY (airport_id) REFERENCES dbo.airports(airport_id);

ALTER TABLE dbo.lounge_reviews ADD CONSTRAINT FK_lounge_reviews_airlines
    FOREIGN KEY (airline_id) REFERENCES dbo.airlines(airline_id);

ALTER TABLE dbo.seat_reviews ADD CONSTRAINT FK_seat_reviews_airlines
    FOREIGN KEY (airline_id) REFERENCES dbo.airlines(airline_id);
GO