class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :product_identifier
      t.string :localized_description
      t.string :localized_title
      t.integer :price
      t.string :price_locale
      t.boolean :downloadable

      t.timestamps
    end
  end
end
