


--Selecting all the raw to make sure that data was succesfuly extracted

Select *
From CovidExploration..CovidDeath
Where continent is not null 


--Following instrucction show countries with the Highest death rate

select Location, Max(cast(total_deaths as int))
from CovidExploration..CovidDeath
group by Location
order by 2 Desc


--Following instruction shows the pourcentage of dying if we get covid per country 

select Location, MAX(total_deaths/total_cases) as Probability_to_die
from CovidExploration..CovidDeath
group by Location



--Following instruction shows the countries Highest Infection Rate compared to Population

select Location, Max(total_cases), MAX(total_cases/population) as Infection_Rate
from CovidExploration..CovidDeath
group by Location
order by 3 Desc



-- Following instruction shows contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidExploration..CovidDeath
Where continent is not null 
Group by continent
order by TotalDeathCount desc


-- Following instruction shows Global Covid NUmbers

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidExploration..CovidDeath
where continent is not null 
order by 1,2




-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From From CovidExploration..CovidDeath dea
Join From CovidExploration..CovidVacc vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3




-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From From CovidExploration..CovidDeath dea
Join CovidExploration..CovidVacc vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From From CovidExploration..CovidDeath dea
Join From CovidExploration..Vacc vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From From CovidExploration..CovidDeath dea
Join From CovidExploration..CoviVacc vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 


