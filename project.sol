// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ScholarshipFund {
    // Define the structure for a student
    struct Student {
        string name;
        string university;
        bool isRegistered;
        uint256 totalReceived;
    }

    address public owner;
    mapping(address => Student) public students;
    mapping(address => uint256) public donations;

    event StudentRegistered(address student, string name, string university);
    event DonationReceived(address donor, uint256 amount);
    event ScholarshipGranted(address student, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Function to register a new student
    function registerStudent(string memory _name, string memory _university) public {
        require(!students[msg.sender].isRegistered, "Student already registered.");
        students[msg.sender] = Student(_name, _university, true, 0);
        emit StudentRegistered(msg.sender, _name, _university);
    }

    // Function to donate to the scholarship fund
    function donate() public payable {
        require(msg.value > 0, "Donation amount must be greater than zero.");
        donations[msg.sender] += msg.value;
        emit DonationReceived(msg.sender, msg.value);
    }

    // Function to grant a scholarship to a student
    function grantScholarship(address _student, uint256 _amount) public onlyOwner {
        require(students[_student].isRegistered, "Student not registered.");
        require(address(this).balance >= _amount, "Insufficient funds in the contract.");
        students[_student].totalReceived += _amount;
        payable(_student).transfer(_amount);
        emit ScholarshipGranted(_student, _amount);
    }

    // Function to get contract balance
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

