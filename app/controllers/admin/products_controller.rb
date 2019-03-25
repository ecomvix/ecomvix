class Admin::ProductsController < Admin::BaseController
# before_action :require_signin
  before_action :require_admin
  include CurrentCart
  before_action :set_cart, only: [:index, :shop, :show, :search_results, :new, :edit, :create]
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def seller
    @products = Product.all.order("created_at DESC")
  end

  # GET /products
  # GET /products.json
  def index
    @products = Product.all.order("created_at DESC")
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit


  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
  if @product.save
    flash[:success] = 'Product has been created'
    redirect_to [:admin, @product]
   else
     flash.now[:danger] = 'Product has not been created'
     render :new
   end
end

  def edit
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    if @product.update(product_params)
      flash[:success] = 'Product has been updated'
      redirect_to [:admin, @product]
    else
      flash[:danger] = 'Product has not been updated'

      render :edit
    end

  end


  def destroy
       if @product.destroy
       flash[:success] = "Recipe Deleted"
       redirect_to admin_products_path
     end
   end
  #def destroy
    #if @product.destroy
      #flash[:success] = 'Product has been deleted'
      #redirect_to admin_products_path
     #end
  #end

  # DELETE /products/1
  # DELETE /products/1.json
  #def destroy
    #if @product.destroy
      #flash[:success] = 'Product has been deleted'
      #redirect_to admin_products_path
      #redirect_to @product
      #redirect_to [:admin, @product]
     #end
  #end

  private
    # Use callbacks to share common setup or constraints between actions.


    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:title, :description, :price, :image)
    end

    def set_product
      @product = Product.find(params[:id])
    end


end
