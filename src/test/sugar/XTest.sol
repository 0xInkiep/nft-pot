// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "forge-std/Test.sol";

contract XTest is Test {
  function account(string memory _label) internal returns (address addr) {
    addr = vm.addr(uint256(keccak256(abi.encodePacked(_label))));
    vm.label(addr, _label);
    return addr;
  }
}
