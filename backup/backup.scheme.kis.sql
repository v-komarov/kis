--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: t_accessdocs(character varying, integer); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_accessdocs(character varying, integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Проверяет доступ к заявке на договор

*/


DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Номер заявки ---
d_id ALIAS FOR $2;

--- Вспомогательная переменная ---
n int;

--- Флаг доступа ---
access int := 0;





BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 THEN
	RETURN 'ERRORDATA';
END IF;


--- Определение является ли пользователь автором заявки ---
SELECT INTO n count(*) FROM t_d WHERE t_create_author=user_kod AND t_rec_delete=0 AND t_rec_id=d_id;
IF n!=0 THEN
	access := access + 1;
END IF;


--- Определение является ли пользователь согласователем ---
SELECT INTO n count(*) FROM t_d_person WHERE t_person_kod=user_kod AND t_d_kod=d_id AND t_rec_delete=0;
IF n!=0 THEN
	access := access + 1;
END IF;




--- Проверка по зафиксированному email руководителя по данной заявке ---
SELECT INTO n count(*) FROM t_d d, t_user_kis u WHERE u.t_email=d.t_email_ruk AND u.t_rec_id=user_kod AND d.t_rec_id=d_id;
IF n!=0 THEN
	access := access + 1;
END IF;




IF access = 0 THEN
    RETURN 'NOTACCESS';
ELSE
    --- Завершение ---
    RETURN 'OK';
END IF;


END;$_$;


ALTER FUNCTION public.t_accessdocs(character varying, integer) OWNER TO kisuser;

--
-- Name: t_addaauto(character varying, character varying, character varying, integer, character varying, integer, numeric, numeric); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_addaauto(character varying, character varying, character varying, integer, character varying, integer, numeric, numeric) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Добавляет автомобиль

*/


DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Город/ЭТЦ ---
location ALIAS FOR $2;

--- марка автомобиля ---
auto_name ALIAS FOR $3;

--- Тип авто легковой/грузовой ---
auto_type ALIAS FOR $4;

--- Госномер ---
g_number ALIAS FOR $5;

--- Тип топлива ---
fuel_type ALIAS FOR $6;

--- Летнее потребление ---
fuel_s ALIAS FOR $7;

--- Зимее потребление ---
fuel_w ALIAS FOR $8;

--- Вспомогательная переменная ---
n int;
genk int;



BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 THEN
	RETURN 'ERRORDATA';
END IF;


--- Определение ключа ---
SELECT INTO n count(*) FROM t_auto_at_list;
IF n=0 THEN
    genk := 1;
ELSE
    SELECT INTO genk max(t_rec_id)+1 FROM t_auto_at_list;
END IF;



--- Добавление ---
INSERT INTO 
t_auto_at_list(
t_rec_id,
t_location,
t_mark,
t_at_number,
t_at_type_kod,
t_fuel_kod,
t_fuel_s,
t_fuel_w,
t_create_author
) 
VALUES(
genk,
btrim(location),
btrim(auto_name),
btrim(g_number),
auto_type,
fuel_type,
fuel_s,
fuel_w,
user_kod
);



--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_addaauto(character varying, character varying, character varying, integer, character varying, integer, numeric, numeric) OWNER TO kisuser;

--
-- Name: t_addaauto(character varying, character varying, character varying, integer, integer, character varying, integer, numeric, numeric); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_addaauto(character varying, character varying, character varying, integer, integer, character varying, integer, numeric, numeric) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Добавляет автомобиль

*/


DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Город/ЭТЦ ---
location ALIAS FOR $2;

--- марка автомобиля ---
auto_name ALIAS FOR $3;

--- Тип авто легковой/грузовой ---
auto_type ALIAS FOR $4;

--- Госномер ---
g_number ALIAS FOR $5;

--- Код стутуса ---
status ALIAS FOR $6;

--- Тип топлива ---
fuel_type ALIAS FOR $7;

--- Летнее потребление ---
fuel_s ALIAS FOR $8;

--- Зимее потребление ---
fuel_w ALIAS FOR $9;

--- Вспомогательная переменная ---
n int;
genk int;



BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 THEN
	RETURN 'ERRORDATA';
END IF;


--- Определение ключа ---
SELECT INTO n count(*) FROM t_auto_at_list;
IF n=0 THEN
    genk := 1;
ELSE
    SELECT INTO genk max(t_rec_id)+1 FROM t_auto_at_list;
END IF;



--- Добавление ---
INSERT INTO 
t_auto_at_list(
t_rec_id,
t_location,
t_mark,
t_at_number,
t_at_type_kod,
t_fuel_kod,
t_fuel_s,
t_fuel_w,
t_create_author,
t_at_status_kod
) 
VALUES(
genk,
btrim(location),
btrim(auto_name),
btrim(g_number),
auto_type,
fuel_type,
fuel_s,
fuel_w,
user_kod,
status
);



--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_addaauto(character varying, character varying, character varying, integer, integer, character varying, integer, numeric, numeric) OWNER TO kisuser;

--
-- Name: t_addaauto(character varying, character varying, character varying, integer, character varying, integer, integer, numeric, numeric); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_addaauto(character varying, character varying, character varying, integer, character varying, integer, integer, numeric, numeric) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Добавляет автомобиль

*/


DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Город/ЭТЦ ---
location ALIAS FOR $2;

--- марка автомобиля ---
auto_name ALIAS FOR $3;

--- Тип авто легковой/грузовой ---
auto_type ALIAS FOR $4;

--- Госномер ---
g_number ALIAS FOR $5;

--- Код стутуса ---
status ALIAS FOR $6;

--- Тип топлива ---
fuel_type ALIAS FOR $7;

--- Летнее потребление ---
fuel_s ALIAS FOR $8;

--- Зимее потребление ---
fuel_w ALIAS FOR $9;

--- Вспомогательная переменная ---
n int;
genk int;



BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 THEN
	RETURN 'ERRORDATA';
END IF;


--- Определение ключа ---
SELECT INTO n count(*) FROM t_auto_at_list;
IF n=0 THEN
    genk := 1;
ELSE
    SELECT INTO genk max(t_rec_id)+1 FROM t_auto_at_list;
END IF;



--- Добавление ---
INSERT INTO 
t_auto_at_list(
t_rec_id,
t_location,
t_mark,
t_at_number,
t_at_type_kod,
t_fuel_kod,
t_fuel_s,
t_fuel_w,
t_create_author,
t_at_status_kod
) 
VALUES(
genk,
btrim(location),
btrim(auto_name),
btrim(g_number),
auto_type,
fuel_type,
fuel_s,
fuel_w,
user_kod,
status
);



--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_addaauto(character varying, character varying, character varying, integer, character varying, integer, integer, numeric, numeric) OWNER TO kisuser;

--
-- Name: t_addaautoperson(character varying, character varying, character varying, integer, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_addaautoperson(character varying, character varying, character varying, integer, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Добавляет личный автомобиль

*/


DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Город/ЭТЦ ---
location ALIAS FOR $2;

--- марка автомобиля ---
auto_name ALIAS FOR $3;

--- Тип авто легковой/грузовой ---
auto_type ALIAS FOR $4;

--- Госномер ---
g_number ALIAS FOR $5;


--- Вспомогательная переменная ---
n int;
genk int;



BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 THEN
	RETURN 'ERRORDATA';
END IF;


--- Определение ключа ---
SELECT INTO n count(*) FROM t_auto_at_list;
IF n=0 THEN
    genk := 1;
ELSE
    SELECT INTO genk max(t_rec_id)+1 FROM t_auto_at_list;
END IF;



--- Добавление ---
INSERT INTO 
t_auto_at_list(
t_rec_id,
t_location,
t_mark,
t_at_number,
t_at_type_kod,
t_fuel_kod,
t_create_author,
t_at_status_kod
) 
VALUES(
genk,
btrim(location),
btrim(auto_name),
btrim(g_number),
auto_type,
0,
user_kod,
2
);



--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_addaautoperson(character varying, character varying, character varying, integer, character varying) OWNER TO kisuser;

--
-- Name: t_addadriver(character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_addadriver(character varying, character varying, character varying, character varying, character varying, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Добавляет водителя в список

*/


DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Код водителя ---
driver_kod ALIAS FOR $2;

--- Город/ЭТЦ ---
location ALIAS FOR $3;

--- ФИО водителя ---
driver_name ALIAS FOR $4;

--- Удостоверение ---
license ALIAS FOR $5;

--- Категории ---
category ALIAS FOR $6;

--- Вспомогательная переменная ---
n int;




BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 OR length(driver_kod)=0 OR length(driver_name)=0 THEN
	RETURN 'ERRORDATA';
END IF;



--- Определение существует ли уже такой водитель ---
SELECT INTO n count(*) FROM t_auto_drivers WHERE t_rec_delete=0 AND t_rec_id=driver_kod;
IF n!=0 THEN
    RETURN 'ERRORDATA';
END IF;


--- Если существует, но как удаленный ---
SELECT INTO n count(*) FROM t_auto_drivers WHERE t_rec_delete=1 AND t_rec_id=driver_kod;
IF n!=0 THEN
    UPDATE t_auto_drivers
    SET
    t_rec_delete=0,
    t_fio_driver=btrim(driver_name),
    t_location=btrim(location),
    t_license=btrim(license),
    t_category=btrim(category),
    t_author_kod=user_kod,
    t_create_time=current_timestamp
    WHERE t_rec_id=driver_kod;

    RETURN 'OK';
END IF;


--- Добавление ---
INSERT INTO 
t_auto_drivers(
t_rec_id,
t_fio_driver,
t_location,
t_license,
t_category,
t_author_kod
) 
VALUES(
driver_kod,
btrim(driver_name),
btrim(location),
btrim(license),
btrim(category),
user_kod
);



--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_addadriver(character varying, character varying, character varying, character varying, character varying, character varying) OWNER TO kisuser;

--
-- Name: t_addaplantrip(character varying, timestamp without time zone, integer, character varying, character varying, character varying, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_addaplantrip(character varying, timestamp without time zone, integer, character varying, character varying, character varying, integer, character varying, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Создание нового планового выезда

*/


DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Дата и время ---
date_and_time ALIAS FOR $2;

--- Продолжительность в часах ---
duration ALIAS FOR $3;

--- Маршрут ---
route ALIAS FOR $4;

--- Объект ---
object ALIAS FOR $5;

--- Код водителя ---
driver_kod ALIAS FOR $6;

--- Код автомобиля  ---
auto_kod ALIAS FOR $7;

--- Прицеп есть или нет ---
trailer ALIAS FOR $8;

--- Код руководителя ЦФО --
chief_kod ALIAS FOR $9;

--- Вспомогательная переменная ---
n int;
genk int;



BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 THEN
	RETURN 'ERRORDATA';
END IF;


--- Определение ключа ---
SELECT INTO n count(*) FROM t_auto_trip;
IF n=0 THEN
    genk := 1;
ELSE
    SELECT INTO genk max(t_rec_id)+1 FROM t_auto_trip;
END IF;



--- Добавление ---
INSERT INTO 
t_auto_trip(
t_rec_id,
t_trip_datetime,
t_duration,
t_plan_or_task,
t_route,
t_object,
t_driver_kod,
t_auto_kod,
t_trailer,
t_author_kod,
t_chief_kod,
t_status_kod
) 
VALUES(
genk,
date_and_time,
duration,
'plan',
btrim(route),
btrim(object),
driver_kod,
auto_kod,
trailer,
user_kod,
chief_kod,
7
);



--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_addaplantrip(character varying, timestamp without time zone, integer, character varying, character varying, character varying, integer, character varying, character varying) OWNER TO kisuser;

--
-- Name: t_addaplantrip(character varying, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_addaplantrip(character varying, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Создание нового планового выезда

*/


DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Дата и время ---
start_date ALIAS FOR $2;
end_date ALIAS FOR $3;

--- Маршрут ---
route ALIAS FOR $4;

--- Объект ---
object ALIAS FOR $5;

--- Код водителя ---
driver_kod ALIAS FOR $6;

--- Код автомобиля  ---
auto_kod ALIAS FOR $7;

--- Цель ---
target ALIAS FOR $8;

--- Попутчик ---
traveler ALIAS FOR $9;

--- Прицеп есть или нет ---
trailer ALIAS FOR $10;

--- Код руководителя ЦФО --
chief_kod ALIAS FOR $11;

--- Вспомогательная переменная ---
n int;
genk int;

--- Продолжительность в часах ---
duration int;



BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 THEN
	RETURN 'ERRORDATA';
END IF;



--- Проверка: время заявки  ---
IF start_date>=end_date THEN
    RETURN 'NOTACCESS';
END IF;


--- Продолжительность в часах
duration := round( (extract(epoch FROM end_date) - extract(epoch FROM start_date))/3600 );


--- Определение ключа ---
SELECT INTO n count(*) FROM t_auto_trip;
IF n=0 THEN
    genk := 1;
ELSE
    SELECT INTO genk max(t_rec_id)+1 FROM t_auto_trip;
END IF;



--- Добавление ---
INSERT INTO 
t_auto_trip(
t_rec_id,
t_trip_datetime,
t_trip_datetime_end,
t_duration,
t_plan_or_task,
t_route,
t_object,
t_driver_kod,
t_auto_kod,
t_target,
t_traveler,
t_trailer,
t_author_kod,
t_chief_kod,
t_status_kod
) 
VALUES(
genk,
start_date,
end_date,
duration,
'plan',
btrim(route),
btrim(object),
driver_kod,
auto_kod,
btrim(target),
btrim(traveler),
trailer,
user_kod,
chief_kod,
7
);



--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_addaplantrip(character varying, timestamp without time zone, timestamp without time zone, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying) OWNER TO kisuser;

--
-- Name: t_addatasktrip(character varying, timestamp without time zone, timestamp without time zone, character varying, character varying, integer, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_addatasktrip(character varying, timestamp without time zone, timestamp without time zone, character varying, character varying, integer, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Создание новой заявки на выезд

*/


DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Дата и время ---
start_date ALIAS FOR $2;
end_date ALIAS FOR $3;

--- Маршрут ---
route ALIAS FOR $4;

--- Объект ---
object ALIAS FOR $5;

--- Код автомобиля  ---
auto_kod ALIAS FOR $6;

--- Цель ---
target ALIAS FOR $7;

--- Вспомогательная переменная ---
n int;
genk int;

--- Продолжительность в часах ---
duration int;


BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 THEN
	RETURN 'ERRORDATA';
END IF;


--- Проверка: время заявки не должно быть прошедшим ---
IF date(start_date)<current_date OR start_date>=end_date THEN
    RETURN 'NOTACCESS';
END IF;


--- Продолжительность в часах
duration := round( (extract(epoch FROM end_date) - extract(epoch FROM start_date))/3600 );


--- Определение ключа ---
SELECT INTO n count(*) FROM t_auto_trip;
IF n=0 THEN
    genk := 1;
ELSE
    SELECT INTO genk max(t_rec_id)+1 FROM t_auto_trip;
END IF;



--- Добавление ---
INSERT INTO 
t_auto_trip(
t_rec_id,
t_trip_datetime,
t_trip_datetime_end,
t_duration,
t_plan_or_task,
t_route,
t_object,
t_auto_kod,
t_target,
t_author_kod
) 
VALUES(
genk,
start_date,
end_date,
duration,
'task',
btrim(route),
btrim(object),
auto_kod,
btrim(target),
user_kod
);



--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_addatasktrip(character varying, timestamp without time zone, timestamp without time zone, character varying, character varying, integer, character varying) OWNER TO kisuser;

--
-- Name: t_addatrailer(integer, numeric, numeric); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_addatrailer(integer, numeric, numeric) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Добавляет вариант расхода топлива с прицепом

*/


DECLARE


--- Код записи автомобиля ---
rec_kod ALIAS FOR $1;

--- Летнее потребление ---
fuel_s ALIAS FOR $2;

--- Зимее потребление ---
fuel_w ALIAS FOR $3;

--- Вспомогательная переменная ---
n int;
genk int;



BEGIN


--- Проверка поступивших данных на корректность ---
IF rec_kod IS NULL OR fuel_s=0.00 OR fuel_w=0.00 THEN
	RETURN 'ERRORDATA';
END IF;



--- Проверка есть ли запись для этого кода записи автомобиля ---
SELECT INTO n count(*) FROM t_auto_trailer WHERE t_auto_kod=rec_kod;
IF n!=0 THEN
    RETURN 'NOTACCESS';
END IF;



--- Определение ключа ---
SELECT INTO n count(*) FROM t_auto_trailer;
IF n=0 THEN
    genk := 1;
ELSE
    SELECT INTO genk max(t_rec_id)+1 FROM t_auto_trailer;
END IF;



--- Добавление ---
INSERT INTO 
t_auto_trailer(
t_rec_id,
t_auto_kod,
t_fuel_s,
t_fuel_w
) 
VALUES(
genk,
rec_kod,
fuel_s,
fuel_w
);



--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_addatrailer(integer, numeric, numeric) OWNER TO kisuser;

--
-- Name: t_addddocs(character varying, integer, character varying, text, character varying, bytea); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_addddocs(character varying, integer, character varying, text, character varying, bytea) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Добавляет документы (файлы) к заявке на договор

*/


DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Номер заявки ---
d_id ALIAS FOR $2;

--- Наименование файла ---
file_name ALIAS FOR $3;

--- Описание файла ---
file_info ALIAS FOR $4;

--- Расширение файла ---
file_ext ALIAS FOR $5;

--- Собственно сам файл ---
d_data ALIAS FOR $6;

--- Вспомогательная переменная ---
n int;

--- Сгенерированный уникальный ключ ---
genk varchar(24);




BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 OR length(file_name)=0 OR length(file_info)=0 THEN
	RETURN 'ERRORDATA';
END IF;



--- Определение существует ли уже такой файл по данной заявке ---
SELECT INTO n count(*) FROM t_d_docs WHERE t_rec_delete=0 AND t_d_kod=d_id AND t_file_name=btrim(file_name);
IF n!=0 THEN
    RETURN 'ERRORDATA';
END IF;


--- Определение уникального ключа ---
n := 1;
WHILE n!=0 LOOP
    genk := t_GenKey24();
    SELECT INTO n count(*) FROM t_d_docs WHERE t_rec_id=genk;
END LOOP;



--- Добавление записи ---
INSERT INTO 
t_d_docs(
t_rec_id,
t_d_kod,
t_comment,
t_ext,
t_file_name,
t_data,
t_create_author
) 
VALUES(
genk,
d_id,
btrim(file_info),
btrim(file_ext),
btrim(file_name),
d_data,
user_kod
);


--- Завершение ---
RETURN genk;


END;$_$;


ALTER FUNCTION public.t_addddocs(character varying, integer, character varying, text, character varying, bytea) OWNER TO kisuser;

--
-- Name: t_adddperson(character varying, integer, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_adddperson(character varying, integer, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Добавляет в список согласования

*/


DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Номер заявки ---
d_id ALIAS FOR $2;

--- Наименование файла ---
person_kod ALIAS FOR $3;

--- Статус заявки ---
d_status_kod int;

--- Вспомогательная переменная ---
n int;

--- Сгенерированный уникальный ключ ---
genk varchar(24);

--- Очередность согласования ---
agre int;

--- Флаг наличия удаленного согласующего ---
flag_delete int;

--- Код пользователя следующего согласующего ---
next_user_kod varchar(24);




BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 OR length(person_kod)=0 THEN
	RETURN 'ERRORDATA';
END IF;


--- Корректировка списка возможно только для некоторых статусов ---
SELECT INTO d_status_kod t_dstatus_kod FROM t_d WHERE t_rec_id=d_id;
IF d_status_kod!=3 THEN
	RETURN 'NOTACCESS';
END IF;


--- Определение существует ли уже такой пользователь (персона) по данной заявке ---
SELECT INTO n count(*) FROM t_d_person WHERE t_rec_delete=0 AND t_d_kod=d_id AND t_person_kod=person_kod;
IF n!=0 THEN
    RETURN 'ERRORDATA';
END IF;

--- Может этот пользователь присутствует в удаленных ---
SELECT INTO n count(*) FROM t_d_person WHERE t_rec_delete=1 AND t_d_kod=d_id AND t_person_kod=person_kod;
IF n = 0 THEN
    flag_delete := 0;
ELSE
    flag_delete := 1;
END IF;


--- Расстановка очередности согласования ---
SELECT INTO n count(*) FROM t_d_person WHERE t_rec_delete=0 AND t_d_kod=d_id;
IF n=0 THEN
    agre := 1;
ELSE
    SELECT INTO agre max(t_order_agremnt)+1 FROM t_d_person WHERE t_rec_delete=0 AND t_d_kod=d_id;
END IF;



--- Добавляем или восстанавливаем запись ---

IF flag_delete = 0 THEN

    --- Определение уникального ключа ---
    n := 1;
    WHILE n!=0 LOOP
	genk := t_GenKey24();
	SELECT INTO n count(*) FROM t_d_person WHERE t_rec_id=genk;
    END LOOP;


    --- Добавление записи ---
    INSERT INTO 
    t_d_person(
    t_rec_id,
    t_d_kod,
    t_person_kod,
    t_create_author,
    t_order_agremnt
    ) 
    VALUES(
    genk,
    d_id,
    person_kod,
    user_kod,
    agre
    );

ELSE
    --- Восстановление записи ---
    UPDATE t_d_person
    SET
    t_rec_delete=0,
    t_order_agremnt=agre,
    t_create_author=user_kod,
    t_create_time=now()
    WHERE
    t_person_kod=person_kod AND t_d_kod=d_id;

END IF;


--- Определение следующего согласующего ---
SELECT INTO next_user_kod t_person_kod FROM t_d_person WHERE t_rec_delete=0 AND t_d_kod=d_id AND (t_dstatus_kod IS NULL OR t_dstatus_kod=3) ORDER BY t_order_agremnt LIMIT 1;

--- Такой следующий уже есть? ---
SELECT INTO n count(*) FROM t_d_person_next WHERE t_d_kod=d_id AND t_user_kod=next_user_kod;
IF n=0 THEN
    --- Добавление записи ---
    DELETE FROM t_d_person_next WHERE t_d_kod=d_id;
    INSERT INTO t_d_person_next (t_d_kod,t_user_kod) VALUES(d_id,next_user_kod);
END IF;


--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_adddperson(character varying, integer, character varying) OWNER TO kisuser;

--
-- Name: t_additdocuser(character varying, character varying, text, character varying, character varying, bytea); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_additdocuser(character varying, character varying, text, character varying, character varying, bytea) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Добавляет документ (файлы) к заявке ИТ

*/


DECLARE


--- Номер заявки ---
it_id ALIAS FOR $1;

--- Наименование файла ---
file_name ALIAS FOR $2;

--- Комментарий ---
user_comment ALIAS FOR $3;

--- Расширение файла ---
file_ext ALIAS FOR $4;

--- IP адрес ---
ip ALIAS FOR $5;

--- Содержание файла ---
file_data ALIAS FOR $6;

--- Вспомогательная переменная ---
n int;

--- Сгенерированный уникальный ключ ---
genk varchar(24);




BEGIN


--- Проверка поступивших данных на корректность ---
IF length(it_id)=0 OR length(user_comment)=0 OR length(ip)=0 THEN
	RETURN 'ERRORDATA';
END IF;


--- Определение существует ли уже такой файл по данной заявке ---
SELECT INTO n count(*) FROM t_it_docs WHERE t_rec_delete=0 AND t_it_task_kod=it_id AND t_filename=btrim(file_name) AND t_filename!='' AND t_ext!='';
IF n!=0 THEN
    RETURN 'ERRORDATA';
END IF;


--- Определение уникального ключа ---
n := 1;
WHILE n!=0 LOOP
    genk := t_GenKey24();
    SELECT INTO n count(*) FROM t_it_docs WHERE t_rec_id=genk;
END LOOP;

--- Добавление записи ---
INSERT INTO 
t_it_docs(
t_rec_id,
t_it_task_kod,
t_ext,
t_filename,
t_user_comment,
t_ip,
t_data
) 
VALUES(
genk,
it_id,
btrim(file_ext),
btrim(file_name),
btrim(user_comment),
btrim(ip),
file_data
);


--- Завершение ---
RETURN 'OK:'||genk;


END;$_$;


ALTER FUNCTION public.t_additdocuser(character varying, character varying, text, character varying, character varying, bytea) OWNER TO kisuser;

--
-- Name: t_addstorename(character varying, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_addstorename(character varying, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Добавляет Склад

*/


DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Название склада ---
name ALIAS FOR $2;

--- Вспомогательная переменная ---
n int;
genk int;



BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 OR length(name)=0 THEN
	RETURN 'ERRORDATA';
END IF;


--- Проверка : есть ли склад с тем же названием ---
SELECT INTO n count(*) FROM t_store_list WHERE btrim(t_store_name)=btrim(name);
IF n != 0 THEN
    RETURN 'ERRORDATA';
END IF;



--- Определение ключа ---
SELECT INTO n count(*) FROM t_store_list;
IF n=0 THEN
    genk := 1;
ELSE
    SELECT INTO genk max(t_rec_id)+1 FROM t_store_list;
END IF;



--- Добавление ---
INSERT INTO 
t_store_list(
t_rec_id,
t_store_name,
t_create_user
) 
VALUES(
genk,
btrim(name),
user_kod
);



--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_addstorename(character varying, character varying) OWNER TO kisuser;

--
-- Name: t_addstoreperson(character varying, integer, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_addstoreperson(character varying, integer, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Добавляет кладовщика

*/


DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Код склада ---
store_kod ALIAS FOR $2;

--- Код кладовщика ---
person_kod ALIAS FOR $3;

--- Вспомогательная переменная ---
n int;
genk int;



BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 OR length(person_kod)=0 OR store_kod IS NULL OR store_kod=0 THEN
	RETURN 'ERRORDATA';
END IF;


--- Проверка : есть ли такой кладовщик для этого склада ---
SELECT INTO n count(*) FROM t_store_person WHERE t_store_kod=store_kod AND t_person_kod=person_kod;
IF n != 0 THEN
    RETURN 'ERRORDATA';
END IF;



--- Определение ключа ---
SELECT INTO n count(*) FROM t_store_person;
IF n=0 THEN
    genk := 1;
ELSE
    SELECT INTO genk max(t_rec_id)+1 FROM t_store_person;
END IF;



--- Добавление ---
INSERT INTO 
t_store_person(
t_rec_id,
t_store_kod,
t_person_kod,
t_create_user
) 
VALUES(
genk,
store_kod,
person_kod,
user_kod
);



--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_addstoreperson(character varying, integer, character varying) OWNER TO kisuser;

--
-- Name: t_addtmcdocs(character varying, integer, character varying, character varying, character varying, bytea); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_addtmcdocs(character varying, integer, character varying, character varying, character varying, bytea) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Добавляет документы (файлы) заявки ТМЦ

*/


DECLARE


--- Код учетной записи пользователя ---
user_kod ALIAS FOR $1;

--- Номер заявки ---
tmc_id ALIAS FOR $2;

--- Наименование файла ---
file_name ALIAS FOR $3;

--- Описание файла ---
file_info ALIAS FOR $4;

--- Расширение файла ---
file_ext ALIAS FOR $5;

--- Данные файла ---
file_data ALIAS FOR $6;

--- Вспомогательная переменная ---
n int;

--- Сгенерированный уникальный ключ ---
genk varchar(24);




BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 OR length(file_name)=0 THEN
	RETURN 'ERRORDATA';
END IF;



--- Определение существует ли уже такой файл по данной заявке ---
SELECT INTO n count(*) FROM t_tmc_docs WHERE t_rec_delete=0 AND t_tmc_kod=tmc_id AND t_filename=btrim(file_name);
IF n!=0 THEN
    RETURN 'ERRORDATA';
END IF;


--- Определение уникального ключа ---
n := 1;
WHILE n!=0 LOOP
    genk := t_GenKey24();
    SELECT INTO n count(*) FROM t_tmc_docs WHERE t_rec_id=genk;
END LOOP;

--- Добавление записи ---
INSERT INTO 
t_tmc_docs(
t_rec_id,
t_tmc_kod,
t_ext,
t_filename,
t_fileinfo,
t_create_author,
t_update_author,
t_filedata
) 
VALUES(
genk,
tmc_id,
btrim(file_ext),
btrim(file_name),
btrim(file_info),
user_kod,
user_kod,
file_data
);


--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_addtmcdocs(character varying, integer, character varying, character varying, character varying, bytea) OWNER TO kisuser;

--
-- Name: t_addtmcspec(character varying, integer, character varying, integer, numeric, numeric, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_addtmcspec(character varying, integer, character varying, integer, numeric, numeric, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Добавляет содержимое заявки ТМЦ

*/


DECLARE


--- Код учетной записи пользователя ---
user_kod ALIAS FOR $1;

--- Номер заявки ---
tmc_id ALIAS FOR $2;

--- Наименование строки ---
row_name ALIAS FOR $3;

--- ОКЕИ ---
row_okei ALIAS FOR $4;

--- Количество ---
row_q ALIAS FOR $5;

--- Стоимость ---
row_cost ALIAS FOR $6;

--- Аналог ---
row_analog ALIAS FOR $7;

--- Вспомогательная переменная ---
n int;

--- Сгенерированный уникальный ключ ---
genk varchar(24);

--- Переменная для хранения строк ---
r record;

--- Переменная нумерации строк ---
i int := 1;

--- Автор код ---
author_kod varchar(24);




BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 OR length(row_name)=0 OR row_q<=0.00 OR row_cost<0.00 THEN
	RETURN 'ERRORDATA';
END IF;

--- Кто создавал заявку, тот и наполняет ---
SELECT INTO author_kod t_author_kod FROM t_tmc WHERE t_rec_id=tmc_id;
IF author_kod != user_kod THEN
    RETURN 'NOTACCESS';
END IF;



--- Определение уникального ключа ---
n := 1;
WHILE n!=0 LOOP
    genk := t_GenKey24();
    SELECT INTO n count(*) FROM t_tmc_spec WHERE t_rec_id=genk;
END LOOP;

--- Добавление записи ---
INSERT INTO 
t_tmc_spec(
t_rec_id,
t_tmc_kod,
t_row_name,
t_row_okei_kod,
t_row_q,
t_row_cost,
t_row_analog,
t_create_author,
t_update_author
) 
VALUES(
genk,
tmc_id,
btrim(row_name),
row_okei,
row_q,
row_cost,
btrim(row_analog),
user_kod,
user_kod
);


--- Расстановка порядковых номеров строк ---
FOR r IN (SELECT * FROM t_tmc_spec WHERE t_tmc_kod=tmc_id AND t_rec_delete=0 ORDER BY t_row_name) LOOP

	UPDATE t_tmc_spec
	SET t_row_kod=i
	WHERE
	t_rec_id=r.t_rec_id;
	i := i + 1;

END LOOP;



--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_addtmcspec(character varying, integer, character varying, integer, numeric, numeric, character varying) OWNER TO kisuser;

--
-- Name: t_changetmcgroup(character varying, integer, text, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_changetmcgroup(character varying, integer, text, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Присвоение группы заявки ТМЦ

*/


DECLARE


--- Код учетной записи пользователя ---
user_kod ALIAS FOR $1;

--- Номер заявки ---
tmc_id ALIAS FOR $2;

--- Коментарий ---
comment ALIAS FOR $3;

--- Группа куда переводим ---
new_group ALIAS FOR $4;

--- Вспомогательная переменная ---
n int;

--- Сгенерированный уникальный ключ ---
genk varchar(24);

--- Группа ТМЦ сейчас ---
now_group varchar(10);




BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 or length(new_group)=0 THEN
	RETURN 'ERRORDATA';
END IF;




--- Определение текущей группы ТМЦ заявки  ---
SELECT INTO now_group t_grouptmc FROM t_tmc WHERE t_rec_id=tmc_id;
--- Повторно вводить ту же группу нельзя --- 
IF now_group=new_group THEN
	RETURN 'NOTACCESS';
END IF;



--- Определение уникального ключа ---
n := 1;
WHILE n!=0 LOOP
    genk := t_GenKey24();
    SELECT INTO n count(*) FROM t_tmc_grouptmc_history WHERE t_rec_id=genk;
END LOOP;



--- Добавление записи ---
INSERT INTO 
t_tmc_grouptmc_history(
t_rec_id,
t_tmc_kod,
t_grouptmc_after,
t_grouptmc_before,
t_comment,
t_author_kod
) 
VALUES(
genk,
tmc_id,
new_group,
now_group,
btrim(comment),
user_kod
);
    



--- Запись новой группы в заявке ---
UPDATE t_tmc
SET 
t_grouptmc=new_group
WHERE
t_rec_id=tmc_id;





--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_changetmcgroup(character varying, integer, text, character varying) OWNER TO kisuser;

--
-- Name: t_deldperson(character varying, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_deldperson(character varying, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Удаляет из списока согласования

*/


DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Код записи ---
rec_kod ALIAS FOR $2;

--- Номер заявки ---
d_id int;

--- Статус заявки ---
d_status_kod int;

--- Вспомогательная переменная ---
n int;

--- Для хранения строки ---
r record;

--- Код следующего согласующего ---
next_user_kod varchar(24);



BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 OR length(rec_kod)=0 THEN
	RETURN 'ERRORDATA';
END IF;



--- Определение номера заявки ---
SELECT INTO d_id t_d_kod FROM t_d_person WHERE t_rec_id=rec_kod;


--- Корректировка списка возможно только для некоторых статусов ---
SELECT INTO d_status_kod t_dstatus_kod FROM t_d WHERE t_rec_id=d_id;
IF d_status_kod!=3 THEN
	RETURN 'NOTACCESS';
END IF;


--- Удаление записи ---
DELETE FROM t_d_person WHERE t_rec_id=rec_kod;



--- Восстановление очередности ---
n := 1;
FOR r IN (SELECT * FROM t_d_person WHERE t_rec_delete=0 AND t_d_kod=d_id ORDER BY t_order_agremnt) LOOP
    UPDATE t_d_person
    SET t_order_agremnt=n
    WHERE
    t_rec_id=r.t_rec_id;
    n := n + 1;
END LOOP;



--- Определение следующего согласующего ---
SELECT INTO n count(*) FROM t_d_person WHERE t_rec_delete=0 AND t_d_kod=d_id AND (t_dstatus_kod IS NULL OR t_dstatus_kod=3);
IF n=0 THEN
    DELETE FROM t_d_person_next WHERE t_d_kod=d_id;
    RETURN 'OK';
END IF;

SELECT INTO next_user_kod t_person_kod FROM t_d_person WHERE t_rec_delete=0 AND t_d_kod=d_id AND (t_dstatus_kod IS NULL OR t_dstatus_kod=3) ORDER BY t_order_agremnt LIMIT 1;

--- Такой следующий уже есть? ---
SELECT INTO n count(*) FROM t_d_person_next WHERE t_d_kod=d_id AND t_user_kod=next_user_kod;
IF n=0 THEN
    --- Добавление записи ---
    DELETE FROM t_d_person_next WHERE t_d_kod=d_id;
    INSERT INTO t_d_person_next (t_d_kod,t_user_kod) VALUES(d_id,next_user_kod);
END IF;





--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_deldperson(character varying, character varying) OWNER TO kisuser;

--
-- Name: t_deltmcspec(character varying, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_deltmcspec(character varying, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Удаляет содержимое заявки ТМЦ

*/


DECLARE


--- Код учетной записи пользователя ---
user_kod ALIAS FOR $1;

--- Ид строки ---
spec_id ALIAS FOR $2;

--- Номер заявки ---
tmc_id int;

--- Вспомогательная переменная ---
n int;

--- Переменная для хранения строк ---
r record;

--- Переменная нумерации строк ---
i int := 1;

--- Автор заявки ---
author_kod varchar(24);



BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 OR length(spec_id)=0 THEN
	RETURN 'ERRORDATA';
END IF;


--- Определение номера заявки ---
SELECT INTO tmc_id t_tmc_kod FROM t_tmc_spec WHERE t_rec_id=spec_id;

--- Определение автора заявки ---
SELECT INTO author_kod t_author_kod FROM t_tmc WHERE t_rec_id=tmc_id;

--- Если не автор заявки - досвидания --
IF author_kod != user_kod THEN
    RETURN 'NOTACCESS';
END IF;


--- Удаление записи записи ---
UPDATE
t_tmc_spec 
SET
t_rec_delete=1,
t_update_time=current_timestamp,
t_update_author=user_kod
WHERE t_rec_id=spec_id;


--- Расстановка порядковых номеров строк ---
FOR r IN (SELECT * FROM t_tmc_spec WHERE t_tmc_kod=tmc_id AND t_rec_delete=0 ORDER BY t_row_name) LOOP

	UPDATE t_tmc_spec
	SET t_row_kod=i
	WHERE
	t_rec_id=r.t_rec_id;
	i := i + 1;

END LOOP;



--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_deltmcspec(character varying, character varying) OWNER TO kisuser;

--
-- Name: t_editaauto(integer, character varying, character varying, integer, character varying, integer, numeric, numeric); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_editaauto(integer, character varying, character varying, integer, character varying, integer, numeric, numeric) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Добавляет автомобиль

*/


DECLARE


--- Код записи ---
rec_kod ALIAS FOR $1;

--- Город/ЭТЦ ---
location ALIAS FOR $2;

--- марка автомобиля ---
auto_name ALIAS FOR $3;

--- Тип авто легковой/грузовой ---
auto_type ALIAS FOR $4;

--- Госномер ---
g_number ALIAS FOR $5;

--- Тип топлива ---
fuel_type ALIAS FOR $6;

--- Летнее потребление ---
fuel_s ALIAS FOR $7;

--- Зимее потребление ---
fuel_w ALIAS FOR $8;

--- Вспомогательная переменная ---
n int;
genk int;



BEGIN


--- Проверка поступивших данных на корректность ---
IF rec_kod IS NULL THEN
	RETURN 'ERRORDATA';
END IF;



--- Изменение записи ---
UPDATE t_auto_at_list
SET
t_location=btrim(location),
t_mark=btrim(auto_name),
t_at_number=btrim(g_number),
t_at_type_kod=auto_type,
t_fuel_kod=fuel_type,
t_fuel_s=fuel_s,
t_fuel_w=fuel_w
WHERE t_rec_id=rec_kod;




--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_editaauto(integer, character varying, character varying, integer, character varying, integer, numeric, numeric) OWNER TO kisuser;

--
-- Name: t_editaauto(integer, character varying, character varying, integer, integer, character varying, integer, numeric, numeric, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_editaauto(integer, character varying, character varying, integer, integer, character varying, integer, numeric, numeric, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Добавляет автомобиль

*/


DECLARE


--- Код записи ---
rec_kod ALIAS FOR $1;

--- Город/ЭТЦ ---
location ALIAS FOR $2;

--- марка автомобиля ---
auto_name ALIAS FOR $3;

--- Тип авто легковой/грузовой ---
auto_type ALIAS FOR $4;

--- Госномер ---
g_number ALIAS FOR $5;

--- Код статуса ---
status ALIAS FOR $6;

--- Тип топлива ---
fuel_type ALIAS FOR $7;

--- Летнее потребление ---
fuel_s ALIAS FOR $8;

--- Зимее потребление ---
fuel_w ALIAS FOR $9;

--- Код пользователя ---
user_kod ALIAS FOR $10;


--- Вспомогательная переменная ---
n int;
genk int;

--- Прежний код стутуса ---
status_old int;



BEGIN


--- Проверка поступивших данных на корректность ---
IF rec_kod IS NULL THEN
	RETURN 'ERRORDATA';
END IF;



--- Изменение записи ---
UPDATE t_auto_at_list
SET
t_location=btrim(location),
t_mark=btrim(auto_name),
t_at_number=btrim(g_number),
t_at_type_kod=auto_type,
t_fuel_kod=fuel_type,
t_fuel_s=fuel_s,
t_fuel_w=fuel_w,
t_at_status_kod=status
WHERE t_rec_id=rec_kod;


SELECT INTO status_old t_at_status_kod FROM t_auto_at_list WHERE t_rec_id=rec_kod;


IF status!=status_old THEN

--- Добавление ---
INSERT INTO 
t_auto_at_status(
t_at_status_kod,
t_at_kod,
t_create_author
) 
VALUES(
status,
rec_kod,
user_kod
);

END IF;



--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_editaauto(integer, character varying, character varying, integer, integer, character varying, integer, numeric, numeric, character varying) OWNER TO kisuser;

--
-- Name: t_editaauto(integer, character varying, character varying, integer, character varying, integer, integer, numeric, numeric, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_editaauto(integer, character varying, character varying, integer, character varying, integer, integer, numeric, numeric, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Добавляет автомобиль

*/


DECLARE


--- Код записи ---
rec_kod ALIAS FOR $1;

--- Город/ЭТЦ ---
location ALIAS FOR $2;

--- марка автомобиля ---
auto_name ALIAS FOR $3;

--- Тип авто легковой/грузовой ---
auto_type ALIAS FOR $4;

--- Госномер ---
g_number ALIAS FOR $5;

--- Код статуса ---
status ALIAS FOR $6;

--- Тип топлива ---
fuel_type ALIAS FOR $7;

--- Летнее потребление ---
fuel_s ALIAS FOR $8;

--- Зимее потребление ---
fuel_w ALIAS FOR $9;

--- Код пользователя ---
user_kod ALIAS FOR $10;


--- Вспомогательная переменная ---
n int;
genk int;

--- Прежний код стутуса ---
status_old int;



BEGIN


--- Проверка поступивших данных на корректность ---
IF rec_kod IS NULL THEN
	RETURN 'ERRORDATA';
END IF;

--- Прежнее значение статуса ---
SELECT INTO status_old t_at_status_kod FROM t_auto_at_list WHERE t_rec_id=rec_kod;


--- Изменение записи ---
UPDATE t_auto_at_list
SET
t_location=btrim(location),
t_mark=btrim(auto_name),
t_at_number=btrim(g_number),
t_at_type_kod=auto_type,
t_fuel_kod=fuel_type,
t_fuel_s=fuel_s,
t_fuel_w=fuel_w,
t_at_status_kod=status
WHERE t_rec_id=rec_kod;




IF status!=status_old THEN

--- Добавление ---
INSERT INTO 
t_auto_at_status(
t_at_status_kod,
t_at_kod,
t_create_author
) 
VALUES(
status,
rec_kod,
user_kod
);

END IF;



--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_editaauto(integer, character varying, character varying, integer, character varying, integer, integer, numeric, numeric, character varying) OWNER TO kisuser;

--
-- Name: t_editaautoperson(integer, character varying, character varying, integer, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_editaautoperson(integer, character varying, character varying, integer, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Изменение данных личного автомобиля

*/


DECLARE


--- Код записи ---
rec_kod ALIAS FOR $1;

--- Город/ЭТЦ ---
location ALIAS FOR $2;

--- марка автомобиля ---
auto_name ALIAS FOR $3;

--- Тип авто легковой/грузовой ---
auto_type ALIAS FOR $4;

--- Госномер ---
g_number ALIAS FOR $5;


--- Вспомогательная переменная ---
n int;
genk int;



BEGIN


--- Проверка поступивших данных на корректность ---
IF rec_kod IS NULL THEN
	RETURN 'ERRORDATA';
END IF;


--- Изменение записи ---
UPDATE t_auto_at_list
SET
t_location=btrim(location),
t_mark=btrim(auto_name),
t_at_number=btrim(g_number),
t_at_type_kod=auto_type
WHERE t_rec_id=rec_kod;


--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_editaautoperson(integer, character varying, character varying, integer, character varying) OWNER TO kisuser;

--
-- Name: t_editaplantrip(integer, character varying, timestamp without time zone, integer, character varying, character varying, character varying, integer, character varying, character varying, integer, integer, numeric, integer, text); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_editaplantrip(integer, character varying, timestamp without time zone, integer, character varying, character varying, character varying, integer, character varying, character varying, integer, integer, numeric, integer, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Изменение планового выезда , регистрация изменения статуса

*/


DECLARE

--- Код записи ---
rec_id ALIAS FOR $1;

--- Код пользователя ---
user_kod ALIAS FOR $2;

--- Дата и время ---
date_and_time ALIAS FOR $3;

--- Продолжительность в часах ---
duration ALIAS FOR $4;

--- Маршрут ---
route ALIAS FOR $5;

--- Объект ---
object ALIAS FOR $6;

--- Код водителя ---
driver_kod ALIAS FOR $7;

--- Код автомобиля  ---
auto_kod ALIAS FOR $8;

--- Прицеп есть или нет ---
trailer ALIAS FOR $9;

--- Код руководителя ЦФО --
chief_kod ALIAS FOR $10;

--- Показания спидометра ---
speedo1 ALIAS FOR $11;
speedo2 ALIAS FOR $12;

--- Расход топлива ---
fuel ALIAS FOR $13;

--- Код стауса заявки ---
status_kod ALIAS FOR $14;

--- Комментарий к статусу ---
comment ALIAS FOR $15;


--- Вспомогательная переменная ---
n int;
genk int;
status_trip int;


BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 OR rec_id IS NULL THEN
	RETURN 'ERRORDATA';
END IF;


--- Определение текущего статуса заявки ---
SELECT INTO status_trip t_status_kod FROM t_auto_trip WHERE t_rec_id=rec_id;
--- Если заявка отменена или выполнена - изменения уже вностить нельзя ---
IF status_trip=6 OR status_trip=8 THEN
    RETURN 'NOTACCESS';
END IF;



--- Если устнавливаем новый статус - фиксируем историю изменений статусов ---
IF status_trip!=status_kod THEN

    --- Определение ключа ---
    SELECT INTO n count(*) FROM t_auto_status;
    IF n=0 THEN
	genk := 1;
    ELSE
	SELECT INTO genk max(t_rec_id)+1 FROM t_auto_status;
    END IF;

    --- Добавление истории смены статусов ---
    INSERT INTO t_auto_status (
    t_rec_id,
    t_auto_trip_kod,
    t_comment,
    t_status_kod,
    t_create_author
    )
    VALUES (
    genk,
    rec_id,
    btrim(comment),
    status_kod,
    user_kod
    );

END IF;






--- Изменение заявки ---
UPDATE t_auto_trip 
SET
t_trip_datetime=date_and_time,
t_duration=duration,
t_route=btrim(route),
t_object=btrim(object),
t_driver_kod=driver_kod,
t_auto_kod=auto_kod,
t_trailer=trailer,
t_chief_kod=chief_kod,
t_speedo1=speedo1,
t_speedo2=speedo2,
t_fuel=fuel,
t_status_kod=status_kod
WHERE t_rec_id=rec_id;





--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_editaplantrip(integer, character varying, timestamp without time zone, integer, character varying, character varying, character varying, integer, character varying, character varying, integer, integer, numeric, integer, text) OWNER TO kisuser;

--
-- Name: t_editaplantrip(integer, character varying, timestamp without time zone, timestamp without time zone, integer, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, integer, integer, numeric, integer, text); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_editaplantrip(integer, character varying, timestamp without time zone, timestamp without time zone, integer, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, integer, integer, numeric, integer, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Изменение планового выезда , регистрация изменения статуса

*/


DECLARE

--- Код записи ---
rec_id ALIAS FOR $1;

--- Код пользователя ---
user_kod ALIAS FOR $2;

--- Дата и время ---
start_date ALIAS FOR $3;
end_date ALIAS FOR $4;

--- Продолжительность в часах ---
duration ALIAS FOR $5;

--- Маршрут ---
route ALIAS FOR $6;

--- Объект ---
object ALIAS FOR $7;

--- Код водителя ---
driver_kod ALIAS FOR $8;

--- Код автомобиля  ---
auto_kod ALIAS FOR $9;

--- Цель ---
target ALIAS FOR $10;

--- Попутчик ---
traveler ALIAS FOR $11;

--- Прицеп есть или нет ---
trailer ALIAS FOR $12;

--- Код руководителя ЦФО --
chief_kod ALIAS FOR $13;

--- Показания спидометра ---
speedo1 ALIAS FOR $14;
speedo2 ALIAS FOR $15;

--- Расход топлива ---
fuel ALIAS FOR $16;

--- Код стауса заявки ---
status_kod ALIAS FOR $17;

--- Комментарий к статусу ---
comment ALIAS FOR $18;


--- Вспомогательная переменная ---
n int;
genk int;
status_trip int;


BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 OR rec_id IS NULL THEN
	RETURN 'ERRORDATA';
END IF;


--- Проверка: время заявки  ---
IF start_date>=end_date THEN
    RETURN 'NOTACCESS';
END IF;



--- Определение текущего статуса заявки ---
SELECT INTO status_trip t_status_kod FROM t_auto_trip WHERE t_rec_id=rec_id;
--- Если заявка отменена или выполнена - изменения уже вностить нельзя ---
IF status_trip=6 OR status_trip=8 THEN
    RETURN 'NOTACCESS';
END IF;



--- Если устнавливаем новый статус - фиксируем историю изменений статусов ---
IF status_trip!=status_kod THEN

    --- Определение ключа ---
    SELECT INTO n count(*) FROM t_auto_status;
    IF n=0 THEN
	genk := 1;
    ELSE
	SELECT INTO genk max(t_rec_id)+1 FROM t_auto_status;
    END IF;

    --- Добавление истории смены статусов ---
    INSERT INTO t_auto_status (
    t_rec_id,
    t_auto_trip_kod,
    t_comment,
    t_status_kod,
    t_create_author
    )
    VALUES (
    genk,
    rec_id,
    btrim(comment),
    status_kod,
    user_kod
    );

END IF;






--- Изменение заявки ---
UPDATE t_auto_trip 
SET
t_trip_datetime=start_date,
t_trip_datetime_end=end_date,
t_duration=duration,
t_route=btrim(route),
t_object=btrim(object),
t_driver_kod=driver_kod,
t_auto_kod=auto_kod,
t_target=btrim(target),
t_traveler=btrim(traveler),
t_trailer=trailer,
t_chief_kod=chief_kod,
t_speedo1=speedo1,
t_speedo2=speedo2,
t_fuel=fuel,
t_status_kod=status_kod
WHERE t_rec_id=rec_id;





--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_editaplantrip(integer, character varying, timestamp without time zone, timestamp without time zone, integer, character varying, character varying, character varying, integer, character varying, character varying, character varying, character varying, integer, integer, numeric, integer, text) OWNER TO kisuser;

--
-- Name: t_editatasktrip(integer, character varying, timestamp without time zone, timestamp without time zone, character varying, character varying, integer, character varying, integer, text); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_editatasktrip(integer, character varying, timestamp without time zone, timestamp without time zone, character varying, character varying, integer, character varying, integer, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Изменение заявки на выезд ползователем , регистрация изменения статуса

*/


DECLARE

--- Код записи ---
rec_id ALIAS FOR $1;

--- Код пользователя ---
user_kod ALIAS FOR $2;

--- Дата и время ---
start_date ALIAS FOR $3;
end_date ALIAS FOR $4;


--- Маршрут ---
route ALIAS FOR $5;

--- Объект ---
object ALIAS FOR $6;

--- Код автомобиля  ---
auto_kod ALIAS FOR $7;

--- Цель ---
target ALIAS FOR $8;

--- Код стауса заявки ---
status_kod ALIAS FOR $9;

--- Комментарий к статусу ---
comment ALIAS FOR $10;

--- Код руководителя ---
chief_kod varchar(24);

--- Вспомогательная переменная ---
n int;
genk int;
status_trip int;

--- Продолжительность в часах ---
duration int;



BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 OR rec_id IS NULL THEN
	RETURN 'ERRORDATA';
END IF;


--- Дата и время заявки не может быть в прошлом ---
IF date(start_date)<current_date OR start_date>=end_date THEN
    RETURN 'NOTACCESS';
END IF;


--- Определение текущего статуса заявки ---
SELECT INTO status_trip t_status_kod FROM t_auto_trip WHERE t_rec_id=rec_id;
--- Для пользователя вносить изменения только для новой заявки ---
IF status_trip!=0 THEN
    RETURN 'NOTACCESS';
END IF;


--- Подписывать может только руководитель ЦФО ---
SELECT INTO n count(*) FROM t_auto_ruk_cfo_kod WHERE t_ruk_cfo_kod=user_kod;
IF n=0 AND status_kod=1 THEN
    RETURN 'NOTACCESS';
END IF;
IF n!=0 AND status_kod=1 THEN
    chief_kod := user_kod;
ELSE
    chief_kod := '';
END IF;



--- Продолжительность в часах
duration := round( (extract(epoch FROM end_date) - extract(epoch FROM start_date))/3600 );




--- Если устнавливаем новый статус - фиксируем историю изменений статусов ---
IF status_trip!=status_kod THEN

    --- Определение ключа ---
    SELECT INTO n count(*) FROM t_auto_status;
    IF n=0 THEN
	genk := 1;
    ELSE
	SELECT INTO genk max(t_rec_id)+1 FROM t_auto_status;
    END IF;

    --- Добавление истории смены статусов ---
    INSERT INTO t_auto_status (
    t_rec_id,
    t_auto_trip_kod,
    t_comment,
    t_status_kod,
    t_create_author
    )
    VALUES (
    genk,
    rec_id,
    btrim(comment),
    status_kod,
    user_kod
    );



END IF;






--- Изменение заявки ---
UPDATE t_auto_trip 
SET
t_trip_datetime=start_date,
t_trip_datetime_end=end_date,
t_duration=duration,
t_route=btrim(route),
t_object=btrim(object),
t_auto_kod=auto_kod,
t_chief_kod=chief_kod,
t_status_kod=status_kod,
t_target=btrim(target)
WHERE t_rec_id=rec_id;





--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_editatasktrip(integer, character varying, timestamp without time zone, timestamp without time zone, character varying, character varying, integer, character varying, integer, text) OWNER TO kisuser;

--
-- Name: t_editatasktrip2(integer, character varying, timestamp without time zone, integer, character varying, character varying, integer, character varying, character varying, integer, integer, numeric, integer, text); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_editatasktrip2(integer, character varying, timestamp without time zone, integer, character varying, character varying, integer, character varying, character varying, integer, integer, numeric, integer, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*


0;"Заказ"
1;"Подписан руководителем ЦФО"
2;"Выезд согласован"
3;"Заказ отклонен"
4;"Заказ отложен"
5;"Печать путевого листа"
6;"Выполнен"
7;"Плановый выезд"
8;"Отменен"


===================================================================================================
---- Изменение заявки на выезд со стороны административной группы , регистрация изменения статуса
===================================================================================================


Для уже установленных статусов Выезд согласован (2) и Печать путевого листа (5) 
- можно изменять только продолжительность, показания спидометра и расход топлива.



Изменение всего содержания заказа допустимо только для статуса Подписан или отложен 1,4



Список всех возможных для данной функции кодов устанавливаемого статуса : 2,3,4,5,6

*/


DECLARE

--- Код записи ---
rec_id ALIAS FOR $1;

--- Код пользователя ---
user_kod ALIAS FOR $2;

--- Дата и время ---
date_and_time ALIAS FOR $3;

--- Продолжительность в часах ---
duration ALIAS FOR $4;

--- Маршрут ---
route ALIAS FOR $5;

--- Объект ---
object ALIAS FOR $6;

--- Код автомобиля  ---
auto_kod ALIAS FOR $7;

--- Прицеп есть или нет ---
trailer ALIAS FOR $8;

--- Код водителя ---
driver_kod ALIAS FOR $9;

--- Спидометр ---
speedo1 ALIAS FOR $10;
speedo2 ALIAS FOR $11;

--- расход топлива ---
fuel ALIAS FOR $12;

--- Код стауса заявки ---
status_kod ALIAS FOR $13;

--- Комментарий к статусу ---
comment ALIAS FOR $14;





--- Вспомогательная переменная ---
n int;
genk int;
status_trip int;




BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 OR rec_id IS NULL THEN
    RETURN 'ERRORDATA';
END IF;


--- Определение текущего кода статуса заявки ---
SELECT INTO status_trip t_status_kod FROM t_auto_trip WHERE t_rec_id=rec_id;


--- Если заказ отменен или выполнен его уже не меняем! ---
IF status_trip=6 OR status_trip=8 THEN
    RETURN 'NOTACCESS';
END IF;


--- Дата и время заявки не может быть в прошлом если заказ еще не начал выполняться ---
IF date(date_and_time)<current_date AND status_trip=1 OR status_trip=4 THEN
    RETURN 'NOTACCESS';
END IF;



--- Если устнавливаем новый статус - фиксируем историю изменений статусов ---
IF status_trip!=status_kod AND (status_kod=2 OR status_kod=3 OR status_kod=4 OR status_kod=6) THEN

    --- Определение ключа ---
    SELECT INTO n count(*) FROM t_auto_status;
    IF n=0 THEN
    genk := 1;
    ELSE
    SELECT INTO genk max(t_rec_id)+1 FROM t_auto_status;
    END IF;

    --- Добавление истории смены статусов ---
    INSERT INTO t_auto_status (
    t_rec_id,
    t_auto_trip_kod,
    t_comment,
    t_status_kod,
    t_create_author
    )
    VALUES (
    genk,
    rec_id,
    btrim(comment),
    status_kod,
    user_kod
    );

END IF;




--- Для статусов 1,4,5 можно изменять весь заказ ---
IF status_trip=1 OR status_trip=4 THEN

    --- Изменение заявки ---
    UPDATE t_auto_trip 
    SET
    t_trip_datetime=date_and_time,
    t_duration=duration,
    t_route=btrim(route),
    t_object=btrim(object),
    t_auto_kod=auto_kod,
    t_trailer=trailer,
    t_driver_kod=driver_kod,
    t_status_kod=status_kod,
    t_speedo1=speedo1,
    t_speedo2=speedo2,
    t_fuel=fuel
    WHERE t_rec_id=rec_id;


ELSE
    UPDATE t_auto_trip 
    SET
    t_status_kod=status_kod,
    t_speedo1=speedo1,
    t_speedo2=speedo2,
    t_fuel=fuel
    WHERE t_rec_id=rec_id;



END IF;



--- Завершение ---
RETURN 'OK';



END;$_$;


ALTER FUNCTION public.t_editatasktrip2(integer, character varying, timestamp without time zone, integer, character varying, character varying, integer, character varying, character varying, integer, integer, numeric, integer, text) OWNER TO kisuser;

--
-- Name: t_editatasktrip2(integer, character varying, timestamp without time zone, timestamp without time zone, integer, character varying, character varying, integer, character varying, character varying, character varying, character varying, integer, integer, numeric, integer, text); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_editatasktrip2(integer, character varying, timestamp without time zone, timestamp without time zone, integer, character varying, character varying, integer, character varying, character varying, character varying, character varying, integer, integer, numeric, integer, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*


0;"Заказ"
1;"Подписан руководителем ЦФО"
2;"Выезд согласован"
3;"Заказ отклонен"
5;"Печать путевого листа"
6;"Выполнен"
7;"Плановый выезд"
8;"Отменен"


===================================================================================================
---- Изменение заявки на выезд со стороны административной группы , регистрация изменения статуса
===================================================================================================


Для уже установленных статусов Выезд согласован (2) и Печать путевого листа (5) 
- можно изменять только продолжительность, показания спидометра и расход топлива.



Изменение всего содержания заказа допустимо только для статуса Подписан или отложен 1,4



Список всех возможных для данной функции кодов устанавливаемого статуса : 2,3,4,5,6

*/


DECLARE

--- Код записи ---
rec_id ALIAS FOR $1;

--- Код пользователя ---
user_kod ALIAS FOR $2;

--- Дата и время ---
start_date ALIAS FOR $3;
end_date ALIAS FOR $4;

--- Продолжительность в часах ---
duration ALIAS FOR $5;

--- Маршрут ---
route ALIAS FOR $6;

--- Объект ---
object ALIAS FOR $7;

--- Код автомобиля  ---
auto_kod ALIAS FOR $8;

--- Цель ---
target ALIAS FOR $9;

--- Попутчик ---
traveler ALIAS FOR $10;

--- Прицеп есть или нет ---
trailer ALIAS FOR $11;

--- Код водителя ---
driver_kod ALIAS FOR $12;

--- Спидометр ---
speedo1 ALIAS FOR $13;
speedo2 ALIAS FOR $14;

--- расход топлива ---
fuel ALIAS FOR $15;

--- Код стауса заявки ---
status_kod ALIAS FOR $16;

--- Комментарий к статусу ---
comment ALIAS FOR $17;





--- Вспомогательная переменная ---
n int;
genk int;
status_trip int;




BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 OR rec_id IS NULL THEN
    RETURN 'ERRORDATA';
END IF;


IF start_date>=end_date THEN
    RETURN 'NOTACCESS';
END IF;


--- Определение текущего кода статуса заявки ---
SELECT INTO status_trip t_status_kod FROM t_auto_trip WHERE t_rec_id=rec_id;


--- Если заказ отменен или выполнен его уже не меняем! ---
IF status_trip=6 OR status_trip=8 THEN
    RETURN 'NOTACCESS';
END IF;


--- Дата и время заявки не может быть в прошлом если заказ еще не начал выполняться ---
IF date(start_date)<current_date AND status_trip=1 OR status_trip=4 THEN
    RETURN 'NOTACCESS';
END IF;



--- Если устнавливаем новый статус - фиксируем историю изменений статусов ---
IF status_trip!=status_kod AND (status_kod=2 OR status_kod=3 OR status_kod=4 OR status_kod=6) THEN

    --- Определение ключа ---
    SELECT INTO n count(*) FROM t_auto_status;
    IF n=0 THEN
    genk := 1;
    ELSE
    SELECT INTO genk max(t_rec_id)+1 FROM t_auto_status;
    END IF;

    --- Добавление истории смены статусов ---
    INSERT INTO t_auto_status (
    t_rec_id,
    t_auto_trip_kod,
    t_comment,
    t_status_kod,
    t_create_author
    )
    VALUES (
    genk,
    rec_id,
    btrim(comment),
    status_kod,
    user_kod
    );

END IF;




--- Для статусов 1,4,5 можно изменять весь заказ ---
IF status_trip=1 OR status_trip=4 THEN

    --- Изменение заявки ---
    UPDATE t_auto_trip 
    SET
    t_trip_datetime=start_date,
    t_trip_datetime_end=end_date,
    t_duration=duration,
    t_route=btrim(route),
    t_object=btrim(object),
    t_auto_kod=auto_kod,
    t_target=btrim(target),
    t_traveler=btrim(traveler),
    t_trailer=trailer,
    t_driver_kod=driver_kod,
    t_status_kod=status_kod,
    t_speedo1=speedo1,
    t_speedo2=speedo2,
    t_fuel=fuel
    WHERE t_rec_id=rec_id;


ELSE
    UPDATE t_auto_trip 
    SET
    t_status_kod=status_kod,
    t_speedo1=speedo1,
    t_speedo2=speedo2,
    t_fuel=fuel
    WHERE t_rec_id=rec_id;



END IF;



--- Завершение ---
RETURN 'OK';



END;$_$;


ALTER FUNCTION public.t_editatasktrip2(integer, character varying, timestamp without time zone, timestamp without time zone, integer, character varying, character varying, integer, character varying, character varying, character varying, character varying, integer, integer, numeric, integer, text) OWNER TO kisuser;

--
-- Name: t_editd(integer, character varying, character varying, text); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_editd(integer, character varying, character varying, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$


/*

Редактирование заявки

*/



DECLARE


--- Код записи ---
rec_id ALIAS FOR $1;

--- Контрагент ---
contragent ALIAS FOR $2;

--- Тема ---
tema ALIAS FOR $3;

--- Текст заявки  ---
task_text ALIAS FOR $4;

--- Вспомогательная переменная ---
n int;

--- Статус заявки ---
status int;



BEGIN


--- Проверка поступивших данных на корректность ---
IF rec_id IS NULL OR length(contragent)=0 OR length(tema)=0 OR length(task_text)=0 THEN
	RETURN 'ERRORDATA';
END IF;


SELECT INTO status t_dstatus_kod FROM t_d WHERE t_rec_id=rec_id;
IF status!=0 THEN
    RETURN 'NOTACCESS';
END IF;



UPDATE t_d
SET
t_contragent=btrim(contragent),
t_tema=btrim(tema),
t_d_text=btrim(task_text)
WHERE t_rec_id=rec_id;



RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_editd(integer, character varying, character varying, text) OWNER TO kisuser;

--
-- Name: t_editstorename(integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_editstorename(integer, character varying, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Редактирует Склад

*/


DECLARE


--- Код записи ---
store_id ALIAS FOR $1;

--- Код пользователя ---
user_kod ALIAS FOR $2;

--- Название склада ---
name ALIAS FOR $3;

--- Вспомогательная переменная ---
n int;
genk int;



BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 OR length(name)=0 OR store_id IS NULL THEN
	RETURN 'ERRORDATA';
END IF;


--- Проверка : есть ли склад с тем же названием ---
SELECT INTO n count(*) FROM t_store_list WHERE btrim(t_store_name)=btrim(name) AND t_rec_id!=store_id;
IF n != 0 THEN
    RETURN 'ERRORDATA';
END IF;


UPDATE t_store_list
SET
t_store_name=btrim(name),
t_edit_user=user_kod,
t_edit_date=current_date
WHERE
t_rec_id=store_id;



--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_editstorename(integer, character varying, character varying) OWNER TO kisuser;

--
-- Name: t_edittmcspec(character varying, character varying, character varying, integer, numeric, numeric, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_edittmcspec(character varying, character varying, character varying, integer, numeric, numeric, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Редактирует содержимое заявки ТМЦ

*/


DECLARE


--- Код учетной записи пользователя ---
user_kod ALIAS FOR $1;

--- Код строки ---
rec_id ALIAS FOR $2;

--- Наименование строки ---
row_name ALIAS FOR $3;

--- ОКЕИ ---
row_okei ALIAS FOR $4;

--- Количество ---
row_q ALIAS FOR $5;

--- Стоимость ---
row_cost ALIAS FOR $6;

--- Аналог ---
row_analog ALIAS FOR $7;

--- Автор ---
author_kod varchar(24);

--- Номер заявки ---
tmc_kod int;

--- Вспомогательная переменная ---
n int;





BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 OR length(rec_id)=0 OR length(row_name)=0 OR row_q<=0.00 OR row_cost<0.00 THEN
	RETURN 'ERRORDATA';
END IF;



--- Кто создал, тот и исправляет ---
SELECT INTO tmc_kod t_tmc_kod FROM t_tmc_spec WHERE t_rec_id=rec_id;
SELECT INTO author_kod t_author_kod FROM t_tmc WHERE t_rec_id=tmc_kod;
IF author_kod != user_kod THEN
    RETURN 'NOTACCESS';
END IF;


--- Изменение строки ---
UPDATE t_tmc_spec
SET
t_row_name=btrim(row_name),
t_row_okei_kod=row_okei,
t_row_q=row_q,
t_row_cost=row_cost,
t_row_analog=btrim(row_analog),
t_update_author=user_kod,
t_update_time=current_timestamp
WHERE
t_rec_id=rec_id;


--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_edittmcspec(character varying, character varying, character varying, integer, numeric, numeric, character varying) OWNER TO kisuser;

--
-- Name: t_genkey24(); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_genkey24() RETURNS character varying
    LANGUAGE plpgsql
    AS $$

DECLARE
-- объявления переменных 
SessionKey varchar(24); 
LengthOfKey integer;
i integer;
j integer;
tmp integer;
Symbol varchar(1);

BEGIN
-- начальная инициализация 
i:=1;
-- Создание численной части ключа функцией current_timestamp
SessionKey := to_char(current_timestamp,'MISSMSSSSSUS');
LengthOfKey:=length(SessionKey);
-- цикл добавления случайных символов
WHILE i <= (24-LengthOfKey) LOOP  
	-- выборка случайных чисел из интервалов {48-57},{65-90},{97-122}
	j:=trunc(random()*3+1);
	if j=1 then
		tmp:=trunc(random()*9+48);
	else
		if j=2 then
			tmp:=trunc(random()*25+65);
		else
			tmp:=trunc(random()*25+97);
		end if;
	end if;
	-- получение случайного символа функцией chr()
	Symbol:=chr(tmp);
	-- добавление случайного символа
	SessionKey:=SessionKey||Symbol;
	i := i + 1;
END LOOP;  
-- возврат результата
RETURN SessionKey; 
END;$$;


ALTER FUNCTION public.t_genkey24() OWNER TO kisuser;

--
-- Name: t_genkey8(); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_genkey8() RETURNS character varying
    LANGUAGE plpgsql
    AS $$

/*

Формирует 8-ти символьный числовой ключ

*/


DECLARE


genk varchar(8);



BEGIN


genk := substr(btrim(to_char(trunc(random()*9999999999999+1),'999999999999999')),1,8);

--- В случае успеха возврат кода ---
RETURN genk;


END;$$;


ALTER FUNCTION public.t_genkey8() OWNER TO kisuser;

--
-- Name: t_loadapp(character varying, integer, character varying, character varying, bytea); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_loadapp(character varying, integer, character varying, character varying, bytea) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Загружает файл приложение к договору

*/


DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Номер заявки ---
d_id ALIAS FOR $2;

--- Наименование файла ---
file_name ALIAS FOR $3;

--- Расширение файла ---
file_ext ALIAS FOR $4;

--- Собственно сам файл ---
docs_data ALIAS FOR $5;

--- Статус заявки ---
d_status_kod int;

--- Версия договора ---
ver int;

--- Вспомогательная переменная ---
n int;





BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 OR length(file_name)=0 OR length(file_ext)=0 THEN
	RETURN 'ERRORDATA';
END IF;



--- Определение статуса заявки ---
SELECT INTO d_status_kod t_dstatus_kod FROM t_d WHERE t_rec_id=d_id;
--- Загружать версию договора можно только для статусов 8,3 ---
IF d_status_kod!=3 AND d_status_kod!=8 THEN
	RETURN 'NOTACCESS';
END IF;


--- Загрузка файла ---
UPDATE
t_d
SET
t_app_data=docs_data,
t_app_ext=btrim(file_ext),
t_app_filename=btrim(file_name),
t_app_time=current_timestamp,
t_app_author=user_kod
WHERE
t_rec_id=d_id;



--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_loadapp(character varying, integer, character varying, character varying, bytea) OWNER TO kisuser;

--
-- Name: t_loaddocs(character varying, integer, character varying, character varying, bytea); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_loaddocs(character varying, integer, character varying, character varying, bytea) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Загружает файл очередной версии договора

*/


DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Номер заявки ---
d_id ALIAS FOR $2;

--- Наименование файла ---
file_name ALIAS FOR $3;

--- Расширение файла ---
file_ext ALIAS FOR $4;

--- Собственно сам файл ---
docs_data ALIAS FOR $5;

--- Статус заявки ---
d_status_kod int;

--- Версия договора ---
ver int;

--- Вспомогательная переменная ---
n int;





BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 OR length(file_name)=0 OR length(file_ext)=0 THEN
	RETURN 'ERRORDATA';
END IF;



--- Определение статуса заявки ---
SELECT INTO d_status_kod t_dstatus_kod FROM t_d WHERE t_rec_id=d_id;
--- Загружать версию договора можно только для статусов 8,3 ---
IF d_status_kod!=3 AND d_status_kod!=8 THEN
	RETURN 'NOTACCESS';
END IF;


--- Принудительная запись кода статуса "Договор не согласован" ---
UPDATE
t_d
SET
t_dstatus_kod=3
WHERE
t_rec_id=d_id;


--- Версия договора ---
SELECT INTO ver t_doc_ver+1 FROM t_d WHERE t_rec_id=d_id; 



--- Загрузка файла ---
UPDATE
t_d
SET
t_doc_data=docs_data,
t_ext=btrim(file_ext),
t_file_name=btrim(file_name),
t_doc_ver=ver,
t_doc_time=current_timestamp::timestamp,
t_doc_author=user_kod
WHERE
t_rec_id=d_id;



--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_loaddocs(character varying, integer, character varying, character varying, bytea) OWNER TO kisuser;

--
-- Name: t_loadeisupkod(character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_loadeisupkod(character varying, character varying, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Загрузка номенклатуры ЕИСУП списком

*/


DECLARE


--- Код  ---
kod ALIAS FOR $1;

--- Название ---
name ALIAS FOR $2;

--- Вид номенклатуры ---
name_type ALIAS FOR $3;

--- Вспомогательная переменная ---
n int;


BEGIN


--- Проверка поступивших данных на корректность ---
IF length(kod)=0 OR length(name)=0 THEN
	RETURN 'ERRORDATA';
END IF;



--- Определение существует ли уже такая номенклатура ---
SELECT INTO n count(*) FROM t_store_eisup_list WHERE t_rec_id=btrim(kod);
IF n=0 THEN
    INSERT INTO t_store_eisup_list (t_rec_id,t_name,t_name_type) VALUES(btrim(kod),btrim(name),btrim(name_type));
END IF;


--- Формирование записи остатков для шт. ---
SELECT INTO n count(*) FROM t_store_total_rest WHERE t_rec_id=btrim(kod) AND t_okei_kod=796;
IF n = 0 THEN
    INSERT INTO t_store_total_rest(t_rec_id,t_okei_kod) VALUES(btrim(kod),796);
END IF;


--- Формирование записи резервов для шт. ---
SELECT INTO n count(*) FROM t_store_total_reserve WHERE t_rec_id=btrim(kod) AND t_okei_kod=796;
IF n = 0 THEN
    INSERT INTO t_store_total_reserve(t_rec_id,t_okei_kod) VALUES(btrim(kod),796);
END IF;


--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_loadeisupkod(character varying, character varying, character varying) OWNER TO kisuser;

--
-- Name: t_newd(character varying, character varying, character varying, text); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_newd(character varying, character varying, character varying, text) RETURNS text
    LANGUAGE plpgsql
    AS $_$


/*

Создание новой заявки

*/



DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Контрагент ---
contragent ALIAS FOR $2;

--- Тема ---
tema ALIAS FOR $3;

--- Текст заявки  ---
task_text ALIAS FOR $4;

--- Вспомогательная переменная ---
n int;

--- Номер заявки ---
genk int;


BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 OR length(contragent)=0 OR length(tema)=0 OR length(task_text)=0 THEN
	RETURN 'ERRORDATA';
END IF;

--- Определение номера заявки ---
SELECT INTO n count(*) FROM t_d;
IF n=0 THEN
    genk := 1;
ELSE
    SELECT INTO genk max(t_rec_id)+1 FROM t_d;
END IF;


INSERT INTO t_d 
(t_rec_id,t_contragent,t_tema,t_d_text,t_create_author) 
VALUES(genk,btrim(contragent),btrim(tema),btrim(task_text),user_kod);


RETURN btrim(to_char(genk,'9999'));


END;$_$;


ALTER FUNCTION public.t_newd(character varying, character varying, character varying, text) OWNER TO kisuser;

--
-- Name: t_newdstatus(character varying, integer, text, integer); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_newdstatus(character varying, integer, text, integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Установка нового статуса заявки на договор
(кроме процесса согласования - коды 2,3)

*/


DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Номер заявки ---
d_id ALIAS FOR $2;

--- Коментарий ---
comment ALIAS FOR $3;

--- Код статуса ---
status_kod ALIAS FOR $4;


--- Вспомогательная переменная ---
n int;

--- Сгенерированный уникальный ключ ---
genk varchar(24);




BEGIN

--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 THEN
	RETURN 'ERRORDATA';
END IF;


IF status_kod=2 OR status_kod=3 THEN
    RETURN 'NOTACCESS';
END IF;



--- Определение уникального ключа ---
n := 1;
WHILE n!=0 LOOP
    genk := t_GenKey24();
    SELECT INTO n count(*) FROM t_d_status WHERE t_rec_id=genk;
END LOOP;


--- Добавление записи ---
INSERT INTO 
t_d_status(
t_rec_id,
t_d_kod,
t_dstatus_kod,
t_comment,
t_create_author
) 
VALUES(
genk,
d_id,
status_kod,
btrim(comment),
user_kod
);


--- Регистрация статуса заявки в самой заявке --
IF status_kod!=6 THEN
UPDATE t_d SET t_dstatus_kod=status_kod WHERE t_rec_id=d_id;
END IF;


--- Фиксируем подписавшего если status_kod=1 --
IF status_kod=1 THEN

    UPDATE t_d
    SET
    t_ruk_kod=user_kod
    WHERE
    t_rec_id=d_id;

END IF;


--- Если заявку отменяем - то подчищаем очередь следующих согласующих по этой заявке ---
IF status_kod=7 THEN

    DELETE FROM t_d_person_next WHERE t_d_kod=d_id;

END IF;




--- Если заявка подписывается , то на всякий случай удаляем список согласующих по этой заявке ---
IF status_kod=1 THEN
    
    DELETE FROM t_d_person WHERE t_d_kod=d_id;
    ---UPDATE t_d_person SET t_rec_delete=1 WHERE t_d_kod=d_id;

END IF;


--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_newdstatus(character varying, integer, text, integer) OWNER TO kisuser;

--
-- Name: t_newdstatusperson(character varying, integer, text, integer); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_newdstatusperson(character varying, integer, text, integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Установка нового статуса заявки на договор (для кодов 3 и 2)

*/


DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Номер заявки ---
d_id ALIAS FOR $2;

--- Коментарий ---
comment ALIAS FOR $3;

--- Код статуса ---
status_kod ALIAS FOR $4;

--- Текущий статус заявки ---
d_status_kod int;

--- Вспомогательная переменная ---
n int;

--- Сгенерированный уникальный ключ ---
genk varchar(24);

--- Версия договора ---
ver int;

--- Дата загрузки версии договора --- 
ver_date date;

--- Количество согласовавших текущую версию ---
person_ver int;

--- Дата и время загруженного приложения ---
app_time timestamp;

--- Код пользователя, кто сейчас должен согласовывать ---
agre_user varchar(24);

--- Код следующего пользователя ---
next_user_kod varchar(24);

--- С какого времени считать задержку в днях ---
start_time timestamp;

--- Задержка дней ---
days int;


BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 THEN
	RETURN 'ERRORDATA';
END IF;

--- Обрабатываем только коды статусов 2 и 3 ---
IF status_kod!=2 AND status_kod!=3  THEN
	RETURN 'NOTACCESS';
END IF;


--- Определение статуса заявки на договор  ---
SELECT INTO d_status_kod t_dstatus_kod FROM t_d WHERE t_rec_id=d_id;


--- Проверка очередности пользователя : первый в очереди или нет ---
SELECT INTO n count(*) FROM t_d_person_next WHERE t_d_kod=d_id AND t_user_kod=user_kod;
IF n=0 THEN
	RETURN 'NOTACCESS';
END IF;


--- Определение уникального ключа ---
n := 1;
WHILE n!=0 LOOP
    genk := t_GenKey24();
    SELECT INTO n count(*) FROM t_d_status WHERE t_rec_id=genk;
END LOOP;


--- Определение текущей версии загруженного договора ---
SELECT INTO ver t_doc_ver FROM t_d WHERE t_rec_id=d_id;


--- Добавление записи ---
INSERT INTO 
t_d_status(
t_rec_id,
t_d_kod,
t_dstatus_kod,
t_comment,
t_create_author
) 
VALUES(
genk,
d_id,
status_kod,
btrim(comment),
user_kod
);



-------------------------------
--- Расчет задержки в днях ---
-------------------------------
--- Если этот согласующий уже "высказал" свое мнение ранее , то количество дней задержки не меняем : берем из записи согласующих ---
SELECT INTO n count(*) FROM t_d_person WHERE t_rec_delete=0 AND t_d_kod=d_id AND t_person_kod=user_kod AND (t_dstatus_kod=2 OR t_dstatus_kod=3);
IF n=0 THEN
    SELECT INTO start_time t_start_time FROM t_d_person_next WHERE t_d_kod=d_id;
    days := EXTRACT (DAYS FROM (current_timestamp - start_time));
ELSE
    SELECT INTO days t_lag_day FROM t_d_person WHERE t_rec_delete=0 AND t_d_kod=d_id AND t_person_kod=user_kod;
END IF;


--- Определение даты загруженной версии договора ---
SELECT INTO ver_date date(t_doc_time) FROM t_d WHERE t_rec_id=d_id;

--- Определение есть ли подгруженное приложение к заявке ---
SELECT INTO n count(*) FROM t_d WHERE t_rec_id=d_id AND t_app_time IS NOT NULL;
IF n!=0 THEN
    SELECT INTO app_time t_app_time FROM t_d WHERE t_rec_id=d_id;


    --- Регистрация мнения в списке согласующих ---
    UPDATE t_d_person
    SET
    t_dstatus_kod=status_kod,
    t_ver=ver,
    t_dstatus_date=current_date,
    t_lag_day=days,
    t_app_time=app_time
    WHERE
    t_d_kod=d_id AND
    t_person_kod=user_kod;

ELSE
	--- Регистрация мнения в списке согласующих ---
    UPDATE t_d_person
    SET
    t_dstatus_kod=status_kod,
    t_ver=ver,
    t_dstatus_date=current_date,
    t_lag_day=days
    WHERE
    t_d_kod=d_id AND
    t_person_kod=user_kod;
END IF;








-------------------------------------------------------------
--- Принятие решение : версия договора согласована или нет ---
--- Общее количество согласующих по заяве ---
SELECT INTO n count(*) FROM t_d_person WHERE t_rec_delete=0 AND t_d_kod=d_id;
--- Количество согласовавших ---
SELECT INTO person_ver count(*) FROM t_d_person WHERE t_rec_delete=0 AND t_d_kod=d_id AND t_dstatus_kod=2;

--- Если все "За" меняем статус заявки ---
IF person_ver=n THEN
    UPDATE t_d
    SET
    t_dstatus_kod=2
    WHERE
    t_rec_id=d_id;
END IF;



--- Определение следующего согласующего ---
SELECT INTO n count(*) FROM t_d_person WHERE t_rec_delete=0 AND t_d_kod=d_id AND (t_dstatus_kod IS NULL OR t_dstatus_kod=3);
IF n=0 THEN
    DELETE FROM t_d_person_next WHERE t_d_kod=d_id;
    RETURN 'OK';
END IF;

SELECT INTO next_user_kod t_person_kod FROM t_d_person WHERE t_rec_delete=0 AND t_d_kod=d_id AND (t_dstatus_kod IS NULL OR t_dstatus_kod=3) ORDER BY t_order_agremnt LIMIT 1;

--- Такой следующий уже есть? ---
SELECT INTO n count(*) FROM t_d_person_next WHERE t_d_kod=d_id AND t_user_kod=next_user_kod;
IF n=0 THEN
    --- Добавление записи ---
    DELETE FROM t_d_person_next WHERE t_d_kod=d_id;
    INSERT INTO t_d_person_next (t_d_kod,t_user_kod) VALUES(d_id,next_user_kod);
END IF;




--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_newdstatusperson(character varying, integer, text, integer) OWNER TO kisuser;

--
-- Name: t_newittaskself(character varying, text, character varying, integer, integer, character varying, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_newittaskself(character varying, text, character varying, integer, integer, character varying, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$


/*

Регистрирует новую IT заявку из модуля ItHelpDesk

*/



DECLARE


--- Тема заявки ---
tema ALIAS FOR $1;

--- Текст заявки ---
task_text ALIAS FOR $2;

--- Код исполнителя ---
isp_kod ALIAS FOR $3;

--- Категория ---
category_kod ALIAS FOR $4;

--- Трудоемкость ---
working ALIAS FOR $5; 

--- Код пользователя ---
user_kod ALIAS FOR $6;

--- IP адрес ---
ip ALIAS FOR $7;

--- Фамилия - имя ---
person varchar(100);

--- Вн.телефон ---
phone varchar(50);

--- Email ---
email varchar(100);

--- Сгенерированный код заявки ---
genk varchar(8);
s int;

--- Вспомогательная переменная ---
n int;




BEGIN


--- Проверка поступивших данных на корректность ---
IF length(task_text)=0 OR length(tema)=0 OR length(user_kod)=0 OR length(ip)=0 THEN
	RETURN 'ERRORDATA';
END IF;


--- Определение имени-фамилии, телефона ---
SELECT INTO person,phone,email t_user_name1||' '||t_user_name2||' '||t_user_name3,t_phone_shot,t_email FROM t_user_kis WHERE t_rec_id=user_kod;


--- Первоначально такой уникальный ключ существует ---
n:=1;
--- Получение уникального ключа ---
WHILE n<>0 LOOP	
	genk := t_GenKey8();
	SELECT INTO n count(*) FROM t_it_task WHERE t_rec_id=genk;
END LOOP;


--- Порядковый номер ---
SELECT INTO n count(*) FROM t_it_task;
IF n=0 THEN
    s := 1;
ELSE
    SELECT INTO s max(t_serial_n)+1 FROM t_it_task;
END IF;


--- Добавление записи ---
INSERT INTO t_it_task(
t_rec_id,
t_text,
t_ip,
t_phone,
t_email,
t_person,
t_tema,
t_itkategory_kod,
t_workhour,
t_isp_kod,
t_serial_n,
t_user_kod
)
VALUES (
genk,
btrim(task_text),
btrim(ip),
btrim(phone),
btrim(email),
btrim(person),
btrim(tema),
category_kod,
working,
isp_kod,
s,
user_kod
);


--- Завершение ---
RETURN 'OK:'||genk;


END;$_$;


ALTER FUNCTION public.t_newittaskself(character varying, text, character varying, integer, integer, character varying, character varying) OWNER TO kisuser;

--
-- Name: t_newittaskuser(character varying, text, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_newittaskuser(character varying, text, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$


/*

Регистрирует новую IT заявку (для авторизованного пользователя)

*/



DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Текст заявки ---
task_text ALIAS FOR $2;

--- IP адрес ---
ip ALIAS FOR $3;

--- Телефон ---
phone varchar(50);

--- email ---
email varchar(100);

--- ФИО ---
person varchar(100);

--- Сгенерированный код заявки ---
genk varchar(8);

--- Вспомогательная переменная ---
n int;
s int;



BEGIN


--- Проверка поступивших данных на корректность ---
IF length(task_text)=0 OR length(user_kod)=0 THEN
	RETURN 'ERRORDATA';
END IF;


--- Заполнение необходимых данных по коду пользователя ---
SELECT INTO phone,email,person t_phone_shot,t_email,t_user_name1||' '||t_user_name2||' '||t_user_name3 FROM t_user_kis WHERE t_rec_id=user_kod;


IF length(email)=0 THEN
    RETURN 'ERRORDATA';
END IF;



--- Первоначально такой уникальный ключ существует ---
n:=1;
--- Получение уникального ключа ---
WHILE n<>0 LOOP	
	genk := t_GenKey8();
	SELECT INTO n count(*) FROM t_it_task WHERE t_rec_id=genk;
END LOOP;


--- Номер ---
SELECT INTO n count(*) FROM t_it_task;
IF n=0 THEN
    s := 1;
ELSE
    SELECT INTO s max(t_serial_n)+1 FROM t_it_task;
END IF;


--- Добавление записи ---
INSERT INTO t_it_task(
t_rec_id,
t_serial_n,
t_text,
t_ip,
t_phone,
t_email,
t_person,
t_user_kod)
VALUES (
genk,
s,
btrim(task_text),
btrim(ip),
btrim(phone),
btrim(email),
btrim(person),
user_kod);


--- Завершение ---
RETURN 'OK:'||genk;


END;$_$;


ALTER FUNCTION public.t_newittaskuser(character varying, text, character varying) OWNER TO kisuser;

--
-- Name: t_neworder(integer, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_neworder(integer, character varying, character varying, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Создает внутренний заказ на основе заявки ТМЦ

*/


DECLARE



--- Номер заявки ТМЦ ---
tmc_id ALIAS FOR $1;

--- Проект ---
project ALIAS FOR $2;

--- Код учетной записи пользователя ---
user_kod ALIAS FOR $3;

--- Код учетной записи исполнителя ---
executor_kod ALIAS FOR $4;



--- Переменная для хранения данных записи ---
r record;


--- Вспомогательная переменная ---
n int;

--- Новый ключ записи ---
nn int;



BEGIN


--- Проверка поступивших данных на корректность ---
IF length(project)=0 OR length(user_kod)=0 OR length(executor_kod)=0 OR tmc_id IS NULL THEN
	RETURN 'ERRORDATA';
END IF;


--- Определение номера внутреннено заказа ---
SELECT INTO n count(*) FROM t_order;
IF n=0 THEN
    nn := 190;
ELSE
    SELECT INTO nn max(t_rec_id)+1 FROM t_order;
END IF;



--- Формирование записи заказа ---
INSERT INTO t_order(
t_rec_id,
t_tmc_kod,
t_project_name,
t_order_author_kod,
t_executor_kod
)
VALUES(
nn,
tmc_id,
btrim(project),
user_kod,
executor_kod
);




--- Формирование списка ---
FOR r IN (SELECT * FROM t_tmc_spec WHERE t_rec_delete=0 AND t_tmc_kod=tmc_id) LOOP

	INSERT INTO 
	t_order_spec(
	t_order_kod,
	t_spec_kod,
	t_q
	)
	VALUES(
	nn,
	r.t_rec_id,
	r.t_row_q
	);
    

END LOOP;

RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_neworder(integer, character varying, character varying, character varying) OWNER TO kisuser;

--
-- Name: t_newstatusittask(character varying, character varying, character varying, character varying, text, integer, integer, character varying, character varying, character varying, bytea, integer); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_newstatusittask(character varying, character varying, character varying, character varying, text, integer, integer, character varying, character varying, character varying, bytea, integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Изменяет статус и категорию IT заявки, добавляет комментарий

*/


DECLARE


--- Код пользователя ---
user_id ALIAS FOR $1;

--- Код заявки ---
task_kod ALIAS FOR $2;

--- Тема заявки ---
tema ALIAS FOR $3;

--- Код исполнителя ---
isp_kod ALIAS FOR $4;

--- Комментарий к заявке ---
task_comment ALIAS FOR $5;

--- Код статуса ---
status_kod ALIAS FOR $6;

--- Код статуса ---
kategory_kod ALIAS FOR $7;

--- IP адрес ---
ip ALIAS FOR $8;

--- Название файла ---
file_name ALIAS FOR $9;

--- Расширение файла ---
file_ext ALIAS FOR $10;

--- Содержание файла ---
file_data ALIAS FOR $11;

--- Трудозатраты ---
workhour ALIAS FOR $12;

--- Вспомогательная переменная ---
n int;

--- Вспомогательная переменная ---
genk varchar(24);
genk2 varchar(24);

--- Номер ДРП ---
drp int;




BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_id)=0 OR length(task_kod)=0 OR length(tema)=0 OR length(ip)=0 THEN
	RETURN 'ERRORDATA';
END IF;



--- Создание уникального ключа ---
n := 1;
WHILE n!=0 LOOP
    genk := t_GenKey24();
    SELECT INTO n count(*) FROM t_it_task_work WHERE t_rec_id=genk;
END LOOP;


--- Определение ДРП ---
SELECT INTO n count(*) FROM t_it_task_work WHERE t_it_task_kod=task_kod;
IF n=0 THEN
    drp := 1;
ELSE
    SELECT INTO drp max(t_drp)+1 FROM t_it_task_work WHERE t_it_task_kod=task_kod;
END IF;



--- Изменение статуса и категории заявки ---
UPDATE t_it_task
SET
t_itstatus_kod=status_kod,
t_itkategory_kod=kategory_kod,
t_tema=btrim(tema),
t_isp_kod=isp_kod,
t_workhour=workhour
WHERE
t_rec_id=task_kod;


--- Добавление записи ---
INSERT INTO t_it_task_work(
t_rec_id,
t_it_task_kod,
t_comment,
t_itstatus_kod,
t_itkategory_kod,
t_author_kod,
t_ip,
t_drp)
VALUES (
genk,
task_kod,
btrim(task_comment),
status_kod,
kategory_kod,
user_id,
btrim(ip),
drp);




--- Добавление файла к записи если файл есть ---
IF file_name!='' THEN

--- Определение уникального ключа ---
n := 1;
WHILE n!=0 LOOP
    genk2 := t_GenKey24();
    SELECT INTO n count(*) FROM t_it_docs WHERE t_rec_id=genk2;
END LOOP;

--- Добавление записи ---
INSERT INTO 
t_it_docs(
t_rec_id,
t_it_task_kod,
t_task_work_kod,
t_ext,
t_filename,
t_ip,
t_data
) 
VALUES(
genk,
task_kod,
genk,
btrim(file_ext),
btrim(file_name),
btrim(ip),
file_data
);
END IF;



--- Завершение ---
RETURN 'OK:'||genk;


END;$_$;


ALTER FUNCTION public.t_newstatusittask(character varying, character varying, character varying, character varying, text, integer, integer, character varying, character varying, character varying, bytea, integer) OWNER TO kisuser;

--
-- Name: t_newtmc(character varying, character varying, text, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_newtmc(character varying, character varying, text, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Добавляет новую заявку ТМЦ 

*/


DECLARE


--- Код учетной записи пользователя ---
user_kod ALIAS FOR $1;

--- Тема заявки ---
tmc_tema ALIAS FOR $2;

--- Описание заявки ---
tmc_text ALIAS FOR $3;

--- Группа ТМЦ ---
grouptmc ALIAS FOR $4;


--- Код дирекции ---
dep_kod int;

--- Код группы дирекции ---
dep_group_kod int;

--- Вспомогательная переменная ---
n int;

--- Новый ключ записи ---
nn int;



BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 OR length(tmc_text)=0 THEN
	RETURN 'ERRORDATA';
END IF;


--- Получение уникального ключа ---
SELECT INTO n count(*) FROM t_tmc;
IF n=0 THEN
    nn := 1;
ELSE
    SELECT INTO nn max(t_rec_id)+1 FROM t_tmc;
END IF;



--- Добавление записи ---
INSERT INTO t_tmc(
t_rec_id,
t_author_kod,
t_note_text,
t_tema,
t_grouptmc
)
VALUES (
nn,
user_kod,
btrim(tmc_text),
substr(btrim(tmc_tema),1,99),
btrim(grouptmc)
);


--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_newtmc(character varying, character varying, text, character varying) OWNER TO kisuser;

--
-- Name: t_newtmcstatus(character varying, integer, text, integer); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_newtmcstatus(character varying, integer, text, integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Установка нового статуса заявки ТМЦ

*/


DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Номер заявки ---
tmc_id ALIAS FOR $2;

--- Коментарий ---
comment_tmc ALIAS FOR $3;

--- Код статуса ---
status_kod ALIAS FOR $4;

--- Текущий код статуса заявки ---
tmc_status_kod int;

--- Вспомогательная переменная ---
n int;

--- Сгенерированный уникальный ключ ---
genk varchar(24);

--- Дата и время задания прошлого статуса ---
last_status timestamp;

--- Код записи прошлого статуса ---
last_rec_id varchar(24);


BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 THEN
	RETURN 'ERRORDATA';
END IF;


--- Определение статуса заявки ТМЦ  ---
SELECT INTO tmc_status_kod t_status_kod FROM t_tmc WHERE t_rec_id=tmc_id;
--- Повторно вводить тот же статус нельзя --- 
IF tmc_status_kod=status_kod AND status_kod!=16 THEN
	RETURN 'NOTACCESS';
END IF;


--- Нефиг подписывать заявки с пустым содержимым ---
IF status_kod = 1 THEN
    SELECT INTO n count(*) FROM t_tmc_spec WHERE t_tmc_kod=tmc_id AND t_rec_delete=0;
    IF n = 0 THEN
	RETURN 'ERRORDATA';
    END IF;
END IF;


--- Определение уникального ключа ---
n := 1;
WHILE n!=0 LOOP
    genk := t_GenKey24();
    SELECT INTO n count(*) FROM t_tmc_status_history WHERE t_rec_id=genk;
END LOOP;




--- Определение количество дней статуса ---
SELECT INTO n count(*) FROM t_tmc_status_history WHERE t_rec_delete=0 AND t_tmc_kod=tmc_id;
IF n!=0 THEN
    SELECT INTO last_rec_id,last_status t_rec_id,t_create_time FROM t_tmc_status_history WHERE t_rec_delete=0 AND t_tmc_kod=tmc_id ORDER BY t_create_time DESC LIMIT 1;

    --- Добавление записи ---
    INSERT INTO 
    t_tmc_status_history(
    t_rec_id,
    t_tmc_kod,
    t_tmc_status_kod,
    t_comment,
    t_author_kod
    ) 
    VALUES(
    genk,
    tmc_id,
    status_kod,
    btrim(comment_tmc),
    user_kod
    );

    UPDATE
    t_tmc_status_history
    SET
    t_day_status=current_date-date(last_status)
    WHERE
    t_rec_id=last_rec_id;



ELSE
    --- Добавление записи ---
    INSERT INTO 
    t_tmc_status_history(
    t_rec_id,
    t_tmc_kod,
    t_tmc_status_kod,
    t_comment,
    t_author_kod
    ) 
    VALUES(
    genk,
    tmc_id,
    status_kod,
    btrim(comment_tmc),
    user_kod
    );
    

END IF;



--- Код 16 это Комментарий, менять статус заявки не нужно ---
IF status_kod!=16 THEN

    IF status_kod=1 THEN
	--- Запись нового статуса в заявке ---
	UPDATE t_tmc
	SET 
	t_status_kod=status_kod,
	t_date_ruk=current_date,
	t_ruk_kod=user_kod,
	t_date_status=current_date
	WHERE
	t_rec_id=tmc_id;
    ELSE
	--- Запись нового статуса в заявке ---
	UPDATE t_tmc
	SET t_status_kod=status_kod,
	t_date_status=current_date
	WHERE
	t_rec_id=tmc_id;
    END IF;


END IF;






--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_newtmcstatus(character varying, integer, text, integer) OWNER TO kisuser;

--
-- Name: t_ordersetq(character varying, integer, numeric); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_ordersetq(character varying, integer, numeric) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Сохраняет количество в заказе

*/


DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- ИД строки состава вн. заказа ---
spec_id ALIAS FOR $2;

--- Количество, которое необходимо записать ---
q ALIAS FOR $3;

--- Количество которое указано в заявке ТМЦ ---
q_tmc numeric(10,2);

--- Код автора заказа ---
author_kod varchar(24);

--- Номер заказа ----
order_id int;

--- Код записи состава заяви ТМЦ ---- 
tmc_spec_kod varchar(24);

--- Вспомогательная переменная ---
n int;



BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 OR spec_id IS NULL OR q IS NULL OR q<0.00 THEN
	RETURN 'ERRORDATA';
END IF;


--- Определение номера заказа ---
SELECT INTO order_id t_order_kod FROM t_order_spec WHERE t_rec_id=spec_id;


--- Определение автора заказа ---
SELECT INTO author_kod t_order_author_kod FROM t_order WHERE t_rec_id=order_id;

IF author_kod!=user_kod THEN
    RETURN 'NOTACCESS';
END IF;


--- Код записи заявки ТМЦ ---
SELECT INTO tmc_spec_kod t_spec_kod FROM t_order_spec WHERE t_rec_id=spec_id;

--- Определение записи количества в заявки ТМЦ ---
SELECT INTO q_tmc t_row_q FROM t_tmc_spec WHERE t_rec_id=tmc_spec_kod;


IF q > q_tmc THEN
    UPDATE t_order_spec SET t_q=q_tmc WHERE t_rec_id=spec_id;
ELSE
    UPDATE t_order_spec SET t_q=q WHERE t_rec_id=spec_id;
END IF;



RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_ordersetq(character varying, integer, numeric) OWNER TO kisuser;

--
-- Name: t_reportit(date, date); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_reportit(date, date) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $_$


/*

Формирует отчет ItHelpDesk

*/



DECLARE


--- Начальная дата ---
start_date ALIAS FOR $1;

--- Конечная дата ---
end_date ALIAS FOR $2;

rec record;


task_all int;
work_all int;
task_ok int;
work_ok int;
percent int;

BEGIN



CREATE TEMP TABLE tmp_table (
isp_name varchar(100) NOT NULL DEFAULT '',
phone varchar(20) NOT NULL DEFAULT '',
task_all int NOT NULL default 0,
work_all int NOT NULL default 0,
task_ok int NOT NULL default 0,
work_ok int NOT NULL default 0,
percent int NOT NULL default 0
);


--- Считаем по каждому исполнителю ---
FOR rec in SELECT DISTINCT isp_kod,isp_name1,isp_name2,isp_phone FROM t_show_it_task WHERE date(datetime) BETWEEN start_date AND end_date ORDER BY isp_name1,isp_name2 LOOP

    SELECT INTO task_all count(*) FROM t_show_it_task WHERE isp_kod=rec.isp_kod AND date(datetime) BETWEEN start_date AND end_date;
    IF task_all!=0 THEN
	SELECT INTO work_all sum(to_number(workhour,'9999')) FROM t_show_it_task WHERE isp_kod=rec.isp_kod AND date(datetime) BETWEEN start_date AND end_date;
    ELSE
	work_all := 0;
    END IF;
    SELECT INTO task_ok count(*) FROM t_show_it_task WHERE isp_kod=rec.isp_kod AND date(datetime) BETWEEN start_date AND end_date AND status_kod='5';
    IF task_ok!=0 THEN
	SELECT INTO work_ok sum(to_number(workhour,'9999')) FROM t_show_it_task WHERE isp_kod=rec.isp_kod AND date(datetime) BETWEEN start_date AND end_date AND status_kod='5';
    ELSE
	work_ok := 0;
    END IF;
    IF task_all!=0 THEN
	percent := task_ok*100/task_all;
    ELSE
	percent := 0;
    END IF;

    INSERT INTO tmp_table (isp_name,phone,task_all,work_all,task_ok,work_ok,percent) 
    VALUES(rec.isp_name2||' '||rec.isp_name1,rec.isp_phone,task_all,work_all,task_ok,work_ok,percent);

END LOOP;



--- Считаем ВСЕГО ---
SELECT INTO task_all count(*) FROM t_show_it_task WHERE date(datetime) BETWEEN start_date AND end_date;
IF task_all!=0 THEN
    SELECT INTO work_all sum(to_number(workhour,'9999')) FROM t_show_it_task WHERE date(datetime) BETWEEN start_date AND end_date;
ELSE
    work_all := 0;
END IF;

SELECT INTO task_ok count(*) FROM t_show_it_task WHERE date(datetime) BETWEEN start_date AND end_date AND status_kod='5';
IF task_ok!=0 THEN
    SELECT INTO work_ok sum(to_number(workhour,'9999')) FROM t_show_it_task WHERE date(datetime) BETWEEN start_date AND end_date AND status_kod='5';
ELSE
    work_ok := 0;
END IF;


IF task_all!=0 THEN
    percent := task_ok*100/task_all;
ELSE
    percent := 0;
END IF;

INSERT INTO tmp_table (isp_name,phone,task_all,work_all,task_ok,work_ok,percent) 
VALUES('ВСЕГО','',task_all,work_all,task_ok,work_ok,percent);



--- Читаем результат ---
FOR rec in SELECT * FROM tmp_table LOOP

    return next rec;

END LOOP; 



END;$_$;


ALTER FUNCTION public.t_reportit(date, date) OWNER TO kisuser;

--
-- Name: t_setatrailersw(integer, numeric, numeric); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_setatrailersw(integer, numeric, numeric) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Корректирует расход топлива с прицепом

*/


DECLARE


--- Код автомобиля ---
car_kod ALIAS FOR $1;

--- Летний расход --
fuel_s ALIAS FOR $2;

--- Зимний расход ---
fuel_w ALIAS FOR $3;

--- Вспомогательная переменная ---
n int;
genk int;
n2 int;


BEGIN


--- Проверка поступивших данных на корректность ---
IF car_kod IS NULL THEN
	RETURN 'ERRORDATA';
END IF;


--- Есть ли записи для данного автомобиля сейчас ---
SELECT INTO n count(*) FROM t_auto_trailer WHERE t_auto_kod=car_kod;


--- Добавляем, обновляем или удаляем...
IF fuel_s != 0.00 AND fuel_w != 0.00 THEN
    IF n = 0 THEN
    --- Добавляем ---
	SELECT INTO n2 count(*) FROM t_auto_trailer;
	IF n2 = 0 THEN
	    genk := 1;
	ELSE
	    SELECT INTO genk max(t_rec_id)+1 FROM t_auto_trailer;
	END IF;

	INSERT INTO t_auto_trailer (t_rec_id,t_auto_kod,t_fuel_s,t_fuel_w) 
	VALUES(genk,car_kod,fuel_s,fuel_w);

	RETURN 'OK';

    ELSE
    --- обновляем ---
	UPDATE t_auto_trailer SET t_fuel_s=fuel_s,t_fuel_w=fuel_w WHERE t_auto_kod=car_kod;

	RETURN 'OK';

    END IF;

ELSE
    --- Удаляем запис , если есть ---
    IF n != 0 THEN
	DELETE FROM t_auto_trailer WHERE t_auto_kod=car_kod;
    END IF;

    RETURN 'OK';


END IF;



--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_setatrailersw(integer, numeric, numeric) OWNER TO kisuser;

--
-- Name: t_setatstatus(character varying, integer, integer); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_setatstatus(character varying, integer, integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Устанавливает новый статус автомобиля 

*/


DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Код устанавливаемого статуса ---
status_kod ALIAS FOR $2;

--- Идентификатор записи автомобиля ---
car_kod ALIAS FOR $3;

--- Вспомогательная переменная ---
n int;



BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 THEN
	RETURN 'ERRORDATA';
END IF;


--- Проверка статуса - не имеет смысла устанавливать тот же статус ---
SELECT INTO n t_at_status_kod FROM t_auto_at_list WHERE t_rec_id=car_kod;

IF n=status_kod THEN
    RETURN 'NOTACCESS';
END IF;


--- Установка статуса ---
UPDATE t_auto_at_list SET t_at_status_kod=status_kod WHERE t_rec_id=car_kod;


--- Добавление ---
INSERT INTO 
t_auto_at_status(
t_at_status_kod,
t_at_kod,
t_create_author
) 
VALUES(
status_kod,
car_kod,
user_kod
);



--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_setatstatus(character varying, integer, integer) OWNER TO kisuser;

--
-- Name: t_storeonein(character varying, character varying, character varying, integer, numeric, integer, integer, text[], integer); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_storeonein(character varying, character varying, character varying, integer, numeric, integer, integer, text[], integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Поступление ТМЦ на склад или ввод остатков ---

*/


DECLARE


--- Код пользователя ---
user_id ALIAS FOR $1;

--- Код номенклатуры ---
one_kod ALIAS FOR $2;

--- штрихкод ---
barcode ALIAS FOR $3;

--- Код склада ---
store_kod ALIAS FOR $4;

--- Количество ---
q ALIAS FOR $5;

--- Код океи ---
okei_kod ALIAS FOR $6;

--- Ввод остатка или поступление ---
action_kod ALIAS FOR $7;

--- Дополнительные поля ---
options ALIAS FOR $8;

--- Модель данных ---
modeldata_kod ALIAS FOR $9;


--- Вспомогательная переменная ---
n int;
nn int;

--- Вспомогательная переменная ---
genk varchar(24);

--- Сколько было и сколько стало ---
before_q numeric(10,2);
after_q numeric(10,2);


---суммарный остаток ---
rest_sum numeric(10,2);



BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_id)=0 OR length(one_kod)=0 OR q<0 OR store_kod IS NULL OR okei_kod IS NULL THEN
	RETURN 'ERRORDATA';
END IF;


--- Проверка записей остаков (и если нет создание) ---
SELECT INTO n count(*) FROM t_store_total_rest WHERE btrim(t_rec_id)=btrim(one_kod) AND t_okei_kod=okei_kod;
IF n = 0 THEN
    INSERT INTO t_store_total_rest(t_rec_id,t_okei_kod,t_rest) VALUES(btrim(one_kod),okei_kod,0.00);
END IF;


SELECT INTO n count(*) FROM t_store_rest WHERE t_store_kod=store_kod AND t_one_kod=btrim(one_kod) AND t_okei_kod=okei_kod;
IF n = 0 THEN
    --- Создание уникального ключа ---
    nn := 1;
    WHILE nn!=0 LOOP
	genk := t_GenKey24();
	SELECT INTO nn count(*) FROM t_store_rest WHERE t_rec_id=genk;
    END LOOP;

    INSERT INTO t_store_rest(t_rec_id,t_okei_kod,t_store_kod,t_rest,t_one_kod) VALUES(genk,okei_kod,store_kod,0.00,btrim(one_kod));
    
END IF;





--- Для "движения" сколько было и сколько стало по складу ---
SELECT INTO before_q t_rest FROM t_store_rest WHERE t_okei_kod=okei_kod AND t_one_kod=btrim(one_kod) AND t_store_kod=store_kod;
after_q := q;





--- Создание уникального ключа ---
n := 1;
WHILE n!=0 LOOP
    genk := t_GenKey24();
    SELECT INTO n count(*) FROM t_store_onein WHERE t_rec_id=genk;
END LOOP;





--- Постуление ТМЦ на склад ---
IF action_kod = 0 THEN

    INSERT INTO t_store_onein (
    t_rec_id,
    t_type_one,
    t_one_kod,
    t_modeldata_kod,
    t_okei_kod,
    t_barcode,
    t_q,
    t_comment,
    t_cancel,
    t_author_kod,
    t_store_kod
    )
    VALUES(
    genk,
    0,
    btrim(one_kod),
    modeldata_kod,
    okei_kod,
    btrim(barcode),
    q,
    options,
    true,
    user_id,
    store_kod
    );


    ---- Установка остатка ---
    UPDATE t_store_rest SET t_rest=before_q+q WHERE t_okei_kod=okei_kod AND t_one_kod=btrim(one_kod) AND t_store_kod=store_kod;
    after_q := before_q+q;

--- Ввод остатков ----
ELSIF action_kod = 1 THEN


    --- После ввода остатка остается только одна актуальная запись для выбора постановк и врезерв ---
    UPDATE t_store_onein SET t_canceled=True WHERE t_okei_kod=okei_kod AND t_store_kod=store_kod AND t_one_kod=btrim(one_kod);



    INSERT INTO t_store_onein (
    t_rec_id,
    t_type_one,
    t_one_kod,
    t_modeldata_kod,
    t_okei_kod,
    t_barcode,
    t_q,
    t_comment,
    t_author_kod,
    t_store_kod
    )
    VALUES(
    genk,
    1,
    btrim(one_kod),
    modeldata_kod,
    okei_kod,
    btrim(barcode),
    q,
    options,
    user_id,
    store_kod
    );


    ---- Установка остатка ---
    UPDATE t_store_rest SET t_rest=q WHERE t_okei_kod=okei_kod AND t_one_kod=btrim(one_kod) AND t_store_kod=store_kod;
    after_q := q;

    --- После ввода остатка запрещаем отменять более раннии поступления ---
    UPDATE t_store_onein SET t_cancel=False WHERE t_store_kod=store_kod AND t_okei_kod=okei_kod AND t_one_kod=one_kod;


ELSE

--- Завершение ---
RETURN 'ERRORDATA';

END IF;


--- Считаем суммы (суммарный остаток по всем складам) ---
SELECT INTO rest_sum sum(t_rest) FROM t_store_rest WHERE t_okei_kod=okei_kod AND t_one_kod=btrim(one_kod);
UPDATE t_store_total_rest SET t_rest=rest_sum WHERE btrim(t_rec_id)=btrim(one_kod) AND t_okei_kod=okei_kod;


--- Пищем в "движение" ---
--- Создание уникального ключа ---
n := 1;
WHILE n!=0 LOOP
    genk := t_GenKey24();
    SELECT INTO n count(*) FROM t_store_process WHERE t_rec_id=genk;
END LOOP;
INSERT INTO t_store_process (
t_rec_id,
t_action_kod,
t_store_kod,
t_one_kod,
t_okei_kod,
t_before_q,
t_q,
t_after_q,
t_author_kod
)
VALUES (
genk,
action_kod,
store_kod,
btrim(one_kod),
okei_kod,
before_q,
q,
after_q,
user_id
);


--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_storeonein(character varying, character varying, character varying, integer, numeric, integer, integer, text[], integer) OWNER TO kisuser;

--
-- Name: t_storeoneincancel(character varying, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_storeoneincancel(character varying, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Отменяет (где возможно) поступление ТМЦ на склад или ввод остатков ---

*/


DECLARE


--- Код пользователя ---
user_id ALIAS FOR $1;

--- Код записи ---
rec_id ALIAS FOR $2;

--- Для хранения данных из записи ---
row t_store_onein%ROWTYPE;

--- Вспомогательная переменная ---
n int;

--- Вспомогательная переменная ---
genk varchar(24);


--- Сколько было и сколько стало ---
before_q numeric(10,2);


---суммарный остаток ---
rest_sum numeric(10,2);



BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_id)=0 OR length(rec_id)=0 THEN
	RETURN 'ERRORDATA';
END IF;



--- Проверка пользователя и можно ли отменять это поступление ---
SELECT INTO n count(*) FROM t_store_onein WHERE t_rec_id=rec_id AND t_author_kod=user_id AND t_cancel=True;
IF n = 0 THEN
    RETURN 'ERRORDATA';
END IF;


--- Считываем данные из отменяемой записи ---
SELECT * INTO row FROM t_store_onein WHERE t_rec_id=rec_id;


--- Для "движения" сколько было и сколько стало по складу ---
SELECT INTO before_q t_rest FROM t_store_rest WHERE t_okei_kod=row.t_okei_kod AND t_one_kod=row.t_one_kod AND t_store_kod=row.t_store_kod;


--- Сброс флага разрешения отмены ---
UPDATE t_store_onein SET t_cancel=False WHERE t_rec_id=rec_id;



--- Создание уникального ключа ---
n := 1;
WHILE n!=0 LOOP
    genk := t_GenKey24();
    SELECT INTO n count(*) FROM t_store_onein WHERE t_rec_id=genk;
END LOOP;



--- Отмечаем исходную запись как отмененную ---
UPDATE t_store_onein SET t_canceled=True WHERE t_rec_id=rec_id;


--- Постуление ТМЦ на склад (с отрицательным значением) ---
INSERT INTO t_store_onein (
t_rec_id,
t_type_one,
t_one_kod,
t_modeldata_kod,
t_okei_kod,
t_barcode,
t_q,
t_comment,
t_cancel,
t_author_kod,
t_store_kod,
t_canceled
)
VALUES(
genk,
0,
row.t_one_kod,
row.t_modeldata_kod,
row.t_okei_kod,
row.t_barcode,
-(row.t_q),
row.t_comment,
False,
user_id,
row.t_store_kod,
True
);


---- Установка остатка ---
UPDATE t_store_rest SET t_rest=before_q-row.t_q WHERE t_okei_kod=row.t_okei_kod AND t_one_kod=row.t_one_kod AND t_store_kod=row.t_store_kod;



--- Считаем суммы (суммарный остаток по всем складам) ---
SELECT INTO rest_sum sum(t_rest) FROM t_store_rest WHERE t_okei_kod=row.t_okei_kod AND t_one_kod=btrim(row.t_one_kod);
UPDATE t_store_total_rest SET t_rest=rest_sum WHERE btrim(t_rec_id)=row.t_one_kod AND t_okei_kod=row.t_okei_kod;


--- Пищем в "движение" ---
--- Создание уникального ключа ---
n := 1;
WHILE n!=0 LOOP
    genk := t_GenKey24();
    SELECT INTO n count(*) FROM t_store_process WHERE t_rec_id=genk;
END LOOP;
INSERT INTO t_store_process (
t_rec_id,
t_action_kod,
t_store_kod,
t_one_kod,
t_okei_kod,
t_before_q,
t_q,
t_after_q,
t_author_kod
)
VALUES (
genk,
0,
row.t_store_kod,
row.t_one_kod,
row.t_okei_kod,
before_q,
-(row.t_q),
before_q-row.t_q,
user_id
);


--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_storeoneincancel(character varying, character varying) OWNER TO kisuser;

--
-- Name: t_storeoneout(character varying, character varying, character varying, numeric, text[]); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_storeoneout(character varying, character varying, character varying, numeric, text[]) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Реализация ТМЦ  ---

*/


DECLARE


--- Код пользователя ---
user_id ALIAS FOR $1;

--- Код зерерва ---
reserve_id ALIAS FOR $2;

--- штрихкод ---
barcode ALIAS FOR $3;

--- Количество ---
q ALIAS FOR $4;

--- Дополнительные поля ---
options ALIAS FOR $5;

--- Вспомогательная переменная ---
n int;

--- Вспомогательная переменная ---
genk varchar(24);

--- Резерв ---
reserve numeric(10,2);

--- Код склада ---
store_id int;

--- Код записи поступления или ввода остатка ---
onein_id varchar(24);

--- Код номенклатуры ---
one_id varchar(12);

--- Код единицы из. ---
okei_id int;

--- Идентификатор содержимого заявки ТМЦ ---
spec_id varchar(24);

--- Номер заявки ТМЦ ---
tmc_id int;

--- Резерв после формирования реализации ---
reserve_after numeric(10,2);

--- Сколько было и сколько стало ---
before_q numeric(10,2);
after_q numeric(10,2);


---суммарный остаток ---
rest_sum numeric(10,2);



BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_id)=0 OR length(reserve_id)=0 OR q<=0 THEN
	RETURN 'ERRORDATA';
END IF;




--- Проверка по количеству ---
SELECT INTO reserve,spec_id t_reserve,t_tmc_spec_kod FROM t_store_reserve WHERE t_rec_id=reserve_id;
IF q > reserve THEN
	RETURN 'ERRORDATA';
END IF;

--- Проверка доступа к складу ---
SELECT INTO onein_id t_onein_kod FROM t_store_reserve WHERE t_rec_id=reserve_id;
SELECT INTO store_id,one_id,okei_id t_store_kod,t_one_kod,t_okei_kod FROM t_store_onein WHERE t_rec_id=onein_id;
SELECT INTO n count(*) FROM t_store_person WHERE t_store_kod=store_id AND t_person_kod=user_id;
IF n = 0 THEN
	RETURN 'NOTACCESS';
END IF;


--- Для "движения" сколько было и сколько стало по складу ---
SELECT INTO before_q t_rest FROM t_store_rest WHERE t_okei_kod=okei_id AND t_one_kod=one_id AND t_store_kod=store_id;

--- Номер заявки ТМЦ ---
SELECT INTO tmc_id t_tmc_kod FROM t_tmc_spec WHERE t_rec_id=spec_id;

--- Создание уникального ключа ---
n := 1;
WHILE n!=0 LOOP
    genk := t_GenKey24();
    SELECT INTO n count(*) FROM t_store_oneout WHERE t_rec_id=genk;
END LOOP;


--- Реализация ---
INSERT INTO t_store_oneout (
t_rec_id,
t_onein_kod,
t_q,
t_tmc_spec_kod,
t_tmc_kod,
t_comment,
t_author_kod,
t_canceled,
t_barcode
)
VALUES (
genk,
onein_id,
q,
spec_id,
tmc_id,
options,
user_id,
False,
barcode
);


--- Изменение количества резерва или удаления ---
reserve_after := reserve - q;
IF reserve_after = 0 THEN
    DELETE FROM t_store_reserve WHERE t_rec_id=reserve_id;
ELSE
    UPDATE t_store_reserve SET t_reserve=reserve_after WHERE t_rec_id=reserve_id;
END IF;


---- Установка остатка ---
after_q := before_q-q;
UPDATE t_store_rest SET t_rest=after_q WHERE t_okei_kod=okei_id AND t_one_kod=one_id AND t_store_kod=store_id;


--- Считаем суммы (суммарный остаток по всем складам) ---
SELECT INTO rest_sum sum(t_rest) FROM t_store_rest WHERE t_okei_kod=okei_id AND t_one_kod=one_id;
UPDATE t_store_total_rest SET t_rest=rest_sum WHERE t_rec_id=one_id AND t_okei_kod=okei_id;




--- Пищем в "движение" ---
--- Создание уникального ключа ---
n := 1;
WHILE n!=0 LOOP
    genk := t_GenKey24();
    SELECT INTO n count(*) FROM t_store_process WHERE t_rec_id=genk;
END LOOP;
INSERT INTO t_store_process (
t_rec_id,
t_action_kod,
t_store_kod,
t_one_kod,
t_okei_kod,
t_before_q,
t_q,
t_after_q,
t_author_kod
)
VALUES (
genk,
2,
store_id,
one_id,
okei_id,
before_q,
q,
after_q,
user_id
);


--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_storeoneout(character varying, character varying, character varying, numeric, text[]) OWNER TO kisuser;

--
-- Name: t_storeonereserve(character varying, character varying, character varying, numeric); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_storeonereserve(character varying, character varying, character varying, numeric) RETURNS text
    LANGUAGE plpgsql
    AS $_$

/*

Резервирование по заявке ТМЦ ---

*/


DECLARE


--- Код пользователя ---
user_id ALIAS FOR $1;

--- Код строки из заявки ТМЦ ---
row_kod ALIAS FOR $2;

--- Код ввода остатка или поступления на склад ---
onein_kod ALIAS FOR $3;

--- Количество ---
q ALIAS FOR $4;


--- Вспомогательная переменная ---
n int;

--- Вспомогательная переменная ---
genk varchar(24);

sum_reserve numeric(10,2) := 0.00;
sum_out numeric(10,2) := 0.00;
sum_in numeric(10,2);


BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_id)=0 OR length(onein_kod)=0 OR q<=0 OR length(row_kod)=0 THEN
	RETURN 'ERRORDATA';
END IF;

--- Проверки по количеству ---
--- Резервы ---
SELECT INTO n count(*) FROM t_store_reserve WHERE t_onein_kod=onein_kod;
IF n != 0 THEN
    SELECT INTO sum_reserve sum(t_reserve) FROM t_store_reserve WHERE t_onein_kod=onein_kod;
END IF;

--- Реализация ---
SELECT INTO n count(*) FROM t_store_oneout WHERE t_onein_kod=onein_kod AND t_canceled=False;
IF n != 0 THEN
    SELECT INTO sum_out sum(t_q) FROM t_store_oneout WHERE t_onein_kod=onein_kod AND t_canceled=False;
END IF;

SELECT INTO sum_in t_q FROM t_store_onein WHERE t_rec_id=onein_kod;

IF (sum_reserve + sum_out + q) > sum_in THEN
    RETURN 'ERRORDATA';
END IF;



--- Создание уникального ключа ---
n := 1;
WHILE n!=0 LOOP
    genk := t_GenKey24();
    SELECT INTO n count(*) FROM t_store_reserve WHERE t_rec_id=genk;
END LOOP;



--- Запись резерва ---
INSERT INTO t_store_reserve (
t_rec_id,
t_reserve,
t_onein_kod,
t_tmc_spec_kod,
t_author_kod
) 
VALUES
(
genk,
q,
onein_kod,
row_kod,
user_id
);


UPDATE t_store_onein SET t_cancel=False WHERE t_rec_id=onein_kod;




--- Завершение ---
RETURN 'OK';


END;$_$;


ALTER FUNCTION public.t_storeonereserve(character varying, character varying, character varying, numeric) OWNER TO kisuser;

--
-- Name: t_test(); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_test() RETURNS text
    LANGUAGE plpgsql
    AS $$



DECLARE

BEGIN


RETURN to_char(localtimestamp,'DD.MM.YYYY HH24:MI');


END;$$;


ALTER FUNCTION public.t_test() OWNER TO kisuser;

--
-- Name: t_toolpersonnext(); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_toolpersonnext() RETURNS text
    LANGUAGE plpgsql
    AS $$

/*

Формирует таблицу t_d_person_next

*/


DECLARE



--- Вспомогательная переменная ---
n int;

--- Для хранения строки ---
r record;

--- Код следующего согласующего ---
next_user_kod varchar(24);



BEGIN

--- Выборка номеров заявок со статусом 3 ---
FOR r IN (SELECT * FROM t_d WHERE t_rec_delete=0 AND t_dstatus_kod=3) LOOP




    --- Определение следующего согласующего ---
    SELECT INTO n count(*) FROM t_d_person WHERE t_rec_delete=0 AND t_d_kod=r.t_rec_id AND (t_dstatus_kod IS NULL OR t_dstatus_kod=3);
    IF n=0 THEN
	DELETE FROM t_d_person_next WHERE t_d_kod=r.t_rec_id;
	RETURN 'OK';
    END IF;

    SELECT INTO next_user_kod t_person_kod FROM t_d_person WHERE t_rec_delete=0 AND t_d_kod=r.t_rec_id AND (t_dstatus_kod IS NULL OR t_dstatus_kod=3) ORDER BY t_order_agremnt LIMIT 1;

    --- Такой следующий уже есть? ---
    SELECT INTO n count(*) FROM t_d_person_next WHERE t_d_kod=r.t_rec_id AND t_user_kod=next_user_kod;
    IF n=0 THEN
	--- Добавление записи ---
	DELETE FROM t_d_person_next WHERE t_d_kod=r.t_rec_id;
	INSERT INTO t_d_person_next (t_d_kod,t_user_kod) VALUES(r.t_rec_id,next_user_kod);
    END IF;



END LOOP;


--- Завершение ---
RETURN 'OK';


END;$$;


ALTER FUNCTION public.t_toolpersonnext() OWNER TO kisuser;

--
-- Name: t_usersave(character varying, character varying, character varying, character varying, character varying, character varying); Type: FUNCTION; Schema: public; Owner: kisuser
--

CREATE FUNCTION t_usersave(character varying, character varying, character varying, character varying, character varying, character varying) RETURNS text
    LANGUAGE plpgsql
    AS $_$


/*

Сохраняем данные пользователя после Radius авторизации 

*/



DECLARE


--- Код пользователя ---
user_kod ALIAS FOR $1;

--- Фамилия ---
name1 ALIAS FOR $2;

--- Имя ---
name2 ALIAS FOR $3;

--- Отчество ---
name3 ALIAS FOR $4;

--- email ---
email ALIAS FOR $5;

--- Телефон ---
phone ALIAS FOR $6;

--- Вспомогательная переменная ---
n int;




BEGIN


--- Проверка поступивших данных на корректность ---
IF length(user_kod)=0 THEN
	RETURN 'ERRORDATA';
END IF;


SELECT INTO n count(*) FROM t_user_kis WHERE t_rec_id=user_kod;
IF n = 0 THEN
    INSERT INTO t_user_kis 
    (t_rec_id,t_user_name1,t_user_name2,t_user_name3,t_email,t_phone_shot) 
    VALUES
    (user_kod,name1,name2,name3,email,phone);
    RETURN 'APPEND';
ELSE
    UPDATE t_user_kis
    SET 
    t_user_name1=name1,
    t_user_name2=name2,
    t_user_name3=name3,
    t_email=email,
    t_phone_shot=phone
    WHERE
    t_rec_id=user_kod;
    RETURN 'EDIT';
END IF;



END;$_$;


ALTER FUNCTION public.t_usersave(character varying, character varying, character varying, character varying, character varying, character varying) OWNER TO kisuser;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO kisuser;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: kisuser
--

CREATE SEQUENCE auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO kisuser;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kisuser
--

ALTER SEQUENCE auth_group_id_seq OWNED BY auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO kisuser;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: kisuser
--

CREATE SEQUENCE auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO kisuser;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kisuser
--

ALTER SEQUENCE auth_group_permissions_id_seq OWNED BY auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE auth_permission (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO kisuser;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: kisuser
--

CREATE SEQUENCE auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO kisuser;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kisuser
--

ALTER SEQUENCE auth_permission_id_seq OWNED BY auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone NOT NULL,
    is_superuser boolean NOT NULL,
    username character varying(30) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    email character varying(75) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO kisuser;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO kisuser;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: kisuser
--

CREATE SEQUENCE auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO kisuser;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kisuser
--

ALTER SEQUENCE auth_user_groups_id_seq OWNED BY auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: kisuser
--

CREATE SEQUENCE auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO kisuser;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kisuser
--

ALTER SEQUENCE auth_user_id_seq OWNED BY auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO kisuser;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: kisuser
--

CREATE SEQUENCE auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO kisuser;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kisuser
--

ALTER SEQUENCE auth_user_user_permissions_id_seq OWNED BY auth_user_user_permissions.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE django_content_type (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO kisuser;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: kisuser
--

CREATE SEQUENCE django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO kisuser;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kisuser
--

ALTER SEQUENCE django_content_type_id_seq OWNED BY django_content_type.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO kisuser;

--
-- Name: django_site; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE django_site (
    id integer NOT NULL,
    domain character varying(100) NOT NULL,
    name character varying(50) NOT NULL
);


ALTER TABLE public.django_site OWNER TO kisuser;

--
-- Name: django_site_id_seq; Type: SEQUENCE; Schema: public; Owner: kisuser
--

CREATE SEQUENCE django_site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_site_id_seq OWNER TO kisuser;

--
-- Name: django_site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kisuser
--

ALTER SEQUENCE django_site_id_seq OWNED BY django_site.id;


--
-- Name: t_auto_at_list; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_auto_at_list (
    t_rec_id integer NOT NULL,
    t_location character varying(100) NOT NULL,
    t_mark character varying(100) NOT NULL,
    t_at_number character varying(20) DEFAULT ''::character varying NOT NULL,
    t_at_type_kod integer NOT NULL,
    t_fuel_kod integer NOT NULL,
    t_fuel_s numeric(6,2) DEFAULT 0.00 NOT NULL,
    t_fuel_w numeric(6,2) DEFAULT 0.00 NOT NULL,
    t_create_author character varying(24) NOT NULL,
    t_create_time timestamp without time zone DEFAULT now() NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL,
    t_at_status_kod integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.t_auto_at_list OWNER TO kisuser;

--
-- Name: t_auto_at_status; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_auto_at_status (
    t_rec_id integer NOT NULL,
    t_at_status_kod integer NOT NULL,
    t_at_kod integer NOT NULL,
    t_create_time timestamp without time zone DEFAULT now() NOT NULL,
    t_create_author character varying(24) NOT NULL
);


ALTER TABLE public.t_auto_at_status OWNER TO kisuser;

--
-- Name: TABLE t_auto_at_status; Type: COMMENT; Schema: public; Owner: kisuser
--

COMMENT ON TABLE t_auto_at_status IS 'Таблица хранения истории изменения статусов автомобиля';


--
-- Name: t_auto_at_status_list; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_auto_at_status_list (
    t_rec_id integer NOT NULL,
    t_status_name character varying(100) NOT NULL
);


ALTER TABLE public.t_auto_at_status_list OWNER TO kisuser;

--
-- Name: TABLE t_auto_at_status_list; Type: COMMENT; Schema: public; Owner: kisuser
--

COMMENT ON TABLE t_auto_at_status_list IS 'справочник статусов автомобилей';


--
-- Name: t_auto_at_status_t_rec_id_seq; Type: SEQUENCE; Schema: public; Owner: kisuser
--

CREATE SEQUENCE t_auto_at_status_t_rec_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_auto_at_status_t_rec_id_seq OWNER TO kisuser;

--
-- Name: t_auto_at_status_t_rec_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kisuser
--

ALTER SEQUENCE t_auto_at_status_t_rec_id_seq OWNED BY t_auto_at_status.t_rec_id;


--
-- Name: t_auto_docs; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_auto_docs (
    t_rec_id integer NOT NULL,
    t_guide text DEFAULT ''::text NOT NULL,
    t_ext character varying(10) NOT NULL,
    t_data bytea,
    t_file_name character varying(200) NOT NULL,
    t_create_date date DEFAULT ('now'::text)::date NOT NULL,
    t_create_author character varying(24) NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.t_auto_docs OWNER TO kisuser;

--
-- Name: t_auto_docs_t_rec_id_seq; Type: SEQUENCE; Schema: public; Owner: kisuser
--

CREATE SEQUENCE t_auto_docs_t_rec_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_auto_docs_t_rec_id_seq OWNER TO kisuser;

--
-- Name: t_auto_docs_t_rec_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kisuser
--

ALTER SEQUENCE t_auto_docs_t_rec_id_seq OWNED BY t_auto_docs.t_rec_id;


--
-- Name: t_auto_drivers; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_auto_drivers (
    t_rec_id character varying(24) NOT NULL,
    t_fio_driver character varying(200) NOT NULL,
    t_location character varying(100) DEFAULT ''::character varying NOT NULL,
    t_create_time timestamp without time zone DEFAULT now() NOT NULL,
    t_author_kod character varying(24) NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL,
    t_license character varying(100) DEFAULT ''::character varying NOT NULL,
    t_category character varying(100) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.t_auto_drivers OWNER TO kisuser;

--
-- Name: t_auto_email_history; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_auto_email_history (
    t_trip_kod integer,
    t_subject character varying(200),
    t_datetime timestamp without time zone DEFAULT now(),
    t_email character varying(100)
);


ALTER TABLE public.t_auto_email_history OWNER TO kisuser;

--
-- Name: t_auto_fuel_type; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_auto_fuel_type (
    t_rec_id integer NOT NULL,
    t_type_name character varying(50) NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.t_auto_fuel_type OWNER TO kisuser;

--
-- Name: t_auto_group_mail; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_auto_group_mail (
    t_email character varying(100) NOT NULL,
    t_author_address integer DEFAULT 0 NOT NULL,
    t_rec_id integer NOT NULL
);


ALTER TABLE public.t_auto_group_mail OWNER TO kisuser;

--
-- Name: t_auto_group_mail_t_rec_id_seq; Type: SEQUENCE; Schema: public; Owner: kisuser
--

CREATE SEQUENCE t_auto_group_mail_t_rec_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_auto_group_mail_t_rec_id_seq OWNER TO kisuser;

--
-- Name: t_auto_group_mail_t_rec_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kisuser
--

ALTER SEQUENCE t_auto_group_mail_t_rec_id_seq OWNED BY t_auto_group_mail.t_rec_id;


--
-- Name: t_auto_ruk_cfo_kod; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_auto_ruk_cfo_kod (
    t_ruk_cfo_kod character varying(24) NOT NULL
);


ALTER TABLE public.t_auto_ruk_cfo_kod OWNER TO kisuser;

--
-- Name: t_auto_season; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_auto_season (
    t_rec_id integer NOT NULL,
    t_start_date date DEFAULT ('now'::text)::date NOT NULL,
    t_s_w character(1) NOT NULL
);


ALTER TABLE public.t_auto_season OWNER TO kisuser;

--
-- Name: t_auto_season_t_rec_id_seq; Type: SEQUENCE; Schema: public; Owner: kisuser
--

CREATE SEQUENCE t_auto_season_t_rec_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_auto_season_t_rec_id_seq OWNER TO kisuser;

--
-- Name: t_auto_season_t_rec_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kisuser
--

ALTER SEQUENCE t_auto_season_t_rec_id_seq OWNED BY t_auto_season.t_rec_id;


--
-- Name: t_auto_status; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_auto_status (
    t_rec_id integer NOT NULL,
    t_auto_trip_kod integer NOT NULL,
    t_comment text DEFAULT ''::text NOT NULL,
    t_status_kod integer NOT NULL,
    t_create_time timestamp without time zone DEFAULT ('now'::text)::timestamp without time zone NOT NULL,
    t_create_author character varying(24) NOT NULL
);


ALTER TABLE public.t_auto_status OWNER TO kisuser;

--
-- Name: t_auto_status_choice; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_auto_status_choice (
    t_status_auto integer NOT NULL,
    t_status_choice integer,
    t_rec_id integer NOT NULL
);


ALTER TABLE public.t_auto_status_choice OWNER TO kisuser;

--
-- Name: t_auto_status_choice_t_rec_id_seq; Type: SEQUENCE; Schema: public; Owner: kisuser
--

CREATE SEQUENCE t_auto_status_choice_t_rec_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_auto_status_choice_t_rec_id_seq OWNER TO kisuser;

--
-- Name: t_auto_status_choice_t_rec_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kisuser
--

ALTER SEQUENCE t_auto_status_choice_t_rec_id_seq OWNED BY t_auto_status_choice.t_rec_id;


--
-- Name: t_auto_status_list; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_auto_status_list (
    t_rec_id integer DEFAULT 0 NOT NULL,
    t_status_name character varying(100) NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.t_auto_status_list OWNER TO kisuser;

--
-- Name: t_auto_trailer; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_auto_trailer (
    t_rec_id integer NOT NULL,
    t_auto_kod integer NOT NULL,
    t_fuel_s numeric(6,2) DEFAULT 0.00 NOT NULL,
    t_fuel_w numeric(6,2)
);


ALTER TABLE public.t_auto_trailer OWNER TO kisuser;

--
-- Name: TABLE t_auto_trailer; Type: COMMENT; Schema: public; Owner: kisuser
--

COMMENT ON TABLE t_auto_trailer IS 'Расход топлива с прицепом';


--
-- Name: t_auto_trip; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_auto_trip (
    t_rec_id integer NOT NULL,
    t_trip_datetime timestamp without time zone NOT NULL,
    t_duration integer DEFAULT 0 NOT NULL,
    t_plan_or_task character(4) DEFAULT 'task'::bpchar NOT NULL,
    t_route character varying(200) NOT NULL,
    t_object character varying(200) NOT NULL,
    t_driver_kod character varying(24) DEFAULT ''::character varying NOT NULL,
    t_auto_kod integer NOT NULL,
    t_trailer character(1),
    t_status_kod integer DEFAULT 0 NOT NULL,
    t_author_kod character varying(24) DEFAULT ''::character varying NOT NULL,
    t_create_time timestamp without time zone DEFAULT now() NOT NULL,
    t_chief_kod character varying(24) DEFAULT ''::character varying NOT NULL,
    t_speedo1 integer DEFAULT 0 NOT NULL,
    t_speedo2 integer DEFAULT 0 NOT NULL,
    t_fuel numeric(6,2) DEFAULT 0.00 NOT NULL,
    t_chief_email character varying(50) DEFAULT ''::character varying NOT NULL,
    t_trip_datetime_end timestamp without time zone NOT NULL,
    t_target character varying(100) DEFAULT ''::character varying NOT NULL,
    t_traveler character varying(100) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.t_auto_trip OWNER TO kisuser;

--
-- Name: t_auto_type_list; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_auto_type_list (
    t_rec_id integer NOT NULL,
    t_auto_type_name character varying(100),
    t_rec_delete integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.t_auto_type_list OWNER TO kisuser;

--
-- Name: t_d; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_d (
    t_rec_id integer,
    t_dstatus_kod integer DEFAULT 0 NOT NULL,
    t_dep_group_kod integer DEFAULT 1000 NOT NULL,
    t_ruk_kod character varying(24) DEFAULT ''::character varying,
    t_tema character varying(100) DEFAULT ''::character varying NOT NULL,
    t_d_text text DEFAULT ''::text NOT NULL,
    t_doc_data bytea,
    t_ext character varying(10) DEFAULT ''::character varying NOT NULL,
    t_file_name character varying(200) DEFAULT ''::character varying,
    t_doc_ver integer DEFAULT 0 NOT NULL,
    t_doc_time timestamp without time zone DEFAULT (now())::timestamp without time zone NOT NULL,
    t_doc_author character varying(24) DEFAULT ''::character varying,
    t_create_date date DEFAULT ('now'::text)::date NOT NULL,
    t_create_author character varying(24) NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL,
    t_app_data bytea,
    t_app_ext character varying(10),
    t_app_filename character varying(200) DEFAULT ''::character varying,
    t_app_author character varying(24) DEFAULT ''::character varying,
    t_app_time timestamp without time zone,
    t_email_ruk character varying(50) DEFAULT ''::character varying NOT NULL,
    t_contragent character varying(200) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.t_d OWNER TO kisuser;

--
-- Name: t_d_docs; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_d_docs (
    t_rec_id character varying(24),
    t_d_kod integer NOT NULL,
    t_comment text DEFAULT ''::text NOT NULL,
    t_ext character varying(10) NOT NULL,
    t_data bytea,
    t_file_name character varying(200) NOT NULL,
    t_create_date date DEFAULT ('now'::text)::date NOT NULL,
    t_create_author character varying(24) NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.t_d_docs OWNER TO kisuser;

--
-- Name: t_d_email_history; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_d_email_history (
    t_d_kod integer,
    t_subject character varying(200),
    t_datetime timestamp without time zone DEFAULT now(),
    t_email character varying(100)
);


ALTER TABLE public.t_d_email_history OWNER TO kisuser;

--
-- Name: t_d_group_mail; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_d_group_mail (
    t_email character varying(100) NOT NULL,
    t_author_address integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.t_d_group_mail OWNER TO kisuser;

--
-- Name: t_d_person; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_d_person (
    t_rec_id character varying(24),
    t_d_kod integer NOT NULL,
    t_person_kod character varying(24) NOT NULL,
    t_dstatus_kod integer,
    t_ver integer,
    t_dstatus_date date,
    t_lag_day integer,
    t_create_time timestamp without time zone DEFAULT now() NOT NULL,
    t_create_author character varying(24) NOT NULL,
    t_update_time timestamp without time zone DEFAULT now() NOT NULL,
    t_update_author character varying(24) DEFAULT ''::character varying NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL,
    t_app_time timestamp without time zone,
    t_order_agremnt integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.t_d_person OWNER TO kisuser;

--
-- Name: t_d_person_next; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_d_person_next (
    t_d_kod integer NOT NULL,
    t_user_kod character varying(24) NOT NULL,
    t_start_time timestamp without time zone DEFAULT now() NOT NULL,
    t_send_email character varying(3) DEFAULT 'NO'::character varying NOT NULL
);


ALTER TABLE public.t_d_person_next OWNER TO kisuser;

--
-- Name: t_d_status; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_d_status (
    t_rec_id character varying(24),
    t_d_kod integer NOT NULL,
    t_comment text DEFAULT ''::text NOT NULL,
    t_dstatus_kod integer NOT NULL,
    t_create_time timestamp without time zone DEFAULT ('now'::text)::timestamp without time zone NOT NULL,
    t_create_author character varying(24) NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.t_d_status OWNER TO kisuser;

--
-- Name: t_d_status_choice; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_d_status_choice (
    t_status_d integer,
    t_status_choice integer
);


ALTER TABLE public.t_d_status_choice OWNER TO kisuser;

--
-- Name: COLUMN t_d_status_choice.t_status_d; Type: COMMENT; Schema: public; Owner: kisuser
--

COMMENT ON COLUMN t_d_status_choice.t_status_d IS 'Код заявки';


--
-- Name: COLUMN t_d_status_choice.t_status_choice; Type: COMMENT; Schema: public; Owner: kisuser
--

COMMENT ON COLUMN t_d_status_choice.t_status_choice IS 'Варианты выбора статуса взависимости от статуса заявки';


--
-- Name: t_d_status_list; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_d_status_list (
    t_rec_id integer NOT NULL,
    t_d_status_name character varying(100) DEFAULT ''::character varying NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.t_d_status_list OWNER TO kisuser;

--
-- Name: t_it_admin_group; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_it_admin_group (
    t_rec_id character varying(24) NOT NULL
);


ALTER TABLE public.t_it_admin_group OWNER TO kisuser;

--
-- Name: t_it_docs; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_it_docs (
    t_rec_id character varying(24) NOT NULL,
    t_it_task_kod character varying(8) NOT NULL,
    t_task_work_kod character varying(24) DEFAULT ''::character varying NOT NULL,
    t_ext character varying(100) DEFAULT ''::character varying NOT NULL,
    t_filename character varying(250) DEFAULT ''::character varying NOT NULL,
    t_user_comment text DEFAULT ''::text NOT NULL,
    t_create_time timestamp without time zone DEFAULT now() NOT NULL,
    t_ip character varying(50) NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL,
    t_data bytea
);


ALTER TABLE public.t_it_docs OWNER TO kisuser;

--
-- Name: t_it_email_address; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_it_email_address (
    t_email character varying(20) NOT NULL
);


ALTER TABLE public.t_it_email_address OWNER TO kisuser;

--
-- Name: t_it_email_history; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_it_email_history (
    t_task_kod integer,
    t_subject character varying(200),
    t_datetime timestamp without time zone DEFAULT now(),
    t_email character varying(100)
);


ALTER TABLE public.t_it_email_history OWNER TO kisuser;

--
-- Name: t_it_task; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_it_task (
    t_rec_id character varying(24) NOT NULL,
    t_datetime timestamp without time zone DEFAULT now() NOT NULL,
    t_text text DEFAULT ''::text NOT NULL,
    t_ip character varying(20) DEFAULT ''::character varying NOT NULL,
    t_phone character varying(50) DEFAULT ''::character varying NOT NULL,
    t_email character varying(100) DEFAULT ''::character varying NOT NULL,
    t_person character varying(100) DEFAULT ''::character varying NOT NULL,
    t_itkategory_kod integer DEFAULT 0 NOT NULL,
    t_itstatus_kod integer DEFAULT 0 NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL,
    t_tema character varying(50) DEFAULT ''::character varying NOT NULL,
    t_isp_kod character varying(24) DEFAULT ''::character varying NOT NULL,
    t_serial_n integer NOT NULL,
    t_user_kod character varying(24) DEFAULT ''::bpchar NOT NULL,
    t_workhour integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.t_it_task OWNER TO kisuser;

--
-- Name: t_it_task_t_serial_n_seq; Type: SEQUENCE; Schema: public; Owner: kisuser
--

CREATE SEQUENCE t_it_task_t_serial_n_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_it_task_t_serial_n_seq OWNER TO kisuser;

--
-- Name: t_it_task_t_serial_n_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kisuser
--

ALTER SEQUENCE t_it_task_t_serial_n_seq OWNED BY t_it_task.t_serial_n;


--
-- Name: t_it_task_work; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_it_task_work (
    t_rec_id character varying(24) NOT NULL,
    t_it_task_kod character varying(24) NOT NULL,
    t_datetime timestamp without time zone DEFAULT now() NOT NULL,
    t_comment text DEFAULT ''::text NOT NULL,
    t_itstatus_kod integer DEFAULT 0 NOT NULL,
    t_itkategory_kod integer DEFAULT 0 NOT NULL,
    t_author_kod character varying(24),
    t_ip character varying(20) DEFAULT ''::character varying NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL,
    t_drp integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.t_it_task_work OWNER TO kisuser;

--
-- Name: t_itkategory_list; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_itkategory_list (
    t_rec_id integer NOT NULL,
    t_itkategory_name character varying(50) DEFAULT ''::character varying NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.t_itkategory_list OWNER TO kisuser;

--
-- Name: t_itstatus_list; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_itstatus_list (
    t_rec_id integer NOT NULL,
    t_itstatus_name character varying(50) DEFAULT ''::character varying NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.t_itstatus_list OWNER TO kisuser;

--
-- Name: t_okei_list; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_okei_list (
    t_rec_id integer NOT NULL,
    t_okei_name character varying(50) DEFAULT ''::character varying NOT NULL,
    t_okei_name_shot character varying(30) DEFAULT ''::character varying NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.t_okei_list OWNER TO kisuser;

--
-- Name: t_order; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_order (
    t_rec_id integer DEFAULT 0 NOT NULL,
    t_tmc_kod integer NOT NULL,
    t_project_name character varying(100) DEFAULT ''::character varying NOT NULL,
    t_order_author_kod character varying(24) NOT NULL,
    t_executor_kod character varying NOT NULL,
    t_order_date date DEFAULT ('now'::text)::date NOT NULL
);


ALTER TABLE public.t_order OWNER TO kisuser;

--
-- Name: t_order_spec; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_order_spec (
    t_rec_id integer NOT NULL,
    t_order_kod integer NOT NULL,
    t_spec_kod character varying(24) NOT NULL,
    t_q numeric(10,2) DEFAULT 0.00 NOT NULL
);


ALTER TABLE public.t_order_spec OWNER TO kisuser;

--
-- Name: t_order_spec_t_rec_id_seq; Type: SEQUENCE; Schema: public; Owner: kisuser
--

CREATE SEQUENCE t_order_spec_t_rec_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_order_spec_t_rec_id_seq OWNER TO kisuser;

--
-- Name: t_order_spec_t_rec_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kisuser
--

ALTER SEQUENCE t_order_spec_t_rec_id_seq OWNED BY t_order_spec.t_rec_id;


--
-- Name: t_user_kis; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_user_kis (
    t_rec_id character varying(24) DEFAULT ''::character varying,
    t_email character varying(50) DEFAULT ''::character varying,
    t_user_name1 character varying(50) DEFAULT ''::character varying,
    t_user_name2 character varying(50) DEFAULT ''::character varying,
    t_user_name3 character varying(50) DEFAULT ''::character varying,
    t_phone_shot character varying(50) DEFAULT ''::character varying
);


ALTER TABLE public.t_user_kis OWNER TO kisuser;

--
-- Name: t_show_auto_at_list; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_auto_at_list AS
    SELECT btrim(to_char(a.t_rec_id, '999'::text)) AS rec_id, a.t_location AS location, a.t_mark AS mark, a.t_at_number AS at_number, t.t_auto_type_name AS auto_type, f.t_type_name AS fuel_type, btrim(to_char(a.t_fuel_s, '9999.00'::text)) AS fuel_s, btrim(to_char(a.t_fuel_w, '9999.00'::text)) AS fuel_w, u.t_user_name1 AS name1, u.t_user_name2 AS name2, u.t_user_name3 AS name3, u.t_email AS email, u.t_phone_shot AS phone, to_char(a.t_create_time, 'DD.MM.YYYY'::text) AS create_time, btrim(to_char(f.t_rec_id, '999'::text)) AS fuel_type_kod, btrim(to_char(t.t_rec_id, '999'::text)) AS auto_type_kod, btrim(to_char(a.t_at_status_kod, '99'::text)) AS at_status_kod, s.t_status_name AS status_name FROM t_auto_at_list a, t_user_kis u, t_auto_fuel_type f, t_auto_type_list t, t_auto_at_status_list s WHERE ((((((u.t_rec_id)::text = (a.t_create_author)::text) AND (f.t_rec_id = a.t_fuel_kod)) AND (t.t_rec_id = a.t_at_type_kod)) AND (a.t_rec_delete = 0)) AND (a.t_at_status_kod = s.t_rec_id)) ORDER BY a.t_location, a.t_mark;


ALTER TABLE public.t_show_auto_at_list OWNER TO kisuser;

--
-- Name: t_show_auto_at_status; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_auto_at_status AS
    SELECT btrim(to_char(h.t_at_kod, '999'::text)) AS at_kod, s.t_status_name AS status_name, to_char(h.t_create_time, 'DD.MM.YYYY'::text) AS create_time, u.t_user_name1 AS user_name1, u.t_user_name2 AS user_name2, u.t_user_name3 AS user_name3, u.t_phone_shot AS user_phone, u.t_email AS user_email FROM t_auto_at_status h, t_auto_at_status_list s, t_user_kis u WHERE ((h.t_at_status_kod = s.t_rec_id) AND ((h.t_create_author)::text = (u.t_rec_id)::text)) ORDER BY h.t_create_time DESC;


ALTER TABLE public.t_show_auto_at_status OWNER TO kisuser;

--
-- Name: t_show_auto_at_status_list; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_auto_at_status_list AS
    SELECT btrim(to_char(s.t_rec_id, '99'::text)) AS rec_id, s.t_status_name AS status_name FROM t_auto_at_status_list s ORDER BY s.t_status_name;


ALTER TABLE public.t_show_auto_at_status_list OWNER TO kisuser;

--
-- Name: t_show_auto_docs; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_auto_docs AS
    SELECT btrim(to_char(d.t_rec_id, '99999'::text)) AS rec_id, d.t_guide AS guide, d.t_ext AS ext, d.t_file_name AS file_name, to_char((d.t_create_date)::timestamp with time zone, 'DD.MM.YYYY'::text) AS create_date, u.t_user_name1 AS user_name1, u.t_user_name2 AS user_name2, u.t_user_name3 AS user_name3, u.t_phone_shot AS user_phone, u.t_email FROM t_auto_docs d, t_user_kis u WHERE (((d.t_create_author)::text = (u.t_rec_id)::text) AND (d.t_rec_delete = 0)) ORDER BY d.t_create_date DESC, d.t_guide;


ALTER TABLE public.t_show_auto_docs OWNER TO kisuser;

--
-- Name: t_show_auto_drivers; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_auto_drivers AS
    SELECT d.t_rec_id AS rec_id, d.t_fio_driver AS fio_driver, d.t_location AS location, d.t_license AS license, d.t_category AS category, to_char(d.t_create_time, 'DD.MM.YYYY'::text) AS create_time, u.t_user_name1 AS author_name1, u.t_user_name2 AS author_name2, u.t_user_name3 AS author_name3, u.t_phone_shot AS author_phone, u.t_email AS author_email FROM t_auto_drivers d, t_user_kis u WHERE (((d.t_author_kod)::text = (u.t_rec_id)::text) AND (d.t_rec_delete = 0)) ORDER BY d.t_fio_driver;


ALTER TABLE public.t_show_auto_drivers OWNER TO kisuser;

--
-- Name: t_show_auto_email_history; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_auto_email_history AS
    SELECT btrim(to_char(e.t_trip_kod, '99999'::text)) AS trip_kod, e.t_subject AS subject, to_char(e.t_datetime, 'DD.MM.YYYY'::text) AS date_, to_char(e.t_datetime, 'HH24:MI'::text) AS time_, e.t_email AS email FROM t_auto_email_history e ORDER BY e.t_datetime DESC;


ALTER TABLE public.t_show_auto_email_history OWNER TO kisuser;

--
-- Name: t_show_auto_fuel_type; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_auto_fuel_type AS
    SELECT btrim(to_char(t.t_rec_id, '999'::text)) AS rec_id, t.t_type_name AS type_name FROM t_auto_fuel_type t WHERE (t.t_rec_delete = 0) ORDER BY t.t_type_name;


ALTER TABLE public.t_show_auto_fuel_type OWNER TO kisuser;

--
-- Name: t_show_auto_report0; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_auto_report0 AS
    SELECT date(t.t_trip_datetime) AS date, to_char(t.t_trip_datetime, 'DD.MM.YYYY'::text) AS date_str, t.t_duration AS duration, t.t_route AS route, t.t_object AS object, d.t_fio_driver AS driver, d.t_location FROM t_auto_trip t, t_auto_drivers d WHERE (((t.t_driver_kod)::text = (d.t_rec_id)::text) AND (t.t_status_kod = 6)) ORDER BY t.t_trip_datetime;


ALTER TABLE public.t_show_auto_report0 OWNER TO kisuser;

--
-- Name: t_show_auto_ruk_cfo; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_auto_ruk_cfo AS
    SELECT c.t_ruk_cfo_kod AS ruk_kod, u.t_user_name1 AS name1, u.t_user_name2 AS name2, u.t_user_name3 AS name3, u.t_phone_shot AS phone, u.t_email AS email FROM t_auto_ruk_cfo_kod c, t_user_kis u WHERE ((u.t_rec_id)::text = (c.t_ruk_cfo_kod)::text) ORDER BY u.t_user_name1, u.t_user_name2, u.t_user_name3;


ALTER TABLE public.t_show_auto_ruk_cfo OWNER TO kisuser;

--
-- Name: t_show_auto_status; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_auto_status AS
    SELECT btrim(to_char(h.t_auto_trip_kod, '99999'::text)) AS trip_kod, s.t_status_name AS status_name, h.t_comment AS comment, to_char(h.t_create_time, 'DD.MM.YYYY'::text) AS create_date, to_char(h.t_create_time, 'HH24:MI'::text) AS create_time, u.t_user_name1 AS name1, u.t_user_name2 AS name2, u.t_user_name3 AS name3, u.t_phone_shot AS phone FROM t_auto_status h, t_user_kis u, t_auto_status_list s WHERE (((h.t_create_author)::text = (u.t_rec_id)::text) AND (s.t_rec_id = h.t_status_kod)) ORDER BY h.t_create_time DESC;


ALTER TABLE public.t_show_auto_status OWNER TO kisuser;

--
-- Name: t_show_auto_status_choice; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_auto_status_choice AS
    SELECT btrim(to_char(c.t_status_auto, '99'::text)) AS status_auto, btrim(to_char(s.t_rec_id, '99'::text)) AS status_kod, s.t_status_name AS status_name FROM t_auto_status_choice c, t_auto_status_list s WHERE (s.t_rec_id = c.t_status_choice) ORDER BY s.t_status_name;


ALTER TABLE public.t_show_auto_status_choice OWNER TO kisuser;

--
-- Name: t_show_auto_tasktrip; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_auto_tasktrip AS
    SELECT btrim(to_char(t.t_rec_id, '99999'::text)) AS rec_id, to_char(t.t_trip_datetime, 'DD.MM.YYYY HH24:MI'::text) AS trip_datetime, to_char(t.t_trip_datetime, 'YYYY-MM-DD'::text) AS trip_date_str, to_char(t.t_trip_datetime, 'DD.MM.YYYY'::text) AS trip_date, to_char(t.t_trip_datetime, 'HH24:MI'::text) AS trip_time, btrim(to_char(t.t_duration, '9999'::text)) AS duration, t.t_plan_or_task AS plan_or_task, t.t_route AS route, t.t_object AS object, t.t_trailer AS trailer, t.t_driver_kod AS driver_kod, CASE WHEN ((t.t_driver_kod)::text = ''::text) THEN ''::text ELSE (SELECT ((((t_auto_drivers.t_fio_driver)::text || ' ('::text) || (t_auto_drivers.t_location)::text) || ')'::text) FROM t_auto_drivers WHERE ((t_auto_drivers.t_rec_id)::text = (t.t_driver_kod)::text)) END AS driver_fio, at.t_auto_type_name AS auto_type_name, a.t_location AS auto_location, a.t_mark AS auto_mark, a.t_at_number AS auto_number, s.t_status_name AS status_name, btrim(to_char(t.t_status_kod, '99'::text)) AS status_kod, btrim(to_char(t.t_speedo1, '9999999999'::text)) AS speedo1, btrim(to_char(t.t_speedo2, '9999999999'::text)) AS speedo2, btrim(to_char(t.t_fuel, '9990.00'::text)) AS fuel, t.t_author_kod AS author_kod, u.t_user_name1 AS author_name1, u.t_user_name2 AS author_name2, u.t_user_name3 AS author_name3, u.t_phone_shot AS author_phone, u.t_email AS author_email, to_char(t.t_create_time, 'DD.MM.YYYY'::text) AS create_time, t.t_chief_email AS chief_email_data, u2.t_user_name1 AS chief_name1, u2.t_user_name2 AS chief_name2, u2.t_user_name3 AS chief_name3, u2.t_phone_shot AS chief_phone, u2.t_email AS chief_email, CASE WHEN (t.t_status_kod = 1) THEN 'blue'::text WHEN (t.t_status_kod = 6) THEN 'green'::text WHEN (t.t_status_kod = 8) THEN 'black'::text WHEN ((t.t_status_kod = 0) OR (t.t_status_kod = 3)) THEN 'red'::text WHEN (((t.t_status_kod = 2) OR (t.t_status_kod = 7)) OR (t.t_status_kod = 5)) THEN 'brown'::text ELSE ''::text END AS color, btrim(to_char(a.t_rec_id, '9999'::text)) AS at_kod, u2.t_rec_id AS chief_kod, t.t_trip_datetime_end AS trip_datetime_end, to_char(t.t_trip_datetime_end, 'DD.MM.YYYY'::text) AS trip_date_end, to_char(t.t_trip_datetime_end, 'HH24:MI'::text) AS trip_time_end, to_char(t.t_trip_datetime_end, 'YYYY-MM-DD'::text) AS trip_date_end_str, t.t_target AS target, t.t_traveler AS traveler FROM t_auto_trip t, t_user_kis u, t_auto_at_list a, t_auto_status_list s, t_auto_type_list at, t_user_kis u2 WHERE (((((t.t_status_kod = s.t_rec_id) AND ((t.t_author_kod)::text = (u.t_rec_id)::text)) AND (a.t_rec_id = t.t_auto_kod)) AND (at.t_rec_id = a.t_at_type_kod)) AND ((u2.t_rec_id)::text = (t.t_chief_kod)::text)) ORDER BY t.t_trip_datetime DESC;


ALTER TABLE public.t_show_auto_tasktrip OWNER TO kisuser;

--
-- Name: t_show_auto_trailer; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_auto_trailer AS
    SELECT btrim(to_char(t.t_rec_id, '99999'::text)) AS rec_id, btrim(to_char(t.t_auto_kod, '9999'::text)) AS auto_kod, btrim(to_char(t.t_fuel_s, '9999.00'::text)) AS fuel_s, btrim(to_char(t.t_fuel_w, '9999.00'::text)) AS fuel_w FROM t_auto_trailer t;


ALTER TABLE public.t_show_auto_trailer OWNER TO kisuser;

--
-- Name: t_show_auto_trip; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_auto_trip AS
    SELECT btrim(to_char(t.t_rec_id, '99999'::text)) AS rec_id, to_char(t.t_trip_datetime, 'DD.MM.YYYY HH24:MI'::text) AS trip_datetime, to_char(t.t_trip_datetime, 'YYYY-MM-DD'::text) AS trip_date_str, to_char(t.t_trip_datetime, 'DD.MM.YYYY'::text) AS trip_date, to_char(t.t_trip_datetime, 'HH24:MI'::text) AS trip_time, btrim(to_char(t.t_duration, '9999'::text)) AS duration, t.t_plan_or_task AS plan_or_task, t.t_route AS route, t.t_object AS object, t.t_trailer AS trailer, t.t_driver_kod AS driver_kod, d.t_fio_driver AS fio_driver, d.t_location AS location_driver, d.t_license AS license_driver, d.t_category AS category_driver, at.t_auto_type_name AS auto_type_name, a.t_location AS auto_location, a.t_mark AS auto_mark, a.t_at_number AS auto_number, s.t_status_name AS status_name, btrim(to_char(t.t_status_kod, '99'::text)) AS status_kod, btrim(to_char(t.t_speedo1, '9999999999'::text)) AS speedo1, btrim(to_char(t.t_speedo2, '9999999999'::text)) AS speedo2, btrim(to_char(t.t_fuel, '9990.00'::text)) AS fuel, t.t_author_kod AS author_kod, u.t_user_name1 AS author_name1, u.t_user_name2 AS author_name2, u.t_user_name3 AS author_name3, u.t_phone_shot AS author_phone, u.t_email AS author_email, t.t_create_time AS create_time, t.t_chief_email AS chief_email_data, u2.t_user_name1 AS chief_name1, u2.t_user_name2 AS chief_name2, u2.t_user_name3 AS chief_name3, u2.t_phone_shot AS chief_phone, u2.t_email AS chief_email, CASE WHEN (t.t_status_kod = 1) THEN 'blue'::text WHEN (t.t_status_kod = 6) THEN 'green'::text WHEN (t.t_status_kod = 8) THEN 'black'::text WHEN ((t.t_status_kod = 0) OR (t.t_status_kod = 3)) THEN 'red'::text WHEN (((t.t_status_kod = 2) OR (t.t_status_kod = 7)) OR (t.t_status_kod = 5)) THEN 'brown'::text ELSE ''::text END AS color, btrim(to_char(a.t_rec_id, '9999'::text)) AS at_kod, u2.t_rec_id AS chief_kod, t.t_trip_datetime_end AS trip_datetime_end, to_char(t.t_trip_datetime_end, 'DD.MM.YYYY'::text) AS trip_date_end, to_char(t.t_trip_datetime_end, 'HH24:MI'::text) AS trip_time_end, to_char(t.t_trip_datetime_end, 'YYYY-MM-DD'::text) AS trip_date_end_str, t.t_target AS target, t.t_traveler AS traveler FROM t_auto_trip t, t_user_kis u, t_auto_drivers d, t_auto_at_list a, t_auto_status_list s, t_auto_type_list at, t_user_kis u2 WHERE (((((((t.t_driver_kod)::text = (d.t_rec_id)::text) AND (t.t_status_kod = s.t_rec_id)) AND ((t.t_author_kod)::text = (u.t_rec_id)::text)) AND (a.t_rec_id = t.t_auto_kod)) AND (at.t_rec_id = a.t_at_type_kod)) AND ((u2.t_rec_id)::text = (t.t_chief_kod)::text)) ORDER BY t.t_trip_datetime DESC;


ALTER TABLE public.t_show_auto_trip OWNER TO kisuser;

--
-- Name: t_show_auto_trip_newtask; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_auto_trip_newtask AS
    SELECT btrim(to_char(t.t_rec_id, '99999'::text)) AS rec_id, t.t_trip_datetime AS trip_datetime, to_char(t.t_trip_datetime, 'DD.MM.YYYY'::text) AS trip_date, to_char(t.t_trip_datetime, 'HH24:MI'::text) AS trip_time, to_char(t.t_trip_datetime, 'YYYY-MM-DD'::text) AS trip_date_str, btrim(to_char(t.t_duration, '999'::text)) AS duration, t.t_route AS route, t.t_object AS object, btrim(to_char(t.t_status_kod, '99'::text)) AS status_kod, s.t_status_name AS status_name, btrim(to_char(t.t_auto_kod, '999'::text)) AS auto_kod, a.t_location AS auto_location, a.t_mark AS auto_mark, l.t_auto_type_name AS auto_type_name, t.t_trailer AS auto_trailer, t.t_author_kod AS author_kod, u.t_user_name1 AS author_name1, u.t_user_name2 AS author_name2, u.t_user_name3 AS author_name3, u.t_phone_shot AS author_phone, u.t_email AS author_email, to_char(t.t_create_time, 'DD.MM.YYYY HH24:MI'::text) AS create_time, t.t_chief_email AS chief_email, CASE WHEN ((t.t_chief_kod)::text = ''::text) THEN ''::text ELSE (SELECT (((t_user_kis.t_user_name2)::text || ' '::text) || (t_user_kis.t_user_name1)::text) FROM t_user_kis WHERE ((t_user_kis.t_rec_id)::text = (t.t_chief_kod)::text)) END AS chief, CASE WHEN (t.t_status_kod = 1) THEN 'blue'::text WHEN (t.t_status_kod = 6) THEN 'green'::text WHEN (t.t_status_kod = 8) THEN 'black'::text WHEN ((t.t_status_kod = 0) OR (t.t_status_kod = 3)) THEN 'red'::text WHEN (((t.t_status_kod = 2) OR (t.t_status_kod = 7)) OR (t.t_status_kod = 5)) THEN 'brown'::text ELSE ''::text END AS color, t.t_trip_datetime_end AS trip_datetime_end, to_char(t.t_trip_datetime_end, 'DD.MM.YYYY'::text) AS trip_date_end, to_char(t.t_trip_datetime_end, 'HH24:MI'::text) AS trip_time_end, to_char(t.t_trip_datetime_end, 'YYYY-MM-DD'::text) AS trip_date_end_str, t.t_target AS target, t.t_traveler AS traveler FROM t_auto_trip t, t_user_kis u, t_auto_at_list a, t_auto_status_list s, t_auto_type_list l WHERE ((((((t.t_author_kod)::text = (u.t_rec_id)::text) AND (t.t_auto_kod = a.t_rec_id)) AND (t.t_status_kod = s.t_rec_id)) AND (a.t_at_type_kod = l.t_rec_id)) AND (t.t_plan_or_task = 'task'::bpchar)) ORDER BY t.t_trip_datetime DESC;


ALTER TABLE public.t_show_auto_trip_newtask OWNER TO kisuser;

--
-- Name: t_show_auto_type_list; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_auto_type_list AS
    SELECT btrim(to_char(t.t_rec_id, '999'::text)) AS rec_id, t.t_auto_type_name AS type_name FROM t_auto_type_list t WHERE (t.t_rec_delete = 0) ORDER BY t.t_auto_type_name;


ALTER TABLE public.t_show_auto_type_list OWNER TO kisuser;

--
-- Name: t_show_d; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_d AS
    SELECT btrim(to_char(d.t_rec_id, '99999'::text)) AS rec_id, d.t_create_date AS create_date, to_char((d.t_create_date)::timestamp with time zone, 'DD.MM.YYYY'::text) AS create_date_str, d.t_contragent AS contragent, d.t_tema AS tema, btrim(to_char(d.t_dstatus_kod, '999'::text)) AS status_kod, s.t_d_status_name AS status_name, d.t_email_ruk AS email_ruk, d.t_d_text AS d_text, u.t_rec_id AS user_kod, u.t_user_name2 AS user_name1, u.t_user_name1 AS user_name2, u.t_user_name3 AS user_name3, u.t_phone_shot AS user_phone, u.t_email AS user_email, u2.t_rec_id AS ruk_kod, u2.t_user_name1 AS ruk_name1, u2.t_user_name2 AS ruk_name2, u2.t_user_name3 AS ruk_name3, u2.t_phone_shot AS ruk_phone, u2.t_email AS ruk_email, d.t_file_name AS doc_name, d.t_ext AS doc_ext, d.t_doc_ver AS doc_ver, btrim(to_char(d.t_doc_ver, '99'::text)) AS doc_ver_str, d.t_doc_time AS doc_time, CASE WHEN (d.t_doc_data IS NULL) THEN ''::text ELSE to_char(d.t_doc_time, 'DD.MM.YYYY HH24:MI'::text) END AS doc_time_str, u3.t_rec_id AS doc_author_kod, u3.t_user_name1 AS doc_author_name1, u3.t_user_name2 AS doc_author_name2, u3.t_user_name3 AS doc_author_name3, u3.t_phone_shot AS doc_author_phone, u3.t_email AS doc_author_email, d.t_app_filename AS app_name, d.t_app_ext AS app_ext, d.t_app_time AS app_time, CASE WHEN (d.t_app_data IS NULL) THEN ''::text ELSE to_char(d.t_app_time, 'DD.MM.YYYY HH24:MI'::text) END AS app_time_str, u4.t_rec_id AS app_author_kod, u4.t_user_name1 AS app_author_name1, u4.t_user_name2 AS app_author_name2, u4.t_user_name3 AS app_author_name3, u4.t_phone_shot AS app_author_phone, u4.t_email AS app_author_email, CASE WHEN ((d.t_dstatus_kod = 0) OR (d.t_dstatus_kod = 9)) THEN 'red'::text WHEN ((d.t_dstatus_kod = 8) OR (d.t_dstatus_kod = 3)) THEN 'darkgoldenrod'::text WHEN (d.t_dstatus_kod = 5) THEN 'green'::text WHEN (d.t_dstatus_kod = 7) THEN 'black'::text WHEN ((d.t_dstatus_kod = 2) OR (d.t_dstatus_kod = 4)) THEN 'brown'::text ELSE 'blue'::text END AS color FROM t_d d, t_user_kis u, t_user_kis u2, t_d_status_list s, t_user_kis u3, t_user_kis u4 WHERE (((((((d.t_create_author)::text = (u.t_rec_id)::text) AND ((d.t_ruk_kod)::text = (u2.t_rec_id)::text)) AND (d.t_dstatus_kod = s.t_rec_id)) AND ((d.t_doc_author)::text = (u3.t_rec_id)::text)) AND ((d.t_app_author)::text = (u4.t_rec_id)::text)) AND (d.t_rec_delete = 0)) ORDER BY d.t_rec_id DESC;


ALTER TABLE public.t_show_d OWNER TO kisuser;

--
-- Name: t_show_d_docs; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_d_docs AS
    SELECT d.t_rec_id AS rec_id, btrim(to_char(d.t_d_kod, '99999'::text)) AS d_kod, d.t_comment AS comment, d.t_ext AS ext, d.t_file_name AS file_name, d.t_create_date AS create_date, to_char((d.t_create_date)::timestamp with time zone, 'DD.MM.YYYY'::text) AS create_date_str, u.t_rec_id AS user_kod, u.t_user_name1 AS user_name1, u.t_user_name2 AS user_name2, u.t_user_name3 AS user_name3, u.t_phone_shot AS user_phone FROM t_d_docs d, t_user_kis u WHERE (((u.t_rec_id)::text = (d.t_create_author)::text) AND (d.t_rec_delete = 0)) ORDER BY d.t_create_date DESC;


ALTER TABLE public.t_show_d_docs OWNER TO kisuser;

--
-- Name: t_show_d_email_history; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_d_email_history AS
    SELECT btrim(to_char(e.t_d_kod, '99999'::text)) AS d_kod, e.t_subject AS subject, to_char(e.t_datetime, 'DD.MM.YYYY'::text) AS date_, to_char(e.t_datetime, 'HH24:MI'::text) AS time_, e.t_email AS email FROM t_d_email_history e ORDER BY e.t_datetime DESC;


ALTER TABLE public.t_show_d_email_history OWNER TO kisuser;

--
-- Name: t_show_d_person; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_d_person AS
    SELECT p.t_rec_id AS rec_id, btrim(to_char(p.t_d_kod, '99999'::text)) AS d_kod, (((uu.t_user_name2)::text || ' '::text) || (uu.t_user_name1)::text) AS person, uu.t_phone_shot AS person_phone, uu.t_email AS person_email, CASE WHEN (p.t_dstatus_kod IS NULL) THEN ''::character varying ELSE (SELECT s.t_d_status_name FROM t_d_status_list s WHERE (p.t_dstatus_kod = s.t_rec_id)) END AS dstatus, CASE WHEN (p.t_dstatus_kod IS NULL) THEN ''::text ELSE btrim(to_char(p.t_ver, '999'::text)) END AS ver, CASE WHEN (p.t_dstatus_kod IS NULL) THEN ''::text ELSE to_char((p.t_dstatus_date)::timestamp with time zone, 'DD.MM.YYYY'::text) END AS status_date, CASE WHEN (p.t_dstatus_kod IS NULL) THEN ''::text ELSE btrim(to_char(p.t_lag_day, '999999999'::text)) END AS lag_day, to_char(p.t_create_time, 'DD.MM.YYYY'::text) AS create_date, (((u.t_user_name2)::text || ' '::text) || (u.t_user_name1)::text) AS create_user, u.t_phone_shot AS user_phone, CASE WHEN (p.t_app_time IS NULL) THEN ''::text ELSE to_char(p.t_app_time, 'DD.MM.YYYY HH24:MI'::text) END AS app_time, CASE WHEN (p.t_order_agremnt = 0) THEN ''::text ELSE to_char(p.t_order_agremnt, '9999999'::text) END AS order_agremnt, p.t_person_kod AS person_kod FROM t_d_person p, t_user_kis u, t_user_kis uu WHERE (((p.t_rec_delete = 0) AND ((p.t_create_author)::text = (u.t_rec_id)::text)) AND ((p.t_person_kod)::text = (uu.t_rec_id)::text)) ORDER BY p.t_order_agremnt;


ALTER TABLE public.t_show_d_person OWNER TO kisuser;

--
-- Name: t_show_d_person_next; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_d_person_next AS
    SELECT btrim(to_char(t_d_person_next.t_d_kod, '99999'::text)) AS d_kod, t_user_kis.t_rec_id AS person_kod, t_user_kis.t_user_name1 AS name1, t_user_kis.t_user_name2 AS name2, t_user_kis.t_user_name3 AS name3, t_user_kis.t_phone_shot AS phone, t_user_kis.t_email AS email, date_part('day'::text, (now() - (t_d_person_next.t_start_time)::timestamp with time zone)) AS lag_day, t_d_person_next.t_send_email AS send_email FROM t_d_person_next, t_user_kis WHERE ((t_user_kis.t_rec_id)::text = (t_d_person_next.t_user_kod)::text);


ALTER TABLE public.t_show_d_person_next OWNER TO kisuser;

--
-- Name: t_show_d_status; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_d_status AS
    SELECT ds.t_rec_id AS rec_id, btrim(to_char(ds.t_d_kod, '99999'::text)) AS d_kod, ds.t_comment AS comment, s.t_d_status_name AS status_name, to_char(ds.t_create_time, 'DD.MM.YYYY'::text) AS create_date, to_char(ds.t_create_time, 'HH24:MI'::text) AS create_time, t_user_kis.t_user_name1 AS user_name1, t_user_kis.t_user_name2 AS user_name2, t_user_kis.t_user_name3 AS user_name3, t_user_kis.t_phone_shot AS user_phone, t_user_kis.t_email AS user_email FROM t_d_status ds, t_d_status_list s, t_user_kis WHERE (((ds.t_dstatus_kod = s.t_rec_id) AND ((ds.t_create_author)::text = (t_user_kis.t_rec_id)::text)) AND (ds.t_rec_delete = 0)) ORDER BY ds.t_create_time DESC;


ALTER TABLE public.t_show_d_status OWNER TO kisuser;

--
-- Name: t_show_d_status_list; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_d_status_list AS
    SELECT btrim(to_char(t_d_status_list.t_rec_id, '99'::text)) AS status_kod, t_d_status_list.t_d_status_name AS status_name, btrim(to_char(t_d_status_choice.t_status_d, '99'::text)) AS status_d_kod FROM t_d_status_list, t_d_status_choice WHERE ((t_d_status_list.t_rec_id = t_d_status_choice.t_status_choice) AND (t_d_status_list.t_rec_delete = 0)) ORDER BY t_d_status_list.t_d_status_name;


ALTER TABLE public.t_show_d_status_list OWNER TO kisuser;

--
-- Name: t_show_it_admin_group; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_it_admin_group AS
    SELECT u.t_rec_id AS rec_id, u.t_user_name1 AS name1, u.t_user_name2 AS name2, u.t_user_name3 AS name3, u.t_phone_shot AS phone, u.t_email AS email FROM t_it_admin_group a, t_user_kis u WHERE ((u.t_rec_id)::text = (a.t_rec_id)::text) ORDER BY u.t_user_name2, u.t_user_name1;


ALTER TABLE public.t_show_it_admin_group OWNER TO kisuser;

--
-- Name: t_show_it_category_list; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_it_category_list AS
    SELECT btrim(to_char(c.t_rec_id, '99'::text)) AS rec_id, c.t_itkategory_name AS category_name FROM t_itkategory_list c WHERE (c.t_rec_delete = 0) ORDER BY c.t_itkategory_name;


ALTER TABLE public.t_show_it_category_list OWNER TO kisuser;

--
-- Name: t_show_it_comment_user; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_it_comment_user AS
    SELECT d.t_rec_id AS rec_id, d.t_it_task_kod AS it_task_kod, to_char(d.t_create_time, 'DD.MM.YYYY'::text) AS create_date, to_char(d.t_create_time, 'HH24:MI'::text) AS create_time, d.t_ext AS ext, d.t_filename AS filename, d.t_user_comment AS user_comment, d.t_ip AS ip FROM t_it_docs d WHERE ((d.t_rec_delete = 0) AND ((d.t_task_work_kod)::text = ''::text)) ORDER BY d.t_create_time DESC;


ALTER TABLE public.t_show_it_comment_user OWNER TO kisuser;

--
-- Name: t_show_it_email_history; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_it_email_history AS
    SELECT e.t_task_kod AS task_kod, e.t_subject AS subject, to_char(e.t_datetime, 'DD.MM.YYYY'::text) AS date_, to_char(e.t_datetime, 'HH24:MI'::text) AS time_, e.t_email AS email FROM t_it_email_history e ORDER BY e.t_datetime DESC;


ALTER TABLE public.t_show_it_email_history OWNER TO kisuser;

--
-- Name: t_show_it_status_list; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_it_status_list AS
    SELECT btrim(to_char(s.t_rec_id, '99'::text)) AS rec_id, s.t_itstatus_name AS status_name FROM t_itstatus_list s WHERE (s.t_rec_delete = 0) ORDER BY s.t_itstatus_name;


ALTER TABLE public.t_show_it_status_list OWNER TO kisuser;

--
-- Name: t_show_it_task; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_it_task AS
    SELECT i.t_rec_id AS rec_id, btrim(to_char(i.t_serial_n, '999999'::text)) AS serial_n, i.t_datetime AS datetime, to_char(i.t_datetime, 'DD.MM.YYYY'::text) AS date_str, to_char(i.t_datetime, 'HH24:MI'::text) AS time_str, btrim(to_char(i.t_workhour, '999'::text)) AS workhour, i.t_tema AS tema, i.t_isp_kod AS isp_kod, u.t_user_name1 AS isp_name1, u.t_user_name2 AS isp_name2, u.t_user_name3 AS isp_name3, u.t_phone_shot AS isp_phone, u.t_email AS isp_email, btrim(to_char(i.t_itstatus_kod, '99'::text)) AS status_kod, s.t_itstatus_name AS status_name, btrim(to_char(i.t_itkategory_kod, '99'::text)) AS kategory_kod, k.t_itkategory_name AS kategory_name, i.t_text AS task_text, i.t_person AS user_fio, i.t_phone AS user_phone, i.t_email AS user_email, i.t_ip AS user_ip, i.t_user_kod AS user_kod, CASE WHEN ((i.t_itstatus_kod = 0) OR (i.t_itstatus_kod = 6)) THEN 'red'::text WHEN ((i.t_itstatus_kod = 1) OR (i.t_itstatus_kod = 2)) THEN 'blue'::text WHEN (i.t_itstatus_kod = 4) THEN 'brown'::text WHEN (i.t_itstatus_kod = 3) THEN 'black'::text WHEN (i.t_itstatus_kod = 5) THEN 'green'::text ELSE ''::text END AS color FROM t_it_task i, t_itkategory_list k, t_user_kis u, t_itstatus_list s WHERE ((((i.t_itkategory_kod = k.t_rec_id) AND (i.t_itstatus_kod = s.t_rec_id)) AND ((i.t_isp_kod)::text = (u.t_rec_id)::text)) AND (i.t_rec_delete = 0)) ORDER BY i.t_datetime DESC;


ALTER TABLE public.t_show_it_task OWNER TO kisuser;

--
-- Name: t_show_it_task_work; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_it_task_work AS
    SELECT t.t_rec_id AS rec_id, t.t_it_task_kod AS task_kod, to_char(t.t_datetime, 'DD.MM.YYYY'::text) AS date_str, to_char(t.t_datetime, 'HH24:MI'::text) AS time_str, t.t_comment AS task_comment, btrim(to_char(t.t_itstatus_kod, '999'::text)) AS itstatus_kod, s.t_itstatus_name AS itstatus_name, btrim(to_char(t.t_itkategory_kod, '999'::text)) AS itkategory_kod, k.t_itkategory_name AS itkategory_name, u.t_user_name1 AS name1, u.t_user_name2 AS name2, u.t_user_name3 AS name3, u.t_phone_shot AS phone, t.t_ip AS ip, CASE WHEN ((t.t_rec_id)::text IN (SELECT x.t_task_work_kod FROM t_it_docs x WHERE (x.t_rec_delete = 0))) THEN (SELECT t_it_docs.t_filename FROM t_it_docs WHERE ((t_it_docs.t_task_work_kod)::text = (t.t_rec_id)::text)) ELSE ''::character varying END AS filename, CASE WHEN ((t.t_rec_id)::text IN (SELECT x.t_task_work_kod FROM t_it_docs x WHERE (x.t_rec_delete = 0))) THEN (SELECT ((t_it_docs.t_rec_id)::text || (t_it_docs.t_ext)::text) FROM t_it_docs WHERE ((t_it_docs.t_task_work_kod)::text = (t.t_rec_id)::text)) ELSE ''::text END AS filename2, u.t_email AS email, btrim(to_char(t.t_drp, '999'::text)) AS drp FROM t_it_task_work t, t_itstatus_list s, t_itkategory_list k, t_user_kis u WHERE ((((t.t_rec_delete = 0) AND (t.t_itstatus_kod = s.t_rec_id)) AND (t.t_itkategory_kod = k.t_rec_id)) AND ((t.t_author_kod)::text = (u.t_rec_id)::text)) ORDER BY t.t_datetime DESC;


ALTER TABLE public.t_show_it_task_work OWNER TO kisuser;

--
-- Name: t_show_itreport; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_itreport AS
    SELECT t.t_serial_n AS serial, t.t_rec_id AS rec_id, (((u.t_user_name2)::text || ' '::text) || (u.t_user_name1)::text) AS isp, u.t_phone_shot AS phone, t.t_workhour AS workhour, t.t_itstatus_kod AS status, (SELECT date(t_it_task_work.t_datetime) AS date FROM t_it_task_work WHERE (((t_it_task_work.t_it_task_kod)::text = (t.t_rec_id)::text) AND (t_it_task_work.t_rec_delete = 0)) ORDER BY t_it_task_work.t_datetime DESC LIMIT 1) AS last_date FROM t_it_task t, t_user_kis u WHERE ((t.t_rec_delete = 0) AND ((t.t_isp_kod)::text = (u.t_rec_id)::text));


ALTER TABLE public.t_show_itreport OWNER TO kisuser;

--
-- Name: t_tmc; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_tmc (
    t_rec_id integer NOT NULL,
    t_date_create date DEFAULT ('now'::text)::date NOT NULL,
    t_author_kod character varying(24) NOT NULL,
    t_shifr_z character varying(100) DEFAULT ''::character varying NOT NULL,
    t_note_text text DEFAULT ''::text NOT NULL,
    t_date_ruk date DEFAULT ('now'::text)::date NOT NULL,
    t_ruk_kod character varying(24) DEFAULT ''::character varying NOT NULL,
    t_date_status date DEFAULT ('now'::text)::date NOT NULL,
    t_status_kod integer DEFAULT 0 NOT NULL,
    t_dep_kod integer,
    t_dep_group_kod integer,
    t_rec_delete integer DEFAULT 0 NOT NULL,
    t_tema character varying(100) DEFAULT ''::character varying NOT NULL,
    t_grouptmc character varying(10) DEFAULT 'common'::bpchar NOT NULL,
    t_shifr character varying(100) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.t_tmc OWNER TO kisuser;

--
-- Name: t_show_order; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_order AS
    SELECT btrim(to_char(o.t_rec_id, '9999'::text)) AS rec_id, to_char((o.t_order_date)::timestamp with time zone, 'DD.MM.YYYY'::text) AS order_date, btrim(to_char(t.t_rec_id, '9999'::text)) AS tmc, to_char((t.t_date_create)::timestamp with time zone, 'DD.MM.YYYY'::text) AS tmc_date, t.t_tema AS tmc_tema, t.t_shifr_z AS tmc_shifr, o.t_project_name AS project_name, t.t_ruk_kod AS chief_kod, o.t_order_author_kod AS author_kod, o.t_executor_kod AS executor_kod, author.t_user_name1 AS author_name1, author.t_user_name2 AS author_name2, author.t_user_name3 AS author_name3, author.t_phone_shot AS author_phone, executor.t_user_name1 AS executor_name1, executor.t_user_name2 AS executor_name2, executor.t_user_name3 AS executor_name3, executor.t_phone_shot AS executor_phone FROM t_order o, t_tmc t, t_user_kis author, t_user_kis executor WHERE (((o.t_tmc_kod = t.t_rec_id) AND ((o.t_order_author_kod)::text = (author.t_rec_id)::text)) AND ((o.t_executor_kod)::text = (executor.t_rec_id)::text)) ORDER BY o.t_rec_id DESC;


ALTER TABLE public.t_show_order OWNER TO kisuser;

--
-- Name: t_tmc_spec; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_tmc_spec (
    t_rec_id character varying(24) NOT NULL,
    t_tmc_kod integer NOT NULL,
    t_row_kod integer DEFAULT 0 NOT NULL,
    t_row_name character varying(250) NOT NULL,
    t_row_okei_kod integer NOT NULL,
    t_row_q numeric(10,2) DEFAULT 0.00 NOT NULL,
    t_row_cost numeric(10,2) DEFAULT 0.00 NOT NULL,
    t_row_analog character varying(250) DEFAULT ''::character varying NOT NULL,
    t_row_note character varying(250) DEFAULT ''::character varying NOT NULL,
    t_create_author character varying(24) NOT NULL,
    t_create_time timestamp without time zone DEFAULT now() NOT NULL,
    t_update_author character varying(24) NOT NULL,
    t_update_time timestamp without time zone DEFAULT now() NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.t_tmc_spec OWNER TO kisuser;

--
-- Name: t_show_order_spec; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_order_spec AS
    SELECT btrim(to_char(s.t_rec_id, '99999'::text)) AS rec_id, btrim(to_char(s.t_order_kod, '9999'::text)) AS order_kod, t.t_row_name AS name, o.t_okei_name_shot AS okei, btrim(to_char(s.t_q, '9999990.00'::text)) AS q, t.t_row_note AS note FROM t_order_spec s, t_tmc_spec t, t_okei_list o WHERE ((((s.t_spec_kod)::text = (t.t_rec_id)::text) AND (t.t_row_okei_kod = o.t_rec_id)) AND (s.t_q <> 0.00)) ORDER BY t.t_row_name;


ALTER TABLE public.t_show_order_spec OWNER TO kisuser;

--
-- Name: t_store_eisup_list; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_store_eisup_list (
    t_rec_id character varying(12) NOT NULL,
    t_name character varying(250) NOT NULL,
    t_name_type character varying(100) DEFAULT ''::character varying NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL,
    t_model_kod integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.t_store_eisup_list OWNER TO kisuser;

--
-- Name: t_store_model_data_list; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_store_model_data_list (
    t_rec_id integer NOT NULL,
    t_model_name character varying(50) NOT NULL,
    t_info text
);


ALTER TABLE public.t_store_model_data_list OWNER TO kisuser;

--
-- Name: t_store_total_rest; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_store_total_rest (
    t_rec_id character varying(12) NOT NULL,
    t_okei_kod integer NOT NULL,
    t_rest numeric(10,2) DEFAULT 0.00 NOT NULL
);


ALTER TABLE public.t_store_total_rest OWNER TO kisuser;

--
-- Name: t_show_store_eisup_list; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_store_eisup_list AS
    SELECT e.t_rec_id AS rec_id, e.t_name AS name, o.t_okei_name_shot AS okei, s.t_rest AS rest, e.t_name_type AS name_type, btrim(to_char(e.t_model_kod, '99'::text)) AS model_kod, m.t_model_name AS model_name FROM t_store_eisup_list e, t_store_total_rest s, t_okei_list o, t_store_model_data_list m WHERE ((((e.t_rec_delete = 0) AND ((e.t_rec_id)::text = (s.t_rec_id)::text)) AND (s.t_okei_kod = o.t_rec_id)) AND (e.t_model_kod = m.t_rec_id)) ORDER BY e.t_name;


ALTER TABLE public.t_show_store_eisup_list OWNER TO kisuser;

--
-- Name: t_store_list; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_store_list (
    t_rec_id integer NOT NULL,
    t_store_name character varying(100) NOT NULL,
    t_create_date date DEFAULT ('now'::text)::date NOT NULL,
    t_create_user character varying(24) DEFAULT ''::character varying NOT NULL,
    t_edit_date date DEFAULT ('now'::text)::date NOT NULL,
    t_edit_user character varying(24) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.t_store_list OWNER TO kisuser;

--
-- Name: t_show_store_list; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_store_list AS
    SELECT btrim(to_char(s.t_rec_id, '999'::text)) AS rec_id, s.t_store_name AS store_name, to_char((s.t_create_date)::timestamp with time zone, 'DD.MM.YYYY'::text) AS create_date, u.t_user_name1 AS create_name1, u.t_user_name2 AS create_name2, u.t_user_name3 AS create_name3, u.t_phone_shot AS create_phone, CASE WHEN ((s.t_edit_user)::text = ''::text) THEN ''::text ELSE to_char((s.t_edit_date)::timestamp with time zone, 'DD.MM.YYYY'::text) END AS edit_date, uu.t_user_name1 AS edit_name1, uu.t_user_name2 AS edit_name2, uu.t_user_name3 AS edit_name3, uu.t_phone_shot AS edit_phone FROM t_store_list s, t_user_kis u, t_user_kis uu WHERE (((s.t_create_user)::text = (u.t_rec_id)::text) AND ((s.t_edit_user)::text = (uu.t_rec_id)::text)) ORDER BY s.t_store_name;


ALTER TABLE public.t_show_store_list OWNER TO kisuser;

--
-- Name: t_show_store_model_data_list; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_store_model_data_list AS
    SELECT btrim(to_char(m.t_rec_id, '99'::text)) AS rec_id, m.t_model_name AS model_name FROM t_store_model_data_list m ORDER BY m.t_model_name;


ALTER TABLE public.t_show_store_model_data_list OWNER TO kisuser;

--
-- Name: t_store_onein; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_store_onein (
    t_rec_id character varying(24) NOT NULL,
    t_type_one integer DEFAULT 0 NOT NULL,
    t_one_kod character varying(12) NOT NULL,
    t_modeldata_kod integer NOT NULL,
    t_okei_kod integer NOT NULL,
    t_barcode character varying(100) DEFAULT ''::character varying NOT NULL,
    t_q numeric(10,2) NOT NULL,
    t_comment text[] NOT NULL,
    t_cancel boolean DEFAULT false NOT NULL,
    t_create_datetime timestamp without time zone DEFAULT now() NOT NULL,
    t_author_kod character varying(24) NOT NULL,
    t_store_kod integer NOT NULL,
    t_canceled boolean DEFAULT false NOT NULL
);


ALTER TABLE public.t_store_onein OWNER TO kisuser;

--
-- Name: COLUMN t_store_onein.t_type_one; Type: COMMENT; Schema: public; Owner: kisuser
--

COMMENT ON COLUMN t_store_onein.t_type_one IS 'Тип :
0 - Поступление
1 - Ввод остатка';


--
-- Name: COLUMN t_store_onein.t_cancel; Type: COMMENT; Schema: public; Owner: kisuser
--

COMMENT ON COLUMN t_store_onein.t_cancel IS 'Флаг, что транзакция (поступление) может быть отменена.';


--
-- Name: t_show_store_onein; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_store_onein AS
    SELECT i.t_rec_id AS rec_id, i.t_one_kod AS one_kod, i.t_cancel AS cancel, i.t_type_one AS type_one, i.t_create_datetime AS datetime, o.t_okei_name_shot AS okei_name, i.t_modeldata_kod AS modeldata, i.t_comment AS comment, i.t_barcode AS barcode, s.t_store_name AS store_name, i.t_q AS q, u.t_user_name1 AS name1, u.t_user_name2 AS name2, u.t_user_name3 AS name3, u.t_phone_shot AS phone, m.t_model_name AS model_name FROM t_store_onein i, t_store_list s, t_okei_list o, t_user_kis u, t_store_model_data_list m WHERE ((((i.t_okei_kod = o.t_rec_id) AND ((i.t_author_kod)::text = (u.t_rec_id)::text)) AND (i.t_store_kod = s.t_rec_id)) AND (i.t_modeldata_kod = m.t_rec_id)) ORDER BY i.t_create_datetime DESC;


ALTER TABLE public.t_show_store_onein OWNER TO kisuser;

--
-- Name: t_store_oneout; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_store_oneout (
    t_rec_id character varying(24) NOT NULL,
    t_onein_kod character varying(24) NOT NULL,
    t_q numeric(10,2) DEFAULT 0 NOT NULL,
    t_tmc_spec_kod character varying(24),
    t_tmc_kod integer,
    t_comment text[],
    t_author_kod character varying(24) NOT NULL,
    t_create_datetime timestamp without time zone DEFAULT now() NOT NULL,
    t_canceled boolean DEFAULT false NOT NULL,
    t_barcode character varying(100) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE public.t_store_oneout OWNER TO kisuser;

--
-- Name: t_show_store_oneout; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_store_oneout AS
    SELECT o.t_rec_id AS rec_id, o.t_create_datetime AS datetime, o.t_tmc_kod AS tmc_kod, m.t_rec_id AS model_kod, m.t_model_name AS model_name, s.t_store_name AS store_name, k.t_okei_name_shot AS okei, k.t_rec_id AS okei_kod, o.t_q AS q, u.t_user_name1 AS name1, u.t_user_name2 AS name2, u.t_user_name3 AS name3, u.t_phone_shot AS phone, i.t_one_kod AS one_kod, CASE WHEN ((date(o.t_create_datetime) = ('now'::text)::date) AND (o.t_canceled = false)) THEN true ELSE false END AS cancel, o.t_barcode AS barcode, o.t_comment AS comment FROM t_store_oneout o, t_store_model_data_list m, t_store_onein i, t_store_list s, t_okei_list k, t_user_kis u WHERE ((((((o.t_onein_kod)::text = (i.t_rec_id)::text) AND (i.t_modeldata_kod = m.t_rec_id)) AND (i.t_store_kod = s.t_rec_id)) AND (i.t_okei_kod = k.t_rec_id)) AND ((u.t_rec_id)::text = (o.t_author_kod)::text)) ORDER BY o.t_create_datetime DESC;


ALTER TABLE public.t_show_store_oneout OWNER TO kisuser;

--
-- Name: t_store_person; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_store_person (
    t_rec_id integer NOT NULL,
    t_store_kod integer NOT NULL,
    t_person_kod character varying(24) NOT NULL,
    t_create_user character varying(24) NOT NULL,
    t_create_date date DEFAULT ('now'::text)::date NOT NULL
);


ALTER TABLE public.t_store_person OWNER TO kisuser;

--
-- Name: t_show_store_person; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_store_person AS
    SELECT btrim(to_char(p.t_rec_id, '999'::text)) AS rec_id, btrim(to_char(p.t_store_kod, '999'::text)) AS store_kod, s.t_store_name AS store_name, p.t_person_kod AS person_kod, u.t_user_name1 AS person_name1, u.t_user_name2 AS person_name2, u.t_user_name3 AS person_name3, u.t_phone_shot AS person_phone, u.t_email AS person_email, to_char((p.t_create_date)::timestamp with time zone, 'DD.MM.YYYY'::text) AS create_date, uu.t_user_name1 AS user_name1, uu.t_user_name2 AS user_name2, uu.t_user_name3 AS user_name3, uu.t_phone_shot AS user_phone FROM t_store_list s, t_store_person p, t_user_kis u, t_user_kis uu WHERE ((((p.t_create_user)::text = (uu.t_rec_id)::text) AND ((p.t_person_kod)::text = (u.t_rec_id)::text)) AND (p.t_store_kod = s.t_rec_id)) ORDER BY s.t_store_name, u.t_user_name1, u.t_user_name2, u.t_user_name3;


ALTER TABLE public.t_show_store_person OWNER TO kisuser;

--
-- Name: t_store_action_list; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_store_action_list (
    t_rec_id integer NOT NULL,
    t_action_name character varying(100) NOT NULL
);


ALTER TABLE public.t_store_action_list OWNER TO kisuser;

--
-- Name: t_store_process; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_store_process (
    t_rec_id character varying(24) NOT NULL,
    t_action_kod integer NOT NULL,
    t_store_kod integer NOT NULL,
    t_one_kod character varying(12) NOT NULL,
    t_okei_kod integer NOT NULL,
    t_before_q numeric(10,2) DEFAULT 0.00 NOT NULL,
    t_q numeric(10,2) DEFAULT 0.00 NOT NULL,
    t_after_q numeric(10,2) DEFAULT 0.00 NOT NULL,
    t_create_datetime timestamp without time zone DEFAULT now() NOT NULL,
    t_author_kod character varying(24) NOT NULL
);


ALTER TABLE public.t_store_process OWNER TO kisuser;

--
-- Name: t_show_store_process; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_store_process AS
    SELECT p.t_rec_id AS rec_id, p.t_create_datetime AS datetime, s.t_store_name AS store_name, o.t_okei_name_shot AS okei_name, p.t_before_q AS before_q, p.t_q AS q, p.t_after_q AS after_q, a.t_action_name AS action_name, u.t_user_name1 AS name1, u.t_user_name2 AS name2, u.t_user_name3 AS name3, u.t_phone_shot AS phone, p.t_one_kod AS one_kod FROM t_store_process p, t_user_kis u, t_store_list s, t_okei_list o, t_store_action_list a WHERE (((((p.t_author_kod)::text = (u.t_rec_id)::text) AND (p.t_store_kod = s.t_rec_id)) AND (p.t_okei_kod = o.t_rec_id)) AND (p.t_action_kod = a.t_rec_id)) ORDER BY p.t_create_datetime DESC;


ALTER TABLE public.t_show_store_process OWNER TO kisuser;

--
-- Name: t_store_reserve; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_store_reserve (
    t_rec_id character varying(24) NOT NULL,
    t_reserve numeric(10,2) NOT NULL,
    t_onein_kod character varying(24) NOT NULL,
    t_tmc_spec_kod character varying(24),
    t_create_datetime timestamp without time zone DEFAULT now() NOT NULL,
    t_author_kod character varying(24) NOT NULL
);


ALTER TABLE public.t_store_reserve OWNER TO kisuser;

--
-- Name: t_show_store_reserve; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_store_reserve AS
    SELECT r.t_rec_id AS rec_id, r.t_create_datetime AS datetime, s.t_rec_id AS store_kod, s.t_store_name AS store_name, i.t_okei_kod AS okei_kod, o.t_okei_name_shot AS okei, r.t_reserve AS reserve, c.t_tmc_kod AS tmc_kod, u.t_user_name1 AS name1, u.t_user_name2 AS name2, u.t_user_name3 AS name3, u.t_phone_shot AS phone, i.t_one_kod AS one_kod, e.t_name AS one_name, e.t_name_type AS name_type, i.t_modeldata_kod AS modeldata_kod, m.t_model_name AS model_name FROM t_store_reserve r, t_user_kis u, t_store_onein i, t_store_list s, t_okei_list o, t_tmc_spec c, t_store_model_data_list m, t_store_eisup_list e WHERE ((((((((r.t_onein_kod)::text = (i.t_rec_id)::text) AND ((r.t_tmc_spec_kod)::text = (c.t_rec_id)::text)) AND ((u.t_rec_id)::text = (r.t_author_kod)::text)) AND (i.t_store_kod = s.t_rec_id)) AND (i.t_okei_kod = o.t_rec_id)) AND (i.t_modeldata_kod = m.t_rec_id)) AND ((i.t_one_kod)::text = (e.t_rec_id)::text)) ORDER BY r.t_create_datetime DESC;


ALTER TABLE public.t_show_store_reserve OWNER TO kisuser;

--
-- Name: t_store_rest; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_store_rest (
    t_rec_id character varying(24) NOT NULL,
    t_okei_kod integer NOT NULL,
    t_store_kod integer NOT NULL,
    t_rest numeric(10,2) NOT NULL,
    t_one_kod character varying(12) NOT NULL
);


ALTER TABLE public.t_store_rest OWNER TO kisuser;

--
-- Name: t_show_store_rest; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_store_rest AS
    SELECT t_store_rest.t_one_kod AS one_kod, t_store_list.t_store_name AS store_name, t_okei_list.t_okei_name_shot AS okei_name, t_store_rest.t_rest AS rest FROM t_store_rest, t_store_list, t_okei_list WHERE (((t_store_rest.t_store_kod = t_store_list.t_rec_id) AND (t_store_rest.t_okei_kod = t_okei_list.t_rec_id)) AND (t_store_rest.t_rest <> (0)::numeric)) ORDER BY t_store_list.t_store_name;


ALTER TABLE public.t_show_store_rest OWNER TO kisuser;

--
-- Name: t_show_store_tmc; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_store_tmc AS
    SELECT s.t_rec_id AS spec_kod, s.t_row_name AS spec_name, s.t_row_okei_kod AS okei_kod, o.t_okei_name_shot AS okei_name, s.t_row_q AS spec_q, t.t_rec_id AS tmc_kod, t.t_date_create AS date_create, t.t_tema AS tema, u.t_user_name1 AS user1, u.t_user_name2 AS user2, u.t_user_name3 AS user3, u.t_phone_shot AS phone, t.t_status_kod AS status_kod, t.t_grouptmc AS grouptmc, (SELECT sum(t_store_oneout.t_q) AS sum FROM t_store_oneout WHERE ((t_store_oneout.t_tmc_spec_kod)::text = (s.t_rec_id)::text)) AS tmcout, (SELECT sum(t_store_reserve.t_reserve) AS sum FROM t_store_reserve WHERE ((t_store_reserve.t_tmc_spec_kod)::text = (s.t_rec_id)::text)) AS reserve FROM t_tmc t, t_tmc_spec s, t_user_kis u, t_okei_list o WHERE (((t.t_rec_id = s.t_tmc_kod) AND ((t.t_author_kod)::text = (u.t_rec_id)::text)) AND (s.t_row_okei_kod = o.t_rec_id)) ORDER BY t.t_date_create DESC;


ALTER TABLE public.t_show_store_tmc OWNER TO kisuser;

--
-- Name: t_show_store_tmceisup; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_store_tmceisup AS
    SELECT i.t_rec_id AS kod, e.t_name AS name, o.t_okei_name_shot AS okei, CASE WHEN (((SELECT count(*) AS count FROM t_store_reserve WHERE ((t_store_reserve.t_onein_kod)::text = (i.t_rec_id)::text)) = 0) AND ((SELECT count(*) AS count FROM t_store_oneout WHERE (((t_store_oneout.t_onein_kod)::text = (i.t_rec_id)::text) AND (i.t_canceled = false))) = 0)) THEN i.t_q WHEN ((SELECT count(*) AS count FROM t_store_reserve WHERE ((t_store_reserve.t_onein_kod)::text = (i.t_rec_id)::text)) = 0) THEN (i.t_q - (SELECT sum(t_store_oneout.t_q) AS sum FROM t_store_oneout WHERE (((t_store_oneout.t_onein_kod)::text = (i.t_rec_id)::text) AND (i.t_canceled = false)))) WHEN ((SELECT count(*) AS count FROM t_store_oneout WHERE (((t_store_oneout.t_onein_kod)::text = (i.t_rec_id)::text) AND (i.t_canceled = false))) = 0) THEN (i.t_q - (SELECT sum(t_store_reserve.t_reserve) AS sum FROM t_store_reserve WHERE ((t_store_reserve.t_onein_kod)::text = (i.t_rec_id)::text))) ELSE ((i.t_q - (SELECT sum(t_store_reserve.t_reserve) AS sum FROM t_store_reserve WHERE ((t_store_reserve.t_onein_kod)::text = (i.t_rec_id)::text))) - (SELECT sum(t_store_oneout.t_q) AS sum FROM t_store_oneout WHERE (((t_store_oneout.t_onein_kod)::text = (i.t_rec_id)::text) AND (i.t_canceled = false)))) END AS q, s.t_store_name AS store, p.t_person_kod AS person_kod, i.t_okei_kod AS okei_kod FROM t_store_onein i, t_store_list s, t_store_person p, t_okei_list o, t_store_eisup_list e WHERE (((((i.t_store_kod = s.t_rec_id) AND (i.t_okei_kod = o.t_rec_id)) AND (s.t_rec_id = p.t_store_kod)) AND ((e.t_rec_id)::text = (i.t_one_kod)::text)) AND (i.t_canceled = false)) ORDER BY e.t_name;


ALTER TABLE public.t_show_store_tmceisup OWNER TO kisuser;

--
-- Name: t_tmc_status_list; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_tmc_status_list (
    t_rec_id integer NOT NULL,
    t_tmc_status_name character varying(100) DEFAULT ''::character varying NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.t_tmc_status_list OWNER TO kisuser;

--
-- Name: t_show_tmc; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_tmc AS
    SELECT btrim(to_char(t.t_rec_id, '999999'::text)) AS rec_id, t.t_grouptmc AS grouptmc, to_char((t.t_date_create)::timestamp with time zone, 'DD.MM.YYYY'::text) AS date_create, t.t_tema AS tema, t.t_note_text AS note, btrim(to_char(t.t_status_kod, '99'::text)) AS status_kod, s.t_tmc_status_name AS status_name, to_char((t.t_date_status)::timestamp with time zone, 'DD.MM.YYYY'::text) AS status_date, t.t_author_kod AS user_kod, u.t_user_name1 AS user_name1, u.t_user_name2 AS user_name2, u.t_user_name3 AS user_name3, u.t_phone_shot AS user_phone, u.t_email AS user_email, to_char((t.t_date_ruk)::timestamp with time zone, 'DD.MM.YYYY'::text) AS ruk_date, t.t_ruk_kod AS ruk_kod, u2.t_user_name1 AS ruk_name1, u2.t_user_name2 AS ruk_name2, u2.t_user_name3 AS ruk_name3, u2.t_phone_shot AS ruk_phone, u2.t_email, CASE WHEN ((t.t_status_kod = 6) OR (t.t_status_kod = 7)) THEN to_char((t.t_date_status - t.t_date_create), '999990'::text) WHEN (t.t_status_kod = 0) THEN ''::text ELSE to_char((('now'::text)::date - t.t_date_create), '999990'::text) END AS day_working, CASE WHEN (((t.t_status_kod = 0) OR (t.t_status_kod = 2)) OR (t.t_status_kod = 12)) THEN 'red'::text WHEN (((((((((t.t_status_kod = 3) OR (t.t_status_kod = 4)) OR (t.t_status_kod = 5)) OR (t.t_status_kod = 8)) OR (t.t_status_kod = 9)) OR (t.t_status_kod = 10)) OR (t.t_status_kod = 11)) OR (t.t_status_kod = 14)) OR (t.t_status_kod = 15)) THEN 'brown'::text WHEN (t.t_status_kod = 7) THEN 'black'::text WHEN (t.t_status_kod = 6) THEN 'green'::text ELSE 'blue'::text END AS color, t.t_shifr AS shifr FROM t_tmc t, t_user_kis u, t_tmc_status_list s, t_user_kis u2 WHERE (((((t.t_author_kod)::text = (u.t_rec_id)::text) AND ((t.t_ruk_kod)::text = (u2.t_rec_id)::text)) AND (t.t_status_kod = s.t_rec_id)) AND (t.t_rec_delete = 0)) ORDER BY t.t_rec_id DESC;


ALTER TABLE public.t_show_tmc OWNER TO kisuser;

--
-- Name: t_tmc_admin_group; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_tmc_admin_group (
    t_rec_id integer NOT NULL,
    t_user_kod character varying(24) NOT NULL,
    t_type_kod integer NOT NULL
);


ALTER TABLE public.t_tmc_admin_group OWNER TO kisuser;

--
-- Name: TABLE t_tmc_admin_group; Type: COMMENT; Schema: public; Owner: kisuser
--

COMMENT ON TABLE t_tmc_admin_group IS 'Административные группы';


--
-- Name: COLUMN t_tmc_admin_group.t_type_kod; Type: COMMENT; Schema: public; Owner: kisuser
--

COMMENT ON COLUMN t_tmc_admin_group.t_type_kod IS '0 - Финансовая группа
1 - Группа логистики';


--
-- Name: t_show_tmc_admin_group; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_tmc_admin_group AS
    SELECT btrim(to_char(g.t_rec_id, '9999'::text)) AS rec_id, btrim(to_char(g.t_type_kod, '9'::text)) AS type_kod, g.t_user_kod AS user_kod, u.t_user_name1 AS user_name1, u.t_user_name2 AS user_name2, u.t_user_name3 AS user_name3, u.t_phone_shot AS user_phone, u.t_email FROM t_tmc_admin_group g, t_user_kis u WHERE ((g.t_user_kod)::text = (u.t_rec_id)::text) ORDER BY u.t_user_name2, u.t_user_name1;


ALTER TABLE public.t_show_tmc_admin_group OWNER TO kisuser;

--
-- Name: t_tmc_docs; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_tmc_docs (
    t_rec_id character varying(24) NOT NULL,
    t_tmc_kod integer NOT NULL,
    t_ext character varying(100) DEFAULT ''::character varying NOT NULL,
    t_filename character varying(250) NOT NULL,
    t_fileinfo character varying(250) DEFAULT ''::character varying NOT NULL,
    t_create_time timestamp without time zone DEFAULT now() NOT NULL,
    t_update_time timestamp without time zone DEFAULT now() NOT NULL,
    t_create_author character varying(24) NOT NULL,
    t_update_author character varying(24) NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL,
    t_filedata bytea
);


ALTER TABLE public.t_tmc_docs OWNER TO kisuser;

--
-- Name: t_show_tmc_docs; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_tmc_docs AS
    SELECT d.t_rec_id AS rec_id, btrim(to_char(d.t_tmc_kod, '999999'::text)) AS tmc_kod, d.t_ext AS ext, d.t_filename AS filename, d.t_fileinfo AS fileinfo, to_char(d.t_create_time, 'DD.MM.YYYY'::text) AS create_date, to_char(d.t_create_time, 'HH24:MI'::text) AS create_time, u.t_user_name1 AS author_name1, u.t_user_name2 AS author_name2, u.t_user_name3 AS author_name3, u.t_phone_shot AS author_phone, u.t_email FROM t_tmc_docs d, t_user_kis u WHERE (((d.t_create_author)::text = (u.t_rec_id)::text) AND (d.t_rec_delete = 0)) ORDER BY d.t_create_time DESC;


ALTER TABLE public.t_show_tmc_docs OWNER TO kisuser;

--
-- Name: t_tmc_email_group; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_tmc_email_group (
    t_rec_id integer NOT NULL,
    t_user_kod character varying(24) NOT NULL,
    t_group_tmc character varying(20) NOT NULL,
    t_type_kod integer NOT NULL
);


ALTER TABLE public.t_tmc_email_group OWNER TO kisuser;

--
-- Name: t_tmc_group_list; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_tmc_group_list (
    t_rec_id character varying(20) NOT NULL,
    t_group_name character varying(100) NOT NULL
);


ALTER TABLE public.t_tmc_group_list OWNER TO kisuser;

--
-- Name: t_show_tmc_email_group; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_tmc_email_group AS
    SELECT btrim(to_char(e.t_rec_id, '999999999'::text)) AS rec_id, u.t_user_name1 AS name1, u.t_user_name2 AS name2, u.t_user_name3 AS name3, u.t_phone_shot AS phone, u.t_email AS email, g.t_group_name AS "group", g.t_rec_id AS group_kod, e.t_type_kod AS type_kod FROM t_tmc_email_group e, t_user_kis u, t_tmc_group_list g WHERE (((e.t_user_kod)::text = (u.t_rec_id)::text) AND ((g.t_rec_id)::text = (e.t_group_tmc)::text)) ORDER BY u.t_user_name2, u.t_user_name1, g.t_group_name;


ALTER TABLE public.t_show_tmc_email_group OWNER TO kisuser;

--
-- Name: t_tmc_email_history; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_tmc_email_history (
    t_tmc_kod integer,
    t_subject character varying(200),
    t_datetime timestamp without time zone DEFAULT now(),
    t_email character varying(100)
);


ALTER TABLE public.t_tmc_email_history OWNER TO kisuser;

--
-- Name: t_show_tmc_email_history; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_tmc_email_history AS
    SELECT btrim(to_char(e.t_tmc_kod, '99999'::text)) AS tmc_kod, e.t_subject AS subject, to_char(e.t_datetime, 'DD.MM.YYYY'::text) AS date_, to_char(e.t_datetime, 'HH24:MI'::text) AS time_, e.t_email AS email FROM t_tmc_email_history e ORDER BY e.t_datetime DESC;


ALTER TABLE public.t_show_tmc_email_history OWNER TO kisuser;

--
-- Name: t_tmc_grouptmc_history; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_tmc_grouptmc_history (
    t_rec_id character varying(24) NOT NULL,
    t_tmc_kod integer NOT NULL,
    t_grouptmc_after character varying(10) NOT NULL,
    t_grouptmc_before character varying(10) NOT NULL,
    t_comment text DEFAULT ''::text NOT NULL,
    t_create_time timestamp without time zone DEFAULT now() NOT NULL,
    t_author_kod character varying(24) NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.t_tmc_grouptmc_history OWNER TO kisuser;

--
-- Name: t_show_tmc_grouptmc_history; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_tmc_grouptmc_history AS
    SELECT h.t_rec_id AS rec_id, btrim(to_char(h.t_tmc_kod, '9999999'::text)) AS tmc_kod, to_char(h.t_create_time, 'DD.MM.YYYY'::text) AS create_date, to_char(h.t_create_time, 'HH24:MI'::text) AS create_time, (((u.t_user_name2)::text || ' '::text) || (u.t_user_name1)::text) AS user_name, u.t_phone_shot AS user_phone, h.t_comment AS comment_tmc, CASE WHEN ((h.t_grouptmc_after)::text = 'auto'::text) THEN 'Автотранспорт'::text WHEN ((h.t_grouptmc_after)::text = 'it'::text) THEN 'Информационные технологии'::text WHEN ((h.t_grouptmc_after)::text = 'tron'::text) THEN 'Трон+'::text WHEN ((h.t_grouptmc_after)::text = 'common'::text) THEN 'Общая группа'::text ELSE ''::text END AS group_after, CASE WHEN ((h.t_grouptmc_before)::text = 'auto'::text) THEN 'Автотранспорт'::text WHEN ((h.t_grouptmc_before)::text = 'it'::text) THEN 'Информационные технологии'::text WHEN ((h.t_grouptmc_before)::text = 'tron'::text) THEN 'Трон+'::text WHEN ((h.t_grouptmc_before)::text = 'common'::text) THEN 'Общая группа'::text ELSE ''::text END AS group_before FROM t_tmc_grouptmc_history h, t_user_kis u WHERE ((h.t_rec_delete = 0) AND ((h.t_author_kod)::text = (u.t_rec_id)::text)) ORDER BY h.t_create_time DESC;


ALTER TABLE public.t_show_tmc_grouptmc_history OWNER TO kisuser;

--
-- Name: t_show_tmc_okei; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_tmc_okei AS
    SELECT btrim(to_char(o.t_rec_id, '999'::text)) AS rec_id, o.t_okei_name AS okei_name, o.t_okei_name_shot AS okei_name_shot FROM t_okei_list o WHERE (o.t_rec_delete = 0) ORDER BY o.t_okei_name;


ALTER TABLE public.t_show_tmc_okei OWNER TO kisuser;

--
-- Name: t_show_tmc_spec; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_tmc_spec AS
    SELECT s.t_rec_id AS rec_id, btrim(to_char(s.t_tmc_kod, '999999'::text)) AS tmc_kod, btrim(to_char(s.t_row_kod, '999'::text)) AS row_kod, s.t_row_name AS row_name, o.t_okei_name_shot AS okei_name_shot, btrim(to_char(s.t_row_q, '9999990.00'::text)) AS row_q, btrim(to_char(s.t_row_cost, '9999990.00'::text)) AS row_cost, s.t_row_analog AS row_analog, s.t_row_note AS row_note, btrim(to_char(s.t_row_okei_kod, '99999'::text)) AS row_okei_kod, u2.t_user_name1 AS create_name1, u2.t_user_name2 AS create_name2, u2.t_user_name3 AS create_name3, u2.t_phone_shot AS create_phone, to_char(s.t_create_time, 'DD.MM.YYYY H24:MI'::text) AS create_date, u.t_user_name1 AS update_name1, u.t_user_name2 AS update_name2, u.t_user_name3 AS update_name3, u.t_phone_shot AS update_phone, to_char(s.t_update_time, 'DD.MM.YYYY H24:MI'::text) AS update_time FROM t_tmc_spec s, t_user_kis u, t_user_kis u2, t_okei_list o WHERE ((((s.t_row_okei_kod = o.t_rec_id) AND ((s.t_create_author)::text = (u2.t_rec_id)::text)) AND ((s.t_update_author)::text = (u.t_rec_id)::text)) AND (s.t_rec_delete = 0)) ORDER BY s.t_row_kod, s.t_row_name;


ALTER TABLE public.t_show_tmc_spec OWNER TO kisuser;

--
-- Name: t_tmc_status_choice; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_tmc_status_choice (
    t_status_tmc integer NOT NULL,
    t_status_choice integer NOT NULL
);


ALTER TABLE public.t_tmc_status_choice OWNER TO kisuser;

--
-- Name: t_show_tmc_status_choice; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_tmc_status_choice AS
    SELECT btrim(to_char(s.t_rec_id, '99'::text)) AS rec_id, s.t_tmc_status_name AS status_name, btrim(to_char(c.t_status_tmc, '99'::text)) AS status_tmc FROM t_tmc_status_choice c, t_tmc_status_list s WHERE (c.t_status_choice = s.t_rec_id) ORDER BY s.t_tmc_status_name;


ALTER TABLE public.t_show_tmc_status_choice OWNER TO kisuser;

--
-- Name: t_tmc_status_history; Type: TABLE; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE TABLE t_tmc_status_history (
    t_rec_id character varying(24) NOT NULL,
    t_tmc_kod integer NOT NULL,
    t_tmc_status_kod integer NOT NULL,
    t_comment text DEFAULT ''::text NOT NULL,
    t_create_time timestamp without time zone DEFAULT now() NOT NULL,
    t_author_kod character varying(24) NOT NULL,
    t_rec_delete integer DEFAULT 0 NOT NULL,
    t_day_status integer
);


ALTER TABLE public.t_tmc_status_history OWNER TO kisuser;

--
-- Name: t_show_tmc_status_history; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_tmc_status_history AS
    SELECT btrim(to_char(h.t_tmc_kod, '9999'::text)) AS tmc_kod, to_char(h.t_create_time, 'DD.MM.YYYY'::text) AS create_date, to_char(h.t_create_time, 'HH24:MI'::text) AS create_time, s.t_tmc_status_name AS status_name, u.t_user_name1 AS user_name1, u.t_user_name2 AS user_name2, u.t_user_name3 AS user_name3, u.t_phone_shot AS user_phone, h.t_comment AS comment, btrim(to_char(h.t_day_status, '9999'::text)) AS day_status, u.t_email AS email, btrim(to_char(h.t_tmc_status_kod, '99'::text)) AS status_kod FROM t_tmc_status_history h, t_user_kis u, t_tmc_status_list s WHERE ((((h.t_author_kod)::text = (u.t_rec_id)::text) AND (h.t_tmc_status_kod = s.t_rec_id)) AND (h.t_rec_delete = 0)) ORDER BY h.t_create_time DESC;


ALTER TABLE public.t_show_tmc_status_history OWNER TO kisuser;

--
-- Name: t_show_tmc_status_list; Type: VIEW; Schema: public; Owner: kisuser
--

CREATE VIEW t_show_tmc_status_list AS
    SELECT ''::text AS rec_id, 'BCE'::character varying AS status_name UNION ALL (SELECT btrim(to_char(s.t_rec_id, '99'::text)) AS rec_id, s.t_tmc_status_name AS status_name FROM t_tmc_status_list s WHERE ((s.t_rec_id <> 16) AND (s.t_rec_delete = 0)) ORDER BY s.t_tmc_status_name);


ALTER TABLE public.t_show_tmc_status_list OWNER TO kisuser;

--
-- Name: t_tmc_admin_group_t_rec_id_seq; Type: SEQUENCE; Schema: public; Owner: kisuser
--

CREATE SEQUENCE t_tmc_admin_group_t_rec_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_tmc_admin_group_t_rec_id_seq OWNER TO kisuser;

--
-- Name: t_tmc_admin_group_t_rec_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kisuser
--

ALTER SEQUENCE t_tmc_admin_group_t_rec_id_seq OWNED BY t_tmc_admin_group.t_rec_id;


--
-- Name: t_tmc_email_group_t_rec_id_seq; Type: SEQUENCE; Schema: public; Owner: kisuser
--

CREATE SEQUENCE t_tmc_email_group_t_rec_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.t_tmc_email_group_t_rec_id_seq OWNER TO kisuser;

--
-- Name: t_tmc_email_group_t_rec_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kisuser
--

ALTER SEQUENCE t_tmc_email_group_t_rec_id_seq OWNED BY t_tmc_email_group.t_rec_id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY auth_group ALTER COLUMN id SET DEFAULT nextval('auth_group_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('auth_group_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY auth_permission ALTER COLUMN id SET DEFAULT nextval('auth_permission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY auth_user ALTER COLUMN id SET DEFAULT nextval('auth_user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY auth_user_groups ALTER COLUMN id SET DEFAULT nextval('auth_user_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('auth_user_user_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY django_content_type ALTER COLUMN id SET DEFAULT nextval('django_content_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY django_site ALTER COLUMN id SET DEFAULT nextval('django_site_id_seq'::regclass);


--
-- Name: t_rec_id; Type: DEFAULT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY t_auto_at_status ALTER COLUMN t_rec_id SET DEFAULT nextval('t_auto_at_status_t_rec_id_seq'::regclass);


--
-- Name: t_rec_id; Type: DEFAULT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY t_auto_docs ALTER COLUMN t_rec_id SET DEFAULT nextval('t_auto_docs_t_rec_id_seq'::regclass);


--
-- Name: t_rec_id; Type: DEFAULT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY t_auto_group_mail ALTER COLUMN t_rec_id SET DEFAULT nextval('t_auto_group_mail_t_rec_id_seq'::regclass);


--
-- Name: t_rec_id; Type: DEFAULT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY t_auto_season ALTER COLUMN t_rec_id SET DEFAULT nextval('t_auto_season_t_rec_id_seq'::regclass);


--
-- Name: t_rec_id; Type: DEFAULT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY t_auto_status_choice ALTER COLUMN t_rec_id SET DEFAULT nextval('t_auto_status_choice_t_rec_id_seq'::regclass);


--
-- Name: t_serial_n; Type: DEFAULT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY t_it_task ALTER COLUMN t_serial_n SET DEFAULT nextval('t_it_task_t_serial_n_seq'::regclass);


--
-- Name: t_rec_id; Type: DEFAULT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY t_order_spec ALTER COLUMN t_rec_id SET DEFAULT nextval('t_order_spec_t_rec_id_seq'::regclass);


--
-- Name: t_rec_id; Type: DEFAULT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY t_tmc_admin_group ALTER COLUMN t_rec_id SET DEFAULT nextval('t_tmc_admin_group_t_rec_id_seq'::regclass);


--
-- Name: t_rec_id; Type: DEFAULT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY t_tmc_email_group ALTER COLUMN t_rec_id SET DEFAULT nextval('t_tmc_email_group_t_rec_id_seq'::regclass);


--
-- Name: auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions_group_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_key UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission_content_type_id_codename_key; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_key UNIQUE (content_type_id, codename);


--
-- Name: auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups_user_id_group_id_key; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_key UNIQUE (user_id, group_id);


--
-- Name: auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_user_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_key UNIQUE (user_id, permission_id);


--
-- Name: auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: django_content_type_app_label_model_key; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_key UNIQUE (app_label, model);


--
-- Name: django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: django_site_pkey; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY django_site
    ADD CONSTRAINT django_site_pkey PRIMARY KEY (id);


--
-- Name: t_auto_at_list_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_auto_at_list
    ADD CONSTRAINT t_auto_at_list_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_auto_at_status_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_auto_at_status
    ADD CONSTRAINT t_auto_at_status_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_auto_at_status_list_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_auto_at_status_list
    ADD CONSTRAINT t_auto_at_status_list_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_auto_docs_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_auto_docs
    ADD CONSTRAINT t_auto_docs_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_auto_drivers_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_auto_drivers
    ADD CONSTRAINT t_auto_drivers_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_auto_drivers_i1; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_auto_drivers
    ADD CONSTRAINT t_auto_drivers_i1 UNIQUE (t_fio_driver);


--
-- Name: t_auto_fuel_type_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_auto_fuel_type
    ADD CONSTRAINT t_auto_fuel_type_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_auto_fuel_type_i1; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_auto_fuel_type
    ADD CONSTRAINT t_auto_fuel_type_i1 UNIQUE (t_type_name);


--
-- Name: t_auto_group_mail_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_auto_group_mail
    ADD CONSTRAINT t_auto_group_mail_i0 UNIQUE (t_email, t_author_address);


--
-- Name: t_auto_group_mail_i3; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_auto_group_mail
    ADD CONSTRAINT t_auto_group_mail_i3 PRIMARY KEY (t_rec_id);


--
-- Name: t_auto_ruk_cfo_kod_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_auto_ruk_cfo_kod
    ADD CONSTRAINT t_auto_ruk_cfo_kod_i0 PRIMARY KEY (t_ruk_cfo_kod);


--
-- Name: t_auto_season_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_auto_season
    ADD CONSTRAINT t_auto_season_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_auto_status_choice_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_auto_status_choice
    ADD CONSTRAINT t_auto_status_choice_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_auto_status_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_auto_status
    ADD CONSTRAINT t_auto_status_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_auto_status_list_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_auto_status_list
    ADD CONSTRAINT t_auto_status_list_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_auto_status_list_i1; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_auto_status_list
    ADD CONSTRAINT t_auto_status_list_i1 UNIQUE (t_status_name);


--
-- Name: t_auto_trailer_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_auto_trailer
    ADD CONSTRAINT t_auto_trailer_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_auto_trip_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_auto_trip
    ADD CONSTRAINT t_auto_trip_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_auto_type_list_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_auto_type_list
    ADD CONSTRAINT t_auto_type_list_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_auto_type_list_i1; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_auto_type_list
    ADD CONSTRAINT t_auto_type_list_i1 UNIQUE (t_auto_type_name);


--
-- Name: t_it_admin_group_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_it_admin_group
    ADD CONSTRAINT t_it_admin_group_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_it_email_address_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_it_email_address
    ADD CONSTRAINT t_it_email_address_i0 PRIMARY KEY (t_email);


--
-- Name: t_okei_list_2; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_okei_list
    ADD CONSTRAINT t_okei_list_2 UNIQUE (t_okei_name_shot);


--
-- Name: t_okei_list_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_okei_list
    ADD CONSTRAINT t_okei_list_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_okei_list_i1; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_okei_list
    ADD CONSTRAINT t_okei_list_i1 UNIQUE (t_okei_name);


--
-- Name: t_order_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_order
    ADD CONSTRAINT t_order_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_order_spec_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_order_spec
    ADD CONSTRAINT t_order_spec_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_store_action_list_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_store_action_list
    ADD CONSTRAINT t_store_action_list_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_store_action_list_i1; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_store_action_list
    ADD CONSTRAINT t_store_action_list_i1 UNIQUE (t_action_name);


--
-- Name: t_store_eisup_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_store_eisup_list
    ADD CONSTRAINT t_store_eisup_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_store_list_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_store_list
    ADD CONSTRAINT t_store_list_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_store_list_i1; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_store_list
    ADD CONSTRAINT t_store_list_i1 UNIQUE (t_store_name);


--
-- Name: t_store_model_data_list_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_store_model_data_list
    ADD CONSTRAINT t_store_model_data_list_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_store_model_data_list_i1; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_store_model_data_list
    ADD CONSTRAINT t_store_model_data_list_i1 UNIQUE (t_model_name);


--
-- Name: t_store_onein_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_store_onein
    ADD CONSTRAINT t_store_onein_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_store_oneout_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_store_oneout
    ADD CONSTRAINT t_store_oneout_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_store_person_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_store_person
    ADD CONSTRAINT t_store_person_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_store_person_i1; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_store_person
    ADD CONSTRAINT t_store_person_i1 UNIQUE (t_store_kod, t_person_kod);


--
-- Name: t_store_process_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_store_process
    ADD CONSTRAINT t_store_process_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_store_reserve_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_store_reserve
    ADD CONSTRAINT t_store_reserve_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_store_rest_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_store_rest
    ADD CONSTRAINT t_store_rest_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_tmc_admin_group_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_tmc_admin_group
    ADD CONSTRAINT t_tmc_admin_group_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_tmc_admin_group_i1; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_tmc_admin_group
    ADD CONSTRAINT t_tmc_admin_group_i1 UNIQUE (t_user_kod, t_type_kod);


--
-- Name: t_tmc_docs_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_tmc_docs
    ADD CONSTRAINT t_tmc_docs_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_tmc_email_group_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_tmc_email_group
    ADD CONSTRAINT t_tmc_email_group_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_tmc_email_group_i1; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_tmc_email_group
    ADD CONSTRAINT t_tmc_email_group_i1 UNIQUE (t_user_kod, t_group_tmc, t_type_kod);


--
-- Name: t_tmc_group_list_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_tmc_group_list
    ADD CONSTRAINT t_tmc_group_list_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_tmc_group_list_i1; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_tmc_group_list
    ADD CONSTRAINT t_tmc_group_list_i1 UNIQUE (t_group_name);


--
-- Name: t_tmc_grouptmc_history_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_tmc_grouptmc_history
    ADD CONSTRAINT t_tmc_grouptmc_history_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_tmc_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_tmc
    ADD CONSTRAINT t_tmc_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_tmc_spec_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_tmc_spec
    ADD CONSTRAINT t_tmc_spec_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_tmc_status_choice_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_tmc_status_choice
    ADD CONSTRAINT t_tmc_status_choice_i0 PRIMARY KEY (t_status_tmc, t_status_choice);


--
-- Name: t_tmc_status_history_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_tmc_status_history
    ADD CONSTRAINT t_tmc_status_history_i0 PRIMARY KEY (t_rec_id);


--
-- Name: t_tmc_status_list_i0; Type: CONSTRAINT; Schema: public; Owner: kisuser; Tablespace: 
--

ALTER TABLE ONLY t_tmc_status_list
    ADD CONSTRAINT t_tmc_status_list_i0 PRIMARY KEY (t_rec_id);


--
-- Name: auth_group_name_like; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX auth_group_name_like ON auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX auth_group_permissions_group_id ON auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX auth_group_permissions_permission_id ON auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX auth_permission_content_type_id ON auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX auth_user_groups_group_id ON auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX auth_user_groups_user_id ON auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX auth_user_user_permissions_permission_id ON auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX auth_user_user_permissions_user_id ON auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_like; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX auth_user_username_like ON auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_session_expire_date; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX django_session_expire_date ON django_session USING btree (expire_date);


--
-- Name: django_session_session_key_like; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX django_session_session_key_like ON django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: t_auto_status_i1; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_auto_status_i1 ON t_auto_status USING btree (t_auto_trip_kod);


--
-- Name: t_auto_trip_i1; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_auto_trip_i1 ON t_auto_trip USING btree (t_trip_datetime);


--
-- Name: t_auto_trip_i2; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_auto_trip_i2 ON t_auto_trip USING btree (t_plan_or_task);


--
-- Name: t_auto_trip_i3; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_auto_trip_i3 ON t_auto_trip USING btree (t_driver_kod);


--
-- Name: t_auto_trip_i4; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_auto_trip_i4 ON t_auto_trip USING btree (t_auto_kod);


--
-- Name: t_auto_trip_i5; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_auto_trip_i5 ON t_auto_trip USING btree (t_status_kod);


--
-- Name: t_auto_trip_i6; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_auto_trip_i6 ON t_auto_trip USING btree (t_author_kod);


--
-- Name: t_auto_trip_i7; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_auto_trip_i7 ON t_auto_trip USING btree (t_chief_kod);


--
-- Name: t_d_docs_i0; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE UNIQUE INDEX t_d_docs_i0 ON t_d_docs USING btree (t_rec_id);


--
-- Name: t_d_docs_i1; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_docs_i1 ON t_d_docs USING btree (t_d_kod);


--
-- Name: t_d_docs_i2; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_docs_i2 ON t_d_docs USING btree (t_create_date);


--
-- Name: t_d_docs_i3; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_docs_i3 ON t_d_docs USING btree (t_create_author);


--
-- Name: t_d_docs_i4; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_docs_i4 ON t_d_docs USING btree (t_rec_delete);


--
-- Name: t_d_group_mail_i0; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE UNIQUE INDEX t_d_group_mail_i0 ON t_d_group_mail USING btree (t_email);


--
-- Name: t_d_i0; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE UNIQUE INDEX t_d_i0 ON t_d USING btree (t_rec_id);


--
-- Name: t_d_i1; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_i1 ON t_d USING btree (t_dstatus_kod);


--
-- Name: t_d_i2; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_i2 ON t_d USING btree (t_dep_group_kod);


--
-- Name: t_d_i3; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_i3 ON t_d USING btree (t_ruk_kod);


--
-- Name: t_d_i4; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_i4 ON t_d USING btree (t_doc_author);


--
-- Name: t_d_i5; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_i5 ON t_d USING btree (t_create_date);


--
-- Name: t_d_i6; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_i6 ON t_d USING btree (t_create_author);


--
-- Name: t_d_i7; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_i7 ON t_d USING btree (t_rec_delete);


--
-- Name: t_d_i8; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_i8 ON t_d USING btree (t_email_ruk);


--
-- Name: t_d_person_i0; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE UNIQUE INDEX t_d_person_i0 ON t_d_person USING btree (t_rec_id);


--
-- Name: t_d_person_i1; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_person_i1 ON t_d_person USING btree (t_d_kod);


--
-- Name: t_d_person_i2; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_person_i2 ON t_d_person USING btree (t_person_kod);


--
-- Name: t_d_person_i3; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_person_i3 ON t_d_person USING btree (t_dstatus_kod);


--
-- Name: t_d_person_i4; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_person_i4 ON t_d_person USING btree (t_create_author);


--
-- Name: t_d_person_i5; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_person_i5 ON t_d_person USING btree (t_rec_delete);


--
-- Name: t_d_person_i6; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE UNIQUE INDEX t_d_person_i6 ON t_d_person USING btree (t_d_kod, t_person_kod);


--
-- Name: t_d_person_i7; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_person_i7 ON t_d_person USING btree (t_order_agremnt);


--
-- Name: t_d_status_i0; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE UNIQUE INDEX t_d_status_i0 ON t_d_status USING btree (t_rec_id);


--
-- Name: t_d_status_i1; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_status_i1 ON t_d_status USING btree (t_d_kod);


--
-- Name: t_d_status_i2; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_status_i2 ON t_d_status USING btree (t_create_time);


--
-- Name: t_d_status_i3; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_status_i3 ON t_d_status USING btree (t_create_author);


--
-- Name: t_d_status_i4; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_status_i4 ON t_d_status USING btree (t_dstatus_kod);


--
-- Name: t_d_status_i5; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_status_i5 ON t_d_status USING btree (t_rec_delete);


--
-- Name: t_d_status_list_i0; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE UNIQUE INDEX t_d_status_list_i0 ON t_d_status_list USING btree (t_rec_id);


--
-- Name: t_d_status_list_i1; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE UNIQUE INDEX t_d_status_list_i1 ON t_d_status_list USING btree (t_d_status_name);


--
-- Name: t_d_status_list_i2; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_d_status_list_i2 ON t_d_status_list USING btree (t_rec_delete);


--
-- Name: t_it_docs_i0; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE UNIQUE INDEX t_it_docs_i0 ON t_it_docs USING btree (t_rec_id);


--
-- Name: t_it_docs_i1; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_it_docs_i1 ON t_it_docs USING btree (t_it_task_kod);


--
-- Name: t_it_docs_i3; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_it_docs_i3 ON t_it_docs USING btree (t_rec_delete);


--
-- Name: t_it_task_i0; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE UNIQUE INDEX t_it_task_i0 ON t_it_task USING btree (t_rec_id);


--
-- Name: t_it_task_i1; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_it_task_i1 ON t_it_task USING btree (t_datetime);


--
-- Name: t_it_task_i2; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_it_task_i2 ON t_it_task USING btree (t_itkategory_kod);


--
-- Name: t_it_task_i3; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_it_task_i3 ON t_it_task USING btree (t_itstatus_kod);


--
-- Name: t_it_task_i4; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_it_task_i4 ON t_it_task USING btree (t_rec_delete);


--
-- Name: t_it_task_i5; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_it_task_i5 ON t_it_task USING btree (t_isp_kod);


--
-- Name: t_order_spec_i1; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_order_spec_i1 ON t_order_spec USING btree (t_order_kod);


--
-- Name: t_store_eisup_i1; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_eisup_i1 ON t_store_eisup_list USING btree (t_name);


--
-- Name: t_store_eisup_i2; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_eisup_i2 ON t_store_eisup_list USING btree (t_rec_delete);


--
-- Name: t_store_eisup_i3; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_eisup_i3 ON t_store_eisup_list USING btree (t_model_kod);


--
-- Name: t_store_list_i2; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_list_i2 ON t_store_list USING btree (t_create_user);


--
-- Name: t_store_list_i3; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_list_i3 ON t_store_list USING btree (t_edit_user);


--
-- Name: t_store_onein_i1; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_onein_i1 ON t_store_onein USING btree (t_one_kod);


--
-- Name: t_store_onein_i2; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_onein_i2 ON t_store_onein USING btree (t_modeldata_kod);


--
-- Name: t_store_onein_i3; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_onein_i3 ON t_store_onein USING btree (t_okei_kod);


--
-- Name: t_store_onein_i4; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_onein_i4 ON t_store_onein USING btree (t_barcode);


--
-- Name: t_store_onein_i5; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_onein_i5 ON t_store_onein USING btree (t_author_kod);


--
-- Name: t_store_onein_i6; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_onein_i6 ON t_store_onein USING btree (t_store_kod);


--
-- Name: t_store_oneout_i1; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_oneout_i1 ON t_store_oneout USING btree (t_onein_kod);


--
-- Name: t_store_oneout_i2; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_oneout_i2 ON t_store_oneout USING btree (t_tmc_spec_kod);


--
-- Name: t_store_oneout_i3; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_oneout_i3 ON t_store_oneout USING btree (t_author_kod);


--
-- Name: t_store_oneout_i4; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_oneout_i4 ON t_store_oneout USING btree (t_create_datetime);


--
-- Name: t_store_person_i2; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_person_i2 ON t_store_person USING btree (t_store_kod);


--
-- Name: t_store_person_i3; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_person_i3 ON t_store_person USING btree (t_person_kod);


--
-- Name: t_store_person_i4; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_person_i4 ON t_store_person USING btree (t_create_user);


--
-- Name: t_store_process_i1; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_process_i1 ON t_store_process USING btree (t_action_kod);


--
-- Name: t_store_process_i2; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_process_i2 ON t_store_process USING btree (t_store_kod);


--
-- Name: t_store_process_i3; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_process_i3 ON t_store_process USING btree (t_one_kod);


--
-- Name: t_store_process_i4; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_process_i4 ON t_store_process USING btree (t_okei_kod);


--
-- Name: t_store_reserve_i3; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_reserve_i3 ON t_store_reserve USING btree (t_onein_kod);


--
-- Name: t_store_rest_i1; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_rest_i1 ON t_store_rest USING btree (t_okei_kod);


--
-- Name: t_store_rest_i2; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_rest_i2 ON t_store_rest USING btree (t_store_kod);


--
-- Name: t_store_rest_i3; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_rest_i3 ON t_store_rest USING btree (t_one_kod);


--
-- Name: t_store_total_rest_i0; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_total_rest_i0 ON t_store_total_rest USING btree (t_rec_id);


--
-- Name: t_store_total_rest_i1; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_store_total_rest_i1 ON t_store_total_rest USING btree (t_okei_kod);


--
-- Name: t_tmc_docs_i1; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_tmc_docs_i1 ON t_tmc_docs USING btree (t_tmc_kod);


--
-- Name: t_tmc_email_history_i0; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_tmc_email_history_i0 ON t_tmc_email_history USING btree (t_tmc_kod);


--
-- Name: t_tmc_grouptmc_history_i1; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_tmc_grouptmc_history_i1 ON t_tmc_grouptmc_history USING btree (t_tmc_kod);


--
-- Name: t_tmc_spec_i1; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_tmc_spec_i1 ON t_tmc_spec USING btree (t_tmc_kod);


--
-- Name: t_tmc_spec_i2; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_tmc_spec_i2 ON t_tmc_spec USING btree (t_row_kod);


--
-- Name: t_tmc_spec_i3; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_tmc_spec_i3 ON t_tmc_spec USING btree (t_row_name);


--
-- Name: t_tmc_spec_i4; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_tmc_spec_i4 ON t_tmc_spec USING btree (t_rec_delete);


--
-- Name: t_tmc_status_history_i1; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE INDEX t_tmc_status_history_i1 ON t_tmc_status_history USING btree (t_tmc_kod);


--
-- Name: t_user_kis_i0; Type: INDEX; Schema: public; Owner: kisuser; Tablespace: 
--

CREATE UNIQUE INDEX t_user_kis_i0 ON t_user_kis USING btree (t_rec_id);


--
-- Name: auth_group_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_fkey FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: content_type_id_refs_id_d043b34a; Type: FK CONSTRAINT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT content_type_id_refs_id_d043b34a FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: group_id_refs_id_f4b32aac; Type: FK CONSTRAINT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT group_id_refs_id_f4b32aac FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_40c41112; Type: FK CONSTRAINT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT user_id_refs_id_40c41112 FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: user_id_refs_id_4dc23c39; Type: FK CONSTRAINT; Schema: public; Owner: kisuser
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT user_id_refs_id_4dc23c39 FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

