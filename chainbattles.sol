//SPDX-License-Identifier:MIT
// QuickNode Deployed Address : 0x65d837F1f182D9e9097EfCff49c52cad63080eFD
//Etherscan Address : https://goerli.etherscan.io/address/0x65d837F1f182D9e9097EfCff49c52cad63080eFD
//Code creates a OnChain NFT with Dynamic Features
pragma solidity > 0.8.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    using Strings for uint;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    // Create a mapping od struct 
    // track levels hp 
    // strengths
   // speed 
    mapping(uint256 => uint256) public tokenIdtoLevels;

    constructor() ERC721("Chain Battles","CBTLS"){

    }

    function generateCharacter(uint256 tokenId) public returns(string memory){
    bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">'
        '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>'
        '<rect width="100%" height="100%" fill="black" />'
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>'
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',"Levels", getLevels(tokenId),'</text>'
        '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                    Base64.encode(svg)
            )
        );
    }

function getLevels(uint256 tokenId) public view returns (string memory) {
    uint256 levels = tokenIdtoLevels[tokenId];
    return levels.toString();
}

function getTokenURI(uint256 tokenId) public returns (string memory){
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

function mint() public{
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _safeMint(msg.sender,newItemId);  // Generate Random number blocktimestamp and difficulty 
    tokenIdtoLevels[newItemId] = 0;
    _setTokenURI(newItemId, getTokenURI(newItemId));//Returns URI for the new token                                                                                                                                                                                              
}

function train(uint256 tokenId)public{
    require(_exists(tokenId),"Please use an existing Token");
    require(ownerOf(tokenId) == msg.sender,"You Don't own the Token");
    uint256 currentLevel = tokenIdtoLevels[tokenId];
    tokenIdtoLevels[tokenId] = currentLevel + 1;
    _setTokenURI(tokenId , getTokenURI(tokenId));
}


}
