// required solidity version 0.5.0 or newer
pragma solidity ^0.5.0;

contract Adoption {
    // create address type variable name adopters
    address[16] public adopters;

    // Adopting a pet
    function adopt(uint petId) public returns (uint) {
        // check rule before
        require(petId >= 0 && petId <= 15);

        // msg.sender is address of person or smart contract that call function
        adopters[petId] = msg.sender;

        return petId;
    }

    // Retrieving the adopters
    // view mean this function will not change state
    // memory gives the data location for the variable
    function getAdopters() public view returns (address[16] memory) {
        return adopters;
    }

    // Retrieving the pets with specific adopter
    function getPets() public view returns (uint[] memory) {
        // cast petList to store list of pet that owner by msg.sender (max length = 16)
        uint[] memory petList = new uint[](16);
        // cast index of petList "j"
        uint j = 0;

        // Loop check adopters state to get list of pets that msg.sender adopted
        for(uint i = 0; i < 16; i++){
            if(adopters[i] == msg.sender){
                petList[j] = i;
                j++;
            }
        }

        // return petList
        return (petList);
    }
}