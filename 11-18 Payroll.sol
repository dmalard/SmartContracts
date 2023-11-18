// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.9;

contract Payroll {
    // state variables, accessible throughout the contract
    address public company;
    address payable public taxInstitution;
    address payable public socialInstitution;

    //constructor deploys smart contract on the blockchain 
    constructor(address _company, address payable _socialInstitution, address payable _taxInstitution) {
        company = _company;
        socialInstitution = _socialInstitution;
        taxInstitution = _taxInstitution;
    }

    //statement can be used to limit function execution to company EOA 
    modifier onlyCompany() {
        require(
            msg.sender == company,
            "Only the company can call this function"
        );
        _; // Placeholder where modified function's code will be inserted
    }

    function setCompanyAddress(address _company) external onlyCompany {
        company = _company;
    }

    function setTaxInstitutionAddress(address payable _taxInstitution) external onlyCompany {
        taxInstitution = _taxInstitution;
    }
    
    function setSocialInstitutionAddress(address payable _socialInstitution) external onlyCompany {
        socialInstitution = _socialInstitution;
    }

    //increased readability with data type struct, group different data types under a single name
    struct Employee {
        uint256 salary;
        uint256 netSalary;
        uint256 taxRate;
        bool isMarried;
        uint256 partnerSalary;
        uint256 socialContributions;
        uint256 tax;
        uint256 addedTimestamp; 
        uint256 removedTimestamp; 
    }

    struct Transaction {
        uint256 amount;
        uint256 timestamp;
    }

    //data structure "mapping" associates a key to a value 
    //Ethereum address is the key, several instances of the Employee struct are values
    mapping(address => Employee) public employees;
    mapping(address => Transaction[]) public transactions;

    function addEmployee(
        address employeeAddress,
        uint256 salary,
        uint256 partnerSalary,
        bool isMarried
    ) external onlyCompany {
        require(
            employees[employeeAddress].salary == 0,
            "Employee already exists"
        );

        uint256 taxRate;
        uint256 tax;
        uint256 netSalary;
        uint256 socialContributions;
        uint256 baseSalary;

        if (isMarried) {
            //both partners work in same firm (boolean=true)
            //real world CH-4147 Aesch married tax rates from /steuerrechner.bl.ch
            uint256 familySalary = salary + partnerSalary;
            if (familySalary <= 15000) {
                taxRate = 0;
            } else if (familySalary <= 20000) {
                taxRate = 1;
            } else if (familySalary <= 50000) {
                taxRate = 4;
            } else if (familySalary <= 75000) {
                taxRate = 9;
            } else if (familySalary <= 100000) {
                taxRate = 13;
            } else if (familySalary <= 150000) {
                taxRate = 19;
            } else if (familySalary <= 200000) {
                taxRate = 24;
            } else if (familySalary <= 300000) {
                taxRate = 29;
            } else if (familySalary <= 400000) {
                taxRate = 32;
            } else {
                taxRate = 33;
            }
            //values are sums of both partners 
            socialContributions = (familySalary * 5275) / 100000;
            baseSalary = familySalary - socialContributions;
            tax = (baseSalary * taxRate) / 100;
            netSalary = familySalary - socialContributions - tax;
        } else {
            //unmarried employee, (boolean=false)
            //real world CH-4147 Aesch tax rates from /steuerrechner.bl.ch
            if (salary <= 15000) {
                taxRate = 0;
            } else if (salary <= 20000) {
                taxRate = 2;
            } else if (salary <= 50000) {
                taxRate = 12;
            } else if (salary <= 75000) {
                taxRate = 17;
            } else if (salary <= 100000) {
                taxRate = 21;
            } else if (salary <= 150000) {
                taxRate = 26;
            } else if (salary <= 200000) {
                taxRate = 29;
            } else if (salary <= 300000) {
                taxRate = 33;
            } else if (salary <= 400000) {
                taxRate = 35;
            } else {
                taxRate = 36;
            }
            //values for single employee 
            socialContributions = (salary * 5275) / 100000;
            baseSalary = salary - socialContributions;
            tax = (baseSalary * taxRate) / 100;
            netSalary = salary - socialContributions - tax;
        }

        //code assigns calculated variables according to struct with key=address specified in mapping
        employees[employeeAddress] = Employee({
            salary: salary,
            netSalary: netSalary,
            taxRate: taxRate,
            isMarried: isMarried,
            partnerSalary: partnerSalary,
            socialContributions: socialContributions,
            tax: tax,
            addedTimestamp: block.timestamp,
            removedTimestamp: 0
        });
    }//end of function addEmployee

    //removing employee adds removed timestamp, variables not deleted to recall address
    function removeEmployee(address employeeAddress) external onlyCompany {
        require(employees[employeeAddress].salary > 0, "Employee does not exist");
        employees[employeeAddress].removedTimestamp = block.timestamp;
    }

    //needed message value (employee+employer side) 
    function CalculateTRXamount(address _employeeAddress) public view onlyCompany returns (uint256) {
        uint256 TRXAmount = employees[_employeeAddress].salary + employees[_employeeAddress].partnerSalary + employees[_employeeAddress].socialContributions;
        return TRXAmount;
    }

    //payments salary, tax, social contribution 
    //requirements for sender=company and ensuring sufficient balance 
    function ExecutePayments(
        address payable _employeeAddress
    ) external payable onlyCompany {
        uint256 TRXAmount = employees[_employeeAddress].salary + employees[_employeeAddress].partnerSalary + employees[_employeeAddress].socialContributions;
        require(address(this).balance >= TRXAmount, "Transaction failed: Insufficient contract balance");

        _employeeAddress.transfer(employees[_employeeAddress].netSalary); 
        taxInstitution.transfer(employees[_employeeAddress].tax);
        socialInstitution.transfer(employees[_employeeAddress].socialContributions); // Employee's social contributions
        socialInstitution.transfer(employees[_employeeAddress].socialContributions); // Company's social contributions

        //transaction amount and timestamp saved in matrix, using .push to add new element 
        //button used to call a specific transaction 
        transactions[_employeeAddress].push(Transaction({ 
            amount: TRXAmount,
            timestamp: block.timestamp
        }));
    }

    //button displays full transaction history of specified employee
    //memory (temporary copy) needed (storage variables=transactions not returnable from functions)
    function getTransactionHistory(address _employeeAddress) external view returns (Transaction[] memory) {
        return transactions[_employeeAddress];
    }
}
