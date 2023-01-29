CREATE DATABASE kinopoisk_hd CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE kinopoisk_hd;

-- страны
CREATE TABLE countries (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(250) NOT NULL UNIQUE
);

-- языки
CREATE TABLE languages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(250) NOT NULL UNIQUE
);

-- возрастные рейтинги
CREATE TABLE age_ratings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(3) NOT NULL UNIQUE
);

-- каналы
CREATE TABLE channels (
	id INT AUTO_INCREMENT PRIMARY KEY,
	title VARCHAR(250) NOT NULL UNIQUE
);

-- фильмы и сериалы
CREATE TABLE films (
	id INT AUTO_INCREMENT PRIMARY KEY,
	title VARCHAR(500) NOT NULL,
	original_title VARCHAR(500) NOT NULL,
	short_description TEXT NOT NULL,
    description TEXT NOT NULL,
    release_date DATE NOT NULL,
	rating DOUBLE,
	rating_count INT NOT NULL DEFAULT 0,
	is_4k BOOL NOT NULL,
	duration INT NOT NULL,
    country_id INT,
	age_rating_id INT,
	channel_id INT,
	INDEX (title),
	FOREIGN KEY (country_id) REFERENCES countries(id),
	FOREIGN KEY (age_rating_id) REFERENCES age_ratings(id),
    FOREIGN KEY (channel_id) REFERENCES channels(id)
);

-- жанры
CREATE TABLE genres (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(250) NOT NULL UNIQUE
);

-- люди
CREATE TABLE persons (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(250) NOT NULL,
	original_name VARCHAR(250),
	birthday DATE,
	height DOUBLE
);

-- должности
CREATE TABLE posts (
	id INT AUTO_INCREMENT PRIMARY KEY,
	title VARCHAR(250) NOT NULL
);

-- перечень жанров для каждого фильма
CREATE TABLE film_genres (
	id INT AUTO_INCREMENT PRIMARY KEY,
	film_id INT,
	genre_id INT,
	UNIQUE(film_id, genre_id),
	FOREIGN KEY (film_id) REFERENCES films(id),
	FOREIGN KEY (genre_id) REFERENCES genres(id)
);

-- аудиодорожки
CREATE TABLE film_languages (
	id INT AUTO_INCREMENT PRIMARY KEY,
	film_id INT,
	language_id INT,
	UNIQUE(film_id, language_id),
	FOREIGN KEY (film_id) REFERENCES films(id),
	FOREIGN KEY (language_id) REFERENCES languages(id)
);

-- съёмочная команда
CREATE TABLE film_crew (
	id INT AUTO_INCREMENT PRIMARY KEY,
	film_id INT,
	person_id INT,
	post_id INT,
	UNIQUE(film_id, person_id, post_id),
	FOREIGN KEY (film_id) REFERENCES films(id),
	FOREIGN KEY (person_id) REFERENCES persons(id),
	FOREIGN KEY (post_id) REFERENCES posts(id)
);

-- серии
CREATE TABLE episodes (
	id INT AUTO_INCREMENT PRIMARY KEY,
	season_number INT NOT NULL DEFAULT 1,
	episode_number INT NOT NULL DEFAULT 1,
	title VARCHAR(500),
	description TEXT,
	duration INT NOT NULL,
	film_id INT,
	FOREIGN KEY (film_id) REFERENCES films(id)
);

-- история удалённых фильмов
CREATE TABLE deleted_films (
	id INT AUTO_INCREMENT PRIMARY KEY,
	film_id INT NOT NULL,
	title VARCHAR(500) NOT NULL,
	delete_date TIMESTAMP NOT NULL
);

-- данные справочников
INSERT INTO countries(name) VALUES('США'), ('Дания');
INSERT INTO languages(title) VALUES ('Русский'), ('Русский 5.1'), ('Английский'), ('Английский 5.1');
INSERT INTO age_ratings(title) VALUES ('0+'), ('12+'), ('16+'), ('18+');
INSERT INTO channels(title) VALUES ('Нет'), ('Viju'), ('HBO'), ('more.tv');
INSERT INTO genres(title) VALUES ('боевик'), ('драма'), ('фантастика'), ('триллер'), ('криминал');
INSERT INTO posts(title) VALUES ('В главных ролях'), ('Режиссёр');

