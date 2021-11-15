ActiveAdmin.register Category do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :name
  #
  # or
  #
  # permit_params do
  #   permitted = [:name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  ############### Custom Column ###############

  index do
    selectable_column
    id_column
    column :name
    column :created_at
    actions
  end

  ############### Custom Filter ###############

  filter :name
  filter :projects
  filter :user_contains, as: :string, label: "Users"
  filter :created_at

  #############################################
  
end
