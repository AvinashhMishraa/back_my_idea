class Project < ApplicationRecord
  # searchkick word_middle: [:title, :status]
  # searchkick
  belongs_to :user
  has_rich_text :description
  has_one_attached :thumbnail
  has_many :comments, as: :commentable


  has_many :categories_projects
  has_many :categories, through: :categories_projects


  # has_many :perks, dependent: :destroy
  # accepts_nested_attributes_for :perks, allow_destroy: true, reject_if: proc { |attr| attr['title'].blank? }
  after_update :create_and_assign_new_stripe_price, if: :saved_change_to_price?

  scope :active, ->{ where(status: "active") }
  scope :inactive, ->{ where(status: "inactive") }

  monetize :price, as: :price_cents

  paginates_per 3

  after_create do
    project = Stripe::Product.create(name: self.title)
    price = Stripe::Price.create(product: project.id, unit_amount: self.price.to_i, currency: self.currency)
    update(stripe_product_id: project.id, stripe_price_id: price.id)
  end

  def backers
    # find users who backed a specific project
  end

  def active?
    status == "active"
  end

  def inactive
    status == "inactive"
  end

  def to_builder
    Jbuilder.new do |product|
      product.price stripe_price_id
      product.quantity 1
    end
  end

  def create_and_assign_new_stripe_price
    price = Stripe::Price.create(product: self.stripe_product_id, unit_amount: self.price.to_i, currency: self.currency)
    update(stripe_price_id: price.id)
  end

  def self.search(params)  # need to uncomment this method to use elasticsearch
    # where("LOWER(title) LIKE?", "%#{params}%")
    
    projects = []
    projects << Project.left_joins(:comments).where("LOWER(projects.title) LIKE :query OR LOWER(projects.status) LIKE :query OR LOWER(comments.body) LIKE :query", query: "%#{params}%".downcase)

    projects << Project.where(id: ActionText::RichText.all.where("body LIKE ?", "%#{params}%".downcase).pluck(:record_id))

    return Project.where(id: ((projects[0] | projects[1]).pluck(:id)))

    # Nokogiri::HTML(Project.find(36).description.body.to_s).text.strip
    # ActionController::Base.helpers.strip_tags(Project.last.description.body.to_s).strip
    # Project.last.description.to_plain_text
    # Project.with_rich_text_description
  end


  # # for searchkick
  # def search_data
  #   {
  #     title: title,
  #     status: status
  #   }
  # end


  ################ Active Admin ###################

  def self.ransackable_scopes(_auth_object = nil)
    %i(category_eq thumbnail_eq comment_contains comment_equals comment_starts_with comment_ends_with description_contains)
  end

  def self.description_contains(value)
    where(id: ActionText::RichText.all.where("LOWER(body) LIKE ?", "%#{value}%".downcase).pluck(:record_id))
  end

  def self.thumbnail_eq(value)
    # ActiveStorage::Blob.all.where("filename LIKE ?", "%#{value}%")
    project_list = []
    self.all.each do |project|
      if project.thumbnail.present? && project.thumbnail_blob.filename == value
        project_list << project
      end
    end
    where(id: project_list.pluck(:id))
  end

  def self.category_eq(value)
    where(id: CategoriesProject.where(category_id: Category.where("LOWER(name) LIKE ?", "%#{value}%".downcase).pluck(:id)).pluck(:project_id))
  end

  def self.comment_contains(value)
    # where(id: Comment.where("body LIKE ?", "%#{value}%").pluck(:commentable_id))
    joins(:comments).where('LOWER(comments.body)  LIKE ?', "%#{value}%".downcase)
  end

  ################ Active Admin ###################

end

