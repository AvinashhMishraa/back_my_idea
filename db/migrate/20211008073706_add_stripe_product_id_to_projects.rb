class AddStripeProductIdToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :stripe_product_id, :string
  end
end
