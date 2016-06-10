require 'rails_helper'
require 'faker'
require 'shoulda'

RSpec.describe Collaborator, type: :model do
  let(:user) { User.create!(email: Faker::Internet.email, password: Faker::Internet.password(8), role: :premium) }
  let(:wiki) { Wiki.create!( title: Faker::Lorem.word, body: Faker::Lorem.sentences(4).join(' '), private: true, user_id: user.id) }
  let(:collab) { Collaborator.create!( user_id: user.id, wiki_id: wiki.id ) }
 
  describe "attributes" do
    it "has user_id, wiki_id attributes" do
      expect(collab).to have_attributes(user_id: collab.user_id, wiki_id: collab.wiki_id)
    end

    it "has user_id" do
      expect(collab).to respond_to(:user_id)
    end

    it "has wiki_id" do
      expect(collab).to respond_to(:wiki_id)
    end
  end
end
