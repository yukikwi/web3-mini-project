App = {
  web3Provider: null,
  contracts: {},
  walletPet: [],

  initUI: async function() {
    // Load pets.
    $.getJSON('../pets.json', function(data) {
      var petsRow = $('#petsRow');
      var petTemplate = $('#petTemplate');

      if(App.walletPet.length == 0){
        // this wallet not adopted any pet
        document.getElementById("empty_title").innerText = "You are not adopted any pets."
        document.getElementById("empty_title").style.display = "block"
        
      }
      else{

        // hide wallet not adopted any pet
        document.getElementById("empty_title").style.display = "none"

        for (i = 0; i < data.length; i ++) {
          if(App.walletPet.includes(i)){
            petTemplate.find('.panel-title').text(data[i].name);
            petTemplate.find('img').attr('src', data[i].picture);
            petTemplate.find('.pet-breed').text(data[i].breed);
            petTemplate.find('.pet-age').text(data[i].age);
            petTemplate.find('.pet-location').text(data[i].location);

            petsRow.append(petTemplate.html());
          }
        }
      }
    });

  },

  initWeb3: async function() {
    // Modern dapp browsers...
    if (window.ethereum) {
      App.web3Provider = window.ethereum;
      try {
        // Request account access
        await window.ethereum.request({ method: "eth_requestAccounts" });;
      } catch (error) {
        // User denied account access...
        console.error("User denied account access")
      }
    }
    // Legacy dapp browsers...
    else if (window.web3) {
      App.web3Provider = window.web3.currentProvider;
    }
    // If no injected web3 instance is detected, fall back to Ganache
    else {
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('Adoption.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with @truffle/contract
      var AdoptionArtifact = data;
      App.contracts.Adoption = TruffleContract(AdoptionArtifact);
    
      // Set the provider for our contract
      App.contracts.Adoption.setProvider(App.web3Provider);
    
      // Use our contract to retrieve and mark the adopted pets
      return App.markAdopted();
    });
  },

  markAdopted: function() {
    var adoptionInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.Adoption.deployed().then(function(instance) {
        adoptionInstance = instance;
  
        return adoptionInstance.getAdopters.call();
      }).then(function(adopters) {
        for (i = 0; i < adopters.length; i++) {
          if (adopters[i] === account) {
            App.walletPet.push(i)
          }
        }

        App.initUI()
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  }

};

$(function() {
  $(window).load(function() {
    App.initWeb3();
  });
});
