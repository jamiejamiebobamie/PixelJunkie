window.addEventListener('load', function() {

    var pixelJunkies;
    var userAccount;

      function startApp() {
        var pixelJunkiesAddress = "YOUR_CONTRACT_ADDRESS";
        pixelJunkies = new web3js.eth.Contract(pixelJunkiesABI, pixelJunkiesAddress);

        var accountInterval = setInterval(function() {
      // Check if account has changed
          if (web3.eth.accounts[0] !== userAccount) {
            userAccount = web3.eth.accounts[0];
            // Call a function to update the UI with the new account
            getOwnedPixels(userAccount)
            .then(displayPixels);
          }
        }, 100);
    }

    function displayPixels(ids) {
       $("#zombies").empty();
       for (id of ids) {
         // Look up zombie details from our contract. Returns a `zombie` object
         getZombieDetails(id)
         .then(function(zombie) {
           // Using ES6's "template literals" to inject variables into the HTML.
           // Append each one to our #zombies div
           $("#zombies").append(`<div class="zombie">
             <ul>
               <li>Name: ${zombie.name}</li>
               <li>DNA: ${zombie.dna}</li>
               <li>Level: ${zombie.level}</li>
               <li>Wins: ${zombie.winCount}</li>
               <li>Losses: ${zombie.lossCount}</li>
               <li>Ready Time: ${zombie.readyTime}</li>
             </ul>
           </div>`);
         });
       }
     }

// the problem is there is a displayZombies function as well as a getZombiesByOwner method,
// and I think I combined those two into one function. a little tired. taking a break.
      function getOwnedPixels(msgSender) {
        return pixelJunkies.methods.showPixels(msgSender).call()
     }

     function buyUnownedPixel(pixels){
         return pixelJunkies.methods.buyUnownedPixel().send()
     }

  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    // Use Mist/MetaMask's provider
    web3js = new Web3(web3.currentProvider);
  } else {
    // Handle the case where the user doesn't have web3. Probably
    // show them a message telling them to install Metamask in
    // order to use our app.
  }

  // Now you can start your app & access web3js freely:
  startApp()

})
