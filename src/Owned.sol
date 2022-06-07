// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

abstract contract Owned {
  event OwnerUpdated(address indexed user, address indexed newOwner);

  address public owner;

  modifier onlyOwner() virtual {
    require(msg.sender == owner, "UNAUTHORIZED");
    _;
  }

  constructor () {
    owner = msg.sender;
    emit OwnerUpdated(address(0), msg.sender);
  }

  function setOwner(address newOwner) public virtual onlyOwner {
    owner = newOwner;
    emit OwnerUpdated(msg.sender, newOwner);
  }
}
