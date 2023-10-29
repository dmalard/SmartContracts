// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Payroll {
    address public company;
    address payable public taxInstitution; // Made it payable for transfers
    uint256 public totalTaxPayments;

    constructor(address _company, address payable _taxInstitution) {
        company = _company;
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

    struct Employee {
        uint256 salary;
        uint256 netSalary;
        uint256 taxRate; // 7% or 10%
        bool paid;
        bool isMarried;
    }

    mapping(address => Employee) public employees;

    event SalaryPaid(
        address indexed employee,
        uint256 salary,
        uint256 tax,
        uint256 netSalary
    );

    function addEmployee(
        address employeeAddress,
        uint256 salary
    ) external onlyCompany {
        require(
            employees[employeeAddress].salary == 0,
            "Employee already exists"
        );

        uint256 taxRate;

        if (employees[employeeAddress].isMarried) {
            if (salary <= 35) {
                taxRate = 2;
            } else if (salary <= 42200) {
                taxRate = 3;
            } else if (salary <= 56200) {
                taxRate = 4;
            } else if (salary <= 73900) {
                taxRate = 5;
            } else if (salary <= 79600) {
                taxRate = 7;
            } else if (salary <= 105500) {
                taxRate = 8;
            } else if (salary <= 137200) {
                taxRate = 10;
            } else if (salary <= 179400) {
                taxRate = 12;
            } else if (salary <= 769600) {
                taxRate = 14;
            } else {
                taxRate = 16;
            }

            uint256 tax = (salary * taxRate) / 100;
            uint256 netSalary = salary - tax;
            employees[employeeAddress] = Employee(
                salary,
                netSalary,
                taxRate,
                false,
                true
            );
        } else {
            if (salary <= 28800){
                taxR
            }
            if (salary <= 32200) {
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
            uint256 tax = (salary * taxRate) / 100;
            uint256 netSalary = salary - tax;
            employees[employeeAddress] = Employee(
                salary,
                netSalary,
                taxRate,
                false,
                false
            );
        }
    }

    function calculateTaxes(
        address employeeAddress
    ) external view onlyCompany returns (uint256) {
        require(
            employees[employeeAddress].salary > 0,
            "Employee does not exist"
        );

        uint256 salary = employees[employeeAddress].salary;
        uint256 taxRate = employees[employeeAddress].taxRate;
        return (salary * taxRate) / 100;
    }

    function deductTaxesAndPay(address employeeAddress) external onlyCompany {
        require(
            employees[employeeAddress].salary > 0,
            "Employee does not exist"
        );
        require(!employees[employeeAddress].paid, "Employee already paid");

        uint256 salary = employees[employeeAddress].salary;
        uint256 taxRate = employees[employeeAddress].taxRate;
        uint256 tax = (salary * taxRate) / 100;
        uint256 netSalary = salary - tax;

        employees[employeeAddress].netSalary = netSalary;
        employees[employeeAddress].paid = true;
        totalTaxPayments += tax;

        payable(employeeAddress).transfer(netSalary); // Paying the employee
        emit SalaryPaid(employeeAddress, salary, tax, netSalary);
    }

    function payTaxesToInstitution() external onlyCompany {
        require(totalTaxPayments > 0, "No taxes to pay");
        require(
            address(this).balance >= totalTaxPayments,
            "Insufficient contract balance"
        );

        uint256 owedTaxes = totalTaxPayments; // Keeping track of owed taxes before resetting
        totalTaxPayments = 0; //After payment no tax debt
        taxInstitution.transfer(owedTaxes); // Paying the taxes
    }

    function getEmployeeNetSalary(
        address employeeAddress
    ) external view returns (uint256) {
        require(
            employees[employeeAddress].salary > 0,
            "Employee does not exist"
        );
        return employees[employeeAddress].netSalary;
    }

    function removeEmployee(address employeeAddress) external onlyCompany {
        require(
            employees[employeeAddress].salary > 0,
            "Employee does not exist"
        );
        delete employees[employeeAddress]; // Removing the employee
    }

    receive() external payable {}
}
