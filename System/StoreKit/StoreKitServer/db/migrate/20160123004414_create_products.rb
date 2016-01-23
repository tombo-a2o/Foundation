class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :product_identifier, null: false
      t.string :localized_description, null: false
      t.string :localized_title, null: false
      t.integer :price, null: false
      t.string :price_locale, null: false
      t.boolean :downloadable, null: false

      t.timestamps null: false
    end
  end
end
