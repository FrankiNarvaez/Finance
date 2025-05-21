# test/controllers/accounts_controller_test.rb
require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_one = users(:one)
    @user_two = users(:two)
    @account_one = accounts(:one)
    @account_two = accounts(:two)

    # Log in user_one for tests
    sign_in @user_one
  end

  test "should get index and assign variables" do
    get root_url
    assert_response :success

    assert_not_nil assigns(:all_transactions)
    assert_not_nil assigns(:categories)
    assert_not_nil assigns(:banks)
    assert_not_nil assigns(:today_transactions)
    assert_not_nil assigns(:total_amount_today)
    assert_not_nil assigns(:total_balance)
    assert_not_nil assigns(:total_income)
    assert_not_nil assigns(:total_expense)
  end

  test "should get group with accounts of current user's children" do
    # Simular que user_two.account tiene parent_id = user_one.id para aparecer en grupo
    @account_two.update(parent_id: @user_one.id)

    get group_url
    assert_response :success
    assert_not_nil assigns(:accounts)
    # Confirmar que @accounts incluye account_two
    assert_includes assigns(:accounts), @account_two
  end

  test "should get new_user_group" do
    get new_user_group_url
    assert_response :success
  end

  test "should add user to group if not self" do
    # user_two no pertenece al grupo de user_one inicialmente
    assert_nil @account_two.parent_id

    post create_user_group_url, params: { email: @user_two.email }
    assert_redirected_to group_url
    follow_redirect!
    assert_match "Usuario agregado al grupo familiar", response.body

    @account_two.reload
    assert_equal @user_one.id, @account_two.parent_id
  end

  test "should not add self to group" do
    post create_user_group_url, params: { email: @user_one.email }
    assert_redirected_to group_url
    follow_redirect!
    assert_match "No te puedes agregar a ti mismo", response.body

    @account_one.reload
    assert_nil @account_one.parent_id
  end

  test "should remove user from group" do
    @account_two.update(parent_id: @user_one.id)
    delete remove_user_from_group_url(@account_two)
    assert_redirected_to group_url
    follow_redirect!
    assert_match "Usuario eliminado", response.body

    @account_two.reload
    assert_nil @account_two.parent_id
  end
end
