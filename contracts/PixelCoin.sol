//defintiely stealing this from somewhere, but the site is called "Pixel Junkie"

pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol';
import 'openzeppelin-solidity/contracts/token/ERC721/ERC721Mintable.sol';

/// @title A contract to implement the PixelCoin for PixelJunkie
/// @author Jamie McCrory
/// @notice This contract is for a school project.
contract PixelCoin is ERC721Full, ERC721Mintable {

    /// @notice these functions were found from Dani's RainbowCoin tutorial
      address public owner;
      uint public last_completed_migration;
      constructor() ERC721Full("PixelCoin", "PixelCoin") public {
          /// @notice This is the contract constructor
          /// @dev The contructor pushes the "city" picture to the picture array
            owner = msg.sender;
            pictures.push('city');
      }

      /// @notice This is a borrowed function from the openzepplin.
      /// @dev This is meant to the replace the "onlyOwner" modifier from Cryptozombies
      modifier restricted() {
        if (msg.sender == owner) _;
      }

      /// @notice This is a borrowed function from the openzepplin.
      /// @dev I copied this from your rainbowcoin contract.
      function setCompleted(uint completed) public restricted {
        last_completed_migration = completed;
      }

      /// @notice This is a borrowed function from the openzepplin.
      /// @dev I copied this from your rainbowcoin contract.
      /// @notice This function was throwing errors on deploy, so I commented it out.
      /* function upgrade(address new_address) public restricted {
        Migrations upgraded = Migrations(new_address);
        upgraded.setCompleted(last_completed_migration);
      } */

    /// @dev I copied this from Cryptozombies.
    /// @notice This function requires methods that I did not copy...
    /// @notice Commented it out as it was throwing errors on deploy.
    /* function withdraw() external restricted {
      owner.transfer(owner.balance);
    } */

    using SafeMath for uint256;

    /// @notice  LOOK THIS UP! STILL DON'T GET IT. SOMETHING ABOUT RECORDING A LOG W/O USING STORAGE
    event NewPixel(uint16[2] _xy, string _picture);

    /// @notice Length and width of picture length x width.
    uint sizeOfPicture = 600;

    /// @notice THE "COINAGE" --> PIXELS
    /// @notice the [x,y] coordinate of the pixel, acts as the pixel's _id
    /// @notice which picture the pixel is part of.
    struct Pixel {
      uint16[2] xy;
      string picture;
    }

    /// @notice USED TO STORE ALL THE NAMES OF THE PICTURES
    string[] public pictures;

    /// @notice Length of the picture-name array.
    /// @notice 1 due to the "city" picture
    uint public lengthOfPictureArray = 1;

    /// @notice USED TO STORE ALL THE AVAILABLE PIXEL COORDINATES ASSOCIATED WITH A GIVEN PICTURE
    mapping (string => uint[]) public pictureToPixels;

    /// @notice USED TO STORE THE OWNED PIXELS OF A GIVEN USER
    mapping (address => Pixel[]) public ownerToPixels;

    /// @notice USED TO CONTROL THE USERS' BUY RATE
    /// @notice key: an address
    /// @notice value: [pixelsBoughtOnADay, aDay'sDate]
    mapping (address => uint[]) ownertoBoughtCountAndBoughtDay;

    /// @notice This function creates a new pixel.
    /// @param _xy an x-y coordinate, two uint16 array.
    /// @param _picture the name of a picture, string.
    function createPixel(uint16[2] memory _xy, string memory _picture) internal {
        uint id = ownerToPixels[msg.sender].push(Pixel(_xy, _picture)).sub(1);
        pictureToPixels[_picture].push(id);
        emit NewPixel(_xy, _picture);
    }

    /// @notice This function calls the createPixel fucntion,
    /// @notice Handles the control flow of the user's buy-rate.
    /// @param _picture the name of a picture, string.
    function buyUnownedPixel(string memory _picture) public payable {
        /// @notice Require that the amount of pixels bought today is less than 3
        /// @notice or require that today's date is different than the date stored from the last buy.
        require(ownertoBoughtCountAndBoughtDay[msg.sender][0] < 3 || ownertoBoughtCountAndBoughtDay[msg.sender][1] + 1 days < now);

        /// @dev this is just for testing purposes.
        /// @dev The logic of generating a random, unowned pixel will be the job
        /// @dev of pulling from the mongodb datbase, that will pass in the pixel
        /// @dev as a parameter, and remove the entry from the database.
        uint16[2] memory _xy = [300,300];

        createPixel(_xy, _picture);

        /// @notice if it hasn't been one day since the last purchase
        if (ownertoBoughtCountAndBoughtDay[msg.sender][1] + 1 days < now){
            /// @notice increment the amount of pixels bought for that day
            ownertoBoughtCountAndBoughtDay[msg.sender][0].add(1);
        } else {
            /// @notice else set the time to the new day
            /// @notice might need to typecast the time by calling the 'uint32()' method.
            ownertoBoughtCountAndBoughtDay[msg.sender][1] = now;
            /// @notice and increment the number of purchases for that day to 1
            ownertoBoughtCountAndBoughtDay[msg.sender][0] = 1;
        }
    }

    /// @dev return all pixels owned by the caller of the function
    /// @return an array of pixels owned by the user.
    function showPixels() public view returns (Pixel[] memory){
        return ownerToPixels[msg.sender];
    }

    /// @notice A function to add new names to the array of picture names
    /// @param _name a string to test.
    function addPictureToArrayOfPictures(string memory _name) public restricted {
        bool unique = true;
        string memory _test;
        /// @notice checks to make sure the name doesn't already exist in the array
        for (uint i = 0; i < lengthOfPictureArray; i++){
            _test = pictures[i];
            if (keccak256(abi.encodePacked(_test)) == keccak256(abi.encodePacked(_name))){
                unique = false;
            }
        /// @notice if the name is unique,
        require(unique == true);
        /// @notice add it to the array.
        pictures.push(_name);
        lengthOfPictureArray.add(1);
        }
    }

}