-- данные актёров и режиссёров
INSERT INTO persons(name, original_name, birthday, height) VALUES
('Николай Костер-Вальдау', 'Nikolaj Coster-Waldau', '1970-07-27', 1.88),
('Омари Хардвик', 'Omari Hardwick', '1974-01-09', 1.78),
('Лейк Белл', 'Lake Bell', '1979-03-24', 1.73),
('Джон Бернтал', 'Jon Bernthal', '1976-09-20', 1.8),
('Рик Роман Во', 'Ric Roman Waugh', '1968-02-20', NULL),

('Том Круз', 'Tom Cruise', '1962-07-03', 1.7),
('Ольга Куриленко', NULL, '1979-11-14', 1.75),
('Андреа Райзборо', 'Andrea Riseborough', '1981-11-20', 1.66),
('Морган Фриман', 'Morgan Freeman', '1937-06-01', 1.88),
('Джозеф Косински', 'Joseph Kosinski', '1974-05-03', 1.93),

('Майлз Теллер', 'Miles Teller', '1987-02-20', 1.85),
('Дженнифер Коннелли', 'Jennifer Connelly', '1970-12-12', 1.69),
('Джон Хэмм', 'Jon Hamm', '1971-03-10', 1.86),
('Николас Виндинг Рефн', 'Nicolas Winding Refn', '1970-09-29', 1.89);

INSERT INTO persons(name, original_name) VALUES
('Анжела Бундалович', 'Angela Bundalovic'),
('Андреас Люкке Йоргенсен', 'Andreas Lykke Jørgensen'),
('Ли И Чжан', 'Li Ii Zhang'),
('Jason Hendil-Forssell', NULL);

-- информация о фильмах
INSERT INTO films(title, original_title, short_description, description, release_date, rating, rating_count, is_4k, duration, country_id, age_rating_id, channel_id) VALUES
('Выстрел в пустоту', 'Shot Caller', 'Угодившему в тюрьму брокеру приходится жить по новым правилам. Сильная драма с Николаем Костером-Вальдау',
'Роковая случайность, смертельная трагедия, и вся его жизнь летит под откос… Оказавшись за решеткой, он должен научиться жить по новым законам. Ты должен стать борцом, авторитетом или окажешься жертвой. Какую цену придется заплатить, чтобы выжить в этом аду, из которого нет дороги назад?',
'2017-06-17', 7.5, 212925, TRUE, 120, 1, 4, 1),

('Обливион', 'Oblivion', 'Двое несут вахту на опустошенной Земле после войны с инопланетянами. Том Круз в фантастике об упрямой памяти',
'Земля, пережившая войну с инопланетными захватчиками, опустела; остатки человечества готовятся покинуть непригодную для жизни планету. Главный герой — техник по обслуживанию дронов — находит разбившийся корабль NASA, команда которого погибает у него на глазах. Ему удаётся спасти лишь одну женщину — и вскоре он понимает, что это перевернёт его жизнь.',
'2013-03-26', 7.2, 367069, TRUE, 125, 1, 3, 2),

('Топ Ган: Мэверик', 'Top Gun: Maverick', 'Американский боевик Джозефа Косински с Томом Крузом в главной роли, являющийся продолжением фильма 1986 года «Лучший стрелок»',
'Пит Митчелл по прозвищу Мэверик более 30 лет остается одним из лучших пилотов ВМФ: бесстрашный летчик-испытатель, он расширяет границы возможного и старательно избегает повышения в звании, которое заставило бы его приземлиться навсегда. Приступив к подготовке отряда выпускников «Топ Ган» для специальной миссии, Мэверик встречает лейтенанта Брэдли Брэдшоу — сына своего покойного друга, лейтенанта Ника Брэдшоу.',
'2022-05-18', 7.8, 80800, TRUE, 130, 1, 3, 1),

('Ковбой из Копенгагена', 'Copenhagen Cowboy', 'Сериал датского режиссёра Николаса Виндинга Рефна, премьера которого состоялась в сентябре 2022 года на 79-м Венецианском кинофестивале',
'Загадочная девушка Миу много лет провела в неволе. Она хочет отомстить своему заклятому врагу и для этого знакомится с преступным миром Копенгагена.',
'2022-09-09', 7.8, 80800, TRUE, 360, 2, 4, 1);

INSERT INTO film_genres(film_id, genre_id) VALUES
(1, 4),
(1, 2),

(2, 1),
(2, 3),

(3, 1),
(3, 2),

(4, 2),
(4, 5);

INSERT INTO film_languages(film_id, language_id) VALUES
(1, 1),
(1, 2),

(2, 1),
(2, 2),
(2, 3),
(2, 4),

(3, 3),
(3, 4),

(4, 3),
(4, 4);

INSERT INTO film_crew(film_id, person_id, post_id) VALUES
(1, 1, 1),
(1, 2, 1),
(1, 3, 1),
(1, 4, 1),
(1, 5, 2),

(2, 6, 1),
(2, 7, 1),
(2, 8, 1),
(2, 9, 1),
(2, 10, 2),

(3, 6, 1),
(3, 11, 1),
(3, 12, 1),
(3, 13, 1),
(3, 10, 2),

(4, 15, 1),
(4, 16, 1),
(4, 17, 1),
(4, 18, 1),
(4, 14, 2);

-- описание серий
INSERT INTO episodes(film_id, season_number, episode_number, title, description, duration) VALUES
(4, 1, 1, 'Миу Таинственная', 'Начало', 60),
(4, 1, 2, 'Месть - мое имя', 'Продолжение', 60),
(4, 1, 3, 'Дворец Дракона', 'Продолжение', 60),
(4, 1, 4, 'От мистера Чанга с любовью', 'Продолжение', 60),
(4, 1, 5, 'Копенгаген', 'Продолжение', 60),
(4, 1, 6, 'Небеса упадут', 'Конец', 60);

-- запрос фильмов с режиссёрами
SELECT
	film_crew.film_id,
	films.title,
	films.release_date,
	films.rating,
	persons.*
FROM
	films LEFT JOIN film_crew
		ON film_crew.film_id = films.id
	INNER JOIN persons
		ON film_crew.person_id = persons.id
WHERE
	film_crew.post_id = 2
ORDER BY
	persons.name;

-- выбрать только сериалы
SELECT
	films.id,
	films.title,
	films.short_description,
	films.release_date,
	films.rating,
	films.rating_count,
	films.is_4k,
	countries.name,
	age_ratings.title age_rating,
	channels.title channel,
	counts.episode_count
FROM
	films,
	countries,
	age_ratings,
	channels,
	(SELECT film_id, COUNT(*) episode_count FROM episodes GROUP BY film_id) counts
WHERE
	films.country_id = countries.id
	AND films.age_rating_id = age_ratings.id
	AND films.channel_id = channels.id
	AND films.id = counts.film_id
	AND counts.episode_count > 1
ORDER BY
	films.title;

-- представления
CREATE VIEW film_directors AS
SELECT
	film_crew.film_id,
	films.title,
	films.release_date,
	films.rating,
	persons.*
FROM
	films LEFT JOIN film_crew
		ON film_crew.film_id = films.id
	INNER JOIN persons
		ON film_crew.person_id = persons.id
WHERE
	film_crew.post_id = 2
ORDER BY
	persons.name;

CREATE VIEW series AS
SELECT
	films.id,
	films.title,
	films.short_description,
	films.release_date,
	films.rating,
	films.rating_count,
	films.is_4k,
	countries.name,
	age_ratings.title age_rating,
	channels.title channel,
	counts.episode_count
FROM
	films,
	countries,
	age_ratings,
	channels,
	(SELECT film_id, COUNT(*) episode_count FROM episodes GROUP BY film_id) counts
WHERE
	films.country_id = countries.id
	AND films.age_rating_id = age_ratings.id
	AND films.channel_id = channels.id
	AND films.id = counts.film_id
	AND counts.episode_count > 1
ORDER BY
	films.title;

-- добавить в БД новый язык
delimiter //
CREATE PROCEDURE add_new_language(IN language VARCHAR(250), IN film_id INT)
BEGIN
	DECLARE lang_id INT;

    INSERT INTO languages(title) VALUES (language);
	SET lang_id = LAST_INSERT_ID();
	INSERT INTO film_languages(film_id, language_id) VALUES (film_id, lang_id);
END//

-- обновить продолжительность сериала
delimiter //
CREATE PROCEDURE update_duration(IN series_id INT)
BEGIN
	DECLARE duration_sum INT;

    SELECT SUM(duration) INTO duration_sum FROM episodes WHERE film_id = series_id;
	UPDATE films SET duration = duration_sum WHERE id = series_id;
END//

-- заполнение истории удаляемых фильмов
delimiter //
CREATE TRIGGER deleted_films_trigger BEFORE DELETE ON films
FOR EACH ROW
BEGIN
    INSERT INTO deleted_films(film_id, title, delete_date) VALUES(OLD.id, OLD.title, NOW());
END//

-- обновление продолжительности сериала
delimiter //
CREATE TRIGGER duration_trigger AFTER INSERT ON episodes
FOR EACH ROW
BEGIN
	CALL update_duration(NEW.film_id);
END//
