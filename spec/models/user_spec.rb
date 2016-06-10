require 'rails_helper'

RSpec.describe User, type: :model do
    let(:user) { User.create!(email: Faker::Internet.email, password: Faker::Internet.password(8), role: :premium) }
    let(:wiki) { Wiki.create!( title: Faker::Lorem.word, body: Faker::Lorem.sentences(4).join(' '), private: true, user_id: user.id) }

    describe "non devise attributes" do
        it "has role, premium attributes" do
            expect(user).to have_attributes(role: user.role)
        end

        it "has role" do
            expect(user).to respond_to(:role)
        end
    end

    describe "it makes private wikis public after downgrade" do
        it "makes private wikis public" do
            user.role = 'member'
            user.save!
            expect(wiki.private).to eq false
        end
    end
end
