// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    ///////////////////////
    // Type declarations //
    ///////////////////////
    using Strings for uint256;
    uint256 private _nextTokenId;

    /////////////////////////
    // State variables //////
    /////////////////////////
    mapping(uint256 => uint256) public tokenIdToLevels;

    /////////////////
    //  Errors //////
    /////////////////
    error CannotTrainInexistentTokenId();
    error OnlyOwnerCanTrain();

    /////////////////
    //  Functions ///
    /////////////////
    constructor() ERC721("Chain Battles", "CBTLS"){}

    function generateCharacter(uint256 tokenId) public view returns(string memory){

        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevels(tokenId),'</text>',
            '</svg>'
        );
        return string(
            abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(svg)));
    }

    function getLevels(uint256 tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToLevels[tokenId];
        return levels.toString();
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function mint() public {
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
        tokenIdToLevels[tokenId] = 0;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    function train(uint256 tokenId) public {
        if(ownerOf(tokenId) == address(0)) revert CannotTrainInexistentTokenId();
        if(ownerOf(tokenId) != msg.sender) revert OnlyOwnerCanTrain();
        tokenIdToLevels[tokenId]++;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}
