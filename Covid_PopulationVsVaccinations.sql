select * from PortfolioProject..CovidDeaths$
order by 3,4
go
select * from PortfolioProject..CovidVaccinations$
order by 3,4

go

select  location,date,total_cases,new_cases,(total_deaths/total_cases)*100 as DeathPercentage
 from PortfolioProject..CovidDeaths$
 where location like '%states%'
 order by 1,2

go 

select  location,Population,Max(total_cases) as HighInfection,Max((total_cases/population))*100 as PercentagePopulationInfected
 from PortfolioProject..CovidDeaths$
 group by location,Population
 order by PercentagePopulationInfected desc

go

Total Death Cases

select continent,Max(cast(total_deaths as int)) as TotalDeathCount from PortfolioProject..CovidDeaths$
where continent IS NOT NULL
group by continent
order by TotalDeathCount desc

go

Global Numbers

select sum(new_cases) as total_cases, SUM(cast(new_deaths as int )) as total_deaths  from PortfolioProject..CovidDeaths$
where continent is not null
order by 1,2

go


Looking at Total Population & Vaccinations

select * from PortfolioProject..CovidDeaths$ as dea
join PortfolioProject..CovidVaccinations$ as vac
   ON dea.location=vac.location 
   and dea.date=vac.date
where dea.continent is not null
order by 1,2,3


go

USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select  dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) over (Partition by dea.location Order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths$ as dea
join PortfolioProject..CovidVaccinations$ as vac
   ON dea.location=vac.location 
   and dea.date=vac.date
where dea.continent is not null
order by 2,3
)
Select * from PopvsVac