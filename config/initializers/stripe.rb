 Rails.configuration.stripe = {
   publishable_key: 'pk_test_Q2aCLs259buUOol0FEXhflxT',
   secret_key: 'sk_test_SAkSMpq5LsDKjiEZmaqAFR6M'
 }
 
 # Set our app-stored secret key with Stripe
 Stripe.api_key = Rails.configuration.stripe[:secret_key]