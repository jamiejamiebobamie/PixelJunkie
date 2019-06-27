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
    // hey, change these to store pixel to owner
      mapping (uint => address) public pixelToOwner;
    // and owner to pixels owned
      mapping (address => uint) ownerPixelCount;

      function buy(address _buyer) {

      }

    //generate random pixel to buy from unowned pixels
      function _generateRandomPixel(string _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        // dnaModulus
        return rand % sizeOfPicture;
        }

    function buy(uint16[2] _xy, string _picture)

    function createPixel(uint16[2] _xy, string _picture) internal {
        /* require(ownerZombieCount[msg.sender] == 0); */
        address _owner = msg.sender
        uint id = pixels.push(Pixel(_xy, _picture)) - 1;
        pixelToOwner[id] = msg.sender;
        ownerPixelCount[msg.sender]++;
        emit NewPixelRevealed(_xy, _picture);
    }

// return all pixels of an owner (can be called by others)
    function showPixels(address _owner) public view returns (pixels){

    }

// STRETCH CHALLENGE: offerToBuy function:: offer to buy the pixels from the owner
    function offerToBuy(address _buyer, address _seller) external {

    }


}
