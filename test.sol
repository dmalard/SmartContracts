// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Payroll {
    address public company;
    address payable public taxInstitution;
    address payable public socialInstitution;
    
    constructor(address _company, address payable _socialInstitution, address payable _taxInstitution) {
        company = _company;
        socialInstitution = _socialInstitution;
        taxInstitution = _taxInstitution;
    }

    modifier onlyCompany() {
        require(
            msg.sender == company,
            "Only the company can call this function"
        );
        _;
    }

    function setCompanyAddress(address _company) external onlyCompany {
        company = _company;
    }

    function setTaxInstitutionAddress(
        address payable _taxInstitution
    ) external onlyCompany {
        taxInstitution = _taxInstitution;
    }
    
      function setsocialInstitutionAddress(
        address payable _socialInstitution
    ) external onlyCompany {
        socialInstitution = _socialInstitution;
    }

    struct Employee {
        uint256 salary;
        uint256 netSalary;
        uint256 taxRate; // Percentage based tax rate
        bool isMarried;
        uint256 partnerSalary;
        uint256 socialContributions;
        uint256 tax;
    }

    mapping(address => Employee) public employees;

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
            uint256 familySalary = salary + partnerSalary;
            if (familySalary <= 28800) {
                taxRate = 0;
            } else if (familySalary <= 51800) {
                taxRate = 1;
            } else if (familySalary <= 105400) {
                taxRate = 5;
            } else if (familySalary <= 912600) {
                taxRate = 13;
            } else {
                taxRate = 12;
            }
            //Calculation for married couples within the same Company 
            socialContributions = (familySalary * 5275) / 100000; //social contribution family
            baseSalary = familySalary -socialContributions;       //base salary family 
            tax = (baseSalary * taxRate) / 100;                   //tax family 
            netSalary=familySalary-socialContributions-tax;       //net salary family 
                        
        } else {
            if (salary <= 28800) {
                taxRate = 0;
            } else if (salary <= 32200) {
                taxRate = 1;
            } else if (salary <= 42200) {
                taxRate = 2;
            } else if (salary <= 56200) {
                taxRate = 3;
            } else if (salary <= 73900) {
                taxRate = 4;
            } else if (salary <= 79600) {
                taxRate = 6;
            } else if (salary <= 105500) {
                taxRate = 7;
            } else if (salary <= 137200) {
                taxRate = 9;
            } else if (salary <= 179400) {
                taxRate = 11;
            } else if (salary <= 769600) {
                taxRate = 13;
            } else {
                taxRate = 15;
            }
            //Calculation for a single employee 
            socialContributions = (salary * 5275) / 100000; //social one person 
            baseSalary = salary -socialContributions;       //base Salary one person 
            tax = (baseSalary * taxRate) / 100;             //tax one person 
            netSalary=salary-socialContributions-tax;       //net salary one person 
        }

        employees[employeeAddress] = Employee(
            salary,
            netSalary,
            taxRate, 
            isMarried,
            partnerSalary,
            socialContributions,
            tax
        );
    }

    function removeEmployee(address employeeAddress) external onlyCompany {
        require(employees[employeeAddress].salary > 0, "Employee does not exist");
        delete employees[employeeAddress]; // Removing the employee
    }

    function CalculateTRXamount(address _employeeAddress) external view onlyCompany returns (uint256) {
        uint256 TRXAmount = employees[_employeeAddress].salary + employees[_employeeAddress].partnerSalary + employees[_employeeAddress].socialContributions;
        return TRXAmount;
    }

    function ExecutePayments(
        address payable _employeeAddress
        ) external payable onlyCompany{ 
            uint256 TRXAmount = employees[_employeeAddress].salary + employees[_employeeAddress].partnerSalary + employees[_employeeAddress].socialContributions;
            require(address(this).balance >= TRXAmount, "Transaction failed: Insufficient contract balance");

            _employeeAddress.transfer(employees[_employeeAddress].netSalary); 
            taxInstitution.transfer(employees[_employeeAddress].tax);
            socialInstitution.transfer(employees[_employeeAddress].socialContributions); //AHV part of salary
            socialInstitution.transfer(employees[_employeeAddress].socialContributions); //AHV contribution of company 
    }
}

//timestamp 
//Beschreibung 
/*
// Variable to store the timestamp when the contract was deployed
    uint256 public deploymentTimestamp;

    // Function to get the current timestamp
    function getCurrentTimestamp() public view returns (uint256) {
        return block.timestamp;
    }

    // Function to set the deployment timestamp
    function setDeploymentTimestamp() public {
        deploymentTimestamp = block.timestamp;
    }
    */
