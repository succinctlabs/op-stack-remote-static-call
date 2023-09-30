// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {NounsMirror} from "../src/Mirror.sol";

interface IL1Block {
    function number() external view returns (uint64);
}

contract DummyNouns is ERC721 {
    uint256 tokenId = 0;

    function mint(address to) external {
        _mint(to, tokenId++);
    }
}

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        // First we deploy a DummyNouns contract on the devnet L1
        vm.createSelectFork("l1");
        DummyNouns nouns = new DummyNouns();
        // Now we mint a Noun to a few addresses
        nouns.mint(address(this));
        nouns.mint(address(0x1));
        nouns.mint(address(0x2));

        uint64 l1BlockNumber = block.number;

        // Now we deploy the mirror contract to the devnet L2
        vm.fork("l2");
        // Now we deploy a contract on the devnet L2
        NounsMirror mirror = new NounsMirror(address(nouns));
        console.log("Mirror address: %s", address(mirror));

        // Now we wait for the block on the L2 to catch up to the L1
        uint64 blockNumberOnL2 = IL1Block().number();
        while (blockNumberOnL2 < l1BlockNumber) {
            console.log(
                "Waiting for L1 block to catch up %s %s",
                blockNumberOnL2,
                l1BlockNumber
            );
            blockNumberOnL2 = IL1Block().number();
        }

        // Now we check the balance of the mirror contract
        assertEq(mirror.balanceOf(address(this)), 1);
        assertEq(mirror.balanceOf(address(0x1)), 1);
        assertEq(mirror.balanceOf(address(0x2)), 1);
        assertEq(mirror.balanceOf(address(0x3)), 0);
    }
}
