class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :order_id
      t.string :item_name
      t.integer :item_quantity

      t.timestamps
    end
  end
end