class ManufacturerOrder < ApplicationRecord
  acts_as_paranoid
  belongs_to :manufacturer
  belongs_to :order
end
