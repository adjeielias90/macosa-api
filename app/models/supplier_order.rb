class SupplierOrder < ApplicationRecord
  belongs_to :order
  belongs_to :supplier
  acts_as_paranoid
end
