// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Crowdfunding {
    address public owner;
    uint public goal;
    uint public deadline;
    uint public raisedAmount;

    mapping(address => uint) public contributions;

    constructor(uint _goalInWei, uint _durationInMinutes) {
        owner = msg.sender;
        goal = _goalInWei;
        deadline = block.timestamp + (_durationInMinutes * 1 minutes);
    }

    // Function to contribute to the campaign
    function contribute() external payable {
        require(block.timestamp < deadline, "Campaign ended");
        require(msg.value > 0, "Contribution must be > 0");

        contributions[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }

    // Function to withdraw funds if goal is met
    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        require(block.timestamp >= deadline, "Campaign still ongoing");
        require(raisedAmount >= goal, "Funding goal not met");

        payable(owner).transfer(address(this).balance);
    }

    // Refund contributors if goal not met
    function refund() external {
        require(block.timestamp >= deadline, "Campaign still ongoing");
        require(raisedAmount < goal, "Goal was met");

        uint amount = contributions[msg.sender];
        require(amount > 0, "No contributions to refund");

        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}
