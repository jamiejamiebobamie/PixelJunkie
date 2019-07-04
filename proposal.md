Token:          "pixeljunkie" will use ERC721 tokens as each "PixelCoin" will be unique,
                non-fungible entities, tied to a specific user, picture, and x-y coordinate
                within that picture.

Use Case:       Ownership of a pixel will be undisputed as the information will exist
                in decentralized-form on the block-chain. Future implementations of the site
                might involve some form of voting, with each user's vote being weighted
                based on the number of pixels they own of a given picture.

Examine:        The blockchain is the ideal format for ensuring ownership and keeping a
                ledger of information, as such the blockchain is the perfect platform
                for pixeljunkie and its associated PixelCoins to keep track of who owns what.

Description:    pixeljunkie will consist of the following action-items:

                1.  the smart contract should allow users to buy a pixel or pixels
                of the picture they click on, on the frontend side of things.
                2.  users should be able to view the pixels they own.
                3.  STRETCH-CHALLENGE: the pixels that are owned by someone are shown, while the pixels that remain to be purchased are grey (on the displayed picture of the buy page).
                4.  STRETCH-CHALLENGE: user should be able to vote on what the picture should be called. the percentage of pixels the user owns of a given picture determines the weight of the  user's vote.
                5.  STRETCH-CHALLENGE: users should be able to offer to buy the pixels of another user.

Plan:
                1. I will implement the frontend first, as it's better to build what the user sees
                before building the functionality.
                2. Once I've built the frontend of the site, I will work on the smart contract.
                3. Once the smart contract (and its superclasses) have been written/implemented, I will work on writing tests for the various functions.
                4. Once the tests have been written I will work on testing and deploying the site on the Rinkeby network, using Metamask and Infura.
                5. Finally with the contract deployed, I will sync my frontend with the contract by utilizing web3.js.
