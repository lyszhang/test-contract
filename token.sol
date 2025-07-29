// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VulnerableDonation {
    mapping(address => uint256) public donations;

    // 捐赠函数
    function donate() public payable {
        donations[msg.sender] += msg.value;
    }

    // 提款函数：允许捐赠者取回自己的捐款
    function withdraw() public {
        uint256 amount = donations[msg.sender];
        require(amount > 0, "No funds to withdraw");

        // 关键漏洞：先转账，再更新余额（重入风险）
        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");

        donations[msg.sender] = 0;
    }

    // 查询合约余额
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}