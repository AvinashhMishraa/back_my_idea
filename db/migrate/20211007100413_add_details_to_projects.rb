class AddDetailsToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :price, :decimal
    add_column :projects, :sales_count, :integer, null: false, default: 0
  end
end
