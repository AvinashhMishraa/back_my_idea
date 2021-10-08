class CheckoutsController < ApplicationController
    before_action :authenticate_user!

	def show
		project = Project.find(params[:id])

		current_user.processor = :stripe
		current_user.customer

		@checkout_session = current_user.payment_processor.checkout(
			mode: params[:mode],
		    # line_items: "price_1JNy8KSC08iXPDHnVEL5rtTZ"

		    # mode: "subscription",
		    # line_items: "price_1JO2UBSC08iXPDHnlqiGouIo"

		    line_items: [{
		        price: project.stripe_price_id,
		        quantity: 1
		    }],
		    success_url: success_url + "?checkout_session_id={CHECKOUT_SESSION_ID}",
		    cancel_url: cancel_url,
		)
		# $checkout_session1 = @checkout_session
		@portal_session = current_user.payment_processor.billing_portal

		respond_to do |format|
		    format.js
		end
	end

	def success
		@session_with_expand = Stripe::Checkout::Session.retrieve({ id: params[:checkout_session_id], expand: ["line_items"]})
		@session_with_expand.line_items.data.each do |line_item|
		  project = Project.find_by(stripe_product_id: line_item.price.product)
		end
	end

	def cancel
	end

end
