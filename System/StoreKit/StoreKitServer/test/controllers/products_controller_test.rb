require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
    assert_not_nil assigns(:products)
  end

  test "should create product" do
    assert_difference('Product.count') do
      post :create, product: { downloadable: @product.downloadable, localized_description: @product.localized_description, localized_title: @product.localized_title, price: @product.price, price_locale: @product.price_locale, product_identifier: "MyProduct3" }, :format => :json
    end

    assert_response 201
  end

  test "should show product" do
    get :show, id: @product, :format => :json
    assert_response :success
  end

  test "should update product" do
    patch :update, id: @product, product: { downloadable: @product.downloadable, localized_description: @product.localized_description, localized_title: @product.localized_title, price: @product.price, price_locale: @product.price_locale, product_identifier: @product.product_identifier }, :format => :json
    assert_response :success
  end

  test "should destroy product" do
    assert_difference('Product.count', -1) do
      delete :destroy, id: @product, :format => :json
    end

    assert_response 204
  end
end
