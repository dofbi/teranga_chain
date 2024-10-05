const TransactionManagement = artifacts.require("TransactionManagement");

contract("TransactionManagement", (accounts) => {
  let transactionManagement;
  const buyer = accounts[1];
  const seller = accounts[2];
  const productId = 1;

  before(async () => {
    transactionManagement = await TransactionManagement.deployed();
  });

  it("should create a new transaction", async () => {
    const amount = web3.utils.toWei("1", "ether");
    const result = await transactionManagement.createTransaction(seller, productId, { from: buyer, value: amount });
    assert.equal(result.logs[0].event, "TransactionCreated", "TransactionCreated event should be emitted");
    
    const transactionId = result.logs[0].args.transactionId.toNumber();
    const transaction = await transactionManagement.getTransaction(transactionId);
    
    assert.equal(transaction.buyer, buyer, "Buyer address should match");
    assert.equal(transaction.seller, seller, "Seller address should match");
    assert.equal(transaction.amount, amount, "Transaction amount should match");
    assert.equal(transaction.status, "Pending", "Initial status should be 'Pending'");
    assert.equal(transaction.productId.toNumber(), productId, "Product ID should match");
  });

  it("should update transaction status", async () => {
    const amount = web3.utils.toWei("1", "ether");
    const result = await transactionManagement.createTransaction(seller, productId, { from: buyer, value: amount });
    const transactionId = result.logs[0].args.transactionId.toNumber();

    await transactionManagement.updateTransactionStatus(transactionId, "Shipped", { from: seller });
    const transaction = await transactionManagement.getTransaction(transactionId);
    assert.equal(transaction.status, "Shipped", "Transaction status should be updated to 'Shipped'");
  });

  it("should not allow non-participants to update status", async () => {
    const amount = web3.utils.toWei("1", "ether");
    const result = await transactionManagement.createTransaction(seller, productId, { from: buyer, value: amount });
    const transactionId = result.logs[0].args.transactionId.toNumber();

    try {
      await transactionManagement.updateTransactionStatus(transactionId, "Shipped", { from: accounts[3] });
      assert.fail("The transaction should have thrown an error");
    } catch (err) {
      assert.include(err.message, "revert", "The error message should contain 'revert'");
    }
  });

  it("should release funds to the seller", async () => {
    const amount = web3.utils.toWei("1", "ether");
    const result = await transactionManagement.createTransaction(seller, productId, { from: buyer, value: amount });
    const transactionId = result.logs[0].args.transactionId.toNumber();

    const sellerBalanceBefore = await web3.eth.getBalance(seller);
    await transactionManagement.releaseFunds(transactionId, { from: buyer });
    const sellerBalanceAfter = await web3.eth.getBalance(seller);

    assert(new web3.utils.BN(sellerBalanceAfter).gt(new web3.utils.BN(sellerBalanceBefore)), "Seller balance should increase");

    const transaction = await transactionManagement.getTransaction(transactionId);
    assert.equal(transaction.status, "Completed", "Transaction status should be 'Completed' after funds release");
  });
});