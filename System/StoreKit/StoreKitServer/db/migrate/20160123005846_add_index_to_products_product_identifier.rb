class AddIndexToProductsProductIdentifier < ActiveRecord::Migration
  def change
    add_index :products, :product_identifier, unique: true
  end
end
