class ShoppingcartController < ApplicationController

	def add_to_cart
	  id = params[:id].to_i
	  session[:cart] << id unless session[:cart].include?(id)
	  redirect_to shoppingcart_path
	end

	def remove_from_cart
	  id = params[:id].to_i
	  session[:cart].delete(id)
	  redirect_to shoppingcart_path
	end

	def show
	end


end