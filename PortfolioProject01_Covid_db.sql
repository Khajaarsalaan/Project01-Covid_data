select * from PortfolioProject01..Coviddeaths where continent is not null
order by 3,4

--select * from PortfolioProject01..covidVaccinations
--order by 3,4

-- selecting the needed data
Select location, date, total_cases, new_cases, total_deaths, population from PortfolioProject01..Coviddeaths where continent is not null
order by 1,2

-- Before executing the next command we have to change the data type of total_cases to run the next query successfully
EXEC sp_help Coviddeaths
ALTER TABLE Coviddeaths ALTER COLUMN total_cases float

--- Looking at the total cases vs total deaths and also the % of dying in Canada
--- Shows the liklihood of dying of covid in Canada
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100  as death_percentage
from PortfolioProject01..Coviddeaths  where location = 'Canada' and continent is not null order by 1,2 desc

--- Looking at the total cases vs population
--- Shows us about what % of people got covid
Select location, date, population, total_cases, (total_cases/population)*100  as population_percentageInfected
from PortfolioProject01..Coviddeaths  where location = 'Canada' and  continent is not null order by 1,2 desc

---Looking at countries with highest infection rates compared to the population

select location, population, MAX(total_cases) as highest_infectionCount, Max((total_cases/population))*100  as population_percentageInfected
from PortfolioProject01..Coviddeaths where continent is not null group by location, population order by population_percentageInfected desc;

---Looking at countries with highest death count compared to the population
select location, population, MAX(cast(total_deaths as int)) as Total_deathCount 
from PortfolioProject01..Coviddeaths  where continent is not null group by location, population order by Total_deathCount desc

--- Now by Continent (highest death count per capital)
select continent, MAX(cast(total_deaths as int)) as Total_deathCount 
from PortfolioProject01..Coviddeaths  where continent is not null group by continent order by Total_deathCount desc

select * from PortfolioProject01..Coviddeaths

--- Global Numbers of new cases

Select date, SUM(new_cases) as WORLD_newcases, sum(cast(new_deaths as int)) as WORLD_Newdeath
from PortfolioProject01..Coviddeaths where continent is not null group by date order by date desc


--- Using Joins


---Looking at total population vs vaccinated per day
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) 
from PortfolioProject01..Coviddeaths dea
join PortfolioProject01..covidVaccinations vac
on dea.location = vac.location
and dea.date= vac.date 
where dea.continent is not null
and vac.new_vaccinations is not null
order by 2,3

--- Using CTE
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location, dea.date) 
from PortfolioProject01..Coviddeaths dea
join PortfolioProject01..covidVaccinations vac
on dea.location = vac.location
and dea.date= vac.date 
where dea.continent is not null
and vac.new_vaccinations is not null
order by 2,3

