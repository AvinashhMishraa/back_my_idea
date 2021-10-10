class Project < ApplicationRecord
  belongs_to :user
  has_rich_text :description
  has_one_attached :thumbnail
  has_many :comments, as: :commentable
  has_many :perks, dependent: :destroy
  accepts_nested_attributes_for :perks, allow_destroy: true, reject_if: proc { |attr| attr['title'].blank? }
  after_update :create_and_assign_new_stripe_price, if: :saved_change_to_price?

  scope :active, ->{ where(status: "active") }
  scope :inactive, ->{ where(status: "inactive") }

  monetize :price, as: :price_cents

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

end

