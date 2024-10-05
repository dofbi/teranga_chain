# TransactionManagement Smart Contract

## Overview

The TransactionManagement smart contract is a crucial component of the Teranga Shen platform. It manages transactions between farmers (sellers) and consumers (buyers), ensuring secure and transparent financial exchanges.

## Contract Structure

### State Variables

- `transactions`: A mapping from transaction IDs to Transaction structs.
- `transactionCount`: A counter for the total number of transactions.

### Structs

- `Transaction`: Represents a transaction with the following properties:
  - `buyer`: The Ethereum address of the buyer.
  - `seller`: The Ethereum address of the seller.
  - `amount`: The amount of Ether involved in the transaction.
  - `status`: The current status of the transaction.
  - `productId`: The ID of the product involved in the transaction.

### Events

- `TransactionCreated`: Emitted when a new transaction is created.
- `TransactionStatusUpdated`: Emitted when the status of a transaction is updated.
- `FundsReleased`: Emitted when funds are released to the seller.

## Functions

### createTransaction

Allows a buyer to create a new transaction.

Parameters:
- `_seller`: The address of the seller (farmer).
- `_productId`: The ID of the product being sold.

Returns:
- The ID of the newly created transaction.

### updateTransactionStatus

Allows the buyer or seller to update the status of a transaction.

Parameters:
- `_transactionId`: The ID of the transaction to update.
- `_newStatus`: The new status of the transaction.

### releaseFunds

Allows the buyer to release funds to the seller once satisfied with the product.

Parameters:
- `_transactionId`: The ID of the transaction.

### getTransaction

Retrieves the details of a specific transaction.

Parameters:
- `_transactionId`: The ID of the transaction to retrieve.

Returns:
- All the details of the transaction (buyer, seller, amount, status, and product ID).

## Usage

1. Buyers can use `createTransaction` to initiate a purchase, sending Ether along with the function call.
2. Both buyers and sellers can update the transaction status using `updateTransactionStatus`.
3. Once the buyer is satisfied, they can release the funds to the seller using `releaseFunds`.
4. Anyone can retrieve transaction information using `getTransaction`.

## Security Considerations

- Only the buyer or seller involved in a transaction can update its status.
- Only the buyer can release funds, and only for transactions in "Pending" status.
- Transaction IDs are checked for validity before any operations.

## Future Improvements

- Implement a dispute resolution mechanism.
- Add time-based automatic fund releases or refunds.
- Integrate with a stablecoin for price stability.