// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title User Management Contract for Teranga Shen
/// @notice This contract manages user information and roles
contract UserManagement {
    struct User {
        string name;
        string role; // "farmer", "consumer", or "transporter"
        bool isRegistered;
        string additionalInfo;
    }

    mapping(address => User) public users;
    address public owner;

    event UserRegistered(address indexed userAddress, string name, string role);
    event UserUpdated(address indexed userAddress, string name, string role);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    /// @notice Register a new user
    /// @param _name The name of the user
    /// @param _role The role of the user ("farmer", "consumer", or "transporter")
    /// @param _additionalInfo Any additional information about the user
    function registerUser(string memory _name, string memory _role, string memory _additionalInfo) public {
        require(!users[msg.sender].isRegistered, "User is already registered");
        require(
            keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("farmer")) ||
            keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("consumer")) ||
            keccak256(abi.encodePacked(_role)) == keccak256(abi.encodePacked("transporter")),
            "Invalid role"
        );

        users[msg.sender] = User({
            name: _name,
            role: _role,
            isRegistered: true,
            additionalInfo: _additionalInfo
        });

        emit UserRegistered(msg.sender, _name, _role);
    }

    /// @notice Update user information
    /// @param _name The new name of the user
    /// @param _additionalInfo The new additional information about the user
    function updateUserInfo(string memory _name, string memory _additionalInfo) public {
        require(users[msg.sender].isRegistered, "User is not registered");

        users[msg.sender].name = _name;
        users[msg.sender].additionalInfo = _additionalInfo;

        emit UserUpdated(msg.sender, _name, users[msg.sender].role);
    }

    /// @notice Get user information
    /// @param _userAddress The address of the user to retrieve
    /// @return name The name of the user
    /// @return role The role of the user
    /// @return isRegistered Whether the user is registered
    /// @return additionalInfo Additional information about the user
    function getUser(address _userAddress) public view returns (
        string memory name,
        string memory role,
        bool isRegistered,
        string memory additionalInfo
    ) {
        User memory user = users[_userAddress];
        return (user.name, user.role, user.isRegistered, user.additionalInfo);
    }

    /// @notice Check if a user is registered
    /// @param _userAddress The address of the user to check
    /// @return Whether the user is registered
    function isUserRegistered(address _userAddress) public view returns (bool) {
        return users[_userAddress].isRegistered;
    }

    /// @notice Get the role of a user
    /// @param _userAddress The address of the user
    /// @return The role of the user
    function getUserRole(address _userAddress) public view returns (string memory) {
        require(users[_userAddress].isRegistered, "User is not registered");
        return users[_userAddress].role;
    }
}