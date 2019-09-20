class Type < ApplicationRecord
  include PublicActivity::Model
  acts_as_paranoid

  # Refer to controller to understand the implementation of current_user
  tracked owner: Proc.new { |controller, model| controller.current_user ? controller.current_user : nil }
  before_save :downcase_name
  has_many :companies

  def downcase_name
    self.name = self.name.delete('').downcase
  end

  validates :name, uniqueness: true

end
