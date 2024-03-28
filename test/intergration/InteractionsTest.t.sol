//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether; //10e17
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        // GIve our user some balance
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUserCanFund() external {
        FundFundMe fundfundMe = new FundFundMe();
        fundfundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawfundMe = new WithdrawFundMe();
        withdrawfundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}
