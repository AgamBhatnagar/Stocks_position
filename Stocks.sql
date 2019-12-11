-- after selecting the schema create the new tables using the tables created using csv files
-- create table named 'bajaj1' using table bajaj from stocks schema.
create table bajaj1 as
(select `Date`,`Close Price`,
CASE WHEN 
ROW_NUMBER() OVER w >= 20 THEN 
avg(`Close Price`) over(order by Date ROWS 20 PRECEDING) 
ELSE NULL 
END AS `20 Day MA`,
CASE WHEN 
ROW_NUMBER() OVER w >= 50 THEN 
avg(`Close Price`) over(order by Date ROWS 50 PRECEDING) 
ELSE NULL 
END AS `50 Day MA`
from bajaj
window w as (ORDER BY DATE));
-- create table 'bajaj2' to determine the 'sell','hold' or 'buy' option
create table bajaj2 as
(select Date, `Close Price`, 
CASE 
WHEN `20 Day MA`>`50 Day MA` then 'BUY'
WHEN `20 Day MA`<`50 Day MA` then 'SELL'
ELSE 'HOLD'
END AS `Signal` 
from bajaj1);

-- create table named 'eicher1' using table eicher from stocks schema.
create table eicher1 as
(select `Date`,`Close Price`,
CASE WHEN 
ROW_NUMBER() OVER w >= 20 THEN 
avg(`Close Price`) over(order by Date ROWS 20 PRECEDING) 
ELSE NULL 
END AS `20 Day MA`,
CASE WHEN 
ROW_NUMBER() OVER w >= 50 THEN 
avg(`Close Price`) over(order by Date ROWS 50 PRECEDING) 
ELSE NULL 
END AS `50 Day MA`
from eicher
window w as (ORDER BY DATE));


-- create table 'eicher2' to determine the 'sell','hold' or 'buy' option
create table eicher2 as
(select Date, `Close Price`, 
CASE 
WHEN `20 Day MA`>`50 Day MA` then 'BUY'
WHEN `20 Day MA`<`50 Day MA` then 'SELL'
ELSE 'HOLD'
END AS `Signal` 
from eicher1);

-- create table 'hero2' from stocks schema

create table hero1 as
(select `Date`,`Close Price`,
CASE WHEN 
ROW_NUMBER() OVER w >= 20 THEN 
avg(`Close Price`) over(order by Date ROWS 20 PRECEDING) 
ELSE NULL 
END AS `20 Day MA`,
CASE WHEN 
ROW_NUMBER() OVER w >= 50 THEN 
avg(`Close Price`) over(order by Date ROWS 50 PRECEDING) 
ELSE NULL 
END AS `50 Day MA`
from hero
window w as (ORDER BY DATE));


-- create table hero2 to determine sell/hold/buy options
create table hero2 as
(select Date, `Close Price`, 
CASE 
WHEN `20 Day MA`>`50 Day MA` then 'BUY'
WHEN `20 Day MA`<`50 Day MA` then 'SELL'
ELSE 'HOLD'
END AS `Signal` 
from hero1);

-- create table infosys1 from the stocks schema
create table infosys1 as
(select `Date`,`Close Price`,
CASE WHEN 
ROW_NUMBER() OVER w >= 20 THEN 
avg(`Close Price`) over(order by Date ROWS 20 PRECEDING) 
ELSE NULL 
END AS `20 Day MA`,
CASE WHEN 
ROW_NUMBER() OVER w >= 50 THEN 
avg(`Close Price`) over(order by Date ROWS 50 PRECEDING) 
ELSE NULL 
END AS `50 Day MA`
from infosys
window w as (ORDER BY DATE));


-- create table infosys 2 to determine the buy/sell/hold option
create table infosys2 as
(select Date, `Close Price`, 
CASE 
WHEN `20 Day MA`>`50 Day MA` then 'BUY'
WHEN `20 Day MA`<`50 Day MA` then 'SELL'
ELSE 'HOLD'
END AS `Signal` 
from infosys1);


-- create table tcs1 from the stocks schema
create table tcs1 as
(select `Date`,`Close Price`,
CASE WHEN 
ROW_NUMBER() OVER w >= 20 THEN 
avg(`Close Price`) over(order by Date ROWS 20 PRECEDING) 
ELSE NULL 
END AS `20 Day MA`,
CASE WHEN 
ROW_NUMBER() OVER w >= 50 THEN 
avg(`Close Price`) over(order by Date ROWS 50 PRECEDING) 
ELSE NULL 
END AS `50 Day MA`
from tcs
window w as (ORDER BY DATE));


-- create table tcs2 to determine the buy/hold/sell option
create table tcs2 as
(select Date, `Close Price`, 
CASE 
WHEN `20 Day MA`>`50 Day MA` then 'BUY'
WHEN `20 Day MA`<`50 Day MA` then 'SELL'
ELSE 'HOLD'
END AS `Signal` 
from tcs1);

-- create table tvs1 from schema stocks
create table tvs1 as
(select `Date`,`Close Price`,
CASE WHEN 
ROW_NUMBER() OVER w >= 20 THEN 
avg(`Close Price`) over(order by Date ROWS 20 PRECEDING) 
	ELSE NULL 
END AS `20 Day MA`,
CASE WHEN 
	ROW_NUMBER() OVER w >= 50 THEN 
		avg(`Close Price`) over(order by Date ROWS 50 PRECEDING) 
	ELSE NULL 
END AS `50 Day MA`
from tvs
window w as (ORDER BY DATE));

-- create table tvs2 to determine buy/sell/hold option
create table tvs2 as
(select Date, `Close Price`, 
CASE 
WHEN `20 Day MA`>`50 Day MA` then 'BUY'
WHEN `20 Day MA`<`50 Day MA` then 'SELL'
ELSE 'HOLD'
END AS `Signal` 
from tvs1);


-- create the master table

create table master as 
(select b.date Date, 
b.`close price` Bajaj, 
tc.`close price` TCS, 
tv.`close price` TVS, 
i.`close price` Infosys,
e.`close price` Eicher,
h.`close price` Hero 
from bajaj1 b inner join tcs1 tc 
	on b.date = tc.date
inner join tvs1 tv 
	on tc.date = tv.date
inner join infosys1 i 
	on i.date = tv.date
inner join eicher1 e 
	on e.date = i.date
inner join hero1 h
	on h.date = e.date
);


# UDF Bajaj
CREATE FUNCTION BajajStock(d date)
returns char(4) deterministic
return (select `Signal` from bajaj2 where date=d);

# UDF Eicher
CREATE FUNCTION EicherStock(d date)
returns char(4) deterministic
return (select `Signal` from eicher2 where date=d);

# UDF Hero
CREATE FUNCTION HeroStock(d date)
returns char(4) deterministic
return (select `Signal` from hero2 where date=d);

# UDF Infosys
CREATE FUNCTION InfosysStock(d date)
returns char(4) deterministic
return (select `Signal` from infosys2 where date=d);

# UDF TCS
CREATE FUNCTION TCSStock(d date)
returns char(4) deterministic
return (select `Signal` from tcs2 where date=d);






