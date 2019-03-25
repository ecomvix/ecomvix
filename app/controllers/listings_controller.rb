class ListingsController < ApplicationController

    def index
    @products = Product.all
  end
 def create
 end
  def show
    @product = Product.find (params[:id])

  end



  private



    def category_params
      params.require(:listing).permit(:name, :description, :total_pages)
    end

end
