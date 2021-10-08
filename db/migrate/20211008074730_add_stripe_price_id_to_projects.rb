class AddStripePriceIdToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :stripe_price_id, :string
  end
end
