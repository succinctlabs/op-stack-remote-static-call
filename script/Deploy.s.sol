// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {NounsMirror} from "../src/Mirror.sol";
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

interface IL1Block {
    function number() external view returns (uint64);

    function hash() external view returns (bytes32);
}

contract DummyNouns is ERC721("NOUNS", "NOUNS") {
    uint256 tokenId = 0;

    function mint(address to) external {
        _mint(to, tokenId++);
    }
}

// Use the below command to run this script
// forge script script/Deploy.s.sol --tc DeployL1 --broadcast
contract DeployL1 is Script {
    function setUp() public {}

    function run() public {
        uint256 privKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.rememberKey(privKey);

        // First we deploy a DummyNouns contract on the devnet L1
        vm.createSelectFork("l1");
        vm.startBroadcast(deployer);
        DummyNouns nouns = new DummyNouns();
        console.log("Nouns address: %s", address(nouns));
        // Now we mint a Noun to a few addresses
        nouns.mint(address(this));
        nouns.mint(address(0x1));
        nouns.mint(address(0x2));

        uint64 l1BlockNumber = uint64(block.number);
        console.log("L1 block number is: %s", l1BlockNumber);
        vm.stopBroadcast();
    }
}

// Use the below command to run this script
// forge script script/Deploy.s.sol --tc DeployL2 --broadcast
contract DeployL2 is Script {
    function setUp() public {}

    function run() public {
        uint256 privKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.rememberKey(privKey);

        // NOTE: Fill in the below quantities with the values from the L1 script
        address nouns = 0x959922bE3CAee4b8Cd9a407cc3ac1C251C2007B1;
        uint64 l1BlockNumber = 282640;

        // Now we deploy the mirror contract to the devnet L2
        vm.createSelectFork("l2");
        vm.startBroadcast(deployer);

        // Check that the L1 block on L2 is caught up
        // https://community.optimism.io/docs/protocol/protocol-2.0/#l1block
        address L1BlockPredeploy = 0x4200000000000000000000000000000000000015;
        uint64 blockNumberOnL2 = IL1Block(L1BlockPredeploy).number();

        if (blockNumberOnL2 < l1BlockNumber) {
            console.log(
                "Waiting for L1 block to catch up %s %s",
                blockNumberOnL2,
                l1BlockNumber
            );
            revert("L1 block not caught up yet on L2");
        }

        NounsMirror mirror = new NounsMirror(address(nouns));
        console.log("Mirror address: %s", address(mirror));
    }
}
