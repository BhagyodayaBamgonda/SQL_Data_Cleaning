show tables;

select * from layoffs;

create table layoffs2 like layoffs;
  
insert into layoffs2
select * from layoffs;

select * from layoffs2;

select *,
row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,
'date',stage,country,funds_raised_millions) as row_num from layoffs2;

select * from
(select *,
row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,
'date',stage,country,funds_raised_millions) as row_num from layoffs2) as duplicates
where row_num>1;

select * from layoffs2
where company like "oda%";

with delete_cte as
( select * from
( select *,
row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,
'date',stage,country,funds_raised_millions) as row_num from layoffs2) as duplicates
 where row_num > 1 )
 select * from delete_cte;
 
 with delete_cte as
( select * from
( select *,
row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,
'date',stage,country,funds_raised_millions) as row_num from layoffs2) as duplicates
 where row_num > 1 )
 delete from delete_cte;
 
 alter table layoffs2 add row_num int;
 select * from layoffs2;
 
 create table layoffs3 (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int DEFAULT NULL
);

INSERT INTO `layoff_schema`.`layoffs3`
(`company`,
`location`,
`industry`,
`total_laid_off`,
`percentage_laid_off`,
`date`,
`stage`,
`country`,
`funds_raised_millions`,
`row_num`)
SELECT `layoffs2`.`company`,
    `layoffs2`.`location`,
    `layoffs2`.`industry`,
    `layoffs2`.`total_laid_off`,
    `layoffs2`.`percentage_laid_off`,
    `layoffs2`.`date`,
    `layoffs2`.`stage`,
    `layoffs2`.`country`,
    `layoffs2`.`funds_raised_millions`,
    row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,
'date',stage,country,funds_raised_millions) as row_num from layoffs2;


select * from layoffs3;

select * from layoffs3
where row_num>=2;

delete from layoffs3
where row_num >1;		

select * from layoffs3
where industry is null or industry=""
order by industry;

select * from layoffs3 
where company like 'Bally%';

select * from layoffs3 
where company like 'airbnb%';

update layoffs3
set industry = null
where industry="";

update layoffs3 t1
join layoffs3 t2
on t1.company=t2.company
set t1.industry=t2.industry
where t1.industry is null
and t2.industry is not null;


select distinct industry 
from layoffs3
order by industry;

update layoffs3 
set industry="Crypto"
where industry like "Crypto%";

select distinct country 
from layoffs3
order by country;

update layoffs3 
set country="United States"
where country like "United States%";

update layoffs3
set `date` = str_to_date(`date`,'%m/%d/%Y');
 
alter table layoffs3
modify column `date` date;

select * from layoffs3;

select * from layoffs3
where total_laid_off is null 
and percentage_laid_off is null;

delete from layoffs3
where total_laid_off is null 
and percentage_laid_off is null;

alter table layoffs3
drop column row_num;