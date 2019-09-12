class Type < ApplicationRecord
  acts_as_paranoid
  before_save :downcase_name
  has_many :companies

  def downcase_name
    self.name = self.name.delete('').downcase
  end

  validates :name, uniqueness: true

end
