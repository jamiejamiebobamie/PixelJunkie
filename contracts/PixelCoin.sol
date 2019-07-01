pragma solidity ^0.5.0;

//defintiely stealing this from somewhere, but the site is called "Pixel Junkie"

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';
import './safemath.sol';

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
    /* ^Untested, foreign, scary. */

    // From crytozombies:
    function withdraw() external onlyOwner {
      address _owner = owner();
      _owner.transfer(address(this).balance);
    }

    using SafeMath for uint256;

    //  LOOK THIS UP! STILL DON'T GET IT. SOMETHING ABOUT RECORDING A LOG W/O USING STORAGE
    event NewPixelRevealed(uint16[2] _xy, string _picture, string _hexCode);

    uint sizeOfPicture = 600; // length and width of picture length x width.

    // THE "COINAGE" --> PIXELS
    struct Pixel {
      uint16[2] xy; // the [x,y] coordinate of the pixel, acts as the pixel's _id
      string picture; // which picture the pixel is part of.
    }

    // Picture-name array
    // USED TO STORE ALL THE NAMES OF THE PICTURES
    string[] public pictures;

    // picture's name to pixel-struct-array mapping
    // USED TO STORE ALL THE AVAILABLE PIXEL COORDINATES ASSOCIATED WITH A GIVEN PICTURE
    mapping (string => uint[]) public pictureToPixels;

    // USED TO STORE THE OWNED PIXELS OF A GIVEN USER
    mapping (address => Pixel[]) public ownerToPixels;

    // key: an address
    // value: [pixelsBoughtOnADay, aDay'sDate]
    // USED TO CONTROL THE USERS' BUY RATE
    mapping (address => uint[]) ownertoBoughtCountAndBoughtDay;

    //**//NOT WRITTEN-----
    //generate random pixel to buy from unowned pixels
      function _generateRandomPixel(string _str) private view returns (uint[]) {
          result = []
        uint rand1 = uint(keccak256(abi.encodePacked(_str)));
        uint rand2 = uint(keccak256(abi.encodePacked(_str)));
        result.push(rand1 % sizeOfPicture);
        result.push(rand2 % sizeOfPicture);
        return result
        }
    //**//NOT WRITTEN-----

    function createPixel(uint16[2] _xy, string _picture) internal {
        uint id = pixels.push(Pixel(_xy, _picture)).sub(1);
        pixelToOwner[id] = msg.sender;
        ownerPixelCount[msg.sender].add(1); //SAFE MATH!!!
    //**//NOT WRITTEN-----
        emit NewPixelRevealed(_xy, _picture); /// NOT IMPLEMENTED!!!!
    //**//NOT WRITTEN-----
    }

    function buyUnownedPixel(string _picture) public payable {
        // require that the amount of pixels bought today is less than 3
        // or require that today's date is different than the date stored from the last buy.
        require(ownertoBoughtCountAndBoughtDay[msg.sender][0] < 3 || ownertoBoughtCountAndBoughtDay[msg.sender][1] + 1 days < now));

        // require that there are still pixels left to purchase from the given picture
        require(pictureToPixels[_picture].length != 0);

    //**//NOT WRITTEN-----
        //NEED TO GENERATE A RANDOM PIXEL IN AN EFFICIENT WAY FROM THE PIXELS STILL AVAILABLE
        // _generateRandomPixel(string _str)
    //**//NOT WRITTEN-----

        uint randCoordinate; // the coordinate randomly generated

        for (uint i = 0; i < pictureToPixels[_picture].length; i++) {
            // find the item in the array that is equal to the random coordinate generated.
            if (pictureToPixels[_picture][i] == randCoordinate) {
                // duplicate the last entry in the array into the index that stores the random coordinate
                // pop the last entry.
                pictureToPixels[_picture][i] = pictureToPixels[_picture][-i];
                pictureToPixels[_picture].pop();
            }
        }

        // create a new pixel and push it to the ownerToPixel array.
        ownerToPixels[msg.sender].push(createPixel(_xy, _picture));

        // if it hasn't been one day since the last purchase
        if (ownertoBoughtCountAndBoughtDay[msg.sender][1] + 1 days < now)){
            //increment the amount of pixels bought for that day
            ownertoBoughtCountAndBoughtDay[msg.sender][0].add(1); //SAFE MATH!!!
        } else {
            //else set the time to the new day
            // might need to typecast the time by calling the 'uint32()' method.
            ownertoBoughtCountAndBoughtDay[msg.sender][1] = now;
            //and increment the number of purchases for that day to 1
            ownertoBoughtCountAndBoughtDay[msg.sender][0] = 1;
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

    // STRETCH CHALLENGE: offerToBuy function:: offer to buy the pixels from their owner
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
