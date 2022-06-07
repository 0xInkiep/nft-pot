// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "./sugar/XTest.sol";
import {NFTPot} from "../NFTPot.sol";

contract NFTPotTest is XTest {
  NFTPot public pot;

  address OWNER = account("owner");
  address SOMEONE = account("someone");

  function setUp() public {
    vm.prank(OWNER);
    pot = new NFTPot();
  }

  function testConstruction() public {
    assertEq(pot.owner(), OWNER);
  }

  function testPrintOneTicket() public {
    hoax(SOMEONE, 1 ether);
    pot.buyTickets{value: 0.101 ether}();

    assertEq(pot.ticketsSold(), 1);
    assertEq(pot.totalPot(), 0.09 ether);
    assertEq(SOMEONE.balance, 0.9 ether); // assert remaining amount is return
  }

  function testPrintManyTickets() public {
    hoax(SOMEONE, 2 ether);
    pot.buyTickets{value: 1.0091 ether}();

    assertEq(pot.ticketsSold(), 10);
    assertEq(pot.totalPot(), 0.9 ether);
    assertEq(SOMEONE.balance, 1 ether); // assert remaining amount is return
  }

  function testPrintOverLimitTickets() public {
    hoax(SOMEONE, 21 ether);
    vm.expectRevert("EXCEEDED_MAX_TICKET_LIMIT");
    pot.buyTickets{value: 20.1 ether}();
  }
}
