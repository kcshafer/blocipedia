require 'rails_helper'
require 'faker'

RSpec.describe CollaboratorsController, type: :controller do
  let(:user) { User.create!(email: Faker::Internet.email, password: Faker::Internet.password(8), confirmed_at: Time.now)}
  let(:wiki) { Wiki.create!( title: Faker::Lorem.word, body: Faker::Lorem.sentences(4).join(' '), private: false, user_id: user.id) }
  let(:collab) { Collaborator.create!(wiki_id: wiki.id, user_id: user.id) }

  context "unauthenticated user" do
    describe "GET #index" do
      it "redirects to user login" do
        get :index, { wiki_id:  wiki.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "POST #create" do
      it "redirects to user login" do
        post :create, { wiki_id:  wiki.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "DELETE #destroy" do
      it "redirects to user login" do
        delete :destroy, { wiki_id:  wiki.id, id: collab.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context "authenticated user" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end

    describe "GET #index" do
      it "returns http success" do
        get :index, { wiki_id: wiki.id }
        expect(response).to have_http_status(:success)
      end

      it "renders the index view" do
        get :index, { wiki_id: wiki.id }
        expect(response).to render_template(:index)
      end

      it "assigns the user collaborator joint to collaborators" do
        Collaborator.create!( wiki_id: wiki.id, user_id: user.id )
        get :index, { wiki_id: wiki.id }
        collabs = assigns(:collaborators)
        expect(collabs.size).to eq 1
        expect(collabs[0].id).not_to be_nil
      end
    end

    describe "POST #create" do
      it "redirects to collaborator path" do
        post :create, { wiki_id: wiki.id, user: { wiki_id: wiki.id, user_id: user.id } } 
        expect(response).to redirect_to(wiki_collaborators_path(wiki.id))
      end

      it "increases the collaborators by one" do
        post :create, { wiki_id: wiki.id, user: { wiki_id: wiki.id, user_id: user.id } } 
        expect(Collaborator.all.size).to eq 1
      end
    end

    describe "DELETE #destroy" do
      before do
        @collab = Collaborator.create!( wiki_id: wiki.id, user_id: user.id )
      end

      it "redirects to collaborator path" do
        delete :destroy, { wiki_id: wiki.id, id: @collab.id, user: { wiki_id: wiki.id, collab_id: @collab.id } }
        expect(response).to redirect_to(wiki_collaborators_path(wiki.id))
      end

      it "decreases the collaborators by one" do
        delete :destroy, { wiki_id: wiki.id, id: @collab.id, user: { wiki_id: wiki.id, collab_id: @collab.id } }
        expect(Collaborator.all.size).to eq 0
      end
    end
  end
end
