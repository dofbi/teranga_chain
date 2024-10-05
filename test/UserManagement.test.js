const UserManagement = artifacts.require("UserManagement");

contract("UserManagement", (accounts) => {
  let userManagement;
  const user1 = accounts[1];
  const user2 = accounts[2];

  before(async () => {
    userManagement = await UserManagement.deployed();
  });

  it("should register a new user", async () => {
    const result = await userManagement.registerUser("John Doe", "farmer", "Experienced mango farmer", { from: user1 });
    assert.equal(result.logs[0].event, "UserRegistered", "UserRegistered event should be emitted");
    
    const user = await userManagement.getUser(user1);
    assert.equal(user.name, "John Doe", "User name should match");
    assert.equal(user.role, "farmer", "User role should match");
    assert.equal(user.isRegistered, true, "User should be registered");
    assert.equal(user.additionalInfo, "Experienced mango farmer", "Additional info should match");
  });

  it("should not allow duplicate registration", async () => {
    await userManagement.registerUser("John Doe", "farmer", "Experienced mango farmer", { from: user1 });

    try {
      await userManagement.registerUser("John Doe", "farmer", "Trying to register again", { from: user1 });
      assert.fail("The transaction should have thrown an error");
    } catch (err) {
      assert.include(err.message, "revert", "The error message should contain 'revert'");
    }
  });

  it("should update user information", async () => {
    await userManagement.registerUser("Jane Doe", "consumer", "Mango enthusiast", { from: user2 });
    await userManagement.updateUserInfo("Jane Smith", "Mango and avocado lover", { from: user2 });

    const user = await userManagement.getUser(user2);
    assert.equal(user.name, "Jane Smith", "User name should be updated");
    assert.equal(user.additionalInfo, "Mango and avocado lover", "Additional info should be updated");
    assert.equal(user.role, "consumer", "User role should remain unchanged");
  });

  it("should check if a user is registered", async () => {
    const isRegistered = await userManagement.isUserRegistered(user1);
    assert.equal(isRegistered, true, "User1 should be registered");

    const isNotRegistered = await userManagement.isUserRegistered(accounts[3]);
    assert.equal(isNotRegistered, false, "Accounts[3] should not be registered");
  });

  it("should get user role", async () => {
    const role = await userManagement.getUserRole(user1);
    assert.equal(role, "farmer", "User1 role should be 'farmer'");

    try {
      await userManagement.getUserRole(accounts[3]);
      assert.fail("The transaction should have thrown an error");
    } catch (err) {
      assert.include(err.message, "revert", "The error message should contain 'revert'");
    }
  });
});