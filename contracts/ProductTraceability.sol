// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Product Traceability Contract for Teranga Shen
/// @notice This contract manages the traceability of agricultural products
contract ProductTraceability {
    struct Product {
        string origin;
        uint256 harvestDate;
        string status;
        address farmer;
        string productName;
        string description;
    }

    mapping(uint256 => Product) public products;
    uint256 public productCount;

    event ProductRegistered(uint256 indexed productId, string productName, address farmer);
    event StatusUpdated(uint256 indexed productId, string newStatus);

    /// @notice Register a new product
    /// @param _origin The origin of the product
    /// @param _harvestDate The harvest date of the product
    /// @param _productName The name of the product
    /// @param _description A brief description of the product
    /// @return The ID of the newly registered product
    function registerProduct(
        string memory _origin,
        uint256 _harvestDate,
        string memory _productName,
        string memory _description
    ) public returns (uint256) {
        productCount++;
        products[productCount] = Product({
            origin: _origin,
            harvestDate: _harvestDate,
            status: "Registered",
            farmer: msg.sender,
            productName: _productName,
            description: _description
        });

        emit ProductRegistered(productCount, _productName, msg.sender);
        return productCount;
    }

    /// @notice Update the status of a product
    /// @param _productId The ID of the product to update
    /// @param _newStatus The new status of the product
    function updateStatus(uint256 _productId, string memory _newStatus) public {
        require(_productId > 0 && _productId <= productCount, "Invalid product ID");
        require(msg.sender == products[_productId].farmer, "Only the farmer can update the status");

        products[_productId].status = _newStatus;
        emit StatusUpdated(_productId, _newStatus);
    }

    /// @notice Get product information
    /// @param _productId The ID of the product to retrieve
    /// @return origin The origin of the product
    /// @return harvestDate The harvest date of the product
    /// @return status The current status of the product
    /// @return farmer The address of the farmer who registered the product
    /// @return productName The name of the product
    /// @return description A brief description of the product
    function getProduct(uint256 _productId) public view returns (
        string memory origin,
        uint256 harvestDate,
        string memory status,
        address farmer,
        string memory productName,
        string memory description
    ) {
        require(_productId > 0 && _productId <= productCount, "Invalid product ID");
        Product memory product = products[_productId];
        return (
            product.origin,
            product.harvestDate,
            product.status,
            product.farmer,
            product.productName,
            product.description
        );
    }

    /// @notice Generate a QR code URL for a product
    /// @param _productId The ID of the product
    /// @return A string representation of the QR code URL
    function generateQRCode(uint256 _productId) public view returns (string memory) {
        require(_productId > 0 && _productId <= productCount, "Invalid product ID");
        // In a real-world scenario, you would generate a proper QR code here.
        // For simplicity, we're returning a string representation.
        return string(abi.encodePacked("https://terangashen.com/product/", _productId));
    }
}