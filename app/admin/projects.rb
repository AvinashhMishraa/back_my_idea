 ActiveAdmin.register Project do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params do
  #   permitted = [:title, :donation_goal, :user_id, :current_donation_amount, :expires_at, :status, :price, :sales_count, :stripe_product_id, :stripe_price_id, :currency]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  permit_params :title, :donation_goal, :user_id, :current_donation_amount, :expires_at, :status, :price, :sales_count, :stripe_product_id, :stripe_price_id, :currency, :description

  scope :all
  scope :active
  scope :inactive

  action_item :activate, only: [:show, :edit] do
    link_to "Activate", activate_admin_project_path(project), method: :put if project.status == "inactive"
  end

  action_item :deactivate, only: [:show, :edit] do
    link_to "Deactivate", deactivate_admin_project_path(project), method: :put if project.status == "active"
  end

  member_action :activate, method: :put do
    project = Project.find(params[:id])
    project.update(status: "active")
    redirect_to admin_project_path(project)
  end

  member_action :deactivate, method: :put do
    project = Project.find(params[:id])
    project.update(status: "inactive")
    redirect_to admin_project_path(project)
  end


  ############### Custom Column ###############

  index do
    selectable_column
    id_column
    column :title
    column :description, sortable: 'rich_text_description.body' do |proj|
      proj.description.body
    end
    column :user
    column :donation_goal
    column :current_donation_amount
    column :created_at
    column :expires_at
    column :status
    column :price
    column :stripe_product_id
    column :stripe_price_id
    column :currency
    # column :description, sortable: 'rich_text_description.body' do |proj|
    #   proj.description.body
    # end
    actions
  end

  controller do
    def scoped_collection
      super.includes("rich_text_description")
    end
  end

  ############### Custom Filter ###############

  #preserve_default_filters!
  filter :title
  filter :status, as: :select, collection: ["active", "inactive"]
  filter :user
  filter :description_contains, as: :string, label: "Description"
  filter :price
  filter :price_cents
  filter :donation_goal
  filter :current_donation_amount
  filter :created_at
  filter :expires_at
  filter :stripe_product_id
  filter :stripe_price_id
  filter :thumbnail, as: :select, collection: proc { ActiveStorage::Blob.all.pluck(:filename).uniq }, label: "Attachment Name"
  # filter :thumbnail, as: :select, collection: -> { ActiveStorage::Blob.all.map { |thumbnail_blob| [thumbnail_blob.filename]}}, label: "Attachment Name"
  filter :category, as: :select, collection: proc { Category.all.pluck(:name).uniq }, label: "Categories"
  filter :comment_contains, as: :string, label: "Comments"

  ##############################################

end
