class AddCurrencyToProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :currency, :string, default: "inr"
  end
end
