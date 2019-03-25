class PagesController < ApplicationController

   include CurrentCart
  before_action :set_cart, only: [:index, :shop]

  
 def index
    @products = Product.all
  end

  def shop
    @products = Product.all
  end


  def show
    @product = Product.find params[:id]
  end

  def about
 end
end
