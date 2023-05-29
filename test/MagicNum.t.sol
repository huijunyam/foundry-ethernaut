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

        }
        level.setSolver(solverInstance);
        assertEq(
            Solver(solverInstance).whatIsTheMeaningOfLife(),
            0x000000000000000000000000000000000000000000000000000000000000002a
        );
        vm.stopPrank();
    }
}
