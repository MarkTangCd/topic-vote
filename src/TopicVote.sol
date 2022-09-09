// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract TopicVote {
  string public topic;
  uint64 public total;
  address public owner;
  address[] public voters;
  uint public expiredTime;
  bool public end; // 投票是否已结束，可能未过期但已结束

  event Voted(uint64 total, address indexed sender);
  event NewVote(string topic, uint expiredTime);

  modifier onlyOwner() {
    require(msg.sender == owner, "You are not the owner");
    _;
  }

  constructor(string memory _topic,uint _expiredTime) {
    owner = msg.sender;
    topic = _topic;
    expiredTime = _expiredTime;
  }

  function changeOwner(address newOwner) external onlyOwner {
    owner = newOwner;
  }

  function vote() external {
    require(block.timestamp < expiredTime, "The topic expired."); // 验证是否已过期
    voters.push(msg.sender);
    total += 1;
    emit Voted(total, msg.sender);
  }

  function newVote(string memory _topic,uint _expiredTime) external onlyOwner {
    require(end == true, "Voting is not end.");
    topic = _topic;
    expiredTime = _expiredTime;
    emit NewVote(topic, expiredTime);
  }

  function voteEnd() external onlyOwner returns (uint64) {
    require(end == false, "Voting is end.");
    end = true;
    return total;
  }
}
