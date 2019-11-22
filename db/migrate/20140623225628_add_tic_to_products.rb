# frozen_string_literal: true

class AddTicToProducts < ActiveRecord::Migration[4.2]
  def up
    add_column :spree_products, :tax_cloud_tic, :string, default: nil
  end

  def down
    remove_column :spree_products, :tax_cloud_tic
  end
end
