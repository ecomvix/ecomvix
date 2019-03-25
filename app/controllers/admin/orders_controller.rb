class Admin::OrdersController < Admin::BaseController
    include CurrentCart
  before_action :set_cart, only: [:index, :shop, :show, :search_results, :edit]
  def index
    @orders = Order.all.order("created_at DESC")
    # @orders = @productitems.orders
  end
end
