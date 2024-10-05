# UserManagement Smart Contract

## Overview

The UserManagement smart contract is an essential component of the Teranga Shen platform. It manages user information and roles, allowing for proper authentication and authorization within the system.

## Contract Structure

### State Variables

- `users`: A mapping from Ethereum addresses to User structs.
- `owner`: The address of the contract owner.

### Structs

- `User`: Represents a user with the following properties:
  - `name`: The name of the user.
  - `role`: The role of the user ("farmer", "consumer", or "transporter").
  - `isRegistered`: A boolean indicating whether the user is registered.
  - `additionalInfo`: Any additional information about the user.

### Events

- `UserRegistered`: Emitted when a new user is registered.
- `UserUpdated`: Emitted when a user's information is updated.

## Functions

### registerUser

Allows a new user to register on the platform.

Parameters:
- `_name`: The name of the user.
- `_role`: The role of the user ("farmer", "consumer", or "transporter").
- `_additionalInfo`: Any additional information about the user.

### updateUserInfo

Allows a registered user to update their information.

Parameters:
- `_name`: The new name of the user.
- `_additionalInfo`: The new additional information about the user.

### getUser

Retrieves the information of a specific user.

Parameters:
- `_userAddress`: The Ethereum address of the user to retrieve.

Returns:
- The details of the user (name, role, registration status, and additional info).

### isUserRegistered

Checks if a user is registered on the platform.

Parameters:
- `_userAddress`: The Ethereum address of the user to check.

Returns:
- A boolean indicating whether the user is registered.

### getUserRole

Retrieves the role of a specific user.

Parameters:
- `_userAddress`: The Ethereum address of the user.

Returns:
- The role of the user.

## Usage

1. Users can register on the platform using `registerUser`, specifying their name, role, and additional information.
2. Registered users can update their information using `updateUserInfo`.
3. Anyone can check if a user is registered using `isUserRegistered`.
4. The role of a registered user can be retrieved using `getUserRole`.
5. Detailed user information can be obtained using `getUser`.

## Security Considerations

- Only unregistered users can register.
- Users can only update their own information.
- The contract owner has no special privileges in this contract, ensuring decentralization.

## Future Improvements

- Implement a role-based access control system for different platform functionalities.
- Add a verification process for farmers and transporters.
- Include a rating system for users based on their interactions on the platform.