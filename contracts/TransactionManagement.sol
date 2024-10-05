// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Transaction Management Contract for Teranga Shen
/// @notice This contract manages transactions between farmers and consumers
contract TransactionManagement {
    struct Transaction {
        address buyer;
        address seller;
        uint256 amount;
        string status;
        uint256 productId;
    }

    mapping(uint256 => Transaction) public transactions;
    uint256 public transactionCount;

    event TransactionCreated(uint256 indexed transactionId, address buyer, address seller, uint256 amount);
    event TransactionStatusUpdated(uint256 indexed transactionId, string newStatus);
    event FundsReleased(uint256 indexed transactionId, address seller, uint256 amount);

    /// @notice Create a new transaction
    /// @param _seller The address of the seller (farmer)
    /// @param _productId The ID of the product being sold
    /// @return The ID of the newly created transaction
    function createTransaction(address _seller, uint256 _productId) public payable returns (uint256) {
        require(msg.value > 0, "Transaction amount must be greater than 0");
        
        transactionCount++;
        transactions[transactionCount] = Transaction({
            buyer: msg.sender,
            seller: _seller,
            amount: msg.value,
            status: "Pending",
            productId: _productId
        });

        emit TransactionCreated(transactionCount, msg.sender, _seller, msg.value);
        return transactionCount;
    }

    /// @notice Update the status of a transaction
    /// @param _transactionId The ID of the transaction to update
    /// @param _newStatus The new status of the transaction
    function updateTransactionStatus(uint256 _transactionId, string memory _newStatus) public {
        require(_transactionId > 0 && _transactionId <= transactionCount, "Invalid transaction ID");
        require(msg.sender == transactions[_transactionId].buyer || msg.sender == transactions[_transactionId].seller, "Only buyer or seller can update the status");

        transactions[_transactionId].status = _newStatus;
        emit TransactionStatusUpdated(_transactionId, _newStatus);
    }

    /// @notice Release funds to the seller
    /// @param _transactionId The ID of the transaction
    function releaseFunds(uint256 _transactionId) public {
        require(_transactionId > 0 && _transactionId <= transactionCount, "Invalid transaction ID");
        require(msg.sender == transactions[_transactionId].buyer, "Only buyer can release funds");
        require(keccak256(abi.encodePacked(transactions[_transactionId].status)) == keccak256(abi.encodePacked("Pending")), "Transaction must be in Pending status");

        Transaction storage transaction = transactions[_transactionId];
        transaction.status = "Completed";
        payable(transaction.seller).transfer(transaction.amount);

        emit FundsReleased(_transactionId, transaction.seller, transaction.amount);
    }

    /// @notice Get transaction details
    /// @param _transactionId The ID of the transaction to retrieve
    /// @return buyer The address of the buyer
    /// @return seller The address of the seller
    /// @return amount The transaction amount
    /// @return status The current status of the transaction
    /// @return productId The ID of the product involved in the transaction
    function getTransaction(uint256 _transactionId) public view returns (
        address buyer,
        address seller,
        uint256 amount,
        string memory status,
        uint256 productId
    ) {
        require(_transactionId > 0 && _transactionId <= transactionCount, "Invalid transaction ID");
        Transaction memory transaction = transactions[_transactionId];
        return (
            transaction.buyer,
            transaction.seller,
            transaction.amount,
            transaction.status,
            transaction.productId
        );
    }
}