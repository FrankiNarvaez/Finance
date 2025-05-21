require "test_helper"

class BanksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @account = accounts(:one)
    @bank = banks(:one)
    sign_in @user
  end

  test "should get index" do
    get banks_url
    assert_response :success
    assert_not_nil assigns(:banks)
    assert_includes assigns(:banks), @bank
    assert_not_includes assigns(:banks), banks(:two)
  end

  test "should get new" do
    get new_bank_url
    assert_response :success
  end

  test "should create bank with valid params" do
    assert_difference "Bank.where(account_id: @account.id).count", 1 do
      post banks_url, params: { bank: { name: "New Bank", balance: 500 } }
    end
    assert_redirected_to root_path
    assert_not_empty flash[:notice]
  end

  test "should not create bank with invalid params" do
    assert_no_difference "Bank.count" do
      post banks_url, params: { bank: { name: "", balance: 100 } }
    end
    assert_response :unprocessable_entity
    assert_template :new
  end

  test "should get edit" do
    get edit_bank_url(@bank)
    assert_response :success
  end

  test "should update bank with valid params" do
    patch bank_url(@bank), params: { bank: { name: "Updated Name", balance: 999 } }
    assert_redirected_to root_path
    assert_not_empty flash[:notice]
    @bank.reload
    assert_equal "Updated Name", @bank.name
    assert_equal 999, @bank.balance
  end

  test "should not update bank with invalid params" do
    patch bank_url(@bank), params: { bank: { name: "", balance: 123 } }
    assert_response :unprocessable_entity
    assert_template :edit
  end

  test "should not destroy bank with transactions" do
    # Ensure @bank has at least one transaction
    assert @bank.transactions.exists?

    assert_no_difference "Bank.count" do
      delete bank_url(@bank)
    end
    assert_redirected_to root_path
    assert_not_empty flash[:alert]
  end

  test "should destroy bank without transactions" do
    # Create a bank without transactions
    temp_bank = Bank.create!(name: "Temp Bank", balance: 0, account: @account)
    assert_difference "Bank.count", -1 do
      delete bank_url(temp_bank)
    end
    assert_redirected_to root_path
    assert_not_empty flash[:notice]
  end
end
