//Buttons die bisher gemacht und contract auf den man ETH senden kann, aber noch nicht vom Contract weg senden 
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ReceiveEther {
    address public addressVARcompany = 0x750F5d77D6A597c4d1d920f047744f8e552d79CC; //0x750F5d77D6A597c4d1d920f047744f8e552d79CC
    function GetaddressCompany ( address _addressFc ) external {
        addressVARcompany = _addressFc ;
    }
    address public addressVARInstitution = 0x1168E8Ef0B3CC75308Fd325B4025b6cc75386Ab4; //0x1168E8Ef0B3CC75308Fd325B4025b6cc75386Ab4
    function GetaddressTaxInstitution ( address _addressFi ) external {
        addressVARInstitution = _addressFi ;
    }    
        /*
    Which function is called, fallback() or receive()?

           send Ether
               |
         msg.data is empty?
              / \
            yes  no
            /     \
receive() exists?  fallback()
         /   \
        yes   no
        /      \
    receive()   fallback()
    */

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
}
