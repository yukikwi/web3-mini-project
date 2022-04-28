// required solidity version 0.5.0 or newer
pragma solidity >=0.8.13;

contract Adoption {
    // create address type variable name adopters
    address[16] public adopters;

    address public owner;
    
    // event
    event RandomPet(
        address from,
        uint _petId
    );

    // Defining a constructor
	constructor() public{
		owner=msg.sender;
	}

	// Function to get
	// address of owner
	function getOwner(
	) public view returns (address) {	
		return owner;
	}

	// Function to return
	// current balance of owner
	function getBalance(
	) public view returns(uint256){
		return uint256(owner.balance);
	} 

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

    // random unadopt pet
    function randomPet(uint nounce) public {
        uint randomPetIndex = random(16, nounce);
        uint oldnounce = nounce;
        // re-random if pet already adopted
        while(adopters[randomPetIndex] != address(0) && oldnounce + 16 != nounce){
            nounce = nounce + 1;
            randomPetIndex = random(16, nounce); 
        }

        if(oldnounce + 16 != nounce){
            adopt(randomPetIndex);
            emit RandomPet(msg.sender, randomPetIndex);
        }
        else{
            emit RandomPet(msg.sender, 17);
        }
    }

    // util: random
    function random(uint max, uint nounce) private view returns(uint){
        return uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, nounce))) % max;
    }

}