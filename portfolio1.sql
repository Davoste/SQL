--select * from project1..coviddata order by 3,4

--select * from project1..covidvac3 order by 3,4

--select location,date,total_cases,new_cases,total_deaths,population from project1..coviddata order by 1,2

--select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPer 
--from project1..coviddata 
--where location like '%ken%'
--order by 1,2

--select location,date,total_cases,population,(total_cases/population)*100 as InfectPer 
--from project1..coviddata 
--where location like '%ken%'
--order by 1,2

--select location,MAX(total_cases)AS HighCount,population,MAX((total_cases/population))*100 as HighInfectPer 
--from project1..coviddata 
--group by location,population
--order by HighInfectPer desc


--select location,MAX(cast(total_deaths as int)) as deathcount 
--from project1..coviddata 
--where continent is null
--group by location
--order by deathcount desc

--select date,SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as totaldeaths,SUM(cast(new_deaths as int))/SUM(New_cases)*100 as deathPer 
--from project1..coviddata 
--where continent is not null
--group by date
--order by 1,2

--select dat.continent,dat.location,dat.date,dat.population,vac.new_vaccinations 
--from project1..covidvac3 vac Join project1..coviddata dat 
--On dat.location=vac.location and dat.date=vac.date
--Where dat.continent is not null
--order by 2,3

--With PopVac (Continent, Location,Date,Population,New_vaccinations,RollppleVac)
--as(
--select dat.continent,dat.location,dat.date,dat.population,vac.new_vaccinations ,
--SUM(cast (vac.new_vaccinations as int)) OVER (Partition by dat.Location Order by dat.location,dat.Date) as RollppleVac
--from project1..covidvac3 vac Join project1..coviddata dat 
--On dat.location=vac.location and dat.date=vac.date
--Where dat.continent is not null

--)
--select *,(RollppleVac/Population)*100 from PopVac 

create view PopVac as 
select dat.continent,dat.location,dat.date,dat.population,vac.new_vaccinations ,
SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dat.Location Order by dat.location,dat.Date) as RollppleVac
from project1..covidvac3 vac Join project1..coviddata dat 
On dat.location=vac.location and dat.date=vac.date
Where dat.continent is not null