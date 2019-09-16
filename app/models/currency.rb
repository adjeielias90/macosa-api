class Currency < ApplicationRecord
  include PublicActivity::Model

  # Refer to controller to understand the implementation of current_user
  tracked owner: Proc.new { |controller, model| controller.current_user ? controller.current_user : nil }
  # tracked recipient: ->(controller, model) { model && model.current_user }

  # implementing soft_delete with paranoia:

  # Gemfile:
  # gem 'paranoia'
  
  # model.rb:
    acts_as_paranoid

  # Generate a new migration add_deleted_at_to_model_name
  # add these fields to the migration:
    # add_column :currencies, :deleted_at, :datetime
    # add_index :currencies, :deleted_at



  has_many :orders

  validates :name, uniqueness: true
  validates :name, presence: true
  validates :symbol, uniqueness: true
  validates :symbol, presence: true
end
