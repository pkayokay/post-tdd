require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe "posts#update action" do
    it "should allow users to successfully update posts" do
      post = FactoryGirl.create(:post, title: 'Initial Value', message: 'Initial Value')
      sign_in post.user

      patch :update, id: post.id, post: {title: 'Changed', message: 'Changed'}
      expect(response).to redirect_to root_path
      post.reload
      expect(post.title).to eq 'Changed'
      expect(post.message).to eq 'Changed'
    end

    it "should have a http 404 error if the post cannot be found" do
      post = FactoryGirl.create(:post, title: 'Initial Value', message: 'Initial Value')
      sign_in post.user

      patch :update, id: 'POOP', post: {title: 'Changed', message: 'Changed'}
      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an http status of unprocessable_entity" do
      post = FactoryGirl.create(:post, title: 'Initial Value', message: 'Initial Value')
      sign_in post.user

      patch :update, id: post.id, post: {title: '', message: ''}
      expect(response).to have_http_status(:unprocessable_entity)
      post.reload
      expect(post.title).to eq 'Initial Value'
      expect(post.message).to eq 'Initial Value'
    end
  end

  describe "posts#edit action" do
    it "should successfully show the edit form if the post is found" do
      post = FactoryGirl.create(:post)
      sign_in post.user
      get :edit, id: post.id
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the post is not found" do
      post = FactoryGirl.create(:post)
      sign_in post.user
      
      get :edit, id: 'POOP'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "posts#edit action" do
    it "should successfully show the edit form if the post is found" do
      post = FactoryGirl.create(:post)
      sign_in post.user

      get :edit, id: post.id
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the post is not found" do
      post = FactoryGirl.create(:post)
      sign_in post.user
      
      get :edit, id: 'TACOS'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "posts#show action" do
    it "should successfully show the page if the post is found" do
      post = FactoryGirl.create(:post)
      get :show, id: post.id
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the post is not found" do
      get :show, id: 'TACOS'
      expect(response).to have_http_status(:not_found)
    end
  end
  describe "posts#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end


  describe "posts#new action" do
    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end
    it "should successfully show the new form" do
      user = FactoryGirl.create(:user)
      sign_in user

      get :new 
      expect(response).to have_http_status(:success)
    end
  end

  describe "posts#create action" do
    it "should require users to be logged in" do
      post :create, post: {title: 'Hello', message: 'World'}
      expect(response).to redirect_to new_user_session_path
    end
    it "should successfully create a new post in our database" do
      user = FactoryGirl.create(:user)
      sign_in user

      post :create, post: {title: 'Hello', message: 'World'}
      expect(response).to redirect_to root_path

      post = Post.last
      expect(post.title).to eq('Hello')
      expect(post.message).to eq('World')
      expect(post.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryGirl.create(:user)
      sign_in user

      post_count = Post.count
      post :create, post: {title: '', message: ''}
      expect(response).to have_http_status(:unprocessable_entity)
      expect(post_count).to eq Post.count
    end
  end
end
