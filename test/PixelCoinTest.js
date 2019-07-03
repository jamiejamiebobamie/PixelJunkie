/*

1.  the smart contract should allow users to buy a pixel or pixels
    of the picture they click on, on the frontend side of things.

1.  users should be able to view the pixels they own.

2.  STRETCH-CHALLENGE the pixels that are owned by someone are shown, while the pixels
    that remain to be purchased are grey.

3.  STRETCH-CHALLENGE user should be able to vote on what the picture should be called.
    the percentage of pixels the user owns determines the weight of the user's vote.

*/


const PixelCoin = artifacts.require('./contracts/PixelCoin.sol');
const _ = '        ';


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

    it("Test-buys the pixel at 0,0", async () => {
      let instance = await PixelCoin.deployed().then(async function(instance) {
            await instance.buyPixel(0,0);
            const pixel = await instance.pixel_placement.call();
            assert.equal(pixel, (0,0), 'Did not work.');
            done();
         });
      });

    });
});
