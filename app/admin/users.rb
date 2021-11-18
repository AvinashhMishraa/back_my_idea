ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :first_name, :last_name, :admin, :uid, :provider, :access_code, :publishable_key, :pay_data, :processor, :processor_id, :trial_ends_at, :card_type, :card_last4, :card_exp_month, :card_exp_year, :extra_billing_info, :plan, :quantity, :card_token, :pay_fake_processor_allowed
  permit_params :email, :password, :password_confirmation, :first_name, :last_name, :admin
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :first_name, :last_name, :admin, :uid, :provider, :access_code, :publishable_key, :pay_data, :processor, :processor_id, :trial_ends_at, :card_type, :card_last4, :card_exp_month, :card_exp_year, :extra_billing_info, :plan, :quantity, :card_token, :pay_fake_processor_allowed]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  filter :charges
  filter :subscriptions
  filter :projects
  filter :email
  # filter :first_name
  # filter :last_name
  filter :first_name_or_last_name_cont, as: :string, label: "Name"
  filter :admin
  filter :created_at
  filter :processor_id, label: "Stripe Customer Id"


  index do
    selectable_column
    #column :id
    id_column
    column :email
    column :first_name
    column :last_name
    column :admin
    column :created_at
    column "Stripe Customer Id", :processor_id
    actions
    # actions dropdown: true do |user|
    #   item "", admin_user_path(user), class: "member_link"
    # end
  end

  # index do
  #   excluded = ["reset_password_token", "reset_password_sent_at", "remember_created_at", "updated_at", "encrypted_password", "uid", "provider", "access_code", "publishable_key", "pay_data", "trial_ends_at", "card_type", "card_last4", "card_exp_month", "card_exp_year", "extra_billing_info"]
  #    (User.column_names - excluded).each do |c|
  #     column c.to_sym
  #   end
  #   actions
  # end

  # this is  common way to increase page performance is to eliminate N+1 queries by eager loading associations
  # includes :projects

  ############### Custom Form ###############

  form do |f|
    f.inputs 'Details' do
      f.inputs :email, :password, :password_confirmation, :first_name, :last_name, :admin
    end
    f.actions
  end

  ###########################################

end
