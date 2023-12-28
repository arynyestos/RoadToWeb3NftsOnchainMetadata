// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattlesImproved is ERC721URIStorage {
    ///////////////////////
    // Type declarations //
    ///////////////////////
    using Strings for uint256;
    uint256 private _nextTokenId;
    struct Stats{
        uint256 level;
        uint256 hitpoints;
        uint256 strength;
        uint256 speed;
    }

    /////////////////////////
    // State variables //////
    /////////////////////////
    mapping(uint256 => Stats) public tokenIdToStats;

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
            '<text x="50%" y="20%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
            '<text x="50%" y="30%" class="base" dominant-baseline="middle" text-anchor="middle">', "Level: ",getStats(tokenId).level.toString(),'</text>',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">', "Hitpoints: ",getStats(tokenId).hitpoints.toString(),'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",getStats(tokenId).strength.toString(),'</text>',
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",getStats(tokenId).speed.toString(),'</text>',
            '</svg>'
        );
        return string(
            abi.encodePacked("data:image/svg+xml;base64,", Base64.encode(svg)));
    }

    function getStats(uint256 tokenId) public view returns (Stats memory) {
        return tokenIdToStats[tokenId];
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
        uint256 hitpoints = uint256(keccak256(abi.encodePacked(tx.origin, blockhash(block.number - 1), block.timestamp))) % 100 + 1;
        uint256 strength = uint256(keccak256(abi.encodePacked(tx.origin, blockhash(block.number - 1), block.timestamp, hitpoints))) % 100 + 1;
        uint256 speed = uint256(keccak256(abi.encodePacked(tx.origin, blockhash(block.number - 1), block.timestamp, strength))) % 100 + 1;
        tokenIdToStats[tokenId].level = 1;
        tokenIdToStats[tokenId].hitpoints = hitpoints;
        tokenIdToStats[tokenId].strength = strength;
        tokenIdToStats[tokenId].speed = speed;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }

    function train(uint256 tokenId) public {
        if(ownerOf(tokenId) == address(0)) revert CannotTrainInexistentTokenId();
        if(ownerOf(tokenId) != msg.sender) revert OnlyOwnerCanTrain();
        tokenIdToStats[tokenId].level++;
        uint256 hitpointIncrease = uint256(keccak256(abi.encodePacked(tx.origin, blockhash(block.number - 1), block.timestamp))) % 50 + 1;
        uint256 strengthIncrease = uint256(keccak256(abi.encodePacked(tx.origin, blockhash(block.number - 1), block.timestamp, hitpointIncrease))) % 50 + 1;
        uint256 speedIncrease = uint256(keccak256(abi.encodePacked(tx.origin, blockhash(block.number - 1), block.timestamp, strengthIncrease))) % 50 + 1;
        tokenIdToStats[tokenId].hitpoints += hitpointIncrease;
        tokenIdToStats[tokenId].strength += strengthIncrease;
        tokenIdToStats[tokenId].speed += speedIncrease;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}
