class CreateProductItems < ActiveRecord::Migration[6.0]
  def change
    create_table :product_items do |t|
      t.references :product, foreign_key: true
      t.belongs_to :cart, foreign_key: true

      t.timestamps
    end
  end
end
