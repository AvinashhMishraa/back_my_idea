# ActiveAdmin.register CategoriesProject do
ActiveAdmin.register CategoriesProject, as: "ProjectCategory" do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :category_id, :project_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:category_id, :project_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  menu label: "ProjectCategories"
end
