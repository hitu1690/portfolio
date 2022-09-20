select * from CovidDeaths;
Select * from CovidDeaths;
---order by clause asc default by column specific--
select * from CovidDeaths order by 3,4 ;
Select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths order by 1,2;
----looking at total deaths vs total cases

SELECT location,date,total_cases,total_deaths, 
       (total_deaths/total_cases)*100 
       as DeathsPercentage
from covidDeaths order by 1,2;
----shows likely funtion--
SELECT location,date,total_cases,total_deaths, 
       (total_deaths/total_cases)*100 
       as DeathsPercentage
from covidDeaths 
where location like '%states%'
order by 1,2;
---shows Total cases vs population
SELECT location,date,total_cases,population, 
       (total_cases/population)*100 
       as CasesPercentage
from covidDeaths 
where location like '%states%'
order by 1,2;
---LOOKING country at infection rate vs population--
SELECT location,population,max(total_cases) as HighestInfectioncount, 
     max ((total_cases/population))*100 
       as PercentagePopulationInfected
from covidDeaths 
group by location,population
order by PercentagePopulationInfected desc;

---showing higest death count by population
SELECT location,max(cast(total_deaths as int)) as Totaldeathcount
     
from covidDeaths 
where continent is not null
group by location
order by Totaldeathcount desc;
---global number

Select date,sum(new_cases) as total_cases,
sum(cast(New_deaths as int))as total_death,sum(cast(New_deaths as int))/sum(new_cases)*100 as 
Death_percentage
from covidDeaths 
where continent is not null
group by date
order by 1,2;

----total number
Select sum(new_cases) as total_cases,
sum(cast(New_deaths as int))as total_death,sum(cast(New_deaths as int))/sum(new_cases)*100 as 
Death_percentage
from covidDeaths 
where continent is not null
order by 1,2;
----join both table
select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations  from CovidDeaths dea
   join CovidVaccinations vac
   on dea.date = vac.date 
   and dea.location = vac.location
   where dea.continent is not null
order by 1,2,3;

----loking total population vs vaccination

select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations,sum(convert(int, vac.new_vaccinations))
 over (partition by dea.location) as RolingPeopleVaccinated
 from CovidDeaths dea
   join CovidVaccinations vac
   on dea.date = vac.date 
   and dea.location = vac.location
   where dea.continent is not null
order by 2,3;

---CTE is temp named result set created from 
--select statement----
with popvsvac (continent,location,date,population,new_vaccinations,
Rollingpeoplevaccinated) as
(select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations,sum(convert(int, vac.new_vaccinations))
 over (partition by dea.location order by dea.location,dea.date) as RolingPeopleVaccinated
 from CovidDeaths dea
   join CovidVaccinations vac
   on dea.date = vac.date 
   and dea.location = vac.location
   where dea.continent is not null
--order by 2,3;
) 
Select *, (Rollingpeoplevaccinated/population)*100
from popvsvac;
---Temp table--
Drop table if exists #PercentPoppulationVaccinated
create table #PercentPoppulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
Date Datetime,
population numeric,
New_vaccination numeric,
Rollingpeoplevaccinated Numeric)
insert into #PercentPoppulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations,sum(convert(int, vac.new_vaccinations))
 over (partition by dea.location) as RolingPeopleVaccinated
 from CovidDeaths dea
   join CovidVaccinations vac
   on dea.date = vac.date 
   and dea.location = vac.location
   where dea.continent is not null
--order by 2,3;
Select *, (Rollingpeoplevaccinated/population)*100
from #PercentPoppulationVaccinated;
 
 ---Creating view for future analyst
 Create view  PercentPoppulationVaccinated as
 select dea.continent,dea.location,dea.date,dea.population,
vac.new_vaccinations,sum(convert(int, vac.new_vaccinations))
 over (partition by dea.location) as RolingPeopleVaccinated
 from CovidDeaths dea
   join CovidVaccinations vac
   on dea.date = vac.date 
   and dea.location = vac.location
   where dea.continent is not null;
   select * from PercentPoppulationVaccinated





