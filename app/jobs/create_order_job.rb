class CreateOrderJob < ApplicationJob
  queue_as :default

  def perform(order)
    # Do something later
    @new_order = @current_user.orders.new(order)
    @new_order.generate_order_number!
    # @order.set_date!
    if @new_order.save
      render json: @new_order, status: :created
    else
      render json: @new_order.errors, status: :unprocessable_entity
    end
  end
end
