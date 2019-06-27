pragma solidity ^0.5.0;

//defintiely stealing this from somewhere, but the site should be called "Pixel Junkie"

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';

contract PixelCoin is ERC721Full, ERC721Mintable {

    event NewZombie(uint zombieId, string name, uint dna);

    address public owner;
    uint public last_completed_migration;

    uint sizeOfPicture = 600;

    struct Pixel {
        uint8[2] xy; // the [x,y] coordinate of the pixel, acts as the pixel's _id
        uint8 picture; // which picture the pixel is part of (each picture is given a number starting at 0).
        string hexCode; // the corresponding hex code of the pixel.
        address _owner; // the owner of the pixel

        /* Hexadecimal literals are prefixed with the keyword hex and are enclosed
        in double or single-quotes (hex"001122FF"). Their content must be a hexadecimal
        string and their value will be the binary representation of those values.
        Hexadecimal literals behave like string literals and have the same convertibility restrictions. */
    }

// Pixel array called pixels
    Pixel[] public pixels;
// hey, change these to store pixel to owner
    mapping (uint => address) public pixelToOwner;
// and owner to pixels owned
    mapping (address => uint) ownerPixelCount;

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

  function buy(address _buyer) {

  }
//generate random pixel to buy from unowned pixels
  function _generateRandomDna(string _str) private view returns (uint) {
    uint rand = uint(keccak256(abi.encodePacked(_str)));
    // dnaModulus
    return rand % sizeOfPicture;
    }

// called with the buy function above.
    function createPixel(string _name) public {
        /* require(ownerZombieCount[msg.sender] == 0); */
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }

// return all pixels of an owner (can be called by others)
    function showPixels(address _owner) public view returns (pixels){

    }

// STRETCH CHALLENGE: offerToBuy function:: offer to buy the pixels from the owner
    function offerToBuy(address _buyer, address _seller) external {

    }


}
