pragma solidity ^0.5.0;

//defintiely stealing this from somewhere, but the site should be called "Pixel Junkie"

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';

contract PixelCoin is ERC721Full, ERC721Mintable {

    address public owner;
    uint public last_completed_migration;
  constructor() ERC721Full("PixelCoin", "PixelCoin") public {
        owner = msg.sender;
  }
  modifier restricted() {
    if (msg.sender == owner) _;
  }

  function setCompleted(uint completed) public restricted {
    last_completed_migration = completed;
  }

  function upgrade(address new_address) public restricted {
    Migrations upgraded = Migrations(new_address);
    upgraded.setCompleted(last_completed_migration);
  }

  event NewPixelRevealed(uint16[2] _xy, string _picture, string _hexCode);
  uint sizeOfPicture = 600;
  struct Pixel {
      uint16[2] xy; // the [x,y] coordinate of the pixel, acts as the pixel's _id
      string picture; // which picture the pixel is part of.
  }

// Pixel array called pixels
      Pixel[] public pixels;

      mapping (uint => address) public pixelToOwner;

      mapping (address => uint) ownerPixelCount;

      // key: an address
      // value: [pixelsBoughtOnADay, aDay'sDate]
      mapping (address => uint[]) ownertoPixelsBoughtAndBoughtDay;

    //generate random pixel to buy from unowned pixels
    //NOT WRITTEN
      function _generateRandomPixel(string _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        // dnaModulus
        return rand % sizeOfPicture;
        }

    function createPixel(uint16[2] _xy, string _picture) internal {
        address _owner = msg.sender
        uint id = pixels.push(Pixel(_xy, _picture)) - 1;
        pixelToOwner[id] = msg.sender;
        ownerPixelCount[msg.sender]++;
        emit NewPixelRevealed(_xy, _picture);
    }


      function buyUnownedPixel(_xy, _picture) public {
          // require that the amount of pixels bought today is less than 3
          // or require that today's date is different than the date stored from the last buy.
          require(ownerPixelsBoughtPerDay[msg.sender][0] < 3 || ownerPixelsBoughtPerDay[msg.sender][1] + 1 days < now));

          createPixel(_xy, _picture);

          // if it hasn't been one day since the last purchase
          if (ownerPixelsBoughtPerDay[msg.sender][1] + 1 days < now)){
              //increment the amount of pixels bought for that day
              ownerPixelsBoughtPerDay[msg.sender][0]++; //NEED TO UPDATE EVERYTHING WITH THE SAFE MATH FUNCTIONS!!!
          } else {
              //else set the time to the new day
              ownerPixelsBoughtPerDay[msg.sender][1] = now;
              //and increment the number of purchases for that day to 1
              ownerPixelsBoughtPerDay[msg.sender][0] = 1;
          }

      }

// return all pixels of an owner (can be called by others)
    function showPixels(address _owner) public view returns (pixels){

    }

// STRETCH CHALLENGE: offerToBuy function:: offer to buy the pixels from the owner
    function offerToBuyOwnedPixel(address _buyer, address _seller) external {

    }


}
