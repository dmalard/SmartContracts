//SPDX-License-Identifier: MIT 
//sepolia works 

pragma solidity ^0.8.9; 

contract Test {
    //Sate 
    //uint public Test1 = 42; // Knopf gibt Zahl 42 aus. 
    //address public testa =0x750F5d77D6A597c4d1d920f047744f8e552d79CC;
    //bool public test=true ; 
    
    address public addressVARcompany = 0x750F5d77D6A597c4d1d920f047744f8e552d79CC; //0x750F5d77D6A597c4d1d920f047744f8e552d79CC
    function GetaddressCompany ( address _addressFc ) external {
        addressVARcompany = _addressFc ;
    }
    address public addressVARInstitution = 0x1168E8Ef0B3CC75308Fd325B4025b6cc75386Ab4; //0x1168E8Ef0B3CC75308Fd325B4025b6cc75386Ab4
    function GetaddressTaxInstitution ( address _addressFi ) external {
        addressVARInstitution = _addressFi ;
    }
    /*uint public TotalAmount  ;
    event payment1 ( address indexed addressVARcompany , uint amount ) ;
    function payTaxes () public payable { 
    TotalAmount = msg. value ;
    addressVARcompany = msg. sender ;
    emit payment1 ( msg. sender , msg. value ) ;
    }
    */
    function sendEther(address payable _receiver, uint256 _amount) external {
        _receiver.transfer(_amount);
    }
    /*
    //send ETH 
    address public owner;

    constructor() {
        owner = msg.sender; // The contract creator becomes the owner
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Function to send ETH from the contract to another address
    function sendEther(address payable _receiver, uint256 _amount) external onlyOwner {
        require(_receiver != address(0), "Invalid receiver address");
        require(_amount > 0 && _amount <= address(this).balance, "Invalid amount");

        _receiver.transfer(_amount);
    }

    // Function to check the contract's ETH balance
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
    */




}
