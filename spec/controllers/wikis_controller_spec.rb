require 'rails_helper'
require 'faker'

RSpec.describe WikisController, type: :controller do
  let(:user) { User.create!(email: Faker::Internet.email, password: Faker::Internet.password(8), confirmed_at: Time.now)}
  let(:wiki) { Wiki.create!( title: Faker::Lorem.word, body: Faker::Lorem.sentences(4).join(' '), private: false, user_id: user.id) }

  context "unauthenticated user" do
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "should assign Wiki.all to wikis" do
        get :index
        expect(assigns(:wikis)).to eq([wiki])
      end
    end

    describe "GET #my_wikis" do
      it "redirect to user login" do
        get :my_wikis
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET #show" do
      it "returns http success" do
        get :show, { id: wiki.id }
        expect(response).to have_http_status(:success)
      end

      it "should assign wiki to wiki" do
        get :show, { id: wiki.id }
        expect(assigns(:wiki)).to eq(wiki)
      end
    end

    describe "GET #new" do
      it "returns http success" do
        get :new
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET #create" do
      it "returns http success" do
        get :create
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET edit" do
      it "returns http redirect" do
        get :edit, id: wiki.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "PUT update" do
      it "returns http redirect" do
        put :update, id: wiki.id, title: Faker::Lorem.word, body: Faker::Lorem.sentences(4).join(' '), private: false
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET #destroy" do
      it "returns http success" do
        get :destroy, { id: wiki.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context "authenticated user" do
    #TODO: the user still isn't authenticated, need to figure out how to auth the the user for tests
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end

    describe "GET #new_wikis" do 
      it "returns http success" do
        get :my_wikis
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end

      it "renders the #new view" do
        get :new
        expect(response).to render_template(:new)
      end

      it "initializes the @wiki" do
        get :new
        expect(:wiki).not_to be_nil
      end
    end

    describe "GET #create" do
      it "increases the number of Wiki by 1" do
        expect{ post :create, wiki: {title: Faker::Lorem.word, body: Faker::Lorem.sentences(4).join(' '), private: false } }.to change(Wiki,:count).by(1)
      end

      it "assigns the new wiki to @wiki" do
        post :create, wiki: {title: Faker::Lorem.word, body: Faker::Lorem.sentences(4).join(' '), private: false }        
        expect(assigns(:wiki)).to eq Wiki.last
      end

      it "redirects to the new post" do
        post :create, wiki: {title: Faker::Lorem.word, body: Faker::Lorem.sentences(4).join(' '), private: false }        
        expect(response).to redirect_to Wiki.last
      end
    end

    describe "GET edit" do
      it "returns http success" do
        get :edit, id: wiki.id
        expect(response).to have_http_status(:success)
      end

      it "renders the #edit view" do
        get :edit, id: wiki.id
        expect(response).to render_template :edit
      end

      it "assigns wiki to be updated to @wiki" do
        get :edit, id: wiki.id
        wiki_instance = assigns(:wiki)

        puts "wiki instance"
        puts wiki_instance
        expect(wiki_instance.id).to eq wiki.id
        expect(wiki_instance.title).to eq wiki.title
        expect(wiki_instance.body).to eq wiki.body
      end
    end

    describe "PUT update" do
      it "updates post with expected attributes" do
        new_title = Faker::Lorem.word
        new_body = Faker::Lorem.sentences(4).join
        put :update, id: wiki.id, title: Faker::Lorem.word, body: Faker::Lorem.sentences(4).join(' '), private: false

        wiki_instance = assigns(:wiki)
        expect(wiki_instance.id).to eq my_post.id
        expect(wiki_instance.title).to eq new_title
        expect(wiki_instance.body).to eq new_body
      end

      it "redirects to the updated post" do
        put :update, id: wiki.id, title: Faker::Lorem.word, body: Faker::Lorem.sentences(4).join(' '), private: false
        expect(response).to redirect_to wiki
      end
    end

    describe "DELETE #destroy" do
      it "redirects to #my_wikis" do
        get :destroy, { id: wiki.id }
        expect(response).to redirect_to(my_wikis_path)
      end
    end
  end
end
