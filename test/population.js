const Population = artifacts.require("Population") ;

contract("Population" , () =>{
    let population = null ;
    before(async () => {
        population = await Population.deployed() ;
    });

    it("Setting Current Population" , async () => {
        await population.set("India" , 1388901219) ;
        const name = await population.countryName() ;
        const pop = await population.currentPopulation();
        assert(name === "India") ;
        assert(pop.toNumber() === 1388901219) ;
    });

    it("Setting Current Population and Vaccinated" , async () => {
        await population.setAll("India" , 1388901219, 500) ;
        const name = await population.countryName() ;
        const pop = await population.currentPopulation();
        const vaccinated = await population.currentVaccinated();

        assert(name === "India") ;
        assert(pop.toNumber() === 1388901219) ;
        assert(vaccinated.toNumber() === 500) ;

    });
    it("Decrement Current Population" , async () => {
        await population.decrement(100) ;
        const pop = await population.currentPopulation() ;
        assert(pop.toNumber() === 1388901119);
    });

    it("Decrement Current vaccinated " , async () => {
        await population.decrementVaccinated(100) ;
        const vaccinatd = await population.currentVaccinated() ;
        assert(vaccinatd.toNumber() === 400);
    });

    it("Increment Current vaccinated" , async () => {
        await population.incrementVaccinated(200) ;
        const vaccinatd = await population.currentVaccinated() ;
        assert(vaccinatd.toNumber() === 600);
        });
});
