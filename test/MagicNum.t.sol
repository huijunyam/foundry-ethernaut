// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/MagicNum.sol";
import "src/levels/MagicNumFactory.sol";

contract TestMagicNum is BaseTest {
    MagicNum private level;

    constructor() public {
        levelFactory = new MagicNumFactory();
    }

    function setUp() public override {
        super.setUp();
    }

    function testRunLevel() public {
        runLevel();
    }

    function setupLevel() internal override {
        levelAddress = payable(this.createLevelInstance(true));
        level = MagicNum(levelAddress);
    }

    // less than 10 bytes
    function exploitLevel() internal override {
        vm.startPrank(player, player);
        address solverInstance;
        assembly {
            let ptr := mload(0x40)
            mstore(ptr, shl(0x68, 0x69602A60005260206000F3600052600A6016F3)) // 0x68: moving 104 bits (13 bytes) to left to remove the padded zero on lhs
            solverInstance := create(0, ptr, 0x13) // 0x13: 19 bytes in total length
        }
        level.setSolver(solverInstance);
        assertEq(
            Solver(solverInstance).whatIsTheMeaningOfLife(),
            0x000000000000000000000000000000000000000000000000000000000000002a
        );
        vm.stopPrank();
    }
}
