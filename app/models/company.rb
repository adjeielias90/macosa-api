class Company < ApplicationRecord
  acts_as_paranoid
  belongs_to :type
  belongs_to :owner
  
  # remove 'dependent: :destroy' to enforce FK constraint
  has_many :contacts, dependent: :destroy
end
