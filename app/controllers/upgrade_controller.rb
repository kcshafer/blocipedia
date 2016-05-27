class UpgradeController < ApplicationController
  before_action :require_login

  def show
    @user = User.find(params[:id])
    @stripe_btn_data = {
        key: "#{ Rails.configuration.stripe[:publishable_key] }",
        description: "Bloccit Membership - #{current_user.email}",
        amount: 1000
    }
  end

  def create
    # Creates a Stripe Customer object, for associating
    # with the charge
    customer = Stripe::Customer.create(
     email: current_user.email,
     card: params[:stripeToken]
    )

    # Where the real magic happens
    charge = Stripe::Charge.create(
     customer: customer.id, # Note -- this is NOT the user_id in your app
     amount: 1000,
     description: "Bloccit Membership - #{current_user.email}",
     currency: 'usd'
    )

    current_user.premium = true
    current_user.save!

    flash[:notice] = "Thanks for all the money, #{current_user.email}! Feel free to pay me again."
    redirect_to edit_user_registration_path(current_user)

    # Stripe will send back CardErrors, with friendly messages
    # when something goes wrong.
    # This `rescue block` catches and displays those errors.
    rescue Stripe::CardError => e
     flash[:alert] = e.message
     puts "error"
     puts e.message
     redirect_to upgrade_path(current_user.id)
    end

    def destroy
      current_user.premium = false
      current_user.save!

      redirect_to edit_user_registration_path
    end
end
