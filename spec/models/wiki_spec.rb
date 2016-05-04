require 'rails_helper'
require 'faker'

RSpec.describe Wiki, type: :model do
    let(:user) { User.create!(email: Faker::Internet.email, password: Faker::Internet.password(8))}
    let(:wiki) { Wiki.create!( title: Faker::Lorem.word, body: Faker::Lorem.sentences(4).join(' '), private: false, user_id: user.id) }
    
    it { is_expected.to belong_to(:user) }

    describe "attributes" do
        it "has title, body and private attributes" do
            expect(wiki).to have_attributes(title: wiki.title, body: wiki.body)
        end

        it "should respond to title" do
            expect(wiki).to respond_to(:title)
        end

        it "should respond to body" do
            expect(wiki).to respond_to(:body)
        end

        it "should respond to private" do
            expect(wiki).to respond_to(:private)
        end
    end
end
