// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <=0.8.11;



import "@rari-capital/solmate/src/tokens/ERC721.sol";
import "@rari-capital/solmate/src/utils/SafeTransferLib.sol";   // copying this for now
import "@openzeppelin/contracts/utils/Strings.sol"; // kinda dont want to use Strings.  will replace later.

import "./SoladayOwnable.sol";

import { Base64 } from "./Base64.sol";


// I'm was tempted to borrow some ownable code from https://github.com/m1guelpf
// or from OpenZepplin, but I think it needs to be my own, even if it's largely derivative

// ok, i sdtill leaned pretty heavily on mocks from transmissions11 and code from m1guelpf


error InsufficientFunds();
error InvalidToken();

/**
 * @title SoladayNFT
 * @dev Mint an NFT on deployment (or registration?) registration
 */
contract SoladayNFT is ERC721, SoladayOwnable {

    uint256 public constant PRICE_PER_MINT = 0.01 ether;

    /*********
    * Events *
    **********/

    /************
    * Variables *
    *************/
    uint256 public totalSupply = 0;

    /*******************
    * Public Functions *
    ********************/
    modifier payToMint()
    {
        if(msg.value < PRICE_PER_MINT) revert InsufficientFunds();
        _;
    }

    modifier tokenMinted(uint256 id)
    {
        if(id >= totalSupply) revert InvalidToken();
        _;
    }

    constructor() ERC721 ("SoladayNFT20220104","SoladayNFT20220104") {}

    function tokenURI(uint256 id) public view override tokenMinted(id) returns (string memory) 
    {
        // svg time
        string memory svgStart = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
        string memory svgEnd = "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

        string memory svgMiddle = string(abi.encodePacked(Strings.toString(id)));
        string memory finalSvg = string(abi.encodePacked(svgStart, svgMiddle, svgEnd, "</text></svg>"));

        string memory json =  Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        svgMiddle,
                        '", "description": "Soladay Deployment Token for Jan 4 2022", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        return string(abi.encodePacked("data:application/json;base64,", json));
    }

    // mocks come in handy I guess
    function mint(address to) external payable virtual payToMint {
        _mint(to, totalSupply);
        totalSupply = totalSupply + 1;
    }

    function burn(uint256 tokenId) public virtual {
        _burn(tokenId);
        // burning doesn't reduce supply.  
    }

    function safeMint(address to) external payable virtual payToMint {
        _safeMint(to, totalSupply);
        totalSupply = totalSupply + 1;
    }

    function safeMint(
        address to,
        bytes memory data
    ) external payable virtual payToMint {
        _safeMint(to, totalSupply, data);
        totalSupply = totalSupply + 1;
    }

    function withdraw() external {
        if (msg.sender != _owner) revert NotOwner();

        SafeTransferLib.safeTransferETH(msg.sender, address(this).balance);
    }
}
