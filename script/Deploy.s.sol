// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {NounsMirror} from "../src/Mirror.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
        NounsMirror mirror = new NounsMirror();
        console.log("Mirror address: %s", address(mirror));
    }
}
