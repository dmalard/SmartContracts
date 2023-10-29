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
    }

    mapping(address => Employee) public employees;

    event SalaryPaid(
        address indexed employee,
        uint256 salary,
        uint256 tax,
        uint256 netSalary
    );

    function calculateTaxtBasedOnTaxRate() private view returns (uint256) {
        uint256 salary = msg.value;
        uint256 taxRate;
        if (salary < 1000) {
            taxRate = 7;
        } else {
            taxRate = 10;
        }
        return taxRate;
    }

    function addEmployee(
        address employeeAddress,
        uint256 salary
    ) external onlyCompany {
        require(
            employees[employeeAddress].salary == 0,
            "Employee already exists"
        );

        uint256 taxRate = calculateTaxtBasedOnTaxRate();

        uint256 tax = (salary * taxRate) / 100;
        uint256 netSalary = salary - tax;

        employees[employeeAddress] = Employee(
            salary,
            netSalary,
            taxRate,
            false
        );
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

    //recieve rausgelöscht

    //part Sending

    address public addressVARcompany =
        0x750F5d77D6A597c4d1d920f047744f8e552d79CC; //0x750F5d77D6A597c4d1d920f047744f8e552d79CC

    function GetaddressCompany(address _addressFc) external {
        addressVARcompany = _addressFc;
    }

    address public addressVARInstitution =
        0x1168E8Ef0B3CC75308Fd325B4025b6cc75386Ab4; //0x1168E8Ef0B3CC75308Fd325B4025b6cc75386Ab4

    function GetaddressTaxInstitution(address _addressFi) external {
        addressVARInstitution = _addressFi;
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

    function sendViaTransfer(
        address payable _adrEMP,
        address payable _adrTax
    ) public payable {
        //external payable onlyCompany
        uint256 salary = msg.value;
        uint256 taxRate = calculateTaxtBasedOnTaxRate();

        uint256 tax = (salary * taxRate) / 100;
        uint256 netSalary = salary - tax;

        _adrEMP.transfer(netSalary);
        _adrTax.transfer(tax);
    }
} //end contract
