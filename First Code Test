// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IncomeTaxSmartContract {
    address public employer;
    address public employee;
    uint256 public salary;
    uint256 public taxRate;
    uint256 public taxWithheld;
    uint256 public paymentDeadline;

    constructor(
        address _employee,
        uint256 _salary,
        uint256 _taxRate,
        uint256 _paymentDeadline
    ) {
        employer = msg.sender;
        employee = _employee;
        salary = _salary;
        taxRate = _taxRate;
        paymentDeadline = _paymentDeadline;
    }

    function withholdTax() public {
        require(msg.sender == employer, "Only the employer can withhold tax");
        require(block.timestamp <= paymentDeadline, "Payment deadline has passed");

        // Calculate and withhold tax
        taxWithheld = (salary * calculateTaxRate()) / 100;
    }
    
    function calculateTaxRate() private view returns (uint256) {
        if (salary > 500) {
            return taxRate1;
        } else {
            return taxRate2;
        }   
    }
    function transferTaxToAuthority() public {
        require(msg.sender == employer, "Only the employer can transfer tax");
        require(taxWithheld > 0, "No tax to transfer");

        // Transfer the withheld tax to the tax authority
        // This is a simplified example and does not include actual transfer code
        // In a real implementation, you would use the Ethereum transfer function.
        // taxAuthority.transfer(taxWithheld);

        // Reset the tax withheld after payment
        taxWithheld = 0;
    }
}
