require "test_helper"
require "stringio"

class BankTest < ActiveSupport::TestCase
  fixtures :banks, :accounts, :transactions

  test "invalid without name" do
    bank = Bank.new(balance: 100, account: accounts(:one))
    assert_not bank.valid?, "Bank should be invalid without a name"
    assert_includes bank.errors[:name], "can't be blank"
  end

  test "valid with name and account" do
    bank = Bank.new(name: "Test Bank", balance: 500, account: accounts(:one))
    assert bank.valid?, "Bank should be valid with a name and account"
  end

  test "belongs to account association" do
    bank = banks(:one)
    assert_equal accounts(:one), bank.account, "Bank.account should return the associated account"
  end

  test "has many transactions association" do
    bank = banks(:one)
    tx = transactions(:one)
    assert_includes bank.transactions, tx, "Bank should have many transactions"
  end

  test "can attach picture" do
    bank = banks(:one)
    bank.picture.attach(
      io: StringIO.new("dummy image data"),
      filename: "test.png",
      content_type: "image/png"
    )
    assert bank.picture.attached?, "Bank should allow attaching a picture"
  end

  test "can attach icon" do
    bank = banks(:one)
    bank.icon.attach(
      io: StringIO.new("dummy icon data"),
      filename: "icon.png",
      content_type: "image/png"
    )
    assert bank.icon.attached?, "Bank should allow attaching an icon"
  end
end
