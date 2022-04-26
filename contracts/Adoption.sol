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
}