// SPDX-License-Identifier: Unlicensed
pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DBZminter is ERC721, Ownable {
    uint256 public maxCharCount; //maximum number of allowed NFTs
    uint256 public charCount; //number of minted NFTs
    uint256 public mintPrice;
    bool public isMintEnabled;
    mapping(address => uint256) public timesMinted;
    mapping(address => uint256) public holdingWallets;

    constructor() payable ERC721("DBZminter", "DBZM") {
        maxCharCount = 10;
        mintPrice = 0.005 ether;
    }

    function ToggleMint() external onlyOwner {
        isMintEnabled = !isMintEnabled;
    }

    function SetMaxCharCount(uint256 _maxCharCount) external onlyOwner {
        maxCharCount = _maxCharCount;
    }

    function ChangeMintPrice(uint256 _mintPrice) external onlyOwner {
        mintPrice = _mintPrice;
    }

    function Mint() payable external {
        require(isMintEnabled, "minting is currently not allowed");
        require(charCount < maxCharCount, "nft sold out");
        require(msg.value == mintPrice, "value must match the mint price");
        require(timesMinted[msg.sender] < 1, "max nft minted for the wallet");

        charCount++;
        timesMinted[msg.sender]++;
        holdingWallets[msg.sender] = charCount;
        _safeMint(msg.sender, holdingWallets[msg.sender]);

    }

}
