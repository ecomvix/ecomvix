class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :name
      t.string :email
      t.text :address
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
