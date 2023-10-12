//With this we can send 100 wei somewhere
//view on etherscan
//[block:9853938 txIndex:5]from: 0x750...d79CCto: Test.(fallback) 0x750...d79CCvalue: 100 weidata: 0x636...d79cclogs: 0hash: 0x51e...305bf
//call to SendEther.getBalance

//SPDX-License-Identifier: MIT 
//sepolia works 

pragma solidity ^0.8.9; 


contract SendEther {


    function sendViaTransfer(address payable _to) public payable {
        // This function is no longer recommended for sending Ether.
        _to.transfer(msg.value);
    }
    function bid() public payable { }

    

 }
