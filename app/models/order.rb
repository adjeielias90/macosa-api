class Order < ApplicationRecord
  include Filterable
  include PublicActivity::Model
  acts_as_paranoid

  # Public activity gem handles notifications for CRUD actions.
  # to activate on heroku:
  # heroku run bundle install
  # heroku run rails db:migrate


  # Refer to controller to understand the implementation of current_user
  tracked owner: Proc.new { |controller, model| controller.current_user ? controller.current_user : nil }
  tracked recipient: ->(controller, model) { model && model }
  paginates_per 10
  # Also in your controller:
  # notifications_controller.rb
  # def index
  #   @activities = PublicActivity::Activity.all
  # end


  belongs_to :customer, counter_cache: :orders_count#,optional: :true
  belongs_to :account_manager, counter_cache: :orders_count #,optional: :true
  belongs_to :currency, counter_cache: :orders_count #,optional: :true
  has_many :manufacturer_orders, dependent: :destroy
  has_many :business_unit_orders, dependent: :destroy
  belongs_to :user, counter_cache: :orders_count
  # belongs_to :user
  accepts_nested_attributes_for :business_unit_orders, :allow_destroy => true
  accepts_nested_attributes_for :manufacturer_orders, :allow_destroy => true


  has_many :supplier_orders


  def set_date!
    self.date = Time.now.utc
    save
  end

  def generate_order_number!
    self.order_no = SecureRandom.hex(8)
    save
  end

  # def create_order(order_params, current_user)

  # end

  # Modify function to check if at least 1 business_unit_order or manifucturer order exists


  validate :has_business_unit_order
  # the name of a method we'll define below
  validate :has_manufacturer_order
  # private # <-- not required, but conventional

  def has_business_unit_order
    self.errors.add(:base, 'order must come from at least one business unit') if self.business_unit_orders.blank?
    # unless self.business_unit_order_attributes.present?
      # since it's not an error on a single field we add an error to :base
      # self.errors.add :base, "Order must come from at least one business unit"
      # (of course you could be much more specific in your handling)
    # end
  end

  def has_manufacturer_order
      self.errors.add(:base, 'order must come from least one manufacturer') if self.manufacturer_orders.blank?
  #   unless self.manufacturer_order_attributes.exists?
  #     # since it's not an error on a single field we add an error to :base
  #     self.errors.add :base, "Order must come from at least one manufacturer"
  #     # (of course you could be much more specific in your handling)
  #   end
  end





# Model Scopes
  scope :customer_id, -> (customer_id) { where customer_id: customer_id }
  scope :user_id, -> (user_id) { where user_id: user_id }
  scope :currency_id, -> (currency_id) { where currency_id: currency_id }
  scope :account_manager_id, -> (account_manager_id) { where account_manager_id: account_manager_id }
  scope :order_date, -> (order_date) {where("order_date like ?", "#{order_date}%")}

  # scope :interval, -> (start_date, end_date)
  # {
  #   where('order_date <= ? AND order_date => ?',
  #     to.to_date, from.to_date
  #   )
  # }



  # scope :starts_with, -> (name) { where("name like ?", "#{name}%")}
end
