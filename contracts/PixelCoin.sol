pragma solidity ^0.5.0;

//defintiely stealing this from somewhere, but the site should be called "Pixel Junkie"

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';

contract PixelCoin is ERC721Full, ERC721Mintable {

/* these functions were found from Dani's RainbowCoin tutorial */
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
/* Untested, foreign, scary. */





    event NewPixelRevealed(uint16[2] _xy, string _picture, string _hexCode);

    uint sizeOfPicture = 600; // length and width of picture

    struct Pixel {
      uint16[2] xy; // the [x,y] coordinate of the pixel, acts as the pixel's _id
      string picture; // which picture the pixel is part of.
    }
    // Picture-name array
    string[] public pictures;
    // Pixel array called pixels
    Pixel[] public pixels;

    mapping (uint => address) public pixelToOwner;
    mapping (address => uint) ownerPixelCount;

    // key: an address
    // value: [pixelsBoughtOnADay, aDay'sDate]
    mapping (address => uint[]) ownertoPixelsBoughtAndBoughtDay;


    //NOT WRITTEN-----
    //generate random pixel to buy from unowned pixels
      function _generateRandomPixel(string _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        // dnaModulus
        return rand % sizeOfPicture;
        }
    //NOT WRITTEN-----

    function createPixel(uint16[2] _xy, string _picture) internal {
        uint id = pixels.push(Pixel(_xy, _picture)) - 1;
        pixelToOwner[id] = msg.sender;
        ownerPixelCount[msg.sender]++; //SAFE MATH!!!
        emit NewPixelRevealed(_xy, _picture);
    }

    function buyUnownedPixel(uint16[2] _xy, string _picture) public {
    // require that the amount of pixels bought today is less than 3
    // or require that today's date is different than the date stored from the last buy.
    require(ownerPixelsBoughtPerDay[msg.sender][0] < 3 || ownerPixelsBoughtPerDay[msg.sender][1] + 1 days < now));

    // create a new pixel.
    createPixel(_xy, _picture);

    // if it hasn't been one day since the last purchase
    if (ownerPixelsBoughtPerDay[msg.sender][1] + 1 days < now)){
        //increment the amount of pixels bought for that day
        ownerPixelsBoughtPerDay[msg.sender][0]++; //SAFE MATH!!!
    } else {
        //else set the time to the new day
        ownerPixelsBoughtPerDay[msg.sender][1] = now;
        //and increment the number of purchases for that day to 1
        ownerPixelsBoughtPerDay[msg.sender][0] = 1;
    }

    }

    // return all pixels owned by the caller of the function
    function showPixels() public view returns (pixels){
        Pixel[] public ownersPixels;
        // iterate through the pixels stored in the 'pixels' array
        for (uint i = 0; i < pixels.length(); i++){
         // use the index as the lookup to find the owner of the pixel
         // if the owner is the caller of the function
         if (pixelToOwner[i] == msg.sender){
             // push the pixels into the array to be returned by the function
             ownersPixels.push(pixels[i])
         }
        }
        return ownersPixels
    }

    // STRETCH CHALLENGE: offerToBuy function:: offer to buy the pixels from the owner
    function offerToBuyOwnedPixel(address _buyer, address _seller, uint16[2] _xy, string _picture) external {

    }

    // A function to add new names to the array of picture names
    function addPictureToArrayOfPictures(string _name) public restricted {
        bool unique = true;
        // checks to make sure the name doesn't already exist in the array
        for (uint i = 0; i < pictures.length(); i++){
            if (pictures[i] == _name){
            unique = false;
        }
        // if the name is unique,
        require(unique == true);
        // add it to the array.
        pictures.push(_name);
    }
}
