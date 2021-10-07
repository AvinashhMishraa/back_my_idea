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
		        name: project.title,
		        amount: project.current_donation_amount,
		        currency: "inr",
		        quantity: 1
		    }]
		)
		@portal_session = current_user.payment_processor.billing_portal

		respond_to do |format|
		    format.js
		end
	end

end
