// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "solmate/auth/Owned.sol";

contract NFTPot is Owned {
  event TicketPrinted(uint16 ticketNumber, address ticketOwner);

  uint public ticketPrice = 0.1 ether;
  uint public ticketFee = 0.01 ether;
  uint public totalPot = 0;
  uint16 public ticketsPerOrderLimit = 100;

  uint16 public ticketsSold = 0;

  mapping (uint => address) public ticketOwners;
  mapping (address => uint16[]) public ownedTickets;

  constructor() Owned(msg.sender) {}

  function buyTickets() public payable {
    require(msg.value >= ticketPrice, "UNSUFFICIENT_AMOUNT");
    uint16 totalTickets = uint16(msg.value / ticketPrice);
    require(totalTickets < ticketsPerOrderLimit, "EXCEEDED_MAX_TICKET_LIMIT");

    for (uint16 i = 1; i <= totalTickets; i++) {
      printTicket(ticketsSold + i);
    }

    ticketsSold += totalTickets;
    uint remainingEth = msg.value % ticketPrice;
    if (remainingEth > 0) payable(msg.sender).transfer(remainingEth);
  }

  function printTicket(uint16 ticketNumber) internal {
    ticketOwners[ticketNumber] = msg.sender;
    ownedTickets[msg.sender].push(ticketNumber);
    totalPot += (ticketPrice - ticketFee);
    emit TicketPrinted(ticketNumber, msg.sender);
  }

  function setTicketPrice(uint newPrice) external onlyOwner {
    ticketPrice = newPrice;
  }

  function setTicketFee(uint newFee) external onlyOwner {
    ticketFee = newFee;
  }

  receive() external payable {
    buyTickets();
  }
}
