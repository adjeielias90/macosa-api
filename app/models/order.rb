class Order < ApplicationRecord
  belongs_to :customer #,optional: :true
  belongs_to :account_manager #,optional: :true
  belongs_to :currency #,optional: :true
  has_many :manufacturer_orders, through: :manifucturers, dependent: :destroy
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


  validate :has_business_unit_order  # the name of a method we'll define below
  # validate :has_manufacturer_order
  # private # <-- not required, but conventional

  def has_business_unit_order
    errors.add(:base, 'must add at least one business unit') if self.business_unit_orders.blank?
    # unless self.business_unit_order_attributes.present?
      # since it's not an error on a single field we add an error to :base
      # self.errors.add :base, "Order must come from at least one business unit"
      # (of course you could be much more specific in your handling)
    # end
  end

  # def has_manufacturer_order
  #   unless self.manufacturer_order_attributes.exists?
  #     # since it's not an error on a single field we add an error to :base
  #     self.errors.add :base, "Order must come from at least one manufacturer"
  #     # (of course you could be much more specific in your handling)
  #   end
  # end







end
