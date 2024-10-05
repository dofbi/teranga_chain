# ProductTraceability Smart Contract

## Overview

The ProductTraceability smart contract is a core component of the Teranga Shen platform. It manages the traceability of agricultural products from farm to consumer, ensuring transparency and authenticity in the supply chain.

## Contract Structure

### State Variables

- `products`: A mapping from product IDs to Product structs.
- `productCount`: A counter for the total number of registered products.

### Structs

- `Product`: Represents an agricultural product with the following properties:
  - `origin`: The place of origin of the product.
  - `harvestDate`: The date when the product was harvested.
  - `status`: The current status of the product.
  - `farmer`: The Ethereum address of the farmer who registered the product.
  - `productName`: The name of the product.
  - `description`: A brief description of the product.

### Events

- `ProductRegistered`: Emitted when a new product is registered.
- `StatusUpdated`: Emitted when the status of a product is updated.

## Functions

### registerProduct

Allows a farmer to register a new product on the platform.

Parameters:
- `_origin`: The origin of the product.
- `_harvestDate`: The harvest date of the product.
- `_productName`: The name of the product.
- `_description`: A brief description of the product.

Returns:
- The ID of the newly registered product.

### updateStatus

Allows the farmer who registered a product to update its status.

Parameters:
- `_productId`: The ID of the product to update.
- `_newStatus`: The new status of the product.

### getProduct

Retrieves the information of a specific product.

Parameters:
- `_productId`: The ID of the product to retrieve.

Returns:
- All the details of the product (origin, harvest date, status, farmer address, product name, and description).

### generateQRCode

Generates a QR code URL for a specific product.

Parameters:
- `_productId`: The ID of the product.

Returns:
- A string representation of the QR code URL.

## Usage

1. Farmers can use `registerProduct` to add new products to the platform.
2. The status of products can be updated using `updateStatus`.
3. Anyone can retrieve product information using `getProduct`.
4. QR codes can be generated for products using `generateQRCode`.

## Security Considerations

- Only the farmer who registered a product can update its status.
- Product IDs are checked for validity before any operations.

## Future Improvements

- Implement a more sophisticated QR code generation system.
- Add role-based access control for different types of users.
- Implement a system for consumers to verify and rate products.