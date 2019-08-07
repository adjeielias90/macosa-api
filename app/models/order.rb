class Order < ApplicationRecord
  belongs_to :customer #,optional: :true
  belongs_to :account_manager #,optional: :true
  belongs_to :currency #,optional: :true
  has_many :manufacturer_orders, dependent: :destroy
  has_many :business_unit_orders, dependent: :destroy
  belongs_to :user
  # belongs_to :user
  accepts_nested_attributes_for :business_unit_orders, :allow_destroy => true
  accepts_nested_attributes_for :manufacturer_orders, :allow_destroy => true

  def set_date!
    self.date = Time.now.utc
  end

  def generate_order_number!
    self.order_no = SecureRandom.hex(3)
  end

  # def create_order(order_params, @current_user)

  # end

  # Modify function to check if at least 1 business_unit_order or manifucturer order exists


  #validate :has_business_unit_order  # the name of a method we'll define below
  # validate :has_manufacturer_order
  # private # <-- not required, but conventional









end
