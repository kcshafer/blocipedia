require 'rails_helper'

RSpec.describe UpgradeController, type: :controller do
  let(:user) { User.create!(email: 'kclshafer@gmail.com', password: Faker::Internet.password(8), confirmed_at: Time.now)}

  context "unauthenticated user" do
    describe "GET #show" do
      it "returns http success" do
        get :create, { id: user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "POST #create" do
      it "returns http success" do
        get :create
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context "authenticated user" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end

    describe "GET #show" do
      it "returns http success" do
        get :show, { id: user.id }
        expect(response).to have_http_status(:success)
      end
    end

    #TODO: this is failing because of my difficulties 
    describe "POST #create" do
      it "returns http success" do
       stub_request(:post, "https://api.stripe.com/v1/customers").
         with(:body => {"card"=>"12345", "email"=> user.email},
              :headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer sk_test_SAkSMpq5LsDKjiEZmaqAFR6M', 'Content-Length'=>'38', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Stripe/v1 RubyBindings/1.42.0', 'X-Stripe-Client-User-Agent'=>'{"bindings_version":"1.42.0","lang":"ruby","lang_version":"2.3.0 p0 (2015-12-25)","platform":"x86_64-darwin14","engine":"ruby","publisher":"stripe","uname":"Darwin KCs-MacBook-Pro.local 15.4.0 Darwin Kernel Version 15.4.0: Fri Feb 26 22:08:05 PST 2016; root:xnu-3248.40.184~3/RELEASE_X86_64 x86_64","hostname":"KCs-MacBook-Pro.local"}'}).
         to_return(:status => 200, :body => '{}', :headers => {})

        post :create, { stripeToken: "12345" , id: "12345"}
        expect(response).to have_http_status(:success)
      end
    end

    describe "DELETE #destroy" do
      it "returns http success" do
        delete :destroy, { id: user.id }
        expect(response).to redirect_to(edit_user_registration_path)
      end
    end
  end
end