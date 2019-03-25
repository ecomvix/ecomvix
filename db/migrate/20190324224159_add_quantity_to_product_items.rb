class AddQuantityToProductItems < ActiveRecord::Migration[6.0]
  def change
    add_column :product_items, :quantity, :integer, default: 1
  end
end
