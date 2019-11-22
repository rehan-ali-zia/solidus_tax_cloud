# frozen_string_literal: true

class CreateSpreeTaxCloudTransactions < ActiveRecord::Migration[4.2]
  def change
    create_table :spree_tax_cloud_transactions do |t|
      t.references :order
      t.string :message

      t.timestamps null: false
    end
    add_index :spree_tax_cloud_transactions, :order_id
  end
end
