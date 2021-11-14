class AddIdToCategoriesProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :categories_projects, :id, :primary_key
  end
end
