const ProductTraceability = artifacts.require("ProductTraceability");

contract("ProductTraceability", (accounts) => {
  let productTraceability;
  const farmer = accounts[1];

  before(async () => {
    productTraceability = await ProductTraceability.deployed();
  });

  it("should register a new product", async () => {
    const result = await productTraceability.registerProduct("Senegal", 1633046400, "Mangoes", "Fresh mangoes from Tamba", { from: farmer });
    assert.equal(result.logs[0].event, "ProductRegistered", "ProductRegistered event should be emitted");
    
    const productId = result.logs[0].args.productId.toNumber();
    const product = await productTraceability.getProduct(productId);
    
    assert.equal(product.origin, "Senegal", "Product origin should match");
    assert.equal(product.harvestDate.toNumber(), 1633046400, "Harvest date should match");
    assert.equal(product.productName, "Mangoes", "Product name should match");
    assert.equal(product.description, "Fresh mangoes from Tamba", "Product description should match");
    assert.equal(product.farmer, farmer, "Farmer address should match");
    assert.equal(product.status, "Registered", "Initial status should be 'Registered'");
  });

  it("should update product status", async () => {
    const result = await productTraceability.registerProduct("Senegal", 1633046400, "Mangoes", "Fresh mangoes from Tamba", { from: farmer });
    const productId = result.logs[0].args.productId.toNumber();

    await productTraceability.updateStatus(productId, "Shipped", { from: farmer });
    const product = await productTraceability.getProduct(productId);
    assert.equal(product.status, "Shipped", "Product status should be updated to 'Shipped'");
  });

  it("should not allow non-farmer to update status", async () => {
    const result = await productTraceability.registerProduct("Senegal", 1633046400, "Mangoes", "Fresh mangoes from Tamba", { from: farmer });
    const productId = result.logs[0].args.productId.toNumber();

    try {
      await productTraceability.updateStatus(productId, "Shipped", { from: accounts[2] });
      assert.fail("The transaction should have thrown an error");
    } catch (err) {
      assert.include(err.message, "revert", "The error message should contain 'revert'");
    }
  });

  it("should generate a QR code URL", async () => {
    const result = await productTraceability.registerProduct("Senegal", 1633046400, "Mangoes", "Fresh mangoes from Tamba", { from: farmer });
    const productId = result.logs[0].args.productId.toNumber();

    const qrCode = await productTraceability.generateQRCode(productId);
    assert.equal(qrCode, `https://terangashen.com/product/${productId}`, "QR code URL should be correct");
  });
});