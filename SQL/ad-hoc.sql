-- 1. Tổng số lượt đánh giá chuyến bay
-- Em ơi, anh cần một con số để mở đầu slide tổng quan cho khách: toàn bộ kho dữ liệu đang có bao nhiêu lượt đánh giá chuyến bay của hành khách? Một con số duy nhất thôi.
SELECT COUNT(*) AS airline_reviews_count
FROM [skytrax].[dbo].[airline_reviews];

-- 2. Số hãng bay được hành khách nhắc tới
-- Chị đang chốt phạm vi báo cáo. Em đếm nhanh giúp chị có bao nhiêu hãng bay khác nhau từng xuất hiện trong các đánh giá chuyến bay? Chị chỉ cần một con số.
SELECT COUNT(DISTINCT airline_id) AS airlines_count
FROM [skytrax].[dbo].[airline_reviews];

-- 3. Tỷ lệ hành khách sẵn sàng giới thiệu
-- Anh cần chỉ số 'thiện cảm' cho slide đầu tiên: trong tất cả đánh giá chuyến bay, bao nhiêu phần trăm hành khách nói rằng họ sẽ giới thiệu hãng cho người khác? Một con số phần trăm.
SELECT
	SUM(CASE WHEN recommended = 1 then 1 ELSE 0 END) AS total_recommended_reviews,
	COUNT(*) AS total_reviews,
	CAST(SUM(CASE WHEN recommended = 1 then 1 ELSE 0 END) * 100.0 / COUNT(*) AS DECIMAL(5,2)) AS recommended_pct
FROM [skytrax].[dbo].[airline_reviews] ar;

-- 4. Top 10 quốc tịch để lại nhiều đánh giá nhất
-- Em ơi, team muốn biết tiếng nói đang đến từ thị trường nào. Cho anh 10 quốc tịch để lại nhiều đánh giá chuyến bay nhất, kèm số lượt của mỗi quốc tịch, xếp từ nhiều xuống ít.
SELECT TOP 10
	nationality,
	COUNT(*) AS total_reviews_by_nationality
FROM [skytrax].[dbo].[airline_reviews] ar
GROUP BY nationality
ORDER BY COUNT(*) DESC;
 
-- 5. Điểm hài lòng ghế ngồi trung bình
-- Chị cần một con số benchmark cho khâu ghế ngồi: điểm trung bình mà hành khách chấm cho mức độ thoải mái của ghế trên toàn bộ đánh giá chuyến bay là bao nhiêu? Một con số là đủ.
SELECT 
    CAST(AVG(CAST(seat_comfort AS FLOAT)) AS DECIMAL(5,2)) AS avg_seat_comfort_score
FROM [skytrax].[dbo].[airline_reviews];

-- 6. Top 10 hãng đáng đồng tiền nhất
-- Anh chuẩn bị slide so sánh cạnh tranh. Cho anh 10 hãng được hành khách đánh giá đáng đồng tiền nhất (tính theo điểm trung bình ở tiêu chí mức đáng đồng tiền). Để công bằng, chỉ tính những hãng có ít nhất 100 lượt đánh giá. Gửi anh tên hãng + điểm trung bình.
SELECT TOP 10
	a.airline_name,
	CAST(AVG(CAST(ar.value_for_money AS FLOAT)) AS DECIMAL(5,2)) AS avg_value_for_money_per_airline
FROM [skytrax].[dbo].[airline_reviews] ar
INNER JOIN [skytrax].[dbo].[airlines] a ON ar.airline_id = a.airline_id
GROUP BY a.airline_id, a.airline_name
HAVING COUNT(ar.value_for_money) >= 100
ORDER BY AVG(CAST(ar.value_for_money AS FLOAT)) DESC;

-- 7. So sánh thiện cảm theo nhóm hành khách
-- Chị nghi khách công vụ và khách du lịch cảm nhận rất khác nhau. Em giúp chị: với mỗi nhóm hành khách, tỷ lệ sẵn sàng giới thiệu là bao nhiêu? Output mỗi dòng một nhóm khách, kèm số lượt đánh giá và tỷ lệ phần trăm.
SELECT
	type_of_traveller,
	COUNT(*) AS total_reviews_per_type,
	CAST(CAST(SUM(CASE WHEN recommended = 1 THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) * 100 AS DECIMAL(5,2)) AS recommended_rate_per_type
FROM [skytrax].[dbo].[airline_reviews]
WHERE type_of_traveller IS NOT NULL AND type_of_traveller <> 'NULL'
GROUP BY type_of_traveller
ORDER BY recommended_rate_per_type;
 
-- 8. Top 10 sân bay bị chê xếp hàng lâu
-- Anh đang làm việc với mấy cụm cảng. Cho anh 10 sân bay bị hành khách chấm tệ nhất ở khâu thời gian xếp hàng (điểm trung bình thấp nhất), chỉ xét sân bay có từ 50 lượt đánh giá trở lên. Gửi anh tên sân bay + điểm trung bình + số lượt.
SELECT TOP 10
	a.airport_name,
	CAST(AVG(CAST(ar.queuing_times AS FLOAT)) AS DECIMAL(5,2)) AS avg_queuing_times_per_airport,
	COUNT(ar.queuing_times) AS total_reviews_per_airport
FROM [skytrax].[dbo].[airport_reviews] ar
INNER JOIN [skytrax].[dbo].[airports] a ON ar.airport_id = a.airport_id
WHERE ar.queuing_times IS NOT NULL
GROUP BY a.airport_id, a.airport_name
HAVING COUNT(*) >= 50
ORDER BY AVG(CAST(ar.queuing_times AS FLOAT)) ASC;

-- 9. Điểm phục vụ tiếp viên theo hạng ghế
-- Chị muốn biết cảm nhận về tiếp viên có khác nhau giữa các khoang không. Em tính giúp chị điểm trung bình hành khách chấm cho phục vụ của tiếp viên, tách theo từng hạng ghế (phổ thông, phổ thông đặc biệt, thương gia, hạng nhất). Mỗi dòng một hạng ghế.
SELECT
	seat_type,
	COUNT(cabin_staff_service) AS total_rated_reviews,
	CAST(AVG(CAST(cabin_staff_service AS FLOAT)) AS DECIMAL(5,2)) AS avg_cabin_staff_service
FROM [skytrax].[dbo].[airline_reviews]
WHERE seat_type IS NOT NULL AND seat_type <> 'NULL'
GROUP BY seat_type
ORDER BY avg_cabin_staff_service DESC;

-- 10. Số lượt đánh giá theo từng năm
-- Anh cần thấy lượng tiếng nói thay đổi ra sao theo thời gian. Cho anh số lượt đánh giá chuyến bay theo từng năm gửi đánh giá, xếp theo trình tự thời gian, để anh vẽ biểu đồ cột.
SELECT
	YEAR(date_submitted) AS review_year,
	COUNT(*) AS total_reviews_per_years
FROM [skytrax].[dbo].[airline_reviews]
WHERE date_submitted IS NOT NULL
GROUP BY YEAR(date_submitted)
ORDER BY review_year;

-- 11. Xếp hạng hãng theo điểm từng năm
-- Em làm cho anh một bảng động: trong mỗi năm, xếp hạng các hãng theo điểm đáng đồng tiền trung bình của năm đó, và chỉ giữ lại 5 hãng đứng đầu mỗi năm. Chỉ tính hãng có ít nhất 50 lượt trong năm. Output: năm, tên hãng, điểm trung bình, thứ hạng trong năm.
WITH agg AS (
    SELECT
        YEAR(ar.date_submitted) AS review_year,
        a.airline_name,
        AVG(CAST(ar.value_for_money AS FLOAT)) AS avg_value_for_money
    FROM [skytrax].[dbo].[airline_reviews] ar
    INNER JOIN [skytrax].[dbo].[airlines] a ON ar.airline_id = a.airline_id
    WHERE ar.date_submitted IS NOT NULL
    GROUP BY YEAR(ar.date_submitted), a.airline_id, a.airline_name
    HAVING COUNT(ar.value_for_money) >= 50
),
ranked AS (
	SELECT
		review_year,
		airline_name,
		avg_value_for_money,
		RANK() OVER (PARTITION BY review_year ORDER BY avg_value_for_money DESC) AS avg_value_for_money_rank
	FROM agg
)
SELECT
	review_year,
	airline_name,
	CAST(avg_value_for_money AS DECIMAL(5,2)) AS avg_value_for_money,
	avg_value_for_money_rank
FROM ranked
WHERE avg_value_for_money_rank <= 5
ORDER BY review_year, avg_value_for_money_rank;
 
-- 12. Xu hướng hài lòng theo năm và mức thay đổi
-- Chị cần biết trải nghiệm chung đang lên hay xuống. Với mỗi năm, tính điểm hài lòng ghế ngồi trung bình của năm đó và mức chênh lệch so với năm liền trước. Sắp xếp theo thời gian để chị thấy năm nào cải thiện, năm nào tụt.
WITH tmp AS (
	SELECT
		YEAR(date_submitted) AS review_year,
		AVG(CAST(seat_comfort AS FLOAT)) AS avg_seat_comfort_score
	FROM [skytrax].[dbo].[airline_reviews]
	WHERE date_submitted IS NOT NULL
	GROUP BY YEAR(date_submitted)
)
SELECT
	review_year,
	CAST(avg_seat_comfort_score AS DECIMAL(5,2)) AS avg_seat_comfort_score,
	CAST(LAG(avg_seat_comfort_score) OVER (ORDER BY review_year) AS DECIMAL(5,2)) AS pre_avg_seat_comfort_score,
	CAST(avg_seat_comfort_score - LAG(avg_seat_comfort_score) OVER (ORDER BY review_year) AS DECIMAL(5,2)) AS change_vs_last_year
FROM tmp
ORDER BY review_year;

-- 13. Phân nhóm hãng theo mức đáng đồng tiền
-- Anh muốn chia thị trường thành các tầng để định vị. Chia toàn bộ các hãng (có từ 100 lượt đánh giá) thành 4 nhóm bằng nhau theo điểm đáng đồng tiền trung bình: nhóm dẫn đầu, khá, trung bình, đuối. Với mỗi nhóm cho anh số hãng và điểm trung bình của nhóm.
WITH tmp AS (
	SELECT
		a.airline_id,
		AVG(CAST(ar.value_for_money AS FLOAT)) AS avg_value_for_money_per_airline
	FROM [skytrax].[dbo].[airline_reviews] ar
	INNER JOIN [skytrax].[dbo].[airlines] a ON ar.airline_id = a.airline_id
	GROUP BY a.airline_id
	HAVING COUNT(ar.value_for_money) >= 100
),
grouped AS (
	SELECT
		avg_value_for_money_per_airline,
		NTILE(4) OVER (ORDER BY avg_value_for_money_per_airline DESC) AS quartile
	FROM tmp
)
SELECT
	CASE quartile
		WHEN 1 THEN N'Dẫn đầu'
		WHEN 2 THEN N'Khá'
		WHEN 3 THEN N'Trung bình'
		ELSE N'Đuối'
	END AS value_for_money_group,
	COUNT(*) AS total_airlines,
	CAST(AVG(avg_value_for_money_per_airline) AS DECIMAL(5,2)) AS avg_value_for_money_per_group
FROM grouped
GROUP BY quartile
ORDER BY quartile;

-- 14. Chặng bay bị phàn nàn nhiều nhất
-- Em giúp anh soi chặng bay: 20 chặng (điểm đi → điểm đến) có tỷ lệ hành khách giới thiệu thấp nhất, chỉ xét chặng có ít nhất 30 lượt đánh giá. Output: điểm đi, điểm đến, số lượt, tỷ lệ giới thiệu. Anh cần để cảnh báo các hãng về chặng có vấn đề.
SELECT TOP 20
	origin_airport,
	destination_airport,
	COUNT(*) AS total_reviews_per_flight_segment,
	CAST(SUM( CASE WHEN recommended = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) * 100 AS DECIMAL(5,2)) AS recommended_rate_pct
FROM [skytrax].[dbo].[airline_reviews]
WHERE origin_airport IS NOT NULL AND origin_airport <> 'NULL'
	AND destination_airport IS NOT NULL AND destination_airport <> 'NULL'
GROUP BY origin_airport, destination_airport
HAVING COUNT(*) >= 30
ORDER BY recommended_rate_pct ASC, total_reviews_per_flight_segment DESC;
 
-- 15. Hãng mạnh cả phòng chờ lẫn ghế ngồi
-- Chị tìm những hãng đầu tư trải nghiệm cao cấp toàn diện. Cho chị những hãng vừa có điểm phòng chờ trung bình cao, vừa có điểm ghế ngồi trung bình cao — mỗi mặt đều dựa trên đủ số lượt để đáng tin (ít nhất 10 lượt mỗi loại). Output: tên hãng, điểm phòng chờ trung bình, điểm ghế trung bình, xếp theo tổng thể tốt nhất.
WITH lounge_agg AS (
    SELECT
        airline_id,
        CAST(AVG(CAST(comfort AS FLOAT)) AS DECIMAL(5,2)) AS avg_lounge_comfort,
        COUNT(comfort) AS lounge_review_count
    FROM [skytrax].[dbo].[lounge_reviews]
    WHERE comfort IS NOT NULL
    GROUP BY airline_id
    HAVING COUNT(comfort) >= 10
),
seat_agg AS (
    SELECT
        airline_id,
        CAST(AVG(CAST(seat_comfort AS FLOAT)) AS DECIMAL(5,2)) AS avg_seat_comfort,
        COUNT(seat_comfort) AS seat_review_count
    FROM [skytrax].[dbo].[airline_reviews]
    WHERE seat_comfort IS NOT NULL
    GROUP BY airline_id
    HAVING COUNT(seat_comfort) >= 10
)
SELECT
    a.airline_name,
    l.avg_lounge_comfort,
    s.avg_seat_comfort,
    CAST((l.avg_lounge_comfort + s.avg_seat_comfort) AS DECIMAL(5,2)) AS overall_score
FROM lounge_agg l
INNER JOIN seat_agg s ON l.airline_id = s.airline_id
INNER JOIN [skytrax].[dbo].[airlines] a ON a.airline_id = l.airline_id
-- "cao" = cao hơn điểm trung bình toàn bộ review của từng mặt
WHERE l.avg_lounge_comfort > (SELECT AVG(CAST(comfort AS FLOAT)) FROM [skytrax].[dbo].[lounge_reviews])
	AND s.avg_seat_comfort > (SELECT AVG(CAST(seat_comfort AS FLOAT)) FROM [skytrax].[dbo].[airline_reviews])
ORDER BY overall_score DESC;