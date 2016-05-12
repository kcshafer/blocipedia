require 'rails_helper'

RSpec.describe User, type: :model do
    let(:user) { User.create!(email: Faker::Internet.email, password: Faker::Internet.password(8))}

    describe "non devise attributes" do
        it "has role attributes" do
            expect(user).to have_attributes(role: user.role)
        end

        it "has role" do
            expect(user).to respond_to(:role)
        end
    end
end
