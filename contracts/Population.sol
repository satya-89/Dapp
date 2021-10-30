pragma solidity^0.5.9 ;

contract Population{
    string public countryName ;
    uint public currentPopulation ;
    uint public currentVaccinated ;


    constructor() public{
        countryName = "Unknown" ;
        currentPopulation = 0 ;
        currentVaccinated = 0;
    }

    function set(string memory name, uint popCount) public{
        countryName = name ;
        currentPopulation = popCount ;

    }
    function setAll(string memory name, uint popCount, uint vaccinatedCount) public{
        countryName = name ;
        currentPopulation = popCount ;
        currentVaccinated  = vaccinatedCount;
    }

    function decrement(uint decrementBy) public{
        currentPopulation -= decrementBy ;
    }


    function increment(uint incrementBy) public{
        currentPopulation += incrementBy ;
    }


    function incrementVaccinated(uint incrementBy) public{
        currentVaccinated += incrementBy ;
    }
    function decrementVaccinated(uint decrementBy) public{
        currentVaccinated -= decrementBy ;
    }

}