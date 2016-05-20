require 'rails_helper'

RSpec.describe User, type: :model do
    let(:user) { User.create!(email: Faker::Internet.email, password: Faker::Internet.password(8))}

    describe "non devise attributes" do
        it "has role, premium attributes" do
            expect(user).to have_attributes(role: user.role, premium: user.premium)
        end

        it "has role" do
            expect(user).to respond_to(:role)
        end

        it "has premium" do
            expect(user).to respond_to(:premium)
        end
    end
end
