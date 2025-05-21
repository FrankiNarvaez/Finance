# test/controllers/transactions_controller_test.rb
require "test_helper"

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user          = users(:one)
    @account       = accounts(:one)
    @bank_one      = banks(:one)
    @bank_two      = banks(:two)
    @category_one  = categories(:one)
    @category_two  = categories(:two)
    @transaction   = transactions(:one)

    # Ensure test preconditions
    @bank_one.update(balance: 1000)

    sign_in @user
  end

  test "should get index" do
    get transactions_url
    assert_response :success
    assert_not_nil assigns(:transactions)
    # All fixtures for user one account are returned
    assert_includes assigns(:transactions), @transaction
  end

  test "should get new" do
    get new_transaction_url
    assert_response :success
  end

  test "should create transaction and update bank balance" do
    initial_balance = @bank_one.balance
    assert_difference "Transaction.count", 1 do
      post transactions_url, params: {
        transaction: {
          name: "New Tx",
          transaction_type: 0,
          amount: 200,
          description: "Test create",
          date: Date.today,
          bank_id: @bank_one.id,
          category_id: @category_one.id
        }
      }
    end
    assert_redirected_to root_path
    @bank_one.reload
    assert_equal initial_balance + 200, @bank_one.balance
    assert_not_empty flash[:notice]
  end

  test "should not create transaction with invalid params" do
    assert_no_difference "Transaction.count" do
      post transactions_url, params: { transaction: { name: "", amount: -10 } }
    end
    assert_response :unprocessable_entity
    assert_template :new
  end

  test "should get edit and set service flag correctly" do
    # For a bank name not Nequi or Bancolombia, flag should be false
    get edit_transaction_url(@transaction)
    assert_response :success
    assert_equal false, assigns(:is_salamabank_service)

    # Simulate Nequi bank
    nequi_bank = Bank.create!(name: "Nequi", balance: 0, account: @account)
    tx = Transaction.create!(name: "Tx Nequi", transaction_type: 0, amount: 50,
                             date: Date.today, bank: nequi_bank, account: @account)
    get edit_transaction_url(tx)
    assert_response :success
    assert_equal true, assigns(:is_salamabank_service)
  end

  test "should update transaction amount and adjust balance" do
    # Prepare a transaction
    tx = Transaction.create!(name: "AmtTx", transaction_type: 0, amount: 100,
                              date: Date.today, bank: @bank_one, account: @account)
    @bank_one.reload
    initial_balance = @bank_one.balance

    patch transaction_url(tx), params: { transaction: { amount: 150, transaction_type: tx.transaction_type, date: tx.date, name: tx.name, bank_id: tx.bank_id } }
    assert_redirected_to root_path
    @bank_one.reload
    # Balance should increase by difference (150 - 100)
    assert_equal initial_balance + (150 - 100), @bank_one.balance
    assert_not_empty flash[:notice]
  end

  test "should destroy transaction and revert bank balance" do
    # Create transaction to destroy
    tx = Transaction.create!(name: "DelTx", transaction_type: 1, amount: 80,
                              date: Date.today, bank: @bank_one, account: @account)
    @bank_one.reload
    initial_balance = @bank_one.balance

    assert_difference "Transaction.count", -1 do
      delete transaction_url(tx)
    end
    assert_redirected_to root_path
    @bank_one.reload
    # For expense (1), balance should increase by amount on deletion
    assert_equal initial_balance + 80, @bank_one.balance
    assert_not_empty flash[:notice]
  end
end
