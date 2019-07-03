    const NFT_CONTRACT_ADDRESS = process.env.NFT_CONTRACT_ADDRESS
window.addEventListener('load', function() {

    var pixelJunkies;
    var userAccount;

    // const FACTORY_CONTRACT_ADDRESS = process.env.FACTORY_CONTRACT_ADDRESS


      function startApp() {
        var pixelJunkiesAddress = NFT_CONTRACT_ADDRESS;
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

        pixelJunkies.events.Transfer({ filter: { _to: userAccount } })
    .on("data", function(event) {
      let data = event.returnValues;
      getOwnedPixels(userAccount)
      .then(displayPixels);
    }).on("error", console.error);
    }

    function displayPixels(ids) {
       $("#pixels").empty();
       for (id of ids) {
         // Look up zombie details from our contract. Returns a `zombie` object
         getPixelDetails(id)
         .then(function(pixel) {
           // Using ES6's "template literals" to inject variables into the HTML.
           // Append each one to our #zombies div
           $("#pixels").append(`<div class="pixel">
             <ul>
               <li>Name: ${pixel.xy}</li>
               <li>DNA: ${pixel.picture}</li>
             </ul>
           </div>`);
         });
       }
     }

     function getPixelDetails(id) {
         return pixelJunkies.methods.pictures(id).call()
     }

// the problem is there is a displayZombies function as well as a getZombiesByOwner method,
// and I think I combined those two into one function. a little tired. taking a break.
      function getOwnedPixels(msgSender) {
        return pixelJunkies.methods.showPixels(msgSender).call()
     }

     function buyPixel(pixels){
         console.log('test')
         return pixelJunkies.methods.buyUnownedPixel('city').send()
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
