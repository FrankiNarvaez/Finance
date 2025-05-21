require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user       = users(:one)
    @account    = accounts(:one)
    @category   = categories(:one)
    @other_cat  = categories(:two)
    sign_in @user
  end

  test "should get index" do
    get categories_url
    assert_response :success
    assert_not_nil assigns(:categories)
    assert_includes assigns(:categories), @category
    assert_not_includes assigns(:categories), @other_cat if @other_cat.account_id != @account.id
  end

  test "should get new" do
    get new_category_url
    assert_response :success
  end

  test "should create category with valid params" do
    assert_difference "Category.where(account_id: @account.id).count", 1 do
      post categories_url, params: { category: { name: "New Category" } }
    end
    assert_redirected_to root_path
    assert_not_empty flash[:notice]
  end

  test "should not create category with invalid params" do
    assert_no_difference "Category.count" do
      post categories_url, params: { category: { name: "" } }
    end
    assert_response :unprocessable_entity
    assert_template :new
  end

  test "should get edit" do
    get edit_category_url(@category)
    assert_response :success
  end

  test "should update category with valid params" do
    patch category_url(@category), params: { category: { name: "Updated Category" } }
    assert_redirected_to root_path
    assert_not_empty flash[:notice]
    @category.reload
    assert_equal "Updated Category", @category.name
  end

  test "should not update category with invalid params" do
    patch category_url(@category), params: { category: { name: "" } }
    assert_response :unprocessable_entity
    assert_template :edit
  end

  test "should not destroy category with transactions" do
    # Fixture one has transactions
    assert @category.transactions.exists?
    assert_no_difference "Category.count" do
      delete category_url(@category)
    end
    assert_redirected_to root_path
    assert_not_empty flash[:alert]
  end

  test "should destroy category without transactions" do
    # Create a category without transactions
    temp_cat = Category.create!(name: "Temp Cat", account: @account)
    assert_difference "Category.count", -1 do
      delete category_url(temp_cat)
    end
    assert_redirected_to root_path
    assert_not_empty flash[:notice]
  end
end
