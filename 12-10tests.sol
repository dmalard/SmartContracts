//With this we can send 100 wei somewhere
//view on etherscan
//[block:9853938 txIndex:5]from: 0x750...d79CCto: Test.(fallback) 0x750...d79CCvalue: 100 weidata: 0x636...d79cclogs: 0hash: 0x51e...305bf
//call to SendEther.getBalance

//SPDX-License-Identifier: MIT 
//sepolia works 

pragma solidity ^0.8.9; 


contract SendEther {
    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function sendViaTransfer(address payable _to) public payable {
        // This function is no longer recommended for sending Ether.
        _to.transfer(msg.value);
    }

    function sendViaSend(address payable _to) public payable {
        // Send returns a boolean value indicating success or failure.
        // This function is not recommended for sending Ether.
        bool sent = _to.send(msg.value);
        require(sent, "Failed to send Ether");
    }

    function sendViaCall(address payable _to) public payable {
        // Call returns a boolean value indicating success or failure.
        // This is the current recommended method to use.
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}
