const assert = require('assert');
const ganache = require('ganache-cli');
const json = require('./../build/contracts/PixelCoin.json');
const PixelCoin = artifacts.require('./PixelCoin.sol');

contract('PixelCoin', async function (accounts) {
  let token;

  before(done => {
    (async () => {
      try {
        // TODO: All setup steps belong here, including contract deployment.
        token = await PixelCoin.new();
        var tx = await web3.eth.getTransactionReceipt(token.transactionHash);
        totalGas = totalGas.plus(tx.gasUsed);
        console.log(_ + tx.gasUsed + ' - Deploy PixelCoin');
        token = await PixelCoin.deployed();

        // Output how much gas was spent
        console.log(_ + '-----------------------');
        console.log(_ + totalGas.toFormat(0) + ' - Total Gas');
        done();
      }
      catch (error) {
        console.error(error);
        done(false);
      }
    })();
  });

  describe('PixelCoin.sol', function () {

    it('Should always pass this canary test', async () => {
      assert(true === true, 'this is true');
    });

// Code to test the owner account copied from: https://github.com/droxey/rainbowcoin/blob/master/test/RainbowCoinTest.js
    it("Should make first account an owner", async () => {
      let instance = await RainbowCoin.deployed();
      let owner = await instance.owner();
      assert.equal(owner, accounts[0]);
    });

    it("Should buy the pixel at 300, 300. (Tests the called function createPixel() as well.)", async () => {
      let instance = await PixelCoin.deployed().then(async function(instance) {
            await instance.buyUnownedPixel("city");
            const pixel = await instance.pixel_placement.call();
            assert.equal(pixel.xy, [300,300], 'Did not work.');
            done();
         });
      });

      it("Should show the bought pixel(s) of the given user", async () => {
        let instance = await PixelCoin.deployed().then(async function(instance) {
              const pixels = await instance.showPixels().call();
              assert.equal(pixels.length, 1, 'Did not work.');
              done();
           });
        });

        it("Should ensure the length of the lengthOfPictureArray variable is increased after adding a new picture", async () => {
          let instance = await PixelCoin.deployed().then(async function(instance) {
                await instance.addPictureToArrayOfPictures("Nicolas Cage");
                const picturesArrayLength = await instance.lengthOfPictureArray.call();
                assert.equal(picturesArrayLength, 2, 'Did not work.');
                done();
             });
          });

          it("Should ensure the same name can't be added twice to the pictures array", async () => {
            let instance = await PixelCoin.deployed().then(async function(instance) {
                  await instance.addPictureToArrayOfPictures("Nicolas Cage");
                  await instance.addPictureToArrayOfPictures("Nicolas Cage");
                  const picturesArrayLength = await instance.lengthOfPictureArray.call();
                  assert.equal(picturesArrayLength, 2, 'Did not work.');
                  done();
               });
            });

            it("Should look at the picture names added to the array", async () => {
              let instance = await PixelCoin.deployed().then(async function(instance) {
                    await instance.addPictureToArrayOfPictures("city");
                    await instance.addPictureToArrayOfPictures("Nicolas Cage");
                    const pictures = await instance.pictures.call();
                    assert.equal([pictures[0],pictures[1]], ["city", "Nicolas Cage"], 'Did not work.');
                    done();
                 });
              });
    });
});
