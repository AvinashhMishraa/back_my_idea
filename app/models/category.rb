class Category < ApplicationRecord
	has_many :categories_projects
	has_many :projects, through: :categories_projects

	# has_many :users, through: :projects

	################ Active Admin ###################

	def self.ransackable_scopes(_auth_object = nil)
	  %i(user_contains user_equals user_starts_with user_ends_with)
	end

	def self.user_contains(value)
	  a = CategoriesProject.where(project_id: Project.where(user_id: User.where("LOWER(first_name) LIKE ?", "%#{value}%".downcase).pluck(:id)).pluck(:id)).pluck(:category_id)
	  b = CategoriesProject.where(project_id: Project.where(user_id: User.where("LOWER(last_name) LIKE ?", "%#{value}%".downcase).pluck(:id)).pluck(:id)).pluck(:category_id)
	  c = CategoriesProject.where(project_id: Project.where(user_id: User.where("LOWER(email) LIKE ?", "%#{value}%".downcase).pluck(:id)).pluck(:id)).pluck(:category_id)
	  category_ids = (a+b+c).uniq
	  where(id: category_ids)
	end

	################ Active Admin ###################

end
