// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Payroll {
    address public company;
    address payable public taxInstitution;
    address payable public socialInstitution;

    struct Employee {
        uint256 salary;
        uint8 taxRate; // Percentage based tax rate
        bool isMarried;
        uint256 partnerSalary;
    }

    mapping(address => Employee) public employees;

    event FundsDistributed(
        address indexed employee,
        uint256 netSalary,
        address indexed taxInstitution,
        uint256 taxAmount,
        address indexed socialInstitution,
        uint256 socialContribution
    );

    constructor(address _company, address payable _taxInstitution, address payable _socialInstitution) {
        company = _company;
        taxInstitution = _taxInstitution;
        socialInstitution = _socialInstitution;
    }

    modifier onlyCompany() {
        require(msg.sender == company, "Only the company can call this function.");
        _;
    }

    function depositFunds() external payable onlyCompany {
        // Funds are added to the contract's balance automatically
    }

    function addEmployee(
        address employeeAddress,
        uint256 salary,
        uint256 partnerSalary,
        bool isMarried
    ) external onlyCompany {
        require(employees[employeeAddress].salary == 0, "Employee already exists");
        uint8 taxRate = _calculateTaxRate(salary, partnerSalary, isMarried);
        employees[employeeAddress] = Employee(salary, taxRate, isMarried, partnerSalary);
    }

    function _calculateTaxRate(uint256 salary, uint256 partnerSalary, bool isMarried) internal pure returns (uint8) {
        uint256 income = isMarried ? salary + partnerSalary : salary;
        if (isMarried) {
            if (income <= 28800) {
                return 0;
            } else if (income <= 51800) {
                return 1;
            } else if (income <= 105400) {
                return 5;
            } else if (income <= 912600) {
                return 13;
            } else {
                return 12;
            }
        } else {
            if (income <= 28800) {
                return 0;
            } else if (income <= 32200) {
                return 1;
            } else if (income <= 42200) {
                return 2;
            } else if (income <= 56200) {
                return 3;
            } else if (income <= 73900) {
                return 4;
            } else if (income <= 79600) {
                return 6;
            } else if (income <= 105500) {
                return 7;
            } else if (income <= 137200) {
                return 9;
            } else if (income <= 179400) {
                return 11;
            } else if (income <= 769600) {
                return 13;
            } else {
                return 15;
            }
        }
    }
    // Set the tax rate value to uint8 since the tax rate will probabily not exceed 255.

    function sendViaTransfer(address payable _employeeAddress) external onlyCompany {
        Employee memory emp = employees[_employeeAddress]; // Discuss with team if we should use memory or storage as type of list.
        uint256 socialContributions = (emp.salary * 5275) / 100000;
        uint256 baseSalary = emp.salary - socialContributions;
        uint256 tax = (baseSalary * emp.taxRate) / 100;
        uint256 netSalary = baseSalary - tax;

        uint256 totalAmount = netSalary + tax + socialContributions;
        require(address(this).balance >= totalAmount, "Insufficient contract balance");

        _employeeAddress.transfer(netSalary);
        taxInstitution.transfer(tax);
        socialInstitution.transfer(socialContributions);

        emit FundsDistributed(_employeeAddress, netSalary, taxInstitution, tax, socialInstitution, socialContributions);
    }

    function removeEmployee(address employeeAddress) external onlyCompany {
        require(employees[employeeAddress].salary > 0, "Employee does not exist");
        delete employees[employeeAddress];
    }

    // Change company address and with it the owner of the contract
    function setCompanyAddress(address _company) external onlyCompany {
        company = _company;
    }

    // Change Tax Institution address
    function setTaxInstitutionAddress(address payable _taxInstitution) external onlyCompany {
        taxInstitution = _taxInstitution;
    }

    // Change Tax Institution address
    function setSocialInstitutionAddress(address payable _socialInstitution) external onlyCompany {
        socialInstitution = _socialInstitution;
    }

    receive() external payable {}
    fallback() external payable {}
}
