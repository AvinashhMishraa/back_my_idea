class CategoriesProject < ApplicationRecord
	belongs_to :category
	belongs_to :project
end