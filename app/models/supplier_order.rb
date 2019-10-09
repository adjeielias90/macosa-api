class SupplierOrder < ApplicationRecord
  include Filterable
  include PublicActivity::Model
  belongs_to :order
  belongs_to :manufacturer
  acts_as_paranoid
  paginates_per 10

  def generate_order_number!
    self.supplier_no = SecureRandom.hex(6)
    save
  end

  def set_default_delivered!
    self.delivered = false
    save
  end

# Model Scopes
  scope :manufacturer_id, -> (manufacturer_id) { where manufacturer_id: manufacturer_id }

end
