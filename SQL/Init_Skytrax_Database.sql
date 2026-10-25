-- 1. TẠO DATABASE
IF DB_ID('skytrax') IS NULL
BEGIN
    CREATE DATABASE skytrax;
END
GO

USE skytrax;
GO

-- 2. BẢNG DANH MỤC (tạo trước vì được FK tham chiếu)

CREATE TABLE [dbo].[airlines](
    [airline_id]   [int] NOT NULL,
    [airline_name] [nvarchar](100) NOT NULL,
    CONSTRAINT [PK_airlines] PRIMARY KEY CLUSTERED ([airline_id] ASC)
);
GO

CREATE TABLE [dbo].[airports](
    [airport_id]   [int] NOT NULL,
    [airport_name] [nvarchar](150) NOT NULL,
    CONSTRAINT [PK_airports] PRIMARY KEY CLUSTERED ([airport_id] ASC)
);
GO

-- 3. BẢNG REVIEW

CREATE TABLE [dbo].[airline_reviews](
    [review_id]              [int] NOT NULL,
    [airline_id]             [int] NOT NULL,
    [verify]                 [bit] NOT NULL,
    [date_submitted]         [date] NULL,
    [date_flown]             [date] NULL,
    [customer_name]          [nvarchar](100) NULL,
    [nationality]            [nvarchar](100) NULL,
    [type_of_traveller]      [nvarchar](30) NULL,
    [seat_type]              [nvarchar](30) NULL,
    [aircraft]               [nvarchar](100) NULL,
    [origin_city]            [nvarchar](100) NULL,
    [origin_airport]         [nvarchar](10) NULL,
    [destination_city]       [nvarchar](100) NULL,
    [destination_airport]    [nvarchar](10) NULL,
    [transit_city]           [nvarchar](100) NULL,
    [transit_airport]        [nvarchar](10) NULL,
    [seat_comfort]           [tinyint] NULL,
    [cabin_staff_service]    [tinyint] NULL,
    [food_and_beverages]     [tinyint] NULL,
    [inflight_entertainment] [tinyint] NULL,
    [ground_service]         [tinyint] NULL,
    [wifi_and_connectivity]  [tinyint] NULL,
    [value_for_money]        [tinyint] NULL,
    [recommended]            [bit] NOT NULL,
    [review]                 [nvarchar](max) NULL,
    CONSTRAINT [PK_airline_reviews] PRIMARY KEY CLUSTERED ([review_id] ASC),
    CONSTRAINT [FK_airline_reviews_airlines] FOREIGN KEY ([airline_id])
        REFERENCES [dbo].[airlines]([airline_id])
);
GO

CREATE TABLE [dbo].[airport_reviews](
    [review_id]              [int] NOT NULL,
    [airport_id]             [int] NOT NULL,
    [verify]                 [bit] NOT NULL,
    [date_submitted]         [date] NULL,
    [date_visit]             [date] NULL,
    [customer_name]          [nvarchar](100) NULL,
    [nationality]            [nvarchar](100) NULL,
    [experience_at_airport]  [nvarchar](40) NULL,
    [type_of_traveller]      [nvarchar](30) NULL,
    [queuing_times]          [tinyint] NULL,
    [terminal_cleanliness]   [tinyint] NULL,
    [terminal_seating]       [tinyint] NULL,
    [terminal_signs]         [tinyint] NULL,
    [food_beverages]         [tinyint] NULL,
    [airport_shopping]       [tinyint] NULL,
    [airport_staff]          [tinyint] NULL,
    [wifi_connectivity]      [tinyint] NULL,
    [recommended]            [bit] NOT NULL,
    [review]                 [nvarchar](max) NULL,
    CONSTRAINT [PK_airport_reviews] PRIMARY KEY CLUSTERED ([review_id] ASC),
    CONSTRAINT [FK_airport_reviews_airports] FOREIGN KEY ([airport_id])
        REFERENCES [dbo].[airports]([airport_id])
);
GO

CREATE TABLE [dbo].[lounge_reviews](
    [review_id]          [int] NOT NULL,
    [airline_id]         [int] NOT NULL,
    [lounge_name]        [nvarchar](150) NULL,
    [airport]            [nvarchar](150) NULL,  -- free text, KHÔNG FK tới bảng airports
    [type_of_lounge]     [nvarchar](40) NULL,
    [type_of_traveller]  [nvarchar](30) NULL,
    [verify]             [bit] NOT NULL,
    [date_submitted]     [date] NULL,
    [date_visit]         [date] NULL,
    [customer_name]      [nvarchar](100) NULL,
    [nationality]        [nvarchar](100) NULL,
    [comfort]            [tinyint] NULL,
    [cleanliness]        [tinyint] NULL,
    [bar_and_beverages]  [tinyint] NULL,
    [catering]           [tinyint] NULL,
    [washrooms]          [tinyint] NULL,
    [wifi_connectivity]  [tinyint] NULL,
    [staff_service]      [tinyint] NULL,
    [recommended]        [bit] NOT NULL,
    [review]             [nvarchar](max) NULL,
    CONSTRAINT [PK_lounge_reviews] PRIMARY KEY CLUSTERED ([review_id] ASC),
    CONSTRAINT [FK_lounge_reviews_airlines] FOREIGN KEY ([airline_id])
        REFERENCES [dbo].[airlines]([airline_id])
);
GO

CREATE TABLE [dbo].[seat_reviews](
    [review_id]          [int] NOT NULL,
    [airline_id]         [int] NOT NULL,
    [type_of_traveller]  [nvarchar](30) NULL,
    [seat_type]          [nvarchar](30) NULL,
    [aircraft_type]      [nvarchar](100) NULL,
    [seat_layout]        [nvarchar](20) NULL,
    [verify]             [bit] NOT NULL,
    [date_submitted]     [date] NULL,
    [date_flown]         [date] NULL,
    [customer_name]      [nvarchar](100) NULL,
    [nationality]        [nvarchar](100) NULL,
    [seat_legroom]       [tinyint] NULL,
    [seat_recline]       [tinyint] NULL,
    [seat_width]         [tinyint] NULL,
    [aisle_space]        [tinyint] NULL,
    [seat_storage]       [tinyint] NULL,
    [power_supply]       [tinyint] NULL,
    [viewing_tv_screen]  [tinyint] NULL,
    [sleep_comfort]      [tinyint] NULL,
    [sitting_comfort]    [tinyint] NULL,
    [seat_bed_width]     [tinyint] NULL,
    [seat_bed_length]    [tinyint] NULL,
    [seat_privacy]       [tinyint] NULL,
    [recommended]        [bit] NOT NULL,
    [review]             [nvarchar](max) NULL,
    CONSTRAINT [PK_seat_reviews] PRIMARY KEY CLUSTERED ([review_id] ASC),
    CONSTRAINT [FK_seat_reviews_airlines] FOREIGN KEY ([airline_id])
        REFERENCES [dbo].[airlines]([airline_id])
);
GO